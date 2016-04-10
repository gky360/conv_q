require 'rails_helper'

RSpec.describe Api::V1::TopicsController, type: :controller do
  fixtures :topics
  fixtures :tag_topics
  fixtures :tags

  before do
    @logger = Logger.new(STDOUT)
  end

  describe 'GET #index' do

    before do
      @sample_fields = Topic.columns.map { |col| col.name.to_sym }
      @sample_fields = @sample_fields.sample(rand(@sample_fields.count) + 1)
    end

    it "return MAX_LIMIT or less topics" do
      get :index
      topics = assigns(:topics)
      expect(topics.length).to be <= Api::V1::TopicsController::MAX_LIMIT
    end

    it "return only permitted fields" do
      get :index
      topics = assigns(:topics)
      fields = topics.sample.attributes.keys.map(&:to_sym)
      expect(fields.sort).to eq Api::V1::TopicsController::PERMITTED_FIELDS.sort
    end

    context "with param q" do
      it "filter topics by title and tags" do
        sample_topic = Topic.rand.first
        title = sample_topic.title.split.sample
        tags = sample_topic.tags
        get :index, title: title, tag_names: tags.pluck(:name).join(",")
        topics = assigns(:topics)
        topics.each do |topic|
          @logger.debug "=========="
          @logger.debug topic.tags.ids
          @logger.debug tags.ids
          expect((topic.tags.ids & tags.ids).sort).to eq tags.ids.sort
        end
      end
    end

    context "with param :limit" do
      it "limit the number of topics" do
        limit = rand(Api::V1::TopicsController::MAX_LIMIT)
        get :index, limit: limit
        topics = assigns(:topics)
        expect(topics.length).to eq limit
      end
    end

    context "with param :offset" do
      it "return topics with offset query" do
        offset = rand(Topic.count)
        get :index, offset: offset
        topics = assigns(:topics)
        expect(topics.first.id).to eq Topic.offset(offset).first.id
      end
    end

    context "with param :fields" do
      it "return only specified fields of topics" do
        @sample_fields ||= Api::V1::TopicsController::PERMITTED_FIELDS if @sample_fields.empty?
        @sample_fields.delete(:id)
        expected_fields = @sample_fields.select { |field| Api::V1::TopicsController::PERMITTED_FIELDS.include?(field) }
        get :index, select: @sample_fields.map { |field| field.to_s }.join(",")
        topics = assigns(:topics)
        fields = topics.sample.attributes.keys.map(&:to_sym)
        fields.delete(:id)
        expect(fields.sort).to eq expected_fields.sort
      end
    end

    context "with param :sort" do
      it "return topics in specified order" do
        asc_desc = [:asc, :desc]
        order_h = {}
        @sample_fields.each do |key|
          order_h[key] = asc_desc[rand(2)]
        end
        @logger.debug order_h
        expected_topic_ids = Topic.order(order_h).limit(Api::V1::TopicsController::MAX_LIMIT).ids
        order_text = order_h
            .map { |kv| (kv[1] === :desc ? "-" : "") + kv[0].to_s }
            .join(",")
        get :index, order: order_text
        topic_ids = assigns(:topics).ids
        expect(topic_ids.sort).to eq expected_topic_ids.sort
      end
    end

  end

  after do
    @logger.debug "requested path: " + URI.decode(request.fullpath)
  end

end

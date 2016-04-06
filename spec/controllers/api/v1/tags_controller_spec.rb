require 'rails_helper'

RSpec.describe Api::V1::TagsController, :type => :controller do
  fixtures :tags

  before do
    @logger = Logger.new(STDOUT)
  end

  describe 'GET #index' do
    it "have 'id' and 'name'" do
      get :index
      tag = assigns(:tags).sample
      expect(tag.id).to be_present
      expect(tag.name).to be_present
    end
  end

  after do
    @logger.debug "requested path: " + URI.decode(request.fullpath)
  end

end

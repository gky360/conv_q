require 'rails_helper'

RSpec.describe Api::V1::TagsController, :type => :controller do
  fixtures :tags

  describe 'GET #index' do
    it "has 'id' and 'name'" do
      get :index
      tag = assigns(:tags).sample
      expect(tag.id).to be_present
      expect(tag.name).to be_present
    end
  end
end

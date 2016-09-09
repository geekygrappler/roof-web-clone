require 'rails_helper'

RSpec.describe AdminSpecController, type: :controller do

  describe "GET #documents" do
    it "returns http success" do
      get :documents
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #document" do
    it "returns http success" do
      get :document
      expect(response).to have_http_status(:success)
    end
  end

end

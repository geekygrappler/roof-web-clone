require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #line_items" do
    it "returns http success" do
      get :line_items
      expect(response).to have_http_status(:success)
    end
  end

end

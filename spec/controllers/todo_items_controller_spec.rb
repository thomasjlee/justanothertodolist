require 'rails_helper'

RSpec.describe TodoItemsController, type: :controller do

  describe "GET #index" do
    xit "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    xit "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    xit "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    xit "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    xit "returns http success" do
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do
    xit "returns http success" do
      get :update
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #delete" do
    xit "returns http success" do
      get :delete
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #set_todo_item" do
    xit "returns http success" do
      get :set_todo_item
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #todo_items_params" do
    xit "returns http success" do
      get :todo_items_params
      expect(response).to have_http_status(:success)
    end
  end

end

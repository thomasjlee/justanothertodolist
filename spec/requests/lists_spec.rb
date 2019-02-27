require "rails_helper"

def user_grants_authorization_on_twitter(twitter_callback_hash)
  OmniAuth.config.add_mock(:twitter, twitter_callback_hash)
end

RSpec.describe "Lists", type: :request do
  let(:twitter_callback_hash) do
    {
      provider: "twitter",
      uid: "1234567",
      credentials: {
        token: "222222",
        secret: "333333",
      },
      info: {
        nickname: "mock_nickname",
      },
    }
  end

  context "as guest user" do
    describe "GET /lists" do
      it "redirects to home" do
        get lists_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to home_path
      end
    end

    describe "POST /lists" do
      it "does not create a new list" do
        some_user = FactoryBot.create(:user)
        expect {
          post lists_path(list: {
                            title: "Title",
                            description: "Description",
                            user: some_user,
                          })
        }.to change(List, :count).by 0
        expect(response).to have_http_status 302
      end
    end

    describe "GET /lists/new" do
      it "redirects to home" do
        get new_list_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to home_path
      end
    end

    describe "GET /lists/:id" do
      it "redirects to lists" do
        some_user = FactoryBot.create(:user)
        list = FactoryBot.create(:list, user: some_user)
        get list_path(list)
        expect(response).to have_http_status 302
        expect(response).to redirect_to home_path
      end
    end

    describe "PATCH /lists/:id" do
      it "does not update the list" do
        some_user = FactoryBot.create(:user)
        list = FactoryBot.create(:list, user: some_user)
        original_title = list.title
        original_description = list.description

        patch list_path(list, list: {
                                title: "Updated Title",
                                description: "Updated Description",
                              })
        expect(response).to have_http_status 302
        expect(response).to redirect_to home_path
        expect(list.reload.title).to eq original_title
        expect(list.reload.description).to eq original_description
      end
    end

    describe "DELETE /lists/:id" do
      it "does not delete the list" do
        some_user = FactoryBot.create(:user)
        list = FactoryBot.create(:list, user: some_user)

        expect {
          delete list_path(list)
        }.to change(List, :count).by 0
        expect(response).to have_http_status 302
        expect(response).to redirect_to home_path
      end
    end
  end

  context "as unauthorized user" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      @list_owner = FactoryBot.create(:user)
      @list_owners_list = FactoryBot.create(:list, user: @list_owner)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      get "/auth/twitter"
      allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                        .and_return(@user)
    end

    describe "GET /lists" do
      it "responds successfully" do
        get lists_path
        expect(response).to have_http_status(200)
        expect(response).to_not include @list_owners_list.title
      end
    end

    describe "GET /lists/:id" do
      it "redirects when attempting to view another user's list" do
        get list_path(@list_owners_list)
        expect(response).to have_http_status 302
        expect(response).to redirect_to home_path
      end
    end

    describe "PATCH /lists/:id" do
      it "does not allow user to update another user's list" do
        original_title = @list_owners_list.title
        original_description = @list_owners_list.description

        patch list_path(@list_owners_list, list: {
                                             title: "Updated Title",
                                             description: "Updated Description",
                                           })
        expect(response).to have_http_status 302
        expect(response).to redirect_to home_path
        expect(@list_owners_list.reload.title).to eq original_title
        expect(@list_owners_list.reload.description).to eq original_description
      end
    end

    describe "DELETE /lists/:id" do
      it "does not allow user to delete another user's list" do
        expect {
          delete list_path(@list_owners_list)
        }.to change(List, :count).by 0
        expect(response).to redirect_to home_path
      end
    end
  end

  context "as authorized user" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      get "/auth/twitter"
      allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                        .and_return(@user)
    end

    describe "GET /lists" do
      it "responds successfully" do
        get lists_path
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /lists" do
      it "creates a new list" do
        expect {
          post lists_path(list: {
                            title: "Title",
                            description: "Description",
                            user: @user,
                          })
        }.to change(List, :count).by 1
        expect(response).to have_http_status 302
      end
    end

    describe "GET /lists/new" do
      it "responds successfully" do
        get new_list_path
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /lists/:id" do
      it "responds successfully" do
        list = FactoryBot.create(:list, user: @user)
        get list_path(list)
        expect(response).to have_http_status 200
      end
    end

    describe "PATCH /lists/:id" do
      it "updates the list" do
        list = FactoryBot.create(:list, user: @user)
        patch list_path(list, list: {
                                title: "Updated Title",
                                description: "Updated Description",
                              })
        expect(response).to redirect_to list_path(list)
        expect(list.reload.title).to eq "Updated Title"
        expect(list.reload.description).to eq "Updated Description"
      end
    end

    describe "DELETE /lists/:id" do
      it "deletes the list" do
        list = FactoryBot.create(:list, user: @user)
        expect {
          delete list_path(list)
        }.to change(List, :count).by -1
      end
    end
  end
end

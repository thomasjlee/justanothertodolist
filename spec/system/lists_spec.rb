require "rails_helper"

def user_grants_authorization_on_twitter(twitter_callback_hash)
  OmniAuth.config.add_mock(:twitter, twitter_callback_hash)
end

RSpec.describe "List System", type: :system do
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

  describe "When creating a list" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      visit "/auth/twitter"
    end

    it "creates a new list" do
      click_on "New List"
      fill_in "list[title]", with: "New List"
      fill_in "list[description]", with: "This is a new list."
      expect { click_on "Save" }.to change(List, :count).by(1)
      expect(page).to have_current_path /lists\/\d+$/
    end

    it "shows the newly created list" do
      list = FactoryBot.create(:list, user: @user)
      visit root_path
      click_on list.title
      expect(page).to have_current_path "/lists/#{list.id}"
    end
  end

  describe "When editing a list" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      @list = FactoryBot.create(:list, user: @user)
      @todo = FactoryBot.create(:todo, list: @list)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      visit "/auth/twitter"
      visit list_path(@list)
    end

    context "with Javascript enabled", js: true do
      it "replaces the list details with the edit list form" do
        click_on "Edit"
        expect(page).to have_field "list[title]"
        expect(page).to have_field "list[description]"
        expect(page).to_not have_css "div#list_details"
      end

      it "adds edit=true to query params" do
        click_on "Edit"
        expect(page).to have_current_path list_path(@list) + "?edit=true"
      end

      it "autofocuses on the list title input" do
        click_on "Edit"
        expect(page).to have_css "input.form-control:focus"
      end

      it "renders the correct view even when on the edit todo path" do
        visit edit_list_todo_path(@list, @todo)
        click_on "Edit"

        expect(page).to have_field "list[title]"
        expect(page).to have_field "list[description]"
        expect(page).to_not have_css "div#list_details"
      end
    end

    context "with Javascript disabled" do
      it "adds edit=true to query params" do
        click_on "Edit"
        expect(page).to have_current_path "/lists/#{@list.id}?edit=true"
        expect(page).to have_field "list[title]"
        expect(page).to have_field "list[description]"
        expect(page).to_not have_css "div#list_details"
      end
    end
  end

  describe "When updating a list" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      visit "/auth/twitter"
    end

    context "with Javascript enabled", js: true do
      before :each do
        @list = FactoryBot.create(:list, user: @user)
        visit list_path(@list)
        click_on "Edit"
        fill_in "list[title]", with: "Updated title"
        fill_in "list[description]", with: "Updated description"
        within("#edit_todo_list_form") { find("input[type='submit']").click }
      end

      it "replaces the edit list form with list details" do
        expect(page).to_not have_field "list[title]"
        expect(page).to_not have_field "list[description]"
        expect(page).to have_css "div#todo_list_details"
      end

      it "removes edit=true from query params" do
        expect(page).to have_current_path list_path(@list)
      end

      it "updates the list" do
        expect(page).to have_text "Updated title"
        expect(page).to have_text "Updated description"
      end
    end

    context "with Javascript disabled" do
      it "updates the list" do
        list = FactoryBot.create(:list, user: @user)
        visit list_path(list)
        click_on "Edit"
        fill_in "list[title]", with: "Updated title"
        fill_in "list[description]", with: "Updated description"
        within("#edit_todo_list_form") { find("input[type='submit']").click }
        expect(page).to have_text "Updated title"
        expect(page).to have_text "Updated description"
        expect(list.reload.title).to eq "Updated title"
        expect(list.reload.description).to eq "Updated description"
      end
    end
  end

  describe "deleting a list" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      visit "/auth/twitter"
    end

    it "prompts the user to confirm delete" do
      list = FactoryBot.create(:list, user: @user)
      visit list_path(list)
      click_on "Delete"
      expect(page).to have_current_path list_path(list) + "?prompt_delete=true"
      expect(page).to have_css "input[value='Confirm Delete']"
    end

    it "can be cancelled" do
      list = FactoryBot.create(:list, user: @user)
      visit list_path(list)
      click_on "Delete"
      click_on "Cancel"
      expect(page).to have_current_path list_path(list)
      expect(page).to_not have_css "input[value='Confirm Delete']"
    end

    it "deletes the list upon confirmation" do
      list = FactoryBot.create(:list, user: @user)
      visit list_path(list)
      click_on "Delete"
      expect { click_on "Confirm Delete" }.to change(List, :count).by(-1)
    end
  end
end

require "rails_helper"

# TODO: Move to separate module

def auth_hash(user)
  OmniAuth::AuthHash.new({
    provider: "twitter",
    uid: user.uid,
    info: {
      nickname: user.username,
    },
    credentials: {
      token: user.token,
      secret: user.secret
    }
  })
end

def stub_omniauth(user)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:twitter] = auth_hash(user)
end

def login
  visit root_path
  click_on "Sign in with Twitter"
end

###

RSpec.describe "List System", type: :system do
  describe "When creating a list" do
    it "creates a new list" do
      user = FactoryBot.create(:user)
      stub_omniauth(user)
      login

      click_on "New List"
      expect(page).to have_current_path new_list_path
      fill_in "list[title]", with: "New List"
      fill_in "list[description]", with: "This is a new list."
      expect { click_on "Save" }.to change(List, :count).by(1)
      expect(page).to have_current_path /lists\/\d+$/
    end

    it "shows the newly created list" do
      user = FactoryBot.create(:user)
      stub_omniauth(user)
      login
      list = FactoryBot.create(:list, user: user)

      visit root_path
      click_on list.title
      expect(page).to have_current_path "/lists/#{list.id}"
    end
  end

  describe "When editing a list" do
    before :each do
      @list = FactoryBot.create(:list)
      @todo = FactoryBot.create(:todo, list: @list)
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
    context "with Javascript enabled", js: true do
      before :each do
        @list = FactoryBot.create(:list)
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
        # I'm struggling to figure out why exactly the following expectation
        # only passes some of the time. Adding `sleep` for a fraction of a second
        # allows it to pass. There must be a race condition between the driver
        # and the database. Reading: https://bibwild.wordpress.com/
        # 2016/02/18/struggling-towards-reliable-capybara-javascript-testing/
        # expect(@list.reload.title).to eq "Updated title"
      end
    end

    context "with Javascript disabled" do
      it "updates the list" do
        list = FactoryBot.create(:list)
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
    it "prompts the user to confirm delete" do
      list = FactoryBot.create(:list)
      visit list_path(list)
      click_on "Delete"
      expect(page).to have_current_path list_path(list) + "?prompt_delete=true"
      expect(page).to have_css "input[value='Confirm Delete']"
    end

    it "can be cancelled" do
      list = FactoryBot.create(:list)
      visit list_path(list)
      click_on "Delete"
      click_on "Cancel"
      expect(page).to have_current_path list_path(list)
      expect(page).to_not have_css "input[value='Confirm Delete']"
    end

    it "deletes the list upon confirmation" do
      list = FactoryBot.create(:list)
      visit list_path(list)
      click_on "Delete"
      expect { click_on "Confirm Delete" }.to change(List, :count).by(-1)
    end
  end
end

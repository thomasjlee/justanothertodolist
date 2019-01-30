require "rails_helper"

RSpec.describe "TodoList System", type: :system do
  describe "When creating a todo list" do
    it "creates a new todo list" do
      visit root_path
      click_on "New List"
      expect(page).to have_current_path new_todo_list_path
      fill_in "todo_list[title]", with: "New List"
      fill_in "todo_list[description]", with: "This is a new todo list."
      expect { click_on "Save" }.to change(TodoList, :count).by(1)
      expect(page).to have_current_path /todo_lists\/\d+$/
    end

    it "shows the newly created todo list" do
      todo_list = FactoryBot.create(:todo_list)
      visit root_path
      click_on todo_list.title
      expect(page).to have_current_path "/todo_lists/#{todo_list.id}"
    end
  end

  describe "When editing a todo list" do
    before :each do
      @todo_list = FactoryBot.create(:todo_list)
      visit todo_list_path(@todo_list)
      click_on "Edit"
    end

    context "with Javascript enabled", js: true do
      it "replaces the todo list details with the edit todo list form" do
        expect(page).to have_field "todo_list[title]"
        expect(page).to have_field "todo_list[description]"
        expect(page).to_not have_css "div#todo_list_details"
      end

      it "adds edit=true to query params" do
        expect(page).to have_current_path todo_list_path(@todo_list) + "?edit=true"
      end

      it "autofocuses on the todo list title input" do
        expect(page).to have_css "input.form-control:focus"
      end
    end

    context "with Javascript disabled" do
      it "adds edit=true to query params" do
        expect(page).to have_current_path "/todo_lists/#{@todo_list.id}?edit=true"
        expect(page).to have_field "todo_list[title]"
        expect(page).to have_field "todo_list[description]"
        expect(page).to_not have_css "div#todo_list_details"
      end
    end
  end

  describe "When updating a todo list" do
    context "with Javascript enabled", js: true do
      before :each do
        @todo_list = FactoryBot.create(:todo_list)
        visit todo_list_path(@todo_list)
        click_on "Edit"
        fill_in "todo_list[title]", with: "Updated title"
        fill_in "todo_list[description]", with: "Updated description"
        within("#edit_todo_list_form") { find("input[type='submit']").click }
      end

      it "replaces the edit todo list form with todo list details" do
        expect(page).to_not have_field "todo_list[title]"
        expect(page).to_not have_field "todo_list[description]"
        expect(page).to have_css "div#todo_list_details"
      end

      it "removes edit=true from query params" do
        expect(page).to have_current_path todo_list_path(@todo_list)
      end

      it "updates the todo list" do
        expect(page).to have_text "Updated title"
        expect(page).to have_text "Updated description"
        # I'm struggling to figure out why exactly the following expectation
        # only passes some of the time. Adding `sleep` for a fraction of a second
        # allows it to pass. There must be a race condition between the driver
        # and the database. Reading: https://bibwild.wordpress.com/
        # 2016/02/18/struggling-towards-reliable-capybara-javascript-testing/
        # expect(@todo_list.reload.title).to eq "Updated title"
      end
    end

    context "with Javascript disabled" do
      it "updates the todo list" do
        todo_list = FactoryBot.create(:todo_list)
        visit todo_list_path(todo_list)
        click_on "Edit"
        fill_in "todo_list[title]", with: "Updated title"
        fill_in "todo_list[description]", with: "Updated description"
        within("#edit_todo_list_form") { find("input[type='submit']").click }
        expect(page).to have_text "Updated title"
        expect(page).to have_text "Updated description"
        expect(todo_list.reload.title).to eq "Updated title"
        expect(todo_list.reload.description).to eq "Updated description"
      end
    end
  end

  describe "deleting a todo list" do
    it "prompts the user to confirm delete" do
      todo_list = FactoryBot.create(:todo_list)
      visit todo_list_path(todo_list)
      click_on "Delete"
      expect(page).to have_current_path todo_list_path(todo_list) + "?prompt_delete=true"
      expect(page).to have_css "input[value='Confirm Delete']"
    end

    it "deletes the todo list upon confirmation" do
      todo_list = FactoryBot.create(:todo_list)
      visit todo_list_path(todo_list)
      click_on "Delete"
      expect { click_on "Confirm Delete" }.to change(TodoList, :count).by(-1)
    end
  end
end


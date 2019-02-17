require "rails_helper"

RSpec.describe "TodoItems", type: :system do
  describe "when creating a new todo item" do
    it "creates a new todo item" do
      list = FactoryBot.create(:list)
      visit list_path(list)
      fill_in "new_todo_item_content", with: "Boil the water"
      expect {
        find("button[type='submit']").click
      }.to change(TodoItem, :count).by(1)
      expect(page).to have_text "Boil the water"
    end

    it "clears the new todo form", js: true do
      list = FactoryBot.create(:list)
      visit list_path(list)
      fill_in "new_todo_item_content", with: "Boil the water."
      find("button[type='submit']").click
      expect(find_field("new_todo_item_content").value).to eq ""
    end

    it "clears the new todo form even when an edit todo button was clicked", js: true do
      todo_item = FactoryBot.create(:todo_item)
      edit_todo_path = edit_list_todo_item_path(todo_item.list, todo_item)
      new_todo_form = "form[action='#{list_todo_items_path(todo_item.list)}']"

      visit list_path(todo_item.list)
      find("a[href='#{edit_todo_path}']").click
      fill_in "new_todo_item_content", with: "Grind the coffee."
      find("#{new_todo_form} button[type='submit']").click

      within(new_todo_form) do
        expect(find_field("new_todo_item_content").value).to eq ""
      end
    end
  end

  describe "when editing a todo item" do
    it "edits a todo item" do
      todo_item = FactoryBot.create(:todo_item)
      todo_path = list_todo_item_path(todo_item.list, todo_item)
      edit_todo_path = edit_list_todo_item_path(todo_item.list, todo_item)

      visit list_path(todo_item.list)
      find("a[href='#{edit_todo_path}']").click
      expect(page).to have_css "form[action='#{todo_path}']"

      within("form.edit-form") {
        fill_in "todo_item[content]",
                with: "Edited todo item"
      }
      click_on "Save"
      expect(todo_item.reload.content).to eq "Edited todo item"
    end

    describe "when the edit todo button is clicked", js: true do
      before(:each) do
        @todo_item = FactoryBot.create(:todo_item)
        @item_path = list_todo_item_path(@todo_item.list, @todo_item)
        @edit_item_path = edit_list_todo_item_path(@todo_item.list, @todo_item)
        @edit_link_css = "a[href='#{@edit_item_path}']"
        @edit_form_css = "form[action='#{@item_path}'] textarea[name='todo_item[content]']"
      end

      it "shows the edit todo form" do
        visit list_path(@todo_item.list)
        find(@edit_link_css).click
        expect(page).to have_css @edit_form_css
      end

      it "hides the edit todo form if the form is already shown" do
        visit list_path(@todo_item.list)
        2.times { find(@edit_link_css).click }
        expect(page).to_not have_css @edit_form_css
      end
    end
  end

  describe "when deleting a todo item" do
    it "deletes a todo item" do
      todo_item = FactoryBot.create(:todo_item)
      todo_path = list_todo_item_path(todo_item.list, todo_item)

      visit list_path(todo_item.list)
      expect {
        within(".todo-row-right") do
          find("button[type='submit']").click
        end
      }.to change(TodoItem, :count).by(-1)
    end
  end

  describe "when toggling todo item completed" do
    it "completes a todo item" do
      todo_item = FactoryBot.create(:todo_item)
      visit list_path(todo_item.list)
      find("[name='todo_item[completed]']").click
      expect(todo_item.reload.completed).to be true
    end

    it "uncompletes a todo item" do
      todo_item = FactoryBot.create(:todo_item, completed: true)
      visit list_path(todo_item.list)
      expect(page).to have_css "button.btn-completed"
      find("[name='todo_item[completed]']").click
      expect(todo_item.reload.completed).to be false
    end
  end
end

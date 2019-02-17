require "rails_helper"

RSpec.describe "Todos", type: :system do
  describe "when creating a new todo" do
    it "creates a new todo" do
      list = FactoryBot.create(:list)
      visit list_path(list)
      fill_in "new_todo_item_content", with: "Boil the water"
      expect {
        find("button[type='submit']").click
      }.to change(Todo, :count).by(1)
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
      todo = FactoryBot.create(:todo)
      edit_todo_path = edit_list_todo_path(todo.list, todo)
      new_todo_form = "form[action='#{list_todos_path(todo.list)}']"

      visit list_path(todo.list)
      find("a[href='#{edit_todo_path}']").click
      fill_in "new_todo_item_content", with: "Grind the coffee."
      find("#{new_todo_form} button[type='submit']").click

      within(new_todo_form) do
        expect(find_field("new_todo_item_content").value).to eq ""
      end
    end
  end

  describe "when editing a todo" do
    it "edits a todo" do
      todo = FactoryBot.create(:todo)
      todo_path = list_todo_path(todo.list, todo)
      edit_todo_path = edit_list_todo_path(todo.list, todo)

      visit list_path(todo.list)
      find("a[href='#{edit_todo_path}']").click
      expect(page).to have_css "form[action='#{todo_path}']"

      within("form.edit-form") {
        fill_in "todo[content]",
                with: "Edited todo"
      }
      click_on "Save"
      expect(todo.reload.content).to eq "Edited todo"
    end

    describe "when the edit todo button is clicked", js: true do
      before(:each) do
        @todo = FactoryBot.create(:todo)
        @todo_path = list_todo_path(@todo.list, @todo)
        @edit_todo_path = edit_list_todo_path(@todo.list, @todo)
        @edit_link_css = "a[href='#{@edit_todo_path}']"
        @edit_form_css = "form[action='#{@todo_path}'] textarea[name='todo[content]']"
      end

      it "shows the edit todo form" do
        visit list_path(@todo.list)
        find(@edit_link_css).click
        expect(page).to have_css @edit_form_css
      end

      it "hides the edit todo form if the form is already shown" do
        visit list_path(@todo.list)
        2.times { find(@edit_link_css).click }
        expect(page).to_not have_css @edit_form_css
      end
    end
  end

  describe "when deleting a todo" do
    it "deletes a todo" do
      todo = FactoryBot.create(:todo)
      todo_path = list_todo_path(todo.list, todo)

      visit list_path(todo.list)
      expect {
        within(".todo-row-right") do
          find("button[type='submit']").click
        end
      }.to change(Todo, :count).by(-1)
    end
  end

  describe "when toggling todo completed" do
    it "completes a todo" do
      todo = FactoryBot.create(:todo)
      visit list_path(todo.list)
      find("[name='todo[completed]']").click
      expect(todo.reload.completed).to be true
    end

    it "uncompletes a todo" do
      todo = FactoryBot.create(:todo, completed: true)
      visit list_path(todo.list)
      expect(page).to have_css "button.btn-completed"
      find("[name='todo[completed]']").click
      expect(todo.reload.completed).to be false
    end
  end
end

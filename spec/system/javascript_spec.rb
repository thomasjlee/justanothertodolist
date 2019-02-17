require "rails_helper"

RSpec.describe "JavaScripts", type: :system, js: true do
  describe "Todos" do
    context "When creating a todo" do
      before :each do
        @list = FactoryBot.create(:list)
        @todo = FactoryBot.create(:todo, list: @list)
        visit list_path(@list)
        fill_in "new_todo_item_content", with: "Grind the coffee beans"
      end

      it "adds the new todo to the DOM" do
        within("form#new_todo_item_form") { find("button[type=submit]").click }
        expect(page).to have_text "Grind the coffee beans"
      end

      it "clears the new todo input" do
        within("form#new_todo_item_form") { find("button[type=submit]").click }
        input_value = find("input[name='todo[content]']").value
        expect(input_value).to eq ""
      end

      it "removes any edit todo forms and displays all todos" do
        find("a.edit-btn").click
        expect(page).to have_css "textarea#edit_todo_item_content_#{@todo.id}"
        expect(page).to have_css "div.todo-text.hidden", visible: false

        within("form#new_todo_item_form") { find("button[type=submit]").click }
        expect(page).to_not have_css "textarea#edit_todo_item_content_#{@todo.id}"
        expect(page).to_not have_css "div.todo-text.hidden"
      end
    end

    context "When editing a todo" do
      before :each do
        @list = FactoryBot.create(:list)
        @todo = FactoryBot.create(:todo, list: @list)
        @another_todo = FactoryBot.create(:todo, list: @list)
        visit list_path(@list)
      end

      it "hides the corresponding todo content" do
        find("a[href='#{edit_list_todo_path(@list, @todo)}']").click
        todo = page.find("div#todo_item_content_#{@todo.id}", visible: false)
        expect(todo[:class]).to have_text "hidden"
      end

      it "shows the form for the corresponding todo" do
        find("a[href='#{edit_list_todo_path(@list, @todo)}']").click
        expect(page).to have_css "textarea#edit_todo_item_content_#{@todo.id}"
      end

      it "autofocuses on the edit todo form" do
        find("a[href='#{edit_list_todo_path(@list, @todo)}']").click
        expect(page).to have_css "textarea:focus"
      end

      it "cancels the edit if the same edit button is clicked twice" do
        find("a[href='#{edit_list_todo_path(@list, @todo)}']").click
        find("a[href='#{edit_list_todo_path(@list, @todo)}']").click
        todo = page.find("div#todo_item_content_#{@todo.id}", visible: false)
        expect(todo[:style]).to_not have_text "display: none;"
        expect(page).to_not have_css "textarea#edit_todo_item_content_#{@todo.id}"
      end

      it "when clicking on two different edit buttons, cancels the first and enables editing for the second" do
        find("a[href='#{edit_list_todo_path(@list, @todo)}']").click
        find("a[href='#{edit_list_todo_path(@list, @another_todo)}']").click
        todo = page.find("div#todo_item_content_#{@todo.id}", visible: false)
        another_todo = page.find("div#todo_item_content_#{@another_todo.id}", visible: false)

        expect(todo[:class]).to_not have_text "hidden"
        expect(page).to_not have_css "textarea#edit_todo_item_content_#{@todo.id}"

        expect(another_todo[:class]).to have_text "hidden"
        expect(page).to have_css "textarea#edit_todo_item_content_#{@another_todo.id}"
      end
    end

    context "When updating a todo" do
      before :each do
        list = FactoryBot.create(:list)
        @todo = FactoryBot.create(:todo, list: list)
        visit list_path(list)
        find("a.edit-btn").click
        within("form.edit-form") { fill_in "todo[content]", with: "Updated todo" }
        click_on "Save"
      end

      it "updates the todo content" do
        expect(page).to_not have_text @todo.content
        expect(page).to have_text @todo.reload.content
      end

      it "displays all todo content and hides edit forms" do
        expect(page).to_not have_css "form.edit-form"
        expect(find("div.todo-text")[:class]).to_not have_text "hidden"
      end
    end

    context "When destroying a todo" do
      before :each do
        @list = FactoryBot.create(:list)
        @todo = FactoryBot.create(:todo, list: @list)
        @todo_to_destroy = FactoryBot.create(:todo,
                                             content: "Destroy me",
                                             list: @list)
        visit list_path(@list)
      end

      it "removes the corresponding todo from the DOM" do
        todo_li = find_by_id(@todo_to_destroy.id)
        within(todo_li) {
          within(find("form#destroy_todo_item_#{@todo_to_destroy.id}")) {
            find("button[type='submit']").click
          }
        }
        expect(page).to_not have_text @todo_to_destroy.content
      end

      it "disables the clear completed button if no completed todos remain" do
        destroy_todo_path = list_todo_path(@list, @todo_to_destroy)
        todo_li = find_by_id(@todo_to_destroy.id)
        within(todo_li) { find("button[name='todo[completed]']").click }
        # FIXME
        sleep(0.05)
        expect(find(".clear-completed-btn")[:class]).to have_text "clear-completed-btn--enabled"
        within(todo_li) {
          within(page.find_by_id("destroy_todo_item_#{@todo_to_destroy.id}")) {
            find("button[type=submit]").click
          }
        }
        expect(find(".clear-completed-btn")[:class]).to have_text "clear-completed-btn--disabled"
      end
    end

    context "When toggling todo completed" do
      before :each do
        list = FactoryBot.create(:list)
        @todo = FactoryBot.create(:todo, list: list)
        visit list_path(list)
      end

      context "When completed" do
        before :each do
          @todo_li = find_by_id(@todo.id)
          within(@todo_li) {
            find("button[name='todo[completed]']")
          }.click
        end

        it "toggles the corresponding complete button" do
          complete_button = within(@todo_li) { find("button[name='todo[completed]']") }
          expect(complete_button[:class]).to have_text "btn-completed"
        end

        it "sets the complete button to completed state" do
          expect(find("input.clear-completed-btn")[:class]).to have_text "clear-completed-btn--enabled"
        end
      end

      context "When not completed" do
        it "sets the complete button to uncompleted state" do
          todo_li = find_by_id(@todo.id)
          complete_button = within(todo_li) { find("button[name='todo[completed]']") }
          2.times { complete_button.click }
          expect(
            within(todo_li) { find("button[name='todo[completed]']")[:class] }
          ).to have_text "btn-not-completed"
        end
      end
    end

    context "When clearing completed todos" do
      before :each do
        @list = FactoryBot.create(:list)
        @todo_one = FactoryBot.create(:todo, list: @list,
                                             content: "Steam the milk", completed: true)
        @todo_two = FactoryBot.create(:todo, list: @list,
                                             content: "Grind the beans", completed: true)
        visit list_path(@list)
        click_on "Clear Completed"
      end

      it "removes all completed todos from the DOM" do
        expect(page).to_not have_content "Steam the milk"
        expect(page).to_not have_content "Grind the beans"
      end

      it "disables the clear completed button" do
        expect(find_by_id("clear_completed_button")[:disabled]).to have_text "true"
      end
    end
  end
end

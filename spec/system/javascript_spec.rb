require "rails_helper"

RSpec.describe "JavaScripts", type: :system, js: true do
  describe "TodoLists" do
    context "When editing a todo list" do
      before :each do
        @todo_list = FactoryBot.create(:todo_list)
        visit todo_list_path(@todo_list)
        click_on "Edit"
      end

      it "replaces the todo list details with the edit todo list form" do
        expect(page).to have_field "todo_list[title]"
        expect(page).to have_field "todo_list[description]"
        expect(page).to_not have_css "div#list-details"
      end

      it "does not change the current path" do
        expect(page).to have_current_path todo_list_path(@todo_list)
      end

      it "autofocuses on the todo list title input" do
        expect(page).to have_css "input.form-control:focus"
      end
    end

    context "When updating a todo list" do
      before :each do
        @todo_list = FactoryBot.create(:todo_list)
        visit todo_list_path(@todo_list)
        click_on "Edit"
        fill_in "todo_list[title]", with: "Updated title"
        fill_in "todo_list[description]", with: "Updated description"
        click_on "Save"
      end

      it "replaces the edit todo list form with todo list details" do
        expect(page).to have_css "div#list-details"
        expect(page).to_not have_field "todo_list[title]"
        expect(page).to_not have_field "todo_list[description]"
      end

      it "does not change the current path" do
        expect(page).to have_current_path todo_list_path(@todo_list)
      end
    end
  end

  describe "TodoItems" do
    context "When creating a todo item" do
      before :each do
        @todo_list = FactoryBot.create(:todo_list)
        @todo_item = FactoryBot.create(:todo_item, todo_list: @todo_list)
        visit todo_list_path(@todo_list)
        fill_in "todo_item[content]", with: "Grind the coffee beans"
      end

      it "adds the new todo item to the DOM" do
        within("form#new_todo_item_form") { find("button[type=submit]").click }
        expect(page).to have_text "Grind the coffee beans"
      end

      it "clears the new todo item input" do
        within("form#new_todo_item_form") { find("button[type=submit]").click }
        input_value = find("input[name='todo_item[content]']").value
        expect(input_value).to eq ''
      end

      it "removes any edit todo item forms and displays all todo items" do
        find("a.edit-btn").click
        expect(page).to have_css "textarea#edit_todo_item_content_#{@todo_item.id}"
        todo_item_content = find("p.todo-text", visible: false)
        expect(todo_item_content[:style]).to have_text "display: none;"

        within("form#new_todo_item_form") { find("button[type=submit]").click }
        expect(page).to_not have_css "textarea#edit_todo_item_content_#{@todo_item.id}"
        expect(todo_item_content[:style]).to have_text "display: block;"
      end
    end

    context "When editing a todo item" do
      before :each do
        @todo_list = FactoryBot.create(:todo_list)
        @todo_item = FactoryBot.create(:todo_item, todo_list: @todo_list)
        @another_todo_item = FactoryBot.create(:todo_item, todo_list: @todo_list)
        visit todo_list_path(@todo_list)
      end

      it "hides the corresponding todo item content" do
        find("a[href='#{edit_todo_list_todo_item_path(@todo_list, @todo_item)}']").click
        todo_item = page.find("p#todo_item_content_#{@todo_item.id}", visible: false)
        expect(todo_item[:style]).to have_text "display: none;"
      end

      it "shows the form for the corresponding todo item" do
        find("a[href='#{edit_todo_list_todo_item_path(@todo_list, @todo_item)}']").click
        expect(page).to have_css "textarea#edit_todo_item_content_#{@todo_item.id}"
      end

      it "autofocuses on the edit todo item form" do
        find("a[href='#{edit_todo_list_todo_item_path(@todo_list, @todo_item)}']").click
        expect(page).to have_css "textarea:focus"
      end

      it "cancels the edit if the same edit button is clicked twice" do
        find("a[href='#{edit_todo_list_todo_item_path(@todo_list, @todo_item)}']").click
        find("a[href='#{edit_todo_list_todo_item_path(@todo_list, @todo_item)}']").click
        todo_item = page.find("p#todo_item_content_#{@todo_item.id}", visible: false)
        expect(todo_item[:style]).to_not have_text "display: none;"
        expect(page).to_not have_css "textarea#edit_todo_item_content_#{@todo_item.id}"
      end

      it "when clicking on two different edit buttons, cancels the first and enables editing for the second" do
        find("a[href='#{edit_todo_list_todo_item_path(@todo_list, @todo_item)}']").click
        find("a[href='#{edit_todo_list_todo_item_path(@todo_list, @another_todo_item)}']").click
        todo_item = page.find("p#todo_item_content_#{@todo_item.id}", visible: false)
        another_todo_item = page.find("p#todo_item_content_#{@another_todo_item.id}", visible: false)

        expect(todo_item[:style]).to have_text "display: block;"
        expect(page).to_not have_css "textarea#edit_todo_item_content_#{@todo_item.id}"
        
        expect(another_todo_item[:style]).to have_text "display: none;"
        expect(page).to have_css "textarea#edit_todo_item_content_#{@another_todo_item.id}"
      end
    end

    context "When updating a todo item" do
      before :each do
        todo_list = FactoryBot.create(:todo_list)
        @todo_item = FactoryBot.create(:todo_item, todo_list: todo_list)
        visit todo_list_path(todo_list)
        find("a.edit-btn").click
        within("form.edit-form") { fill_in "todo_item[content]", with: "Updated todo" }
        click_on "Save"
      end

      it "updates the todo item content" do
        expect(page).to_not have_text @todo_item.content
        expect(page).to have_text @todo_item.reload.content
      end

      it "displays all todo item content and hides edit forms" do
        expect(page).to_not have_css "form.edit-form"
        expect(find("p.todo-text")[:style]).to have_text "display: block"
      end
    end

    context "When destroying a todo item" do
      before :each do
        @todo_list = FactoryBot.create(:todo_list)
        @todo_item = FactoryBot.create(:todo_item, todo_list: @todo_list)
        @todo_item_to_destroy = FactoryBot.create(:todo_item,
                                                  content: "Destroy me",
                                                  todo_list: @todo_list)
        visit todo_list_path(@todo_list)
      end

      it "removes the corresponding todo item from the DOM" do
        destroy_todo_item_path = todo_list_todo_item_path(@todo_list, @todo_item_to_destroy)
        todo_li = find_by_id(@todo_item_to_destroy.id)
        within(todo_li) {
          within(page.find_by_id("destroy_todo_item_#{@todo_item_to_destroy.id}")) {
            find("button[type=submit]").click
          }
        }
        page.driver.browser.switch_to.alert.accept
        expect(page).to_not have_text @todo_item_to_destroy.content
      end

      it "disables the clear completed button if no completed todo items remain" do
        destroy_todo_item_path = todo_list_todo_item_path(@todo_list, @todo_item_to_destroy)
        todo_li = find_by_id(@todo_item_to_destroy.id)
        within(todo_li) { find("button[name='todo_item[completed]']").click }
        expect(find(".clear-completed-btn")[:class]).to have_text "clear-completed-btn--enabled"
        within(todo_li) {
          within(page.find_by_id("destroy_todo_item_#{@todo_item_to_destroy.id}")) {
            find("button[type=submit]").click
          }
        }
        page.driver.browser.switch_to.alert.accept
        expect(find(".clear-completed-btn")[:class]).to have_text "clear-completed-btn--disabled"
      end
    end

    context "When toggling todo item completed" do
      before :each do
        todo_list = FactoryBot.create(:todo_list)
        @todo_item = FactoryBot.create(:todo_item, todo_list: todo_list)
        visit todo_list_path(todo_list)
      end

      context "When completed" do
        before :each do
          todo_li = find_by_id(@todo_item.id)
          @complete_button = within(todo_li) { find("button[name='todo_item[completed]']") }
          @complete_button.click
        end

        it "sets the form submit value to false" do
          expect(@complete_button[:value]).to eq "true"
        end

        it "enables the clear completed button if completed" do
          expect(find("input.clear-completed-btn")[:class]).to have_text "clear-completed-btn--enabled"
        end
      end

      context "When not completed" do
        it "sets the form submit value to true" do
          todo_li = find_by_id(@todo_item.id)
          @complete_button = within(todo_li) { find("button[name='todo_item[completed]']") }
          2.times { @complete_button.click }
          expect(@complete_button[:value]).to eq "false"
        end
      end
    end

    context "When clearing completed todo items" do
      it "removes all completed todo items from the DOM" do
        todo_list = FactoryBot.create(:todo_list)
        todo_item_one = FactoryBot.create(:todo_item, todo_list: todo_list,
                                          content: "Steam the milk", completed: true)
        todo_item_two = FactoryBot.create(:todo_item, todo_list: todo_list,
                                          content: "Grind the beans", completed: true)
        visit todo_list_path(todo_list)
        click_on "Clear Completed"
        expect(page).to_not have_content "Steam the milk"
        expect(page).to_not have_content "Grind the beans"
      end
    end
  end
end

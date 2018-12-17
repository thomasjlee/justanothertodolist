require "rails_helper"

RSpec.describe "TodoItems", type: :system do
  it "creates a new todo item" do
    todo_list = FactoryBot.create(:todo_list)
    visit todo_list_path(todo_list)
    fill_in "todo_item[content]", with: "Boil the water"
    expect {
      find("button[type='submit']").click
    }.to change(TodoItem, :count).by(1)
    expect(page).to have_text "Boil the water"
  end

  it "edits a todo item" do
    todo_item      = FactoryBot.create(:todo_item)
    todo_path      = todo_list_todo_item_path(todo_item.todo_list, todo_item)
    edit_todo_path = edit_todo_list_todo_item_path(todo_item.todo_list, todo_item)

    visit todo_list_path(todo_item.todo_list)
    find("a[href='#{edit_todo_path}']").click
    expect(page).to have_css "form[action='#{todo_path}']"

    within('form.edit-form') { fill_in "todo_item[content]",
                               with: "Edited todo item" }
    click_on "Save"
    expect(todo_item.reload.content).to eq "Edited todo item"
  end

  describe "when the edit todo button is clicked", js: true do
    before(:all) do
      @todo_item = FactoryBot.create(:todo_item)
      @item_path = todo_list_todo_item_path(@todo_item.todo_list, @todo_item)
      @edit_item_path = edit_todo_list_todo_item_path(@todo_item.todo_list, @todo_item)
      @edit_link_css  = "a[href='#{@edit_item_path}']"
      @edit_form_css  = "form[action='#{@item_path}'] textarea[name='todo_item[content]']"
    end

    it "shows the edit todo form" do
      visit todo_list_path(@todo_item.todo_list)
      find(@edit_link_css).click
      expect(page).to have_css @edit_form_css
    end

    it "hides the edit todo form if the form is already shown" do
      visit todo_list_path(@todo_item.todo_list)
      2.times { find(@edit_link_css).click }
      expect(page).to_not have_css @edit_form_css
    end
  end

  it "deletes a todo item" do
    todo_item = FactoryBot.create(:todo_item)
    todo_path = todo_list_todo_item_path(todo_item.todo_list, todo_item)

    visit todo_list_path(todo_item.todo_list)
    expect {
      within(".todo-row-right") do
        find("button[type='submit']").click
      end
    }.to change(TodoItem, :count).by(-1)
  end

  it "completes a todo item" do
    todo_item = FactoryBot.create(:todo_item)
    visit todo_list_path(todo_item.todo_list)
    find("[name='todo_item[completed]']").click
    expect(todo_item.reload.completed).to be true
  end

  it "uncompletes a todo item" do
    todo_item = FactoryBot.create(:todo_item, completed: true)
    visit todo_list_path(todo_item.todo_list)
    expect(page).to have_css "button.btn-completed"
    find("[name='todo_item[completed]']").click
    expect(todo_item.reload.completed).to be false
  end
end

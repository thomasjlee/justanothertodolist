require "rails_helper"

RSpec.describe "TodoItems", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "creates a new todo item" do
    todo_list = FactoryBot.create(:todo_list)
    visit todo_list_path(todo_list)
    fill_in "todo_item[name]", with: "Boil the water"
    expect {
      find("button[type='submit']").click
    }.to change(TodoItem, :count).by(1)
    expect(page).to have_text "Boil the water"
  end

  it "creates a new todo item with ujs"

  it "edits a todo item" do
    todo_item      = FactoryBot.create(:todo_item)
    todo_path      = todo_list_todo_item_path(todo_item.todo_list, todo_item)
    edit_todo_path = edit_todo_list_todo_item_path(todo_item.todo_list, todo_item)

    visit todo_list_path(todo_item.todo_list)
    find("a[href='#{edit_todo_path}']").click
    expect(page).to have_css "form[action='#{todo_path}']"

    within('form.edit-form') { fill_in "todo_item[name]",
                               with: "Edited todo item" }
    click_on "Save"
    expect(todo_item.reload.name).to eq "Edited todo item"
  end

  it "deletes a todo item with delete confirmation"

  it "deletes a todo item" do
    todo_item = FactoryBot.create(:todo_item)
    todo_path = todo_list_todo_item_path(todo_item.todo_list, todo_item)

    visit todo_list_path(todo_item.todo_list)
    expect {
      within("form[action='#{todo_path}']") do
        find("button[type='submit']").click
      end
    }.to change(TodoItem, :count).by(-1)
  end

  it "completes a todo item" do
    todo_item = FactoryBot.create(:todo_item)
    todo_path = todo_list_todo_item_path(todo_item.todo_list, todo_item)
    complete_todo_path = complete_todo_list_todo_item_path(todo_item.todo_list, todo_item)

    visit todo_list_path(todo_item.todo_list)
    within("form[action='#{complete_todo_path}']") do
      find("button[type=submit]").click
    end
    expect(todo_item.reload.completed).to be true
  end

  it "uncompletes a todo item" do
    todo_item = FactoryBot.create(:todo_item, completed: true)
    complete_todo_path = complete_todo_list_todo_item_path(todo_item.todo_list, todo_item)

    visit todo_list_path(todo_item.todo_list)
    expect(page).to have_css "button.btn-completed"

    within("form[action='#{complete_todo_path}']") do
      find("button[type=submit]").click
    end
    expect(todo_item.reload.completed).to be false
  end
end

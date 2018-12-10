require "rails_helper"

RSpec.describe "TodoLists", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "creates a new todo list" do
    visit root_path
    click_on "Add List"
    expect(page).to have_current_path new_todo_list_path
    fill_in "todo_list[name]", with: "New List"
    fill_in "todo_list[description]", with: "This is a new todo list."
    expect { click_on "Save" }.to change(TodoList, :count).by(1) 
    expect(page).to have_current_path /todo_lists\/\d+$/
  end

  it "shows a newly created todo list" do
    todo_list = FactoryBot.create(:todo_list)
    visit root_path
    click_on todo_list.name
    expect(page).to have_current_path "/todo_lists/#{todo_list.id}"
  end

  it "edits a todo list" do
    todo_list = FactoryBot.create(:todo_list)
    visit todo_list_path(todo_list)
    click_on "Edit"
    expect(page).to have_current_path "/todo_lists/#{todo_list.id}/edit"
    fill_in "todo_list[name]", with: "Edited List"
    fill_in "todo_list[description]", with: "Edited todo list description."
    click_on "Save"
    expect(todo_list.reload.name).to eq "Edited List"
    expect(todo_list.reload.description).to eq "Edited todo list description."
    expect(page).to have_current_path todo_list_path(todo_list)
  end

  it "deletes a todo list" do
    todo_list = FactoryBot.create(:todo_list)
    visit todo_list_path(todo_list)
    expect { click_on "Delete" }.to change(TodoList, :count).by(-1)
    expect(page).to have_current_path todo_lists_path
  end
end


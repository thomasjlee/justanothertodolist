require "rails_helper"

RSpec.describe "TodoLists", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "creates a new todo_list" do
    visit root_path
    click_on "Add List"
    expect(page).to have_current_path /todo_lists\/new$/
    fill_in "todo_list[name]", with: "New List"
    fill_in "todo_list[description]", with: "This is a new todo list."
    expect { click_on "Save" }.to change(TodoList, :count).by(1) 
    expect(page).to have_current_path /todo_lists\/\d+$/
  end

  it "edits a todo_list"

  it "deletes a todo_list" do
    todo_list = FactoryBot.create(:todo_list)
    visit root_path
    click_on todo_list.name
    expect(page).to have_current_path "/todo_lists/#{todo_list.id}"
    expect { click_on "Delete" }.to change(TodoList, :count).by(-1)
    expect(page).to have_current_path todo_lists_path
  end
end


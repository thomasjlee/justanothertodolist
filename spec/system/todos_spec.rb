require "rails_helper"

def user_grants_authorization_on_twitter(twitter_callback_hash)
  OmniAuth.config.add_mock(:twitter, twitter_callback_hash)
end

RSpec.describe "Todos", type: :system do
  let(:twitter_callback_hash) do
    {
      provider: "twitter",
      uid: "1234567",
      credentials: {
        token: "222222",
        secret: "333333",
      },
      info: {
        nickname: "mock_nickname",
      },
    }
  end

  describe "when creating a new todo" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      visit "/auth/twitter"
    end

    it "creates a new todo" do
      list = FactoryBot.create(:list, user: @user)
      visit list_path(list)
      fill_in "new_todo_item_content", with: "Boil the water"
      expect {
        find("button[type='submit']").click
      }.to change(Todo, :count).by(1)
      expect(page).to have_text "Boil the water"
    end

    it "clears the new todo form", js: true do
      list = FactoryBot.create(:list, user: @user)
      visit list_path(list)
      fill_in "new_todo_item_content", with: "Boil the water."
      find("button[type='submit']").click
      expect(find_field("new_todo_item_content").value).to eq ""
    end

    it "clears the new todo form even when an edit todo button was clicked", js: true do
      list = FactoryBot.create(:list, user: @user)
      todo = FactoryBot.create(:todo, list: list)
      edit_todo_path = edit_list_todo_path(list, todo)
      new_todo_form = "form[action='#{list_todos_path(list)}']"

      visit list_path(list)
      find("a.edit-btn[data-todo-id='#{todo.id}']").click
      fill_in "new_todo_item_content", with: "Grind the coffee."
      find("#{new_todo_form} button[type='submit']").click

      within(new_todo_form) do
        expect(find_field("new_todo_item_content").value).to eq ""
      end
    end
  end

  describe "when editing a todo" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      visit "/auth/twitter"
    end

    it "edits a todo" do
      list = FactoryBot.create(:list, user: @user)
      todo = FactoryBot.create(:todo, list: list)
      todo_path = list_todo_path(list, todo)
      edit_todo_path = edit_list_todo_path(list, todo)

      visit list_path(list)
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
        @list = FactoryBot.create(:list, user: @user)
        @todo = FactoryBot.create(:todo, list: @list)
        @todo_path = list_todo_path(@list, @todo)
        @edit_todo_path = edit_list_todo_path(@list, @todo)
        @edit_link_css = "a.edit-btn[data-todo-id='#{@todo.id}']"
        @edit_form_css = "form[action='#{@todo_path}'] textarea[name='todo[content]']"
      end

      it "shows the edit todo form" do
        visit list_path(@list)
        find(@edit_link_css).click
        expect(page).to have_css @edit_form_css
      end

      it "hides the edit todo form if the form is already shown" do
        visit list_path(@list)
        2.times { find(@edit_link_css).click }
        expect(page).to_not have_css @edit_form_css
      end
    end
  end

  describe "when deleting a todo" do
    it "deletes a todo" do
      OmniAuth.config.mock_auth[:twitter] = nil
      user = FactoryBot.create(:user)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: user.uid))
      visit "/auth/twitter"

      list = FactoryBot.create(:list, user: user)
      todo = FactoryBot.create(:todo, list: list)
      todo_path = list_todo_path(list, todo)

      visit list_path(list)
      expect {
        within(".todo-row-right") do
          find("button[type='submit']").click
        end
      }.to change(Todo, :count).by(-1)
    end
  end

  describe "when toggling todo completed" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      @list = FactoryBot.create(:list, user: @user)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      visit "/auth/twitter"
    end

    it "completes a todo" do
      todo = FactoryBot.create(:todo, list: @list)
      visit list_path(@list)
      find("[name='todo[completed]']").click
      expect(todo.reload.completed).to be true
    end

    it "uncompletes a todo" do
      todo = FactoryBot.create(:todo, list: @list, completed: true)
      visit list_path(@list)
      expect(page).to have_css "button.btn-completed"
      find("[name='todo[completed]']").click
      expect(todo.reload.completed).to be false
    end
  end
end

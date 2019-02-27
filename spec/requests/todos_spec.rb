require 'rails_helper'

def user_grants_authorization_on_twitter(twitter_callback_hash)
  OmniAuth.config.add_mock(:twitter, twitter_callback_hash)
end

RSpec.describe "Todos", type: :request do
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

  context "as guest user" do
    describe "GET /lists/:list_id/todos/:id/edit" do
      it "redirects to lists" do
        some_user = FactoryBot.create(:user)
        some_list = FactoryBot.create(:list, user: some_user)
        todo = FactoryBot.create(:todo, list: some_list)

        get edit_list_todo_path(some_list, todo)

        expect(response).to have_http_status 302
        expect(response).to redirect_to lists_path
      end
    end

    describe "PATCH /lists/:list_id/todos/:id" do
      it "does not allow guest to update a todo" do
        some_user = FactoryBot.create(:user)
        some_list = FactoryBot.create(:list, user: some_user)
        todo = FactoryBot.create(:todo, list: some_list)
        original_content = todo.content

        patch list_todo_path(some_list, todo, todo: { content: "Updated todo" })

        expect(response).to have_http_status 302
        expect(response).to redirect_to lists_path
        expect(todo.reload.content).to eq original_content
      end
    end

    describe "DELETE /lists/:list_id/todos/:id" do
      it "does not allow guest to delete a todo" do
        some_user = FactoryBot.create(:user)
        some_list = FactoryBot.create(:list, user: some_user)
        todo = FactoryBot.create(:todo, list: some_list)

        expect {
          delete list_todo_path(some_list, todo)
        }.to change(Todo, :count).by 0
        expect(response).to have_http_status 302
        expect(response).to redirect_to lists_path
      end
    end

    describe "PATCH /lists/:list_id/todos/:id/complete" do
      it "does not allow guest to toggle a todo's completed status" do
        some_user = FactoryBot.create(:user)
        some_list = FactoryBot.create(:list, user: some_user)
        todo = FactoryBot.create(:todo, list: some_list, completed: false)

        patch complete_list_todo_path(some_list, todo, todo: { completed: true })
        expect(todo.reload.completed).to be false
        expect(response).to redirect_to lists_path
      end
    end

    describe "DELETE /lists/:list_id/todos/clear_completed" do
      it "does not allow a guest to clear a list's completed todos" do
        some_user = FactoryBot.create(:user)
        some_list = FactoryBot.create(:list, user: some_user)
        completed_one = FactoryBot.create(:todo, list: some_list, completed: true)
        completed_two = FactoryBot.create(:todo, list: some_list, completed: true)
        incomplete_todo = FactoryBot.create(:todo, list: some_list, completed: false)

        expect {
          delete clear_list_todos_path(some_list)
        }.to change(Todo, :count).by 0
        expect(response).to redirect_to lists_path
        expect(some_list.todos).to include completed_one
        expect(some_list.todos).to include completed_two
        expect(some_list.todos).to include incomplete_todo
      end
    end
  end

  context "as unauthorized user" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      @list_owner       = FactoryBot.create(:user)
      @list_owners_list = FactoryBot.create(:list, user: @list_owner)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      get "/auth/twitter"
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(@user)
    end

    describe "GET /lists/:list_id/todos/:id/edit" do
      it "redirects to lists" do
        todo = FactoryBot.create(:todo, list: @list_owners_list)

        get edit_list_todo_path(@list_owners_list, todo)

        expect(response).to have_http_status 302
        expect(response).to redirect_to lists_path
      end
    end

    describe "PATCH /lists/:list_id/todos/:id" do
      it "does not allow user to update another user's todo" do
        todo = FactoryBot.create(:todo, list: @list_owners_list)
        original_content = todo.content

        patch list_todo_path(@list_owners_list, todo, todo: { content: "Updated todo" })

        expect(response).to have_http_status 302
        expect(response).to redirect_to lists_path
        expect(todo.reload.content).to eq original_content
      end
    end

    describe "DELETE /lists/:list_id/todos/:id" do
      it "does not allow user to delete another user's todo" do
        todo = FactoryBot.create(:todo, list: @list_owners_list)

        expect {
          delete list_todo_path(@list_owners_list, todo)
        }.to change(Todo, :count).by 0
        expect(response).to have_http_status 302
        expect(response).to redirect_to lists_path
      end
    end

    describe "PATCH /lists/:list_id/todos/:id/complete" do
      it "does not allow user to toggle another user's todo's completed status" do
        todo = FactoryBot.create(:todo, list: @list_owners_list, completed: false)

        patch complete_list_todo_path(@list_owners_list, todo, todo: { completed: true })
        expect(todo.reload.completed).to be false
        expect(response).to redirect_to lists_path
      end
    end

    describe "DELETE /lists/:list_id/todos/clear_completed" do
      it "does not allow user to clear another user's list's completed todos" do
        completed_one = FactoryBot.create(:todo, list: @list_owners_list, completed: true)
        completed_two = FactoryBot.create(:todo, list: @list_owners_list, completed: true)
        incomplete_todo = FactoryBot.create(:todo, list: @list_owners_list, completed: false)

        expect {
          delete clear_list_todos_path(@list_owners_list)
        }.to change(Todo, :count).by 0
        expect(response).to redirect_to lists_path
        expect(@list_owners_list.todos).to include completed_one
        expect(@list_owners_list.todos).to include completed_two
        expect(@list_owners_list.todos).to include incomplete_todo
      end
    end
  end

  context "as authorized user" do
    before :each do
      OmniAuth.config.mock_auth[:twitter] = nil
      @user = FactoryBot.create(:user)
      @list = FactoryBot.create(:list, user: @user)
      user_grants_authorization_on_twitter(twitter_callback_hash.merge(uid: @user.uid))
      get "/auth/twitter"
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(@user)
    end

    describe "POST /lists/:list_id/todos" do
      it "creates a new todo" do
        expect {
          post list_todos_path(@list, todo: { content: "Test todo" })
        }.to change(Todo, :count).by 1
        expect(response).to have_http_status 302
        expect(response).to redirect_to list_path(@list)
      end
    end

    describe "GET /lists/:list_id/todos/:id/edit" do
      it "responds successfully" do
        todo = FactoryBot.create(:todo, list: @list)
        get edit_list_todo_path(@list, todo)
        expect(response).to have_http_status 200
      end
    end

    describe "PATCH /lists/:list_id/todos/:id" do
      it "updates the todo" do
        todo = FactoryBot.create(:todo, list: @list)
        original_content = todo.content

        patch list_todo_path(@list, todo, todo: { content: "Updated todo" })
        expect(response).to have_http_status 302
        expect(response).to redirect_to list_path(@list)
        expect(todo.reload.content).to eq "Updated todo"
      end
    end

    describe "DELETE /lists/:list_id/todos/:id" do
      it "deletes the todo" do
        todo = FactoryBot.create(:todo, list: @list)

        expect {
          delete list_todo_path(@list, todo)
        }.to change(Todo, :count).by -1
        expect(response).to have_http_status 302
        expect(response).to redirect_to list_path(@list)
      end
    end

    describe "PATCH /lists/:list_id/todos/:id/complete" do
      it "sets incomplete todo to completed" do
        todo = FactoryBot.create(:todo, list: @list, completed: false)
        patch complete_list_todo_path(@list, todo, todo: { completed: true })
        expect(todo.reload.completed).to be true
      end

      it "sets completed todo to not completed" do
        todo = FactoryBot.create(:todo, list: @list, completed: true)
        patch complete_list_todo_path(@list, todo, todo: { completed: false })
        expect(todo.reload.completed).to be false
      end
    end

    describe "DELETE /lists/:list_id/todos/clear_completed" do
      it "clears a list's completed todos" do
        completed_one = FactoryBot.create(:todo, list: @list, completed: true)
        completed_two = FactoryBot.create(:todo, list: @list, completed: true)
        incomplete_todo = FactoryBot.create(:todo, list: @list, completed: false)

        expect {
          delete clear_list_todos_path(@list)
        }.to change(Todo, :count).by -2
        expect(response).to redirect_to list_path(@list)
        expect(@list.todos).to_not include completed_one
        expect(@list.todos).to_not include completed_two
        expect(@list.todos).to     include incomplete_todo
      end
    end
  end
end

# Todos Actions
#. clear_list_todos   DELETE /lists/:list_id/todos/clear_completed(.:format) todos#clear_completed
#. complete_list_todo PATCH  /lists/:list_id/todos/:id/complete(.:format)    todos#complete
#. list_todos         POST   /lists/:list_id/todos(.:format)                 todos#create
#. edit_list_todo     GET    /lists/:list_id/todos/:id/edit(.:format)        todos#edit
#. list_todo          PATCH  /lists/:list_id/todos/:id(.:format)             todos#update
#.                    DELETE /lists/:list_id/todos/:id(.:format)             todos#destroy

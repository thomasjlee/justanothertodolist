class TodoListsController < ApplicationController
  before_action :set_todo_list, only: [:show, :edit, :update, :destroy]

  def index
    @todo_lists = TodoList.all
  end

  def show
  end

  def new
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_todo_list
    @todo_list = TodoList.find(params[:id])
  end
end

class TodoListsController < ApplicationController
  before_action :set_todo_list, only: [:show, :edit, :update, :destroy]

  def index
    @todo_lists = TodoList.all
  end

  def show
    @todo_list_items = @todo_list.todo_items.order(created_at: :asc)
  end

  def new
    @todo_list = TodoList.new
  end

  def create
    @todo_list = TodoList.new(todo_list_params)

    if @todo_list.save
      redirect_to @todo_list
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @todo_list.update_attributes(todo_list_params)
      redirect_to @todo_list
    else
      render 'edit'
    end
  end

  def destroy
    if @todo_list.destroy
      redirect_to todo_lists_path
    end
  end

  private

  def set_todo_list
    @todo_list = TodoList.find(params[:id])
  end

  def todo_list_params
    params.require(:todo_list).permit(:name, :description)
  end
end

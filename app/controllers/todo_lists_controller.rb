class TodoListsController < ApplicationController
  before_action :set_todo_list, only: [:show, :edit, :update, :destroy]
  before_action :set_ordered_items, only: [:show, :edit]

  def index
    @todo_lists = TodoList.all
  end

  def show
  end

  def new
    @todo_list = TodoList.new
  end

  def create
    @todo_list = TodoList.new(todo_list_params)
    respond_to do |format|
      if @todo_list.save
        format.html { redirect_to @todo_list }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @editing_list = true
    respond_to do |format|
      format.html { render :show }
      format.js
    end
  end

  def update
    respond_to do |format|
      if @todo_list.update_attributes(todo_list_params)
        format.html { redirect_to @todo_list }
        format.js
      else
        render :edit
      end
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

    def set_ordered_items
      @todo_list_items = @todo_list.todo_items.order(created_at: :asc)
    end

    def todo_list_params
      params.require(:todo_list).permit(:title, :description)
    end
end

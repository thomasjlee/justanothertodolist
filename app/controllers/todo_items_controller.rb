class TodoItemsController < ApplicationController
  before_action :set_todo_list
  before_action :set_todo_item, except: [:create, :clear_completed]

  def create
    @todo_item = @todo_list.todo_items.create(todo_item_params)
    redirect_to @todo_list
  end

  def update
    if @todo_item.update_attributes(todo_item_params)
      redirect_to @todo_list
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @todo_item.destroy
    respond_to do |format|
      format.html { redirect_to @todo_list }
      format.js
    end
  end

  def complete
    @todo_item.toggle!(:completed)
    respond_to do |format|
      format.html { redirect_to @todo_list }
      format.js
    end
  end

  def clear_completed
    @todo_items = @todo_list.todo_items.where(completed: true)
    @todo_items.destroy_all
    redirect_to @todo_list
  end

  private

    def set_todo_list
      @todo_list = TodoList.find(params[:todo_list_id])
    end

    def set_todo_item
      @todo_item = @todo_list.todo_items.find(params[:id])
    end

    def todo_item_params
      params.require(:todo_item).permit(:name, :completed)
    end
end

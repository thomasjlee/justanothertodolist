class TodoItemsController < ApplicationController
  before_action :set_todo_list
  before_action :set_todo_item, except: [:create, :clear_completed]

  def create
    @todo_item = @todo_list.todo_items.build(todo_item_params)
    respond_to do |format|
      if @todo_item.save
        format.js
        format.html { redirect_to @todo_list }
      else
        format.html { redirect_to @todo_list }
      end
    end
  end

  def edit
    @todo_list_items = @todo_list.todo_items.order(created_at: :asc)
    @editing_todo = TodoItem.find(params[:id])
    respond_to do |format|
      format.html { render "todo_lists/show" }
      format.js
    end
  end

  def update
    respond_to do |format|
      if @todo_item.update_attributes(todo_item_params)
        format.html { redirect_to @todo_list }
        format.js do
          render "update"   if params[:todo_item][:content]
          render "complete" if params[:todo_item][:completed]
        end
      else
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def destroy
    @todo_item.destroy
    respond_to do |format|
      format.html { redirect_to @todo_list }
      format.js
    end
  end

  def clear_completed
    @todo_list.todo_items.where(completed: true).destroy_all
    respond_to do |format|
      format.html { redirect_to @todo_list }
      format.js
    end
  end

  private

    def set_todo_list
      @todo_list = TodoList.find(params[:todo_list_id])
    end

    def set_todo_item
      @todo_item = @todo_list.todo_items.find(params[:id])
    end

    def todo_item_params
      params.require(:todo_item).permit(:content, :completed)
    end
end

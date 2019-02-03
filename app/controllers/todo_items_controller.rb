class TodoItemsController < ApplicationController
  before_action :set_todo_list
  before_action :set_todo_item, except: [:create, :clear_completed]

  def create
    @todo_item = @todo_list.todo_items.build(todo_item_params)
    if @todo_item.save
      if params[:js] == "true"
        render @todo_item
      else
        redirect_to @todo_list
      end
    else
      # TODO: handle error case
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
          render "update"
        end
      else
        # TODO: handle error case
      end
    end
  end

  def destroy
    @todo_item.destroy
    redirect_to @todo_list unless params[:js] == "true"
  end

  def complete
    if @todo_item.update_attributes(todo_item_params)
      redirect_to @todo_list unless params[:js] == "true"
    else
      # TODO: handle error case
    end
  end

  def clear_completed
    @todo_list.todo_items.where(completed: true).destroy_all
    redirect_to @todo_list unless params[:js] == "true"
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

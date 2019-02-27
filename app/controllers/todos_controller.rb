class TodosController < ApplicationController
  before_action :set_list
  before_action :set_todo, except: [:create, :clear_completed]
  before_action :authorize_or_redirect

  def create
    @todo = @list.todos.build(todo_params)
    if @todo.save
      if params[:js] == "true"
        render @todo
      else
        redirect_to @list
      end
    else
      # TODO: handle error case
    end
  end

  def edit
    @list_todos = @list.todos.order(created_at: :asc)
    render "lists/show"
  end

  def update
    if @todo.update_attributes(todo_params)
      if params[:js] == "true"
        render plain: @todo.content
      else
        redirect_to @list
      end
    else
      # TODO: handle error case
    end
  end

  def destroy
    @todo.destroy
    redirect_to @list unless params[:js] == "true"
  end

  def complete
    if @todo.update_attributes(todo_params)
      redirect_to @list unless params[:js] == "true"
    else
      # TODO: handle error case
    end
  end

  def clear_completed
    @list.todos.where(completed: true).destroy_all
    redirect_to @list unless params[:js] == "true"
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def set_todo
    @todo = @list.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:content, :completed)
  end

  def authorize_or_redirect
    redirect_to lists_path unless @list.user == current_user
  end
end

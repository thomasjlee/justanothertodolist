class ListsController < ApplicationController
  before_action :require_authentication, only: [:new, :create]
  before_action :set_list, only: [:show, :update, :destroy]
  before_action :authorize_or_redirect, only: [:show, :update, :destroy]
  before_action :set_ordered_items, only: [:show]

  def index
    @lists = List.all
  end

  def show
  end

  def new
  end

  def create
    @list = current_user.lists.new(list_params)
    respond_to do |format|
      if @list.save
        format.html { redirect_to @list }
      else
        format.html { render :new }
      end
    end
  end

  def update
    if @list.update_attributes(list_params)
      redirect_to @list
    else
      render :show
    end
  end

  def destroy
    if @list.destroy
      redirect_to lists_path
    end
  end

  private

  def require_authentication
    redirect_to lists_path unless current_user
  end

  def set_list
    @list = List.find(params[:id])
  end

  def authorize_or_redirect
    redirect_to lists_path unless @list.user == current_user
  end

  def set_ordered_items
    @list_todos = @list.todos.order(created_at: :asc)
  end

  def list_params
    params.require(:list).permit(:title, :description)
  end
end

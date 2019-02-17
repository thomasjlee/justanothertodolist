class ListsController < ApplicationController
  before_action :set_list, only: [:show, :update, :destroy]
  before_action :set_ordered_items, only: [:show]

  def index
    @lists = List.all
  end

  def show
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
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

  def set_list
    @list = List.find(params[:id])
  end

  def set_ordered_items
    @list_items = @list.todo_items.order(created_at: :asc)
  end

  def list_params
    params.require(:list).permit(:title, :description)
  end
end

class StaticPagesController < ApplicationController
  def home
    redirect_to lists_path if current_user
  end
end

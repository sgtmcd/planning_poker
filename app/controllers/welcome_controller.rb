class WelcomeController < ApplicationController
  def index
  end

  def new_round
    Developer.destroy_all
    render :index
  end

  def vote
    if params[:n] && params[:vote]
      d = Developer.find_or_create_by_name params[:n]
      d.vote = params[:vote]
      d.save
      redirect_to controller: 'welcome', action: 'index', n: params[:n]
    end    
  end
end

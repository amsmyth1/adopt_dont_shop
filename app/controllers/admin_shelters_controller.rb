class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.all_desc
  end

  def show
    @shelter = Shelter.admin_show_query(params[:id]).first
  end
end

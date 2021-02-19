class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.all_desc
    @shelters_pending_apps = Pet.shelters_with_pending_applications
  end

  def show
    @shelter = Shelter.admin_show_query(params[:id]).first
  end
end

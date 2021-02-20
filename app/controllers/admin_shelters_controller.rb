class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.all_desc
    @shelters_pending_apps = Shelter.shelters_with_pending_applications.distinct(:id).order(:name)
  end

  def show
    @shelter = Shelter.admin_show_query(params[:id]).first
  end
end

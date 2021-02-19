class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.all_desc
    shelter_ids_pending_apps = Pet.shelters_with_pending_applications
    @shelters_pending_apps = shelter_ids_pending_apps.map do |ar_object|
      Shelter.find(ar_object.shelter_id)
    end
  end

  def show
    @shelter = Shelter.admin_show_query(params[:id]).first
  end
end

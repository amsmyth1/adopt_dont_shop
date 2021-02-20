class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.all_desc
    @shelters_pending_apps = Shelter.shelters_with_pending_applications.distinct(:id).order(:name)
  end

  def show
    @shelter = Shelter.admin_show_query(params[:id]).first
    @shelter_average_pet_age = @shelter.average_pet_age
    @shelter_pet_count = @shelter.pet_count
    @shelter_number_adopted_pets = @shelter.adopted_pet_count
    @shelter_pets_not_reviewed_on_apps = @shelter.pets_pending_app_reivew
  end
end

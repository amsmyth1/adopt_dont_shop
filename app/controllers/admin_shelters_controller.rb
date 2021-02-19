class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.all_desc
    @shelters_with_pending_applications = Shelter.all.map do |shelter|
      Application.shelter_associations(shelter.id)
    end
  end

  def show
    @shelter = Shelter.admin_show_query(params[:id]).first
  end
end

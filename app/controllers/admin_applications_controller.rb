class AdminApplicationsController < ApplicationController

  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
    @pets = @application.pets #move to view
    if params[:commit] == "Approve this Pet"
      @pet_approved = Pet.find(params[:pet_id])
      ApplicationPet.approve(@pet_approved.id, @application.id)
    end
    if params[:commit] == "Reject this Pet"
      @pet_approved = Pet.find(params[:pet_id])
      ApplicationPet.reject(@pet_approved.id, @application.id)
    end
    @application.approve_or_reject
  end
end

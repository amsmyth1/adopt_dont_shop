class ApplicationsController < ApplicationController

  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
    @app_pet_status =
    @pets = @application.pets
    @search_pets = Pet.search(params[:query])

    if params[:commit] == "Adopt This Pet"
      @pet_to_adopt = Pet.find(params[:pet_id])
      @application.pets << @pet_to_adopt
    end
  end

  def new
  end

  def create
    new_params = application_params.merge({status: "In Progress"})
    application = Application.new(new_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      flash[:notice] = "Application not created: Required information missing."
      render :new
    end
  end

  def update
    application = Application.find(params[:id])
    application.update(description: params[:app_submission])
    if params[:commit] == "Submit Application"
      application.update({status: "Pending"})
    end
    redirect_to "/applications/#{application.id}"
  end

  private
  def application_params
    params.permit(:first_name, :last_name, :street_address, :city, :state, :zip, :description)
  end
end

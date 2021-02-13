class ApplicationsController < ApplicationController

  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
  end

  def edit
    @application = Application.find(params[:id])
  end

  def update
    app = Application.find(params[:id])
    app.update(app_params)

    redirect_to "/applications/#{app.id}"
  end

  def destroy
    Application.destroy(params[:id])

    redirect_to "/applications"
  end

  privete
  def application_params
    params.permit(:first_name, :last_name, :street_address, :city, :state, :zip)
  end 
end

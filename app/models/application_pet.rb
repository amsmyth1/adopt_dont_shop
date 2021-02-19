class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  validates :pet_id, presence:true
  validates :application_id, presence:true

  before_create do
    self.application_status = "Pending"
  end

  def self.status(app_pet_id, app_application_id)
    app_pet = find_by(pet_id: app_pet_id, application_id: app_application_id)
    pet = Pet.find(app_pet_id)
    if app_pet.application_status == "Pending"
      if pet.adoptable == false
        app_pet.update(application_status: "Pending with issue")
        app_pet.application_status
      else
        app_pet.application_status
      end
    else
      app_pet.application_status
    end
  end

  def self.approve(app_pet_id, app_application_id)
    app_pet = find_by(pet_id: app_pet_id, application_id: app_application_id)
    app_pet.update(application_status: "Approved")
  end

  def self.reject(app_pet_id, app_application_id)
    app_pet = find_by(pet_id: app_pet_id, application_id: app_application_id)
    app_pet.update(application_status: "Rejected")
  end

  def self.other_applications_with_pet(app_pet_id, app_id)
    pets_all = ApplicationPet.where(pet_id: app_pet_id)
    pets = pets_all.where.not(application_id: app_id)
    pets.update(application_status: "Pending with issue")
  end
end

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
    app_pet.application_status
  end

  def self.approve(app_pet_id, app_application_id)
    app_pet = find_by(pet_id: app_pet_id, application_id: app_application_id)
    app_pet.update(application_status: "Approved")
  end

  def self.reject(app_pet_id, app_application_id)
    app_pet = find_by(pet_id: app_pet_id, application_id: app_application_id)
    app_pet.update(application_status: "Rejected")
  end
end

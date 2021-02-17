class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true

  def approve
    id = self.id
    app_pets_ids = ApplicationPet.where(application_id: id)
    app_pets_ids.map do |app_pet|
      pet = Pet.find(app_pet.pet_id)
      pet.adopt
    end
    update(status: "Approved")
  end

  def reject
    update(status: "Rejected")
  end

  def can_approve?
    id = self.id
    app_pets_ids = ApplicationPet.where(application_id: id)
    if all_pets_reviewed?
      app_pets_ids.all? do |app_pet|
        app_pet.application_status == "Approved"
      end
    else
      false
    end
  end

  def can_reject?
    id = self.id
    app_pets_ids = ApplicationPet.where(application_id: id)
    if all_pets_reviewed?
      app_pets_ids.any? do |app_pet|
        app_pet.application_status == "Rejected"
      end
    else
      false
    end
  end

  def all_pets_reviewed?
    id = self.id
    app_pets_ids = ApplicationPet.where(application_id: id)
    app_pets_ids.none? do |app_pet|
      app_pet.application_status == "Pending"
    end
  end
end

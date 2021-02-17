class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true

  def approve_or_reject
    if can_approve?
      id = self.id
      adopt_all_pets
      update(status: "Approved")
    elsif can_reject?
      update(status: "Rejected")
    end
  end

  def adopt_all_pets
    id = self.id
    app_pets_ids = ApplicationPet.where(application_id: id)
    app_pets_ids.each do |app_pet|
      pet = Pet.find(app_pet.pet_id)
      pet.adopt
    end
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

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
    update(status: "Approved")
  end

  def can_approve?
    id = self.id
    app_pets_ids = ApplicationPet.where(application_id: id)
    app_pets_ids.all? do |app_pet|
      app_pet.application_status == "Approved"
    end
  end
end

class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true

  def all_pets_reviewed?
    if ApplicationPet.where('application_status = ?', "Pending").where(application_id: self.id).count == 0
      true
    else
      false
    end
  end

  def can_approve?
    number_of_pets_on_app = ApplicationPet.where(application_id: self.id).count
    number_of_pets_approved_on_app = ApplicationPet.where(application_id: self.id).where('application_status = ?', 'Approved').count
    if all_pets_reviewed? && number_of_pets_on_app == number_of_pets_approved_on_app
      true
    else
      false
    end
  end

  def can_reject?
    number_of_pets_on_app = ApplicationPet.where(application_id: self.id).count
    number_of_pets_rejected_on_app = ApplicationPet.where(application_id: self.id).where('application_status = ?', 'Rejected').count
    if all_pets_reviewed? && number_of_pets_on_app == number_of_pets_rejected_on_app
      true
    else
      false
    end
  end

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
      pet.update(adoptable: false)
      # pet.adopt
      ApplicationPet.other_applications_with_pet(app_pet.pet_id, id)
    end
  end

  def self.all_pending
    pending = Application.where(status: "Pending")
  end

  # def self.shelter_associations(shelt_id)
  #   all_pending.joins(:application_pets).joins(:pets).where('pets.shelter_id = ?', shelt_id).select('id').distinct
  # end
end

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
    number_of_pets_rejected_on_app = ApplicationPet.where(application_id: self.id).where('application_status = ?', 'Rejected').count
    if number_of_pets_rejected_on_app > 0
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
    Pet.joins(:applications).where('applications.id = ?', self.id).update(adoptable: false)
  end

  def self.all_pending
    pending = Application.where(status: "Pending")
  end
end

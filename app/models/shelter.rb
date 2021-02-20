class Shelter < ApplicationRecord
  has_many :pets
  has_many :applications, through: :pets

  def self.all_desc
    find_by_sql("SELECT * FROM shelters ORDER BY name desc")
  end

  def self.admin_show_query(id)
    find_by_sql("SELECT id, name, address, city, state, zip FROM shelters WHERE id = #{id}")
  end

  def average_pet_age
    pets = Pet.where(shelter_id: self.id).average(:approximate_age)
  end

  def pet_count
    pets = Pet.where(shelter_id: self.id).count
  end

  def adopted_pet_count
    pets = Pet.where(shelter_id: self.id).where(adoptable: false).count
  end

  def self.shelters_with_pending_applications
    Shelter.joins(:pets).joins(:applications).where('applications.status = ?', "Pending")
  end

  def pets_pending_app_reivew
    pets.joins(:applications).joins(:application_pets).where('application_pets.application_status = ?', 'Pending')
  end

  def action_required_applications(pet)
    pet.applications.pluck(:id, :first_name)
  end
end

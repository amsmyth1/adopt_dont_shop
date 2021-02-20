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
    pets = Pet.where(shelter_id: self.id)
    pets.average(:approximate_age)
  end

  def pet_count
    pets = Pet.where(shelter_id: self.id)
    pets.count
  end

  def adopted_pet_count
    pets = Pet.where(shelter_id: self.id).where(adoptable: false)
    pets.count
  end

  def self.shelters_with_pending_applications
    Shelter.joins(:pets).joins(:applications).where('applications.status = ?', "Pending")
  end
end

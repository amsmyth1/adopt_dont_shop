class Shelter < ApplicationRecord
  has_many :pets

  def self.all_desc
    find_by_sql("SELECT * FROM shelters ORDER BY name desc")
  end

  # def self.with_pending_applications
  #   pending_apps = Application.all_pending
  #   pending_apps.select('applications.*', ' application_pets.pet_id').joins(:application_pets)
  # end

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

  # def self.shelters_with_pending_applications
  #   Pet.shelters_with_pending_applications.joins(:shelters)
  # end
end

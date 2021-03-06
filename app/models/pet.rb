class Pet < ApplicationRecord
  belongs_to :shelter
  has_many :application_pets
  has_many :applications, through: :application_pets

  validates_presence_of :name, :description, :approximate_age, :sex

  validates :approximate_age, numericality: {
              greater_than_or_equal_to: 0
            }

  enum sex: [:female, :male]
  # scope :adoptable, { where(adoptable: true) }
  # scope :adopted, { where(adoptable: false) }

  def adoptable?
    if adoptable == true
      true
    else
      false
    end
  end 

  def self.all_adoptable
    where(adoptable: true)
  end

  def self.all_adopted
    where(adoptable: false)
  end

  def self.search(search_terms)
    if search_terms
      @pets = Pet.where("lower(name) LIKE ?", "%#{search_terms.downcase}%")
    else
      @pets = Pet.all
    end
  end

  def adopt
    update(adoptable: false)
  end

  def self.shelters_with_pending_applications
    Pet.joins(:shelter).joins(:applications).where('applications.status = ?', "Pending")
  end
end

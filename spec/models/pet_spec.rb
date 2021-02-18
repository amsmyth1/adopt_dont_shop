require 'rails_helper'

describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to :shelter }
    it { should have_many :application_pets }
    it { should have_many(:applications).through(:application_pets) }
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :sex}
    it {should validate_numericality_of(:approximate_age).is_greater_than_or_equal_to(0)}

    it 'is created as adoptable by default' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(true)
    end

    it 'can be created as not adoptable' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(adoptable: false, name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(false)
    end

    it 'can be male' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :male, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('male')
      expect(pet.male?).to be(true)
      expect(pet.female?).to be(false)
    end

    it 'can be female' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :female, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('female')
      expect(pet.female?).to be(true)
      expect(pet.male?).to be(false)
    end
  end

  describe "class methods" do
    describe "::search(search_terms)" do
      it "should search all pets' names for the matching term" do
        shelter = create(:shelter)
        pet_1 = create(:pet, name: "Thor")
        pet_2 = create(:pet, name: "Zues")
        pet_3 = create(:pet, name: "Athena")
        pet_4 = create(:pet, name: "Helena")

        search_result_thor = Pet.search("Thor")
        search_result_ze = Pet.search("Zu")
        search_result_th = Pet.search("Th")

        expect(search_result_thor).to eq([pet_1])
        expect(search_result_ze).to eq([pet_2])
        expect(search_result_th).to eq([pet_1, pet_3])
      end
    end
  end

  describe "instance methods" do
    describe "#adopted" do
      it "should change the adoptable status to false" do
        shelter = create(:shelter)
        pet_1 = create(:pet, name: "Thor")
        pet_2 = create(:pet)

        expect(pet_1.adoptable).to eq(true)
        pet_1.adopt
        expect(pet_1.adoptable).to eq(false)
        expect(pet_2.adoptable).to eq(true)
      end
    end
  end
end

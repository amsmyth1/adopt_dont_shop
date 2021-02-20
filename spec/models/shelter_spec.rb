require 'rails_helper'

RSpec.describe Shelter, type: :model do
  before :each do
    @shelter_1 = create(:shelter, name: "Dogs R Us")
    @shelter_2 = create(:shelter, name: "Paws n Frands")
    @shelter_3 = create(:shelter, name: "Animal Patrol")
    @pet1 = create(:pet, approximate_age: 1, shelter_id: @shelter_1.id)
    @pet2 = create(:pet, approximate_age: 2, shelter_id: @shelter_1.id)
    @pet3 = create(:pet, approximate_age: 3, shelter_id: @shelter_1.id)
    @pet4 = create(:pet, approximate_age: 4, shelter_id: @shelter_1.id)
    @pet5 = create(:pet, approximate_age: 5, shelter_id: @shelter_1.id)

    @average_age = ((1 + 2 + 3 + 4 + 5) / 5)
  end

  describe 'relationships' do
    it { should have_many :pets }
  end

  describe "instance methods" do
    describe "#average_pet_age" do
      it "should give the average pet age of all pets in shelter" do
        expect(@shelter_1.average_pet_age).to eq(@average_age)
      end
    end

    describe "#pet_count" do
      it "should give the number of pets in shelter" do
        expect(@shelter_1.pet_count).to eq(5)
      end
    end

    describe "#adopted_pet_count" do
      it "should give the number of pets that have been adopted from the shelter" do
        shelter_1 = create(:shelter)
        pet1 = create(:pet, approximate_age: 1, shelter_id: shelter_1.id, adoptable: false)
        pet2 = create(:pet, approximate_age: 2, shelter_id: shelter_1.id, adoptable: false)
        pet3 = create(:pet, approximate_age: 3, shelter_id: shelter_1.id, adoptable: false)
        pet4 = create(:pet, approximate_age: 4, shelter_id: shelter_1.id, adoptable: true)
        pet5 = create(:pet, approximate_age: 5, shelter_id: shelter_1.id, adoptable: false)

        expect(shelter_1.adopted_pet_count).to eq(4)
      end
    end
  end

  describe "class methods" do
    describe "::all_desc" do
      it "should list all shelters in descending order using SQL" do
        shelters = Shelter.all_desc

        expect(shelters.first.name).to eq(@shelter_2.name)
        expect(shelters[1].name).to eq(@shelter_1.name)
        expect(shelters.last.name).to eq(@shelter_3.name)
      end
    end

    describe "::admin_show_query" do
      it "should only query for name and address" do
        expect(Shelter.admin_show_query(@shelter_1.id).first.name).to eq(@shelter_1.name)
        expect(Shelter.admin_show_query(@shelter_1.id).first.address).to eq(@shelter_1.address)
        expect(Shelter.admin_show_query(@shelter_1.id).first.city).to eq(@shelter_1.city)
        expect(Shelter.admin_show_query(@shelter_1.id).first.state).to eq(@shelter_1.state)
      end
    end

    describe "::shelters_with_pending_applications" do
      it "should return a list of shelter ids with pending applications" do
        shelter = create(:shelter, name: "Dogs R Us")
        shelter2 = create(:shelter, name: "Paws n Frands")
        shelter3 = create(:shelter, name: "Animal Patrol")
        shelter4 = create(:shelter)

        pet1 = create(:pet, shelter_id: shelter.id)
        pet2 = create(:pet, shelter_id: shelter2.id)
        pet3 = create(:pet, shelter_id: shelter3.id)
        pet4 = create(:pet, shelter_id: shelter4.id)
        application = create(:application, status: "In Progress")
        application2 = create(:application, status: "In Progress")
        application3 = create(:application, status: "In Progress")
        application4 = create(:application, status: "In Progress")

        application.pets << pet1
        application.pets << pet2
        application.pets << pet3
        application2.pets << pet1
        application2.pets << pet2
        application2.pets << pet3
        application3.pets << pet1
        application3.pets << pet2
        application3.pets << pet3
        application4.pets << pet4
        application.update(status: "Pending")
        application2.update(status: "Pending")
        application3.update(status: "Pending")

        shelters = Shelter.shelters_with_pending_applications
        expect(shelters[0].name).to eq(shelter.name)
        expect(shelters[1].name).to eq(shelter2.name)
        expect(shelters[2].name).to eq(shelter3.name)
      end
    end
  end
end

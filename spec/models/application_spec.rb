require 'rails_helper'

describe Application, type: :model do
  before :each do
    shelter = create(:shelter)
    @application = create(:application, status: "Pending")
    @pet1 = create(:pet, shelter_id: shelter.id)
    @pet2 = create(:pet, shelter_id: shelter.id)
    @pet3 = create(:pet, shelter_id: shelter.id)
  end

  describe "applications" do
    it { should have_many :application_pets }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe "instance methods" do
    describe "#all_pets_reviewed?" do
      it "can return true if all pets on application are reviewed" do
        @application.pets << @pet1
        @application.pets << @pet2
        ApplicationPet.approve(@pet1.id, @application.id)
        expect(@application.all_pets_reviewed?).to eq(false)

        ApplicationPet.approve(@pet2.id, @application.id)
        expect(@application.all_pets_reviewed?).to eq(true)
      end
    end

    describe "#can_approve?" do
      it "can check if all pets are reviewed and all are approved" do
        @application.pets << @pet1
        @application.pets << @pet2
        @application.pets << @pet3
        ApplicationPet.approve(@pet1.id, @application.id)

        expect(@application.can_approve?).to eq(false)
        ApplicationPet.approve(@pet2.id, @application.id)

        expect(@application.can_approve?).to eq(false)
        ApplicationPet.approve(@pet3.id, @application.id)

        expect(@application.can_approve?).to eq(true)
      end
    end

    describe "#can_reject?" do
      it "can check if all pets reviewed and at least 1 pet is rejected" do
        @application.pets << @pet1
        @application.pets << @pet2
        @application.pets << @pet3
        ApplicationPet.approve(@pet1.id, @application.id)

        expect(@application.can_approve?).to eq(false)

        ApplicationPet.approve(@pet2.id, @application.id)
        expect(@application.can_approve?).to eq(false)

        ApplicationPet.approve(@pet3.id, @application.id)

        expect(@application.can_approve?).to eq(true)
      end
    end

    describe "#approve_or_reject" do
      it "can change an applications status to Approved" do
        application = create(:application, status: "Pending")
        pet1 = create(:pet)
        application.pets << pet1
        ApplicationPet.approve(pet1.id, application.id)

        expect(application.status).to eq("Pending")
        application.approve_or_reject
        expect(application.status).to eq("Approved")
      end

      it "can change an applications status to Rejected" do
        application = create(:application, status: "Pending")
        pet1 = create(:pet)
        application.pets << pet1
        ApplicationPet.reject(pet1.id, application.id)

        expect(application.status).to eq("Pending")
        application.approve_or_reject
        expect(application.status).to eq("Rejected")
      end
    end

    describe "#adopt_all_pets" do
      it "can change the adoptable status for the pets on the approved application" do
        shelter = create(:shelter)
        application = create(:application, status: "Pending")
        pet1 = shelter.pets.create!(name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
        application.pets << pet1
        ApplicationPet.approve(pet1.id, application.id)
        application.approve_or_reject

        expect(application.status).to eq("Approved")
      end
    end
  end

  describe "class methods" do
    describe "::all_pending" do
      it "should list all applications with Pending" do
        application = create(:application, status: "Pending", first_name: "Able")
        application2 = create(:application, status: "In Progress", first_name: "Matt")
        application3 = create(:application, status: "Pending", first_name: "Abigail")
        application4 = create(:application, status: "Accepted", first_name: "Max")
        application5 = create(:application, status: "Pending", first_name: "Absynth")
        application6 = create(:application, status: "Rejected", first_name: "Mason")

        expect(Application.all_pending.pluck(:first_name)).to eq([@application.first_name, application.first_name, application3.first_name, application5.first_name])
      end
    end
  end
end

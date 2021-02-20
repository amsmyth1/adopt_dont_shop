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
        application = create(:application, status: "Pending")
        pet1 = create(:pet)
        application.pets << pet1
        ApplicationPet.approve(pet1.id, application.id)
        application.approve_or_reject

        expect(application.status).to eq("Approved")
        expect(pet1.adoptable).to eq (false)
        expect(@pet3.adoptable).to eq (true)
      end
    end
  end

  describe "class methods" do
    describe "::all_pending" do
      skip "should list all applications with Pending or Pending with issue" do
        application = create(:application, status: "Pending")
        application2 = create(:application, status: "In Progress")
        application3 = create(:application, status: "Pending")
        application4 = create(:application, status: "Accepted")
        application5 = create(:application, status: "Pending with issue")
        application6 = create(:application, status: "Rejected")

        expect(Application.all_pending).to eq([application, application3, application5])
      end
    end

    describe "::with_pending_applications" do
      skip "should list all shelters that have a pending application" do
        shelter = create(:shelter)
        pet1 = create(:pet, shelter_id: shelter.id)
        pet2 = create(:pet, shelter_id: shelter.id)
        pet3 = create(:pet, shelter_id: shelter.id)
        application = create(:application)
        application2 = create(:application)
        application3 = create(:application)
        application4 = create(:application, status: "Rejected")

        application.pets << pet1
        application.pets << pet2
        application.pets << pet3
        application2.pets << pet1
        application2.pets << pet2
        application2.pets << pet3
        application3.pets << pet1
        application3.pets << pet2
        application3.pets << pet3
        application4.pets << pet1
        application4.pets << pet2
        application4.pets << pet3
        application.update(status: "Pending")
        application2.update(status: "Pending")
        application3.update(status: "Pending")

        shelters_associated_with_application = Application.shelter_associations(shelter.id)

        expect(shelters_associated_with_application.count).to eq(3)
        expect(shelters_associated_with_application.first).to eq(application)
        expect(shelters_associated_with_application[1]).to eq(application2)
        expect(shelters_associated_with_application[2]).to eq(application3)
        expect(shelters_associated_with_application[3]).to eq(nil)
      end
    end
  end
end

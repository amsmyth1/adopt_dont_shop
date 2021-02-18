require 'rails_helper'

describe ApplicationPet, type: :model do
  describe "application pets" do
    it { should belong_to :application }
    it { should belong_to :pet }
  end

  describe "validations" do
    it { should validate_presence_of :pet_id}
    it { should validate_presence_of :application_id}
  end

  describe "instance methods" do
    describe "#other_applications_with_pet(petid, appid)" do
      it "shoud change the status of app/pets after an application is approved" do
        application = create(:application, status: "Pending")
        application2 = create(:application, status: "Pending")
        pet1 = create(:pet)
        pet2 = create(:pet)
        application.pets << pet1
        application2.pets << pet1
        ApplicationPet.approve(pet1.id, application.id)

        expect(ApplicationPet.status(pet1.id, application.id)).to eq ("Approved")
        expect(ApplicationPet.status(pet1.id, application2.id)).to eq ("Pending")

        application.approve_or_reject
        expect(ApplicationPet.status(pet1.id, application.id)).to eq ("Approved")
        expect(ApplicationPet.status(pet1.id, application2.id)).to eq ("Pending with issue")
      end
    end
  end

  describe "class methods" do
    describe "::status" do
      it "should be able find the app status for each app/pet pair" do
        application = create(:application, status: "Pending")
        application2 = create(:application, status: "Pending")
        pet1 = create(:pet)
        pet2 = create(:pet)

        application.pets << pet1
        application2.pets << pet1

        expect(ApplicationPet.status(pet1.id, application.id)).to eq ("Pending")
        expect(ApplicationPet.status(pet1.id, application2.id)).to eq ("Pending")

        ApplicationPet.approve(pet1.id, application.id)
        expect(ApplicationPet.status(pet1.id, application.id)).to eq ("Approved")
        expect(ApplicationPet.status(pet1.id, application2.id)).to eq ("Pending")
        application.approve_or_reject


        expect(ApplicationPet.status(pet1.id, application.id)).to eq ("Approved")
        expect(ApplicationPet.status(pet1.id, application2.id)).to eq ("Pending with issue")
      end
    end

    describe "::aprove" do
      it "should not be able to approve a pet if already approved" do
        application = create(:application, status: "Pending")
        application2 = create(:application, status: "Pending")
        pet1 = create(:pet)
        pet2 = create(:pet)
        application.pets << pet1
        application2.pets << pet1
        application.pets << pet2
        ApplicationPet.approve(pet1.id, application.id)
        app2 = ApplicationPet.find_by(pet_id: pet1.id, application_id: application2.id)
        ApplicationPet.approve(pet1.id, application2.id)

        expect(app2.application_status).to eq("Pending")
      end
    end

    describe "::reject" do
      it "should be able to reject pets on applicaitons" do
        application = create(:application, status: "Pending")
        pet1 = create(:pet)
        pet2 = create(:pet)
        application.pets << pet1
        application.pets << pet2

        ApplicationPet.reject(pet1.id, application.id)

        expect(ApplicationPet.status(pet1.id, application.id)).to eq ("Rejected")
        expect(ApplicationPet.status(pet2.id, application.id)).to eq ("Pending")
      end
    end
  end
end

require 'rails_helper'

describe Application, type: :model do
  describe 'applications' do
    it { should have_many :application_pets }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe "methods" do
    describe "#approve" do
      it "can change an applications status to Approved" do
        application = create(:application, status: "Pending")
        pet1 = create(:pet)
        application.pets << pet1
        ApplicationPet.approve(pet1.id, application.id)

        expect(application.status).to eq("Pending")
        application.approve
        expect(application.status).to eq("Approved")
      end
    end
    describe "#can_approve" do
      it "can check all pets are approved" do
        application = create(:application, status: "Pending")
        pet1 = create(:pet)
        pet2 = create(:pet)
        pet3 = create(:pet)
        application.pets << pet1
        application.pets << pet2
        application.pets << pet3
        ApplicationPet.approve(pet1.id, application.id)

        expect(application.can_approve?).to eq(false)

        ApplicationPet.approve(pet2.id, application.id)
        ApplicationPet.approve(pet3.id, application.id)

        expect(application.can_approve?).to eq(true)
      end
    end
  end
end

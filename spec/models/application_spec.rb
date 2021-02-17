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

        expect(application.status).to eq ("Pending")
        application.approve
        expect(application.status).to eq ("Approved")
      end
    end
  end

end

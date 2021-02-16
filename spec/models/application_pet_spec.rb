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

  describe "class methods" do
    describe "should track application status for each pet" do
      it "should be able to approve pets on applicaitons" do
        application = create(:application, status: "Pending")
        pet1 = create(:pet)
        pet2 = create(:pet)
  
        application.pets << pet1
        application.pets << pet2

        ApplicationPet.approve(pet1.id, application.id)

        expect(ApplicationPet.status(pet1.id, application.id)).to eq ("Approved")
        expect(ApplicationPet.status(pet2.id, application.id)).to eq ("Pending")
      end

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

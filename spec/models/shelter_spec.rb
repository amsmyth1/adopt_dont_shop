require 'rails_helper'

RSpec.describe Shelter, type: :model do
  before :each do
    @shelter_1 = create(:shelter, name: "Dogs R Us")
    @shelter_2 = create(:shelter, name: "Paws n Frands")
    @shelter_3 = create(:shelter, name: "Animal Patrol")
  end

  describe 'relationships' do
    it { should have_many :pets }
  end

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

  describe "::with_pending_applications" do
    it "should list all shelters that have a pending application" do
      shelter = create(:shelter)
      pet1 = create(:pet, shelter_id: shelter.id)
      pet2 = create(:pet, shelter_id: shelter.id)
      application = create(:application)

      application.pets << pet1
      application.update(status: "Pending")
      expect(application.status).to eq("Pending")

      expect(Shelter.with_pending_applications).to eq([shelter])
    end
  end
end

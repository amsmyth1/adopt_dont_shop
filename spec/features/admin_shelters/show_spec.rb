require 'rails_helper'

RSpec.describe "ADMIN shelter show page" do
  before :each do
    @shelter = create(:shelter, name: "Fur and Feathers")
    @pet1 = create(:pet, approximate_age: 1, shelter_id: @shelter.id)
    @pet2 = create(:pet, approximate_age: 2, shelter_id: @shelter.id)
    @pet3 = create(:pet, approximate_age: 3, shelter_id: @shelter.id)
    @pet4 = create(:pet, approximate_age: 4, shelter_id: @shelter.id)
    @pet5 = create(:pet, approximate_age: 5, shelter_id: @shelter.id)
    @average_age = ((1+ 2 + 3 + 4 + 5) / 5)

  end
  describe "should display the shelters" do
    it "only displays name and full address" do
      shelter = create(:shelter)

      visit "/admin/shelters/#{shelter.id}"

      expect(page).to have_content(shelter.name)
      expect(page).to have_content(shelter.city)
      expect(page).to have_content(shelter.state)
      expect(page).to have_content(shelter.zip)
    end
  end

  describe "should have a section for shelter statistics" do
    it "displays the average pet age of the shelter" do

      visit "/admin/shelters/#{@shelter.id}"

      within ".admin_shelter_info#statistics" do
        expect(page).to have_content(@average_age)
      end
    end

    it "displays the pet count of the shelter" do
      visit "/admin/shelters/#{@shelter.id}"

      within ".admin_shelter_info#statistics" do
        expect(page).to have_content("Count of Adoptable: 5")
      end
    end
  end
end

require 'rails_helper'

describe "ADMIN shelter index page" do
  describe "should display the shelters" do
    it "in reverse alphabetical order" do
      shelter_1 = create(:shelter, name: "Dogs R Us")
      shelter_2 = create(:shelter, name: "Paws n Frands")
      shelter_3 = create(:shelter, name: "Animal Patrol")

      visit "/admin/shelters"

      expect(page).to have_content(shelter_1.name)
      expect(page).to have_content(shelter_2.name)
      expect(page).to have_content(shelter_3.name)
      expect(shelter_2.name).to appear_before(shelter_1.name)
      expect(shelter_2.name).to appear_before(shelter_3.name)
      expect(shelter_1.name).to appear_before(shelter_3.name)
    end
  end
end

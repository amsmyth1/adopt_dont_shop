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
  describe "should have a section to display the Shelters with Pending Applications " do
    it "should list shelters alphabetically" do
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

      visit "/admin/shelters"
      binding.pry
      within ".pending_applications" do
        expect(page).to have_content(shelter.name)
        expect(page).to have_content(shelter2.name)
        expect(page).to have_content(shelter3.name)
        expect(page).to_not have_content(shelter4.name)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "the ADMIN applications show page" do
  before :each do
    @shelter = create(:shelter)
    @application = create(:application, status: "Pending")
    @pet_1 = create(:pet, shelter_id: @shelter.id, name: "Thor")
    @pet_2 = create(:pet, shelter_id: @shelter.id)
    @pet_3 = create(:pet, shelter_id: @shelter.id, name: "Thoraneous")
    @pet_4 = create(:pet, shelter_id: @shelter.id)
    @pet_5 = create(:pet, shelter_id: @shelter.id)


    @application.pets << @pet_2
    @application.pets << @pet_4

    @admin_app_show = "/admin/applications/#{@application.id}"
  end

  describe "should show the application and attributes" do
    it "name, address, description, and status " do
      visit @admin_app_show

      expect(page).to have_content(@application.first_name)
      expect(page).to have_content(@application.last_name)
      expect(page).to have_content(@application.street_address)
      expect(page).to have_content(@application.city)
      expect(page).to have_content(@application.state)
      expect(page).to have_content(@application.zip)
      expect(page).to have_content(@application.description)
      expect(page).to have_content(@application.status)
    end

    it "should list and link to all pets associated with the application" do
      visit @admin_app_show

      expect(page).to have_content(@pet_2.name)
      expect(page).to have_content(@pet_4.name)

      click_on("#{@pet_2.name}")

      expect(current_path).to eq("/pets/#{@pet_2.id}")
    end
  end

  describe "should be able to change the pet status on an application" do
    it "can approve a pet on the application" do
      visit "/admin/applications/#{@application.id}"

      expect(page).to have_button("Approve this Pet")
      first(:button, "Approve this Pet").click

      expect(current_path).to eq(@admin_app_show)
      expect(page).to have_content("APPROVED!")
    end

    it "can reject a pet on the application" do
      visit "/admin/applications/#{@application.id}"

      expect(page).to have_button("Approve this Pet")
      first(:button, "Reject this Pet").click

      expect(current_path).to eq(@admin_app_show)
      expect(page).to have_content("Rejected")
    end
  end
end

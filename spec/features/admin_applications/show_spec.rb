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

  describe "should be able to change an application status" do
    it "can approve an application" do
      visit "/admin/applications/#{@application.id}"
      shelter = create(:shelter)
      application = create(:application, status: "Pending")
      pet_4 = create(:pet, shelter_id: shelter.id)
      pet_6 = create(:pet, shelter_id: shelter.id)
      pet_7 = create(:pet, shelter_id: shelter.id)

      application.pets << pet_6
      application.pets << pet_7
      application.pets << pet_4

      loop do
        first(:button,"Approve this Pet").click
        if !page.body.include?("Approve this Pet")
          break
        end
      end

      expect(page).to_not have_content("Approve this Pet")
      expect(page).to_not have_content("Reject this Pet")

      within ('.app_info#app_status') do
        expect(page).to have_content("Approved")
      end
    end

    it "can reject an application when all pets are reviewed and rejected" do
      visit "/admin/applications/#{@application.id}"
      shelter = create(:shelter)
      application = create(:application, status: "Pending")
      pet_2 = create(:pet, shelter_id: shelter.id)
      pet_4 = create(:pet, shelter_id: shelter.id)
      pet_5 = create(:pet, shelter_id: shelter.id)

      application.pets << pet_2
      application.pets << pet_4
      application.pets << pet_5

      loop do
        first(:button,"Reject this Pet").click
        if !page.body.include?("Reject this Pet")
          break
        end
      end

      expect(page).to_not have_content("Approve this Pet")
      expect(page).to_not have_content("Reject this Pet")

      within ('.app_info#app_status') do
        expect(page).to have_content("Rejected")
      end
    end

    it "can reject an application when 1 pet is rejected" do
      visit "/admin/applications/#{@application.id}"
      shelter = create(:shelter)
      application = create(:application, status: "Pending")
      pet_2 = create(:pet, shelter_id: shelter.id)
      pet_4 = create(:pet, shelter_id: shelter.id)
      pet_5 = create(:pet, shelter_id: shelter.id)

      application.pets << pet_2
      application.pets << pet_4
      application.pets << pet_5

      first(:button,"Reject this Pet").click
      loop do
        first(:button,"Approve this Pet").click
        if !page.body.include?("Approve this Pet")
          break
        end
      end

      expect(page).to_not have_content("Approve this Pet")
      expect(page).to_not have_content("Reject this Pet")

      within ('.app_info#app_status') do
        expect(page).to have_content("Rejected")
      end
    end

    it "is notified if a pet is already apopted and cannot see the approve button" do
      shelter = create(:shelter)
      application = create(:application, status: "Pending")
      pet_4 = create(:pet, shelter_id: shelter.id)
      pet_6 = create(:pet, shelter_id: shelter.id)
      pet_7 = create(:pet, shelter_id: shelter.id)
      application.pets << pet_6
      application.pets << pet_7
      application.pets << pet_4
      visit "/admin/applications/#{@application.id}"
      loop do
        first(:button,"Approve this Pet").click
        if !page.body.include?("Approve this Pet")
          break
        end
      end

      application2 = create(:application, status: "Pending")
      application2.pets << pet_6

      visit "/admin/applications/#{application2.id}"
      save_and_open_page

      expect(page).to have_content("This pet has been adopted by another applicant")

    end
  end
end

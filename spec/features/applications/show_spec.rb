require 'rails_helper'

RSpec.describe "the applications show page" do
  before :each do
    @shelter = create(:shelter)
    @application = create(:application, status: "In Progress")
    @pet_1 = create(:pet, shelter_id: @shelter.id, name: "Thor")
    @pet_2 = create(:pet, shelter_id: @shelter.id)
    @pet_3 = create(:pet, shelter_id: @shelter.id, name: "Thoraneous")
    @pet_4 = create(:pet, shelter_id: @shelter.id)
    @pet_5 = create(:pet, shelter_id: @shelter.id)


    @application.pets << @pet_2
    @application.pets << @pet_4

    @app_show_url = "/applications/#{@application.id}"
  end

  describe "should show the application and attributes" do
    it "name, address, description, and status " do
      visit @app_show_url

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
      visit @app_show_url

      expect(page).to have_content(@pet_2.name)
      expect(page).to have_content(@pet_4.name)

      click_on("#{@pet_2.name}")

      expect(current_path).to eq("/pets/#{@pet_2.id}")
    end
  end

  describe "should be able to add pets to In Progress applications" do
    it "should be able to search pets" do

      visit @app_show_url

      expect(page).to have_content("In Progress")
      expect(page).to have_content("Add a Pet to this Application")

      fill_in(:query, with: "Thor")
      click_button("Search")

      expect(current_path).to eq (@app_show_url)
      expect(page).to have_content("Thor")
      expect(page).to have_content("Thoraneous")
      expect(page).to_not have_content(@pet_5.name)
    end

    it "should be able to add pets to application by clicking a link" do
      visit @app_show_url
      fill_in(:query, with: "Thor")
      click_button("Search")

      first(:button, "Adopt This Pet").click
      expect(current_path).to eq (@app_show_url)

      expect(@application.pets.first.name).to eq("Thor")
      expect(page).to have_content("Thor")
    end
  end

  describe "should be able to submit an application" do
    it "submit option in view once more than 1 pet added to app" do
      app = create(:application, status: "In Progress")
      visit "/applications/#{app.id}"

      expect(page).to_not have_content("Submit Application")
      app.pets << @pet_1
      visit "/applications/#{app.id}"

      expect(page).to have_content("Thor")
      expect(page).to have_content("Submit Application")
    end

    it "should be able to submit an application and status change to Pending" do
      visit @app_show_url

      fill_in(:app_submission, with: "Large yard and lots of love")
      click_on "Submit Application"

      expect(current_path).to eq (@app_show_url)
      expect(page).to have_content("Pending")
      expect(page).to have_content("Large yard and lots of love")
      expect(page).to_not have_content("Add a Pet to this Application")
      expect(page).to_not have_content("Submit Application")
    end
  end
end

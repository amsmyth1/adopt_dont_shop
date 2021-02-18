require 'rails_helper'

RSpec.describe "admin app index page" do
  before :each do
    @shelter = create(:shelter)
    @application_1 = create(:application)
    @application_2 = create(:application)
    @application_3 = create(:application)
    @application_4 = create(:application)
    @application_5 = create(:application)
  end

  it "should show a list of the applicants and status" do

    visit "/admin/applications/"

    expect(page).to have_content(@application_1.first_name)
    expect(page).to have_content(@application_2.first_name)
    expect(page).to have_content(@application_3.first_name)
    expect(page).to have_content(@application_4.first_name)
    expect(page).to have_content(@application_5.first_name)
    expect(page).to have_content(@application_5.status)
    expect(page).to have_content(@application_4.status)
    expect(page).to have_content(@application_3.status)
    expect(page).to have_content(@application_2.status)
    expect(page).to have_content(@application_1.status)
  end

  it "should link to the applicants show page" do

    visit "/admin/applications/"
    click_on "#{@application_1.first_name}"

    expect(current_path).to eq("/admin/applications/#{@application_1.id}")
    expect(page).to have_content(@application_1.first_name)
    expect(page).to have_content(@application_1.last_name)
  end
end

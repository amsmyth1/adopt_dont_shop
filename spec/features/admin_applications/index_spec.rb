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

  it "should show a list of the applicants" do

    visit "/applications/"

    expect(page).to have_content(@application_1.first_name)
    expect(page).to have_content(@application_2.first_name)
    expect(page).to have_content(@application_3.first_name)
    expect(page).to have_content(@application_4.first_name)
    expect(page).to have_content(@application_5.first_name)
  end
end

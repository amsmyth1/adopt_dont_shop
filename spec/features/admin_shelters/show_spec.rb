require 'rails_helper'

RSpec.describe "ADMIN shelter show page" do
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
end

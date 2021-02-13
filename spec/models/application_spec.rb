require 'rails_helper'

describe Application, type: :model do
  describe 'applications' do
    it { should belong_to :shelter }
    it { should have_many :application_pets }
    it { should have_many(:pets).through(:application_pets) }
  end
end

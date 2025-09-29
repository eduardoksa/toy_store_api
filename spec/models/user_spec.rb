require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid email and password' do
      user = build(:user, email: 'test@example.com', password: 'password123')
      expect(user).to be_valid
    end

    it 'is invalid without email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      create(:user, email: 'duplicate@example.com')
      user = build(:user, email: 'duplicate@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it 'is invalid without password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end
  end

  describe 'authentication' do
    it 'authenticates with correct password' do
      user = create(:user, password: 'securepass')
      expect(user.authenticate('securepass')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      user = create(:user, password: 'securepass')
      expect(user.authenticate('wrongpass')).to be_falsey
    end
  end
end

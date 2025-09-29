require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'associations' do
    it 'has many sales' do
      client = create(:client)
      sale1 = create(:sale, client: client)
      sale2 = create(:sale, client: client)
      expect(client.sales).to include(sale1, sale2)
    end

    it 'destroys associated sales when destroyed' do
      client = create(:client)
      create(:sale, client: client)
      expect { client.destroy }.to change { Sale.count }.by(-1)
    end
  end

  describe 'validations' do
    it 'is valid with full_name and email' do
      client = build(:client, full_name: 'Ana Beatriz', email: 'ana@example.com')
      expect(client).to be_valid
    end

    it 'is invalid without full_name' do
      client = build(:client, full_name: nil)
      expect(client).not_to be_valid
      expect(client.errors[:full_name]).to include("can't be blank")
    end

    it 'is invalid without email' do
      client = build(:client, email: nil)
      expect(client).not_to be_valid
      expect(client.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with duplicate email' do
      create(:client, email: 'duplicate@example.com')
      client = build(:client, email: 'duplicate@example.com')
      expect(client).not_to be_valid
      expect(client.errors[:email]).to include("has already been taken")
    end
  end
end

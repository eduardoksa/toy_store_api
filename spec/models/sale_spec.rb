require 'rails_helper'

RSpec.describe Sale, type: :model do
  describe 'associations' do
    it 'belongs to a client' do
      client = create(:client)
      sale = create(:sale, client: client)
      expect(sale.client).to eq(client)
    end
  end

  describe 'validations' do
    let(:client) { create(:client) }

    it 'is valid with valid attributes' do
      sale = build(:sale, client: client, value: 100.0, sold_at: Date.today)
      expect(sale).to be_valid
    end

    it 'is invalid without sold_at' do
      sale = build(:sale, client: client, sold_at: nil)
      expect(sale).not_to be_valid
      expect(sale.errors[:sold_at]).to include("can't be blank")
    end

    it 'is invalid with negative value' do
      sale = build(:sale, client: client, value: -50.0)
      expect(sale).not_to be_valid
      expect(sale.errors[:value]).to include("must be greater than or equal to 0")
    end

    it 'is valid with value zero' do
      sale = build(:sale, client: client, value: 0.0, sold_at: Date.today)
      expect(sale).to be_valid
    end
  end
end

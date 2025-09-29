require 'rails_helper'

RSpec.describe 'Statistics', type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' } }

  before do
    @c1 = create(:client)
    @c2 = create(:client)
    create(:sale, client: @c1, value: 100, sold_at: '2024-01-01')
    create(:sale, client: @c1, value: 200, sold_at: '2024-01-02')
    create(:sale, client: @c2, value: 400, sold_at: '2024-01-01')
  end

  it 'returns sales per day' do
    get '/statistics/sales_per_day', headers: headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data']).to be_an(Array)
  end

  it 'returns client metrics' do
    get '/statistics/client_metrics', headers: headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['highest_total']).to be_present
  end
end

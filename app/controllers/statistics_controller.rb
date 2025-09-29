class StatisticsController < ApplicationController

  def sales_per_day
    data = Sale.group(:sold_at).sum(:value).map { |date, total| { date: date, total: total.to_f } }
    render json: { data: data }
  end

  def client_metrics
    clients = Client.includes(:sales)

    total_by_client = clients.map { |c| [c, c.sales.sum(:value).to_f] }.to_h
    avg_by_client = clients.map { |c| [c, (c.sales.average(:value) || 0).to_f] }.to_h
    unique_days_by_client = clients.map { |c| [c, c.sales.select('DISTINCT sold_at').pluck(:sold_at).compact.uniq.count] }.to_h

    highest_total_client = total_by_client.max_by { |_, v| v }&.first
    highest_avg_client = avg_by_client.max_by { |_, v| v }&.first
    highest_freq_client = unique_days_by_client.max_by { |_, v| v }&.first

    render json: {
      highest_total: serialize_client_with_metric(highest_total_client, total_by_client[highest_total_client]),
      highest_avg: serialize_client_with_metric(highest_avg_client, avg_by_client[highest_avg_client]),
      highest_frequency: serialize_client_with_metric(highest_freq_client, unique_days_by_client[highest_freq_client])
    }
  end

  private

  def serialize_client_with_metric(client, metric)
    return nil unless client
    { id: client.id, full_name: client.full_name, email: client.email, metric: metric }
  end
end

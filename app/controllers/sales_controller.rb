class SalesController < ApplicationController
  before_action :set_sale, only: [:show]

  def create
    sale = Sale.new(sale_params)
    if sale.save
      render json: sale, status: :created
    else
      render json: { errors: sale.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @sale
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Sale not found" }, status: :not_found
  end

  def sale_params
    params.require(:sale).permit(:client_id, :value, :sold_at)
  end
end

class ClientsController < ApplicationController
  skip_before_action :authenticate_request, only: [ :index, :show ]
  before_action :set_client, only: [ :show, :update, :destroy ]

  def index
    clients = Client.filter_by(
      name: params[:filter_name],
      email: params[:filter_email]
    )
    render json: clients.as_json(include: { sales: { only: [ :value, :sold_at ] } })
  end

  def create
    client = Client.new(client_params)

    if client.save
      render json: client, status: :created
    else
      render_error_response(client)
    end
  end

  def show
    render json: @client
  end

  def update
    if @client.update(client_params)
      render json: @client
    else
      render_error_response(@client)
    end
  end

  def destroy
    @client.destroy
    head :no_content
  end

  def import
    payload = params.require(:data).permit(
      clientes: [
        info: [
          :nomeCompleto,
          detalhes: [ :email, :nascimento ]
        ],
        estatisticas: [
          vendas: [ :valor, :data ]
        ]
      ]
    )
    results = ClientImportService.new(payload).call
    render json: results, status: :created
  end

  private

  def set_client
    @client = Client.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Client not found" }, status: :not_found
  end

  def client_params
    params.require(:client).permit(:full_name, :email, :birthdate)
  end

  def render_error_response(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end

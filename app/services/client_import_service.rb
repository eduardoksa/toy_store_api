class ClientImportService
  def initialize(data)
    @data = data
    @results = { created: 0, skipped: 0, errors: [] }
  end

  def call
    @data[:clientes].each { |cliente| process_client(cliente) }
    @results
  end

  private

  def process_client(cliente)
    info = cliente[:info] || {}
    detalhes = info[:detalhes] || {}
    email = detalhes[:email]
    full_name = info[:nomeCompleto]
    birthdate = detalhes[:nascimento]

    validate_and_create_client(email, full_name, birthdate, cliente)
  rescue StandardError => e
    handle_error(email, e)
  end

  def validate_and_create_client(email, full_name, birthdate, cliente)
    if missing_required_fields?(email, full_name)
      add_error(email, "missing required fields")
      return
    end

    return if client_exists?(email)

    create_client_with_sales(email, full_name, birthdate, cliente)
  end

  def missing_required_fields?(email, full_name)
    email.blank? || full_name.blank?
  end

  def client_exists?(email)
    if Client.exists?(email: email)
      @results[:skipped] += 1
      true
    else
      false
    end
  end

  def create_client_with_sales(email, full_name, birthdate, cliente)
    ActiveRecord::Base.transaction do
      client = Client.create!(full_name: full_name, email: email, birthdate: birthdate)
      @results[:created] += 1

      create_sales_for_client(client, cliente)
    end
  end

  def create_sales_for_client(client, cliente)
    vendas = cliente.dig(:estatisticas, :vendas) || []
    vendas.each do |v|
      next if v[:valor].nil? || v[:data].nil?

      Sale.create!(
        client: client,
        value: v[:valor],
        sold_at: v[:data]
      )
    end
  end

  def handle_error(email, error)
    @results[:errors] << { email: email, error: error.message }
    @results[:skipped] += 1
  end

  def add_error(email, message)
    @results[:errors] << { email: email, error: message }
    @results[:skipped] += 1
  end
end

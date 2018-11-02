require_relative("../db/sql_runner")

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE * from customers where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end


  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    result = customers.map { |customer| Customer.new(customer) }
    return result
  end


  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def screenings()
    sql = "SELECT screenings.* FROM screenings
    INNER JOIN tickets
    ON screenings.id = tickets.screening_id
    WHERE customer_id = $1"
    values = [@id]
    screenings = SqlRunner.run(sql, values)
    result = screenings.map {|screening| Screening.new(screening)}
    return result
  end

  def tickets()
    sql = "SELECT tickets.* FROM tickets"
    tickets = SqlRunner.run(sql)
    result = tickets.map { |ticket| Ticket.new(ticket) }
    return result
  end

  def buy_ticket(screening)
    if enough_money?(screening)
      @funds -= screening.get_price()
    end
    ticket = Ticket.new({'customer_id' => @id, 'screening_id' => screening.id})
    return ticket.save()
  end

  def enough_money?(screening)
    return funds >= screening.get_price()
  end

  def how_many_tickets_bought()
    sql = "SELECT customers.*, tickets.* FROM customers
    INNER JOIN tickets
    ON customers.id = tickets.customer_id
    WHERE customers.id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.count
  end




end

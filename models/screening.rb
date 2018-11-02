class Screening

  attr_accessor :times, :film_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @times = options['times']
    @film_id = options['film_id'].to_i
  end


  def save()
    sql = "INSERT INTO screenings (times, film_id) VALUES ($1, $2) RETURNING id"
    values = [@times, @film_id]
    screening = SqlRunner.run(sql, values).first
    @id = screening['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET (times, film_id) = ($1, $2) WHERE id = $3"
    values = [@times, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE * from screenings where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end


    def self.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    result = screenings.map { |screening| Screening.new(screening) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def customers()
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets
    ON customers.id = tickets.customer_id
    WHERE screening_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    result = customers.map {|customer| Customer.new(customer)}
    return result
  end

  def how_many_cus_watching_film
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets
    ON customers.id = tickets.customer_id
    WHERE film_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.count
  end

  def get_price
    sql = "SELECT films.* FROM films
    WHERE id = $1"
    values = [@film_id]
    results = SqlRunner.run(sql, values)
    return results[0]['price'].to_i
  end
end

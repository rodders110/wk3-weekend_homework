require_relative("../sql_runner")
require_relative('tickets')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
    sql = "ALTER SEQUENCE customers_id_seq RESTART WITH 1"
    SqlRunner.run(sql)
  end

  def self.find_all()
    sql = "SELECT * FROM customers"
    results = SqlRunner.run(sql)
    records = results.map {|result| Customer.new(result)}
    return records
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def find()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@id]
    results = SqlRunner.run(sql,values)
    record = results.map {|result| Customer.new(result)}
    return record[0]
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT tickets.*, films.title FROM tickets INNER JOIN films ON films.id = tickets.film_id WHERE customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    films = []
    for result in results
      films << result['title']
    end
    return films
  end

  def tickets()
    sql = "SELECT * FROM tickets WHERE customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.count()
  end

  def buy_ticket(film, screening)
    if screening.spaces != 0
      @funds -= film.price.to_i
      update()
      screening.spaces -= 1
      screening.update()
      ticket = Ticket.new({
        'customer_id' => @id,
        'film_id' => film.id,
        })
        ticket.save()
        screening.ticket_id = ticket.id
        screening.save()
    else
        p "Sorry there are no seats left for this screening"
    end
  end

end

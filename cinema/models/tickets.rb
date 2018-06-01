require_relative('../sql_runner')

class Ticket

  attr_accessor :customer_id, :film_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
    sql = "ALTER SEQUENCE tickets_id_seq RESTART WITH 1"
    SqlRunner.run(sql)
  end

  def self.find_all()
    sql = "SELECT * FROM tickets"
    results = SqlRunner.new(sql)
    records = results.map{|result| Ticket.new(result)}
    return records
  end

  def save()
    sql = "INSERT INTO tickets (customer_id, film_id) VALUES ($1, $2) RETURNING id"
    values = [@customer_id, @film_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def find()
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    record = results.map{|result| Ticket.new(result)}
    return record[0]
  end

  def update()
    sql = "UPDATE tickets SET (customer_id, film_id) = ($1, $2) WHERE id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

end

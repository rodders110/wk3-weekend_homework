require_relative("../sql_runner")

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i
    @title = options['title']
    @price = options['price'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
    sql = "ALTER SEQUENCE films_id_seq RESTART WITH 1"
    SqlRunner.run(sql)
  end

  def self.find_all()
    sql = "SELECT * FROM films"
    results = SqlRunner.run(sql)
    records = results.map{|result| Film.new(result)}
    return records
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def find()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    record = results.map {|result| Film.new(result)}
    return record[0]
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT tickets.*,customers.name FROM tickets INNER JOIN customers ON customers.id = tickets.customer_id WHERE customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    customers = []
    for result in results
      customers << result['name']
    end
    return customers
  end

  def attendance()
    return customers.count()
  end

  def screenings()
    sql = "SELECT screenings.times FROM screenings INNER JOIN tickets ON screenings.ticket_id = tickets.id INNER JOIN films ON tickets.film_id = films.id WHERE films.id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    screenings = results.map {|result| Screening.new(result)}
    times = []
    for screening in screenings
      times << screening.times
    end
    return times
  end

  def pop_screening()
    array = screenings()
    array.max_by {|x| array.count(x)}
  end
end

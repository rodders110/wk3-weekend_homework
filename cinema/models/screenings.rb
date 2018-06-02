require_relative('../sql_runner')

class Screening

  attr_accessor :ticket_id, :times, :spaces
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i
    @ticket_id = options['ticket_id'].to_i
    @times = options['times']
    @spaces = options['spaces'].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
    sql = "ALTER SEQUENCE screenings_id_seq RESTART WITH 1"
    SqlRunner.run(sql)
  end

  def self.find_all()
    sql = "SELECT * FROM screenings"
    results = SqlRunner.new(sql)
    records = results.map{|result| Screening.new(result)}
    return records
  end

  def save()
    sql = "INSERT INTO screenings (ticket_id, times, spaces) VALUES ($1, $2, $3) RETURNING id"
    values = [@ticket_id, @times, @spaces]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def find()
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    record = results.map{|result| Screening.new(result)}
    return record[0]
  end

  def update()
    sql = "UPDATE screenings SET (ticket_id, times, spaces) = ($1, $2, $3) WHERE id = $4"
    values = [@ticket_id, @times, @spaces, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

end

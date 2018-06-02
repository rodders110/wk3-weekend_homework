require('pry')
require_relative('models/customers')
require_relative('models/films')
require_relative('models/tickets')
require_relative('models/screenings')

Screening.delete_all()
Ticket.delete_all()
Customer.delete_all()
Film.delete_all()


customer1 = Customer.new({
  'name' => 'Roddy Daly',
  'funds' => 100
  })

customer1.save()

customer2 = Customer.new({
  'name' => 'Xander Langford',
  'funds' => 150
  })

customer2.save()


customer1.name = 'Freddy Charleston'
customer1.funds = 300
customer1.update()

# customer1.delete()

query = customer2.find()

film1 = Film.new({
  'title' => 'The Matrix',
  'price' => '2'
  })

film1.save()

film2 = Film.new({
  'title' => 'The Matrix',
  'price' => '2'
  })

film2.save()

film3 = Film.new({
  'title' => 'Thor',
  'price' => '3'
  })

film3.save()

film1.title = 'I Kill Giants'
film1.price = '4'
film1.update()

# film1.delete()

query2 = film1.find()

ticket1 = Ticket.new({
  'customer_id' => customer1.id,
  'film_id' => film1.id
  })
ticket1.save()

ticket2 = Ticket.new({
  'customer_id' => customer1.id,
  'film_id' => film3.id
  })
ticket2.save()

ticket3 = Ticket.new({
  'customer_id' => customer1.id,
  'film_id' => film2.id
  })
ticket3.save()

ticket1.customer_id = customer2.id
ticket1.film_id = film2.id
ticket1.update

# ticket1.delete()

query3 = ticket1.find()

screening1 = Screening.new({
  'ticket_id' => ticket1.id,
  'times' => '12:00',
  'spaces' => 20
  })
screening1.save()

screening2 = Screening.new({
  'ticket_id' => ticket2.id,
  'times' => '13:00',
  'spaces' => 20
  })
screening2.save()

screening3 = Screening.new({
  'ticket_id' => ticket3.id,
  'times' => '13:00',
  'spaces' => 20
  })
screening3.save()

binding.pry
nil

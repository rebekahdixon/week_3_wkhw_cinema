require_relative('models/ticket')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/screening')
require('pry-byebug')

Ticket.delete_all()
Customer.delete_all()
Film.delete_all()
Screening.delete_all()

film1 = Film.new({ 'title' => 'prisoner of azkaban', 'price' => '10'})
film1.save()
film2 = Film.new({ 'title' => 'rat race', 'price' => '5'})
film2.save()
film3 = Film.new({ 'title' => 'bend it like beckham', 'price' => '12'})
film3.save()


customer1 = Customer.new({ 'name' => 'bekah', 'funds' => '30'})
customer1.save()
customer2 = Customer.new({ 'name' => 'leah', 'funds' => '23'})
customer2.save()
customer3 = Customer.new({ 'name' => 'chris', 'funds' => '35'})
customer3.save()
customer4 = Customer.new({ 'name' => 'john', 'funds' => '15'})
customer4.save()
customer5 = Customer.new({ 'name' => 'fiona', 'funds' => '60'})
customer5.save()

customer5.name = 'elliot'
customer5.update()

film3.title = 'sex and city'
film3.update()

screening1 = Screening.new({'times' => '18:00', 'film_id' => film1.id})
screening1.save()

ticket1 = Ticket.new({ 'customer_id' => customer2.id, 'screening_id' => screening1.id})
ticket1.save()
ticket2 = Ticket.new({ 'customer_id' => customer1.id, 'screening_id' => screening1.id})
ticket2.save()
ticket3 = Ticket.new({ 'customer_id' => customer4.id, 'screening_id' => screening1.id})
ticket3.save()
ticket4 = Ticket.new({ 'customer_id' => customer3.id, 'screening_id' => screening1.id})
ticket4.save()

customer1.buy_ticket(screening1)
customer1.update()


result = customer1.how_many_tickets_bought()
p result

# result2 = film2.how_many_cus_watching_film
# p result2

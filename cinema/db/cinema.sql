DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS films;


CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  funds INT4
);

CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title TEXT,
  price INT4
);

CREATE TABLE tickets(
  id SERIAL4 PRIMARY KEY,
  customer_id SERIAL4 REFERENCES customers(id) ON DELETE CASCADE,
  film_id SERIAL4 REFERENCES films(id) ON DELETE CASCADE
);

CREATE TABLE screenings(
  id SERIAL4 PRIMARY KEY,
  ticket_id INT4 REFERENCES tickets(id) ON DELETE CASCADE,
  times TEXT,
  spaces INT4
);

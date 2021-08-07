-- check if company database exist and delete if it exists
IF DB_ID('company') IS NOT NULL
	USE master
    DROP DATABASE company;

--create new database name company and use it
CREATE DATABASE company;
GO
USE company

-- check if any of these table exists and delete and them
DROP TABLE IF EXISTS invoice, store, v_order, vehicle, customer, address, payment;

--creating tables
CREATE TABLE address(
	postal_code		INT			NOT NULL,
	street			VARCHAR(30)	NOT NULL,
	city			VARCHAR(20)	NOT NULL,
	province		VARCHAR(20)	NOT NULL);

CREATE TABLE customer(
	customer_id		INT			NOT NULL,
	postal_code		INT			NOT NULL,
	building_name	VARCHAR(20)	NOT NULL,
	first_name		CHAR(15)	NOT NULL,
	middle_name		CHAR(15)	NULL,
	last_name		CHAR(15)	NOT NULL,
	dob				DATE		NOT NULL,
	email_address	VARCHAR(30)	NOT NULL,
	phone_number	CHAR(14)	NULL);

CREATE TABLE store(
	store_no					SMALLINT		NOT NULL,
	postal_code					INT				NOT NULL,
	building_name				VARCHAR(30)		NOT NULL,
    vehicle_availability		CHAR(1)			DEFAULT 'Y');

CREATE TABLE vehicle(
	vin				BIGINT		NOT NULL,
	store_id		SMALLINT	NOT NULL,
	[name]			CHAR(20)	NOT NULL,
	brand			CHAR(15)	NOT NULL,
	color			CHAR(10)	DEFAULT 'white',
	price			MONEY		NOT NULL,
	make_date		DATE		NOT NULL,
	fuel_type		CHAR(10)	DEFAULT 'diesel');

CREATE TABLE payment(
	payment_id		INT			NOT NULL,
	payment_status	CHAR(1)		NOT NULL,
	amount_paid		MONEY		DEFAULT 0,
	payment_mode	CHAR(6)		DEFAULT 'online');

CREATE TABLE v_order(
	order_id		INT			NOT NULL,
	payment_id		INT			NOT NULL,
	customer_id 	INT			NOT NULL,
	vehicle_id		BIGINT		NOT NULL,
	[date]			DATE		DEFAULT GETDATE(),
	amount			MONEY		NOT NULL,
	quantity		TINYINT		DEFAULT 1);

CREATE TABLE invoice(
	invoice_no		INT			NOT NULL,
	payment_id		INT			NOT NULL,
	product_id		BIGINT		NOT NULL,
	invoice_date	DATE		NOT NULL);


--adding constraints
ALTER TABLE address WITH CHECK ADD
	CONSTRAINT		address_postal_code_pk		PRIMARY KEY(postal_code);

ALTER TABLE customer WITH CHECK ADD
	CONSTRAINT		customer_customer_id_pk		PRIMARY KEY(customer_id),
	CONSTRAINT		customer_postal_code_fk		FOREIGN KEY(postal_code)	REFERENCES address(postal_code),
	CONSTRAINT		cusomter_dob_ck				CHECK(dob < (GETDATE()-6570));

ALTER TABLE store WITH CHECK ADD
	CONSTRAINT		store_store_no_pk			PRIMARY KEY(store_no),
	CONSTRAINT		store_postal_code_fk		FOREIGN KEY(postal_code)	REFERENCES address(postal_code),
	CONSTRAINT		store_vehicle_availability_ck		CHECK(vehicle_availability IN ('Y', 'S', 'N'));

ALTER TABLE vehicle WITH CHECK ADD	
	CONSTRAINT		vehicle_vin_pk				PRIMARY KEY(vin),
	CONSTRAINT		vehicle_store_id_fk			FOREIGN KEY(store_id)	REFERENCES store(store_no),
	CONSTRAINT		vehicle_vin_ck				CHECK(vin > 10000000000000000 AND vin < 99999999999999999),
	CONSTRAINT		vehicle_price_ck			CHECK(price > 0),
	CONSTRAINT		vehicle_make_date_ck		CHECK(make_date < GETDATE()),
	CONSTRAINT		vehicle_fuel_type_ck		CHECK(fuel_type IN ('diesel', 'petrol', 'electric', 'gas'));

ALTER TABLE payment WITH CHECK ADD
	CONSTRAINT		payment_payment_id_pk		PRIMARY KEY(payment_id),
	CONSTRAINT		payment_payment_status_ck	CHECK(payment_status IN ('C', 'P', 'N')),
	CONSTRAINT		payment_payment_mode_ck		CHECK(payment_mode IN ('online', 'check', 'cash'));

ALTER TABLE v_order WITH CHECK ADD
	CONSTRAINT		v_order_order_id_pk			PRIMARY KEY(order_id),
	CONSTRAINT		v_order_payment_id_fk		FOREIGN KEY(payment_id)		REFERENCES payment(payment_id),
	CONSTRAINT		order_customer_id_fk		FOREIGN KEY(customer_id)	REFERENCES customer(customer_id),
	CONSTRAINT		v_order_vehicle_id_fk		FOREIGN KEY(vehicle_id)		REFERENCES vehicle(vin),
	CONSTRAINT		v_order_date_ck				CHECK(date <= GETDATE()),
	CONSTRAINT		v_order_amount_ck			CHECK(amount > 0),
	CONSTRAINT		v_order_quantity_ck			CHECK(quantity > 0);

ALTER TABLE invoice WITH CHECK ADD
	CONSTRAINT		invoice_invoice_no_pk		PRIMARY KEY(invoice_no),
	CONSTRAINT		invoice_payment_id_fk		FOREIGN KEY(payment_id)		REFERENCES payment(payment_id),
	CONSTRAINT		invoive_pproduct_id_fk		FOREIGN KEY(product_id)		REFERENCES vehicle(vin),
	CONSTRAINT		invoice_invoice_date_ck		CHECK(invoice_date < GETDATE());

--inserting data
INSERT INTO address VALUES
	(60647, 'Armitage Avenue', 'Chicago', 'Illinois'), --de
	(60668, 'Cermak Road', 'Chicago', 'Illinois'), --cu --de
	(12933, 'TN', 'Memphis', 'Oregon'), --cu --de
	(28356, 'Indiana', 'South Bend', 'CT'), --de
	(87425, 'Florida', 'Orlando', '03yland'), --de
	(64944, 'Wyoming', 'Cheyenne', 'Oklahoma'), --cu --de
	(82170, 'Montana', 'Great Falls', 'MS'), --cu
	(85655, 'IA', 'Cedar Rapids', 'Connecticut'), --de
	(90080, 'ID', 'Boise', 'Utah'), --cu --de
	(62561, 'Tennessee', 'Memphis', 'Massachusetts'),--cu --de
	(92769, 'Indiana', 'South Bend', 'NV'), --cu
	(45529, 'KY', 'Owensboro', 'Arkansas'); --de

INSERT INTO customer VALUES
	(895043, 60668, 'Orchard House-3/5', 'Griffin', 'R.', 'Malachi', '1983-10-23', 'dolor.sit.amet@nequeet.co.uk', '1-769-869-9917'), 
	(251550, 64944, 'Rose Cottage-4/2/3', 'Lucian', NULL, 'Harrison', '1990-10-11', 'ultrices.Vivamus@nibh.org', NULL), 
	(967139, 62561, '20-The hollies', 'Rylee', NULL, 'Eric', '1995-08-13', 'commodo.hendit@ultre.co.uk', NULL), 
	(2474123, 92769, 'oak barn-64/24', 'Tanek', NULL, 'Ezra', '1968-05-01', 'pharetra@Proineget.ca', '1-834-683-2691'), 
	(55869, 82170, 'The Willows', 'Samuel', NULL, 'Cain', '1966-05-22', 'senectus@tortor.org', '1-436-806-6305'), 
	(12461, 64944, 'School House-22', 'Holmes', 'W.', 'Carson', '1966-10-30', 'feugiat@traQuisque.org', '1-523-965-0864'), 
	(9596128, 12933, 'SunnySide-65/3', 'Nigel', 'F.', 'Deacon', '2001-12-03', 'vitae@dapibus.ca', NULL), 
	(85134661, 90080, 'Springfield/2', 'Susan', 'W.', 'Burton', '1984-06-04', 'nibh@Donec.org', '1-576-444-0364'), 
	(446309, 92769, 'Corner House', 'Jarrod', NULL, 'Hilel', '1970-02-03', 'eu.nibh@oremipsum.com', NULL), 
	(1866, 90080, 'High Field-2', 'Camilla', 'H.', 'Axel', '1994-03-03', 'arcu.Morbi.sit@vitae.org', NULL), 
	(557474, 60668, '45-The Mill HOuse', 'Briar', 'Peck', 'Samuel', '1972-11-10', 'ornare.In@necquam.edu', '1-778-231-9916'), 
	(365255, 62561, 'The Old reactory', 'Joan', 'Potts', 'Merrill', '1987-04-17', 'Nulla.eu.neque@lucices.org', '1-346-330-5841'), 
	(6069504, 82170, 'Havoc-332/22/3-1', 'Giselle', 'Mosley', '06ian', '1982-09-21', 'orci@monidiculus.ca', NULL), 
	(2592, 62561, 'Primrose Cottage-ESB', 'Eugenia', NULL, 'Ryan', '1962-05-23', 'risus@utnulla.net', NULL),
	(354455, 60668, 'Radicle_House-23', 'David', NULL, 'Neff', '1999-03-04', 'davidneff@mail.com', NULL);

INSERT INTO store VALUES
	(14968, 60647, 'Nibh Ltd', 'Y'),
	(17243, 28356, 'Semper Et Lacinia Sales', 'Y'),
	(16974, 45529, 'Sodales Mauris Corporation', 'Y'),
	(27921, 87425, 'Dictum Mi Ac Dealers', 'S'),
	(9749, 90080, 'Velit Justo Dealers', 'S'),
	(26596, 12933, 'Et Malesuada PC', 'S'),
	(8314, 85655, 'Quisque Ac Associates', 'Y');

INSERT INTO store (store_no, postal_code, building_name) VALUES
	(21827, 60668, 'Porttitor Inc.'),
	(8098, 62561, 'Ornare Fusce Mollis'),
	(1401, 64944, 'Praesent Limited');


INSERT INTO vehicle VALUES
	(17493468428372875, 26596, 'Merc 450SLC', 'Ford', 'gold', 322930, '2013-02-22', 'diesel'), 
	(88749952604405770, 8098, 'Porsche 914-2', 'BMW', 'green', 377062, '2020-03-17', 'electric'), --1
	(87872984949503123, 8098, 'Mazda RX4', 'Nissan', 'black', 244410, '2019-03-01', 'diesel'), 
	(33221038619648441, 17243, 'Honda Civic', 'Chrysler', 'black', 453986, '2006-01-01', 'electric'), --4
	(51180981525132113, 8314, 'Volvo 142E', 'Volvo', 'green', 184213, '2020-12-22', 'diesel'), 
	(92116511512315456, 26596, 'Ford Pantera L', 'General Motors', 'red', 66954, '2012-01-30', 'diesel'), --7
	(25816837766265469, 27921, 'Datsun 710', 'Subaru', 'black', 460892, '2020-03-17', 'petrol'),
	(92726953550642324, 8098, 'Ca03o Z28', 'Mahindra', 'yellow', 54350, '2002-09-23', 'diesel'); --6

INSERT INTO vehicle (vin, store_id, name, brand, price, make_date, fuel_type) VALUES
	(44576045677973803, 9749, 'Datsun 710', 'Peugeot', 283408, '2016-03-12', 'electric'), 
	(11779127144361565, 16974, 'Porsche 914-2', 'Peugeot', 73932, '2020-12-22', 'petrol'), --9
	(27324771901443098, 8314, 'Merc 280', 'Daimler', 420821, '2009-01-01', 'diesel'), 
	(44097268977600536, 14968, 'Honda Civic', 'Daihatsu', 86538, '2001-03-30', 'petrol'),
	(30720999394455454, 9749, 'Datsun 710', 'Acura', 156443, '2017-04-22', 'petrol');

INSERT INTO vehicle (vin, store_id, name, brand, color, price, make_date) VALUES
	(94537909704917620, 16974, 'Hornet Sportabout', 'Vauxhall', 'black', 137005, '2020-10-12'), --8
	(94546901669963275, 1401, 'Pontiac Firebird', 'BMW', 'blue', 165752, '2012-03-16'), --10
	(24596749140048868, 17243, 'Mazda RX4', 'Volkswagen', 'blue', 420264, '2016-04-22');

INSERT INTO vehicle (vin, store_id, name, brand, price, make_date) VALUES
	(31897188587050302, 8314, 'Chrysler Imperial', 'Audi', 224977, '2013-07-30'), 
	(82663626837597120, 21827, 'Dodge Challenger', 'Dongfeng Motor', 403851, '2020-05-01'), --5
	(44185429410219109, 14968, 'Merc 280', 'Mazda', 307887, '2014-03-17'), --3
	(76399951979326822, 16974, 'Volvo 142E', 'Volkswagen', 68549, '2008-11-01'); --2

INSERT INTO payment VALUES
	(906704,'P', 726374, 'Cash'),
	(437858,'C', 15889, 'Online'),
	(531089,'C', 14134, 'Check'),
	(290382,'N', 2000, 'Online'),
	(140509,'C', 5243, 'Cash');

INSERT INTO payment (payment_id, payment_status, amount_paid) VALUES
	(898016,'C', 68549),
	(998448,'C', 3000),
	(978955,'P', 128201);

INSERT INTO payment (payment_id, payment_status, payment_mode) VALUES
	(530285,'N', 'Check'),
	(210104,'N', 'Cash');

INSERT INTO v_order VALUES
	(410410, 906704, 85134661, 88749952604405770, '2020-03-03', 377062, 1), 
	(364433, 898016, 446309, 76399951979326822, '2020-01-22', 68549, 2), 
	(958269, 978955, 1866, 44185429410219109, '2020-06-12', 307887, 1), 
	(146467, 437858, 557474, 33221038619648441, '2019-12-15', 453986, 1);


INSERT INTO v_order (order_id, payment_id, customer_id, vehicle_id, date, amount) VALUES
	(942180, 998448, 354455, 11779127144361565, '2020-01-13', 73932), 
	(949257, 210104, 2592, 94546901669963275, '2019-02-24', 165752),
	(467219, 290382, 251550, 92726953550642324, '2020-10-12', 54350), 
	(472348, 530285, 6069504, 92116511512315456, '2021-02-05', 66954);

INSERT INTO v_order (order_id, payment_id, customer_id, vehicle_id, amount) VALUES
	(548980, 140509, 365255, 94537909704917620, 137005),
	(845033, 531089, 895043, 82663626837597120, 403851);


INSERT INTO invoice VALUES
	(876121, 898016, 76399951979326822, '2020-05-13'),
	(502232, 437858, 33221038619648441, '2020-04-06'),
	(923016, 531089, 82663626837597120, '2020-06-23'),
	(210209, 140509, 94537909704917620, '2020-12-12'),
	(456093, 998448, 11779127144361565, '2019-04-23');

--SELECT * FROM address;
--SELECT * FROM customer;
--SELECT * FROM store;
--SELECT * FROM vehicle;
--SELECT * FROM payment;
--SELECT * FROM v_order;
--SELECT * FROM invoice;
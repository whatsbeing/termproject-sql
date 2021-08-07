-- check if company database exist and delete if it exists
IF DB_ID('company') IS NOT NULL
    DROP DATABASE company;

CREATE DATABASE company;

-- check if any of these table exists and delete and them
DROP TABLE IF EXISTS  invoice, store, v_order, vehicle, customer, addresses, payment;

CREATE TABLE addresses(
	postal_code		INT,
	street			VARCHAR(30)	NOT NULL,
	city			VARCHAR(20)	NOT NULL,
	province		VARCHAR(20)	NOT NULL,
	CONSTRAINT		addresses_postal_code_pk	
		PRIMARY KEY(postal_code)
	);

CREATE TABLE customer(
	customer_id		INT,
	postal_code		INT			NOT NULL,
	building_number	VARCHAR(20)	NOT NULL,
	first_name		CHAR(15)	NOT NULL,
	middle_name		CHAR(15),
	last_name		CHAR(15)	NOT NULL,
	dob				DATE		NOT NULL,
	email_address	VARCHAR(30)	NOT NULL,
	phone_number	CHAR(14),
	CONSTRAINT		customer_customer_id_pk		
		PRIMARY KEY(customer_id),
	CONSTRAINT		customer_postal_code_fk		
		FOREIGN KEY(postal_code)	REFERENCES addresses(postal_code)
	);

CREATE TABLE vehicle(
	vin				BIGINT,
	v_name			CHAR(20)	NOT NULL,
	brand			CHAR(15)	NOT NULL,
	color			CHAR(10),
	price			MONEY		NOT NULL,
	make_year		DATE		NOT NULL,
	fuel_type		CHAR(10),
	CONSTRAINT		vehicle_vin_pk
		PRIMARY KEY(vin)
	);

CREATE TABLE payment(
	payment_id		INT,
	payment_status	CHAR(1)		NOT NULL,
	amount_paid		MONEY,
	payment_mode	CHAR(10),
	CONSTRAINT		payment_payment_id_pk		
		PRIMARY KEY(payment_id)
	);

CREATE TABLE v_order(
	order_id		INT,
	payment_id		INT		NOT NULL,
	customer_id 	INT		NOT NULL,
	vehicle_id		BIGINT	NOT NULL,
	o_date			DATE	NOT NULL,
	amount			MONEY	NOT NULL,
	quantity		TINYINT,
	CONSTRAINT		v_order_order_id_pk
		PRIMARY KEY(order_id),
	CONSTRAINT		v_payment_id_fk
		FOREIGN KEY(payment_id)		REFERENCES payment(payment_id),
	CONSTRAINT		v_order_customer_id_fk
		FOREIGN KEY(customer_id)		REFERENCES customer(customer_id),
	CONSTRAINT		v_order_vehicle_id_fk
		FOREIGN KEY(vehicle_id)		REFERENCES vehicle(vin)
	);

CREATE TABLE invoice(
	invoice_no		INT,
	payment_id		INT		NOT NULL,
	product_id		BIGINT	NOT NULL,
	invoice_date	DATE	NOT NULL,
	CONSTRAINT		invoice_invoice_no_pk		
		PRIMARY KEY(invoice_no),
	CONSTRAINT		invoice_payment_id_fk		
		FOREIGN KEY(payment_id)	REFERENCES payment(payment_id),
	CONSTRAINT		invoive_pproduct_id_fk	
		FOREIGN KEY(product_id)	REFERENCES vehicle(vin)
	);

CREATE TABLE store(
	store_no		SMALLINT,
	vehicle_id		BIGINT			NOT NULL,
	postal_code		INT			NOT NULL,
	building_name	VARCHAR(30)	NOT NULL,
    vehicle_availability		CHAR(1),
	CONSTRAINT		store_store_no_pk		
		PRIMARY KEY(store_no),
	CONSTRAINT		store_vehicle_id_fk		
		FOREIGN KEY(vehicle_id)		REFERENCES vehicle(vin),
	CONSTRAINT		store_postal_code_fk	
		FOREIGN KEY(postal_code)	REFERENCES addresses(postal_code)
);

INSERT INTO addresses VALUES
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
	
INSERT INTO vehicle VALUES
	(44185429410219109, 'Merc 280', 'Mazda', 'white', 307887, '2014-03-17', NULL), --3
	(17493468428372875, 'Merc 450SLC', 'Ford', NULL, 322930, '2013-02-22', 'diesel'), 
	(94546901669963275, 'Pontiac Firebird', 'BMW', 'blue', 165752, '2012-03-16', NULL), --10
	(88749952604405770, 'Porsche 914-2', 'BMW', 'green', 377062, '2020-03-17', 'electrical'), --1
	(87872984949503123, 'Mazda RX4', 'Nissan', NULL, 244410, '2019-03-01', 'diesel'), 
	(33221038619648441, 'Honda Civic', 'Chrysler', 'black', 453986, '2006-01-01', 'electrical'), --4
	(27324771901443098, 'Merc 280', 'Daimler', NULL, 420821, '2009-01-01', 'diesel'), 
	(44576045677973803, 'Datsun 710', 'Peugeot', NULL, 283408, '2016-03-12', NULL), 
	(24596749140048868, 'Mazda RX4', 'Volkswagen', 'blue', 420264, '2016-04-22', NULL), 
	(44097268977600536, 'Honda Civic', 'Daihatsu', NULL, 86538, '2001-03-30', 'petrol'),
	(76399951979326822, 'Volvo 142E', 'Volkswagen', 'black', 68549, '2008-11-01', NULL), --2
	(30720999394455454, 'Datsun 710', 'Acura', NULL, 156443, '2017-04-22', 'petrol'), 
	(11779127144361565, 'Porsche 914-2', 'Peugeot', NULL, 73932, '2020-12-22', NULL), --9
	(94537909704917620, 'Hornet Sportabout', 'Vauxhall', NULL, 137005, '2020-10-12', NULL), --8
	(51180981525132113, 'Volvo 142E', 'Volvo', 'green', 184213, '2020-12-22', 'diesel'), 
	(92116511512315456, 'Ford Pantera L', 'General Motors', 'red', 66954, '2012-01-30', 'diesel'), --7
	(25816837766265469, 'Datsun 710', 'Subaru', 'black', 460892, '2020-03-17', 'petrol'),
	(31897188587050302, 'Chrysler Imperial', 'Audi', 'black', 224977, '2013-07-30', NULL), 
	(82663626837597120, 'Dodge Challenger', 'Dongfeng Motor', NULL, 403851, '2020-05-01', NULL), --5
	(92726953550642324, 'Ca03o Z28', 'Mahindra', NULL, 54350, '2002-09-23', 'diesel'); --6

INSERT INTO payment VALUES
	(906704,'P', 726374, 'Cash'),
	(898016,'C', 68549, 'Online'),
	(978955,'P', 128201, 'Check'),
	(437858,'C', NULL, 'Online'),
	(531089,'C', NULL, 'Check'),
	(290382,'I', 0, NULL),
	(530285,'I', 0, 'Check'),
	(140509,'C', NULL, 'Check'),
	(998448,'C', NULL, 'Online'),
	(210104,'I', 0, 'Cash');

INSERT INTO v_order VALUES
	(410410, 906704, 85134661, 88749952604405770, '2020-03-03', 377062, 2), 
	(364433, 898016, 446309, 76399951979326822, '2020-01-22', 68549, 2), 
	(958269, 978955, 1866, 44185429410219109, '2020-06-12', 307887, 2), 
	(146467, 437858, 557474, 33221038619648441, '2019-12-15', 453986, 1), 
	(845033, 531089, 895043, 82663626837597120, '2020-04-23', 403851, 2), 
	(467219, 290382, 251550, 92726953550642324, '2020-10-12', 54350, 1), 
	(472348, 530285, 6069504, 92116511512315456, '2021-02-05', 66954, 1), 
	(548980, 140509, 365255, 94537909704917620, '2021-01-30', 137005, 3), 
	(942180, 998448, 354455, 11779127144361565, '2020-01-13', 73932, 1), 
	(949257, 210104, 2592, 94546901669963275, '2019-02-24', 165752, 2);

INSERT INTO invoice VALUES
	(876121, 898016, 76399951979326822, '2020-05-13'),
	(502232, 437858, 33221038619648441, '2020-04-06'),
	(923016, 531089, 82663626837597120, '2020-06-23'),
	(210209, 140509, 94537909704917620, '2020-12-12'),
	(456093, 998448, 11779127144361565, '2019-04-23');

--INSERT INTO store VALUES
--	(14968, 44185429410219109, 60647, 'Nibh Ltd', 'Y'),
--	(17243, 17493468428372875, 28356, 'Semper Et Lacinia Sales', 'Y'),
--	(16974, 94546901669963275, 45529, 'Sodales Mauris Corporation', 'Y'),
--	(27921, 88749952604405770, 87425, 'Dictum Mi Ac Dealers', 'S'),
--	(8314, 87872984949503123, 85655, 'Quisque Ac Associates', 'S'),
--	(21827, 33221038619648441, 60668, 'Porttitor Inc.', 'Y'),
--	(8098, 27324771901443098, 62561, 'Ornare Fusce Mollis', 'N'),
--	(1401, 44576045677973803, 64944, 'Praesent Limited', 'N'),
--	(9749, 24596749140048868, 90080, 'Velit Justo Dealers', 'S'),
--	(26596, 44097268977600536, 12933, 'Et Malesuada PC', 'N'),
--	(14968, 76399951979326822, 60647, 'Nibh Ltd', 'Y'),
--	(17243, 30720999394455454, 28356, 'Semper Et Lacinia Sales', 'Y'),
--	(16974, 11779127144361565, 45529, 'Sodales Mauris Corporation', 'Y'),
--	(27921, 94537909704917620, 87425, 'Dictum Mi Ac Dealers', 'S'),
--	(8314, 51180981525132113, 85655, 'Quisque Ac Associates', 'S'),
--	(21827, 92116511512315456, 60668, 'Porttitor Inc.', 'Y'),
--	(8098, 25816837766265469, 62561, 'Ornare Fusce Mollis', 'N'),
--	(1401, 31897188587050302, 64944, 'Praesent Limited', 'N'),
--	(9749, 82663626837597120, 90080, 'Velit Justo Dealers', 'S'),
--	(26596, 92726953550642324, 12933, 'Et Malesuada PC', 'N');

--SELECT * FROM customer;
--SELECT * FROM addresses;
--SELECT * FROM vehicle;
--SELECT * FROM v_order;
--SELECT * FROM payment;
--SELECT * FROM invoice;
--SELECT * FROM store;
  
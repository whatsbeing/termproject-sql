-- check if company database exist and delete if it exists
IF DB_ID('company') IS NOT NULL
BEGIN
    DROP DATABASE company;
END

CREATE DATABASE company;

-- check if any of these table exists and delete and them
DROP TABLE IF EXISTS  salesinvoice, store, product_order, product, customer, addresses, payment;

CREATE TABLE addresses(
	postal_code		INT,
	city			CHAR(20),
	province		CHAR(20),
	CONSTRAINT		addresses_postal_code_pk	
		PRIMARY KEY(postal_code)
	);

CREATE TABLE customer(
	customer_id		INT,
	last_name		CHAR(40),
	first_name		CHAR(20),
	phone_number	INT,
	email_address	CHAR(30),
	postal_code		INT,
	CONSTRAINT		customer_customer_id_pk		
		PRIMARY KEY(customer_id),
	CONSTRAINT		customer_postal_code_fk		
		FOREIGN KEY(postal_code)	REFERENCES addresses(postal_code)
	);

CREATE TABLE product(
	product_id		INT,
	product_no		INT,
	product_type	CHAR(15),
	quantity		INT,
	price			INT,
	CONSTRAINT		product_id_pk
		PRIMARY KEY(product_id)
	);

CREATE TABLE product_order(
	order_id		INT,
	product_id		INT,
	p_availability	CHAR(2),
	CONSTRAINT		product_order_order_id_pk
		PRIMARY KEY(order_id),
	CONSTRAINT		product_order_product_id_fk
		FOREIGN KEY(order_id)		REFERENCES product(product_id)
	);



CREATE TABLE payment(
	payee_id		INT,
	amount_paid		DECIMAL(20,2),
	payment_mode	CHAR(40),
	CONSTRAINT		payment_Payee_id_pk		PRIMARY KEY(Payee_id)
	);

CREATE TABLE salesinvoice(
	invoice_no		INT,
	customer_id		INT,
	Total			DECIMAL(20,2),
	CONSTRAINT		salesinvoice_Invoice_no_pk		PRIMARY KEY(invoice_no),
	CONSTRAINT		salesinvoice_customer_id_fk		FOREIGN KEY(customer_id)	REFERENCES customer(customer_id)
	);

CREATE TABLE store(
	store_no		INT,
	product_id		INT,
	postal_code		INT,
	CONSTRAINT		store_store_no_pk		PRIMARY KEY(store_no),
	CONSTRAINT		store_product_id_fk		FOREIGN KEY(product_id)		REFERENCES product(product_id),
	CONSTRAINT		store_postal_code_fk	FOREIGN KEY(postal_code)	REFERENCES addresses(postal_code)
);

SELECT * FROM customer;
SELECT * FROM addresses;
SELECT * FROM product;
SELECT * FROM product_order;
SELECT * FROM payment;
SELECT * FROM salesinvoice;
SELECT * FROM store;
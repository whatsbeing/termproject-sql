IF DB_ID('company') IS NOT NULL
BEGIN
    DROP DATABASE company;
END

CREATE DATABASE company;

IF OBJECT_ID(N'dbo.customer', N'U') IS NOT NULL
BEGIN
	DROP TABLE customer;
	DROP TABLE addresses;
	DROP TABLE product_order;
	DROP TABLE product;
END

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
	id				INT,
	product_no		INT,
	product_type	CHAR(15),
	quantity		INT,
	price			INT,
	CONSTRAINT		product_id_pk
		PRIMARY KEY(id)
	);

CREATE TABLE product_order(
	order_id		INT,
	product_id		INT,
	p_availability	CHAR(2),
	CONSTRAINT		product_order_order_id_pk
		PRIMARY KEY(order_id),
	CONSTRAINT		product_order_product_id_fk
		FOREIGN KEY(order_id)		REFERENCES product(id)
	);


SELECT * FROM customer;
SELECT * FROM addresses;
SELECT * FROM product;
SELECT * FROM product_order;
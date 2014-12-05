-- TABLE STRUCTURE FOR PATS DATABASE
--
-- by (Jay Chopra) & (Logan Watanabe)
--
--CREATE DATABASE pats OWNER {your username};
--psql -U {your username} -d pats  -f pats_structure.sql

CREATE TABLE animals(
	id SERIAL PRIMARY KEY,
   	name varchar(40) NOT NULL,
  	active boolean NOT NULL DEFAULT true
);

CREATE TABLE pets(
	id SERIAL PRIMARY KEY,
   	name varchar(40) NOT NULL,
   	animal_id integer NOT NULL,
   	owner_id integer NOT NULL,
   	female boolean NOT NULL,
   	date_of_birth date default CURRENT_DATE,
   	active boolean NOT NULL DEFAULT true
);

CREATE TABLE owners(
	id SERIAL PRIMARY KEY,
	first_name varchar(40) NOT NULL,
	last_name varchar(40) NOT NULL,
	street varchar(40) NOT NULL,
	city varchar(40) NOT NULL,
	state varchar(2) NOT NULL DEFAULT 'PA',
	zip varchar(16) NOT NULL,
	phone varchar(10),
	email varchar(40),
	active boolean NOT NULL DEFAULT true
);

CREATE TABLE users(
   id SERIAL PRIMARY KEY,
   first_name varchar(40) NOT NULL,
   last_name varchar(40) NOT NULL,
   role varchar(40) NOT NULL,
   username varchar(40) NOT NULL UNIQUE,
   password_digest text NOT NULL,
   active boolean NOT NULL DEFAULT true
);

CREATE TABLE visits(
	id SERIAL PRIMARY KEY NOT NULL,
	pet_id integer NOT NULL,
	date date NOT NULL default CURRENT_DATE,
	weight integer,
	overnight_stay boolean DEFAULT false,
	total_charge integer DEFAULT 0
);

CREATE TABLE notes(
	id SERIAL PRIMARY KEY NOT NULL,
	notable_type varchar(10) NOT NULL,
	notable_id integer NOT NULL,
	title varchar(40) NOT NULL,
	content text NOT NULL,
	user_id integer NOT NULL,
	date date NOT NULL default CURRENT_DATE
);

CREATE TABLE medicines (
	id SERIAL PRIMARY KEY NOT NULL,
	name text NOT NULL,
	description text NOT NULL,
	stock_amount integer NOT NULL,
	method varchar(40) NOT NULL,
	unit varchar(40) NOT NULL,
	vaccine boolean NOT NULL DEFAULT false
);

CREATE TABLE medicine_costs (
	id SERIAL PRIMARY KEY NOT NULL,
	medicine_id integer NOT NULL,
	cost_per_unit integer NOT NULL,
	start_date date NOT NULL default CURRENT_DATE,
	end_date date
);

CREATE TABLE animal_medicines (
	id SERIAL PRIMARY KEY NOT NULL,
	animal_id integer NOT NULL,
	medicine_id integer NOT NULL,
	recommended_num_of_units integer
);

CREATE TABLE visit_medicines (
	id SERIAL PRIMARY KEY NOT NULL,
	visit_id integer NOT NULL,
	medicine_id integer NOT NULL,
	units_given integer NOT NULL,
	discount real NOT NULL DEFAULT 0
);

CREATE TABLE procedures (
	id SERIAL PRIMARY KEY NOT NULL,
	name varchar(40) NOT NULL,
	description text,
	length_of_time integer NOT NULL,
	active boolean NOT NULL DEFAULT true
);

CREATE TABLE treatments (
	id SERIAL PRIMARY KEY NOT NULL,
	visit_id integer NOT NULL,
	procedure_id integer NOT NULL,
	successful boolean,
	discount real NOT NULL DEFAULT 0
);

CREATE TABLE procedure_costs (
	id SERIAL PRIMARY KEY NOT NULL,
	procedure_id integer NOT NULL,
	cost integer NOT NULL,
	start_date date NOT NULL default CURRENT_DATE,
	end_date date
);

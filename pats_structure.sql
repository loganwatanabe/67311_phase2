-- TABLE STRUCTURE FOR PATS DATABASE
--
-- by (student_1) & (student_2)
--
--CREATE DATABASE pats OWNER {your username};
--psql -U {your username} -d pats  -f pats_structure.sql

CREATE TABLE animals(
	id SERIAL PRIMARY KEY,
   	name text NOT NULL,
  	active boolean NOT NULL DEFAULT true
);

CREATE TABLE pets(
	id SERIAL PRIMARY KEY,
   	name text NOT NULL,
   	animal_id integer NOT NULL,
   	owner_id integer NOT NULL,
   	female boolean NOT NULL,
   	date_of_birth date,
   	active boolean NOT NULL DEFAULT true
);

CREATE TABLE owners(
	id SERIAL PRIMARY KEY,
	first_name text NOT NULL,
	last_name text NOT NULL,
	street text NOT NULL,
	city text NOT NULL,
	state text NOT NULL DEFAULT 'PA',
	zip text NOT NULL,
	phone text,
	email text,
	active boolean NOT NULL DEFAULT true
);

CREATE TABLE users(
   id SERIAL PRIMARY KEY,
   first_name text NOT NULL,
   last_name text NOT NULL,
   role text NOT NULL,
   username text NOT NULL UNIQUE,
   password_digest text NOT NULL,
   active boolean NOT NULL DEFAULT true
);

CREATE TABLE visits(
	id SERIAL PRIMARY KEY NOT NULL,
	pet_id integer NOT NULL,
	date date NOT NULL,
	weight integer,
	overnight_stay boolean NOT NULL,
	total_charge integer NOT NULL
);

CREATE TABLE notes(
	id SERIAL PRIMARY KEY NOT NULL,
	notable_type text NOT NULL,
	notable_id integer NOT NULL,
	title text NOT NULL,
	content text NOT NULL,
	user_id integer NOT NULL,
	date date NOT NULL
);

CREATE TABLE medicines (
	id SERIAL PRIMARY KEY NOT NULL,
	name text NOT NULL,
	description text NOT NULL,
	stock_amount integer NOT NULL,
	method text NOT NULL,
	unit text NOT NULL,
	vaccine boolean DEFAULT false NOT NULL
);

CREATE TABLE medicine_costs (
	id SERIAL PRIMARY KEY NOT NULL,
	medicine_id integer NOT NULL,
	cost_per_unit integer NOT NULL,
	start_date date NOT NULL,
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
	name text NOT NULL,
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
	start_date date NOT NULL,
	end_date date
);

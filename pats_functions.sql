-- FUNCTIONS AND TRIGGERS FOR PATS DATABASE
--
-- by (student_1) & (student_2)
--
--
-- calculate_total_costs
-- (associated with two triggers: update_total_costs_for_medicines_changes & update_total_costs_for_treatments_changes)
CREATE OR REPLACE FUNCTION calculate_total_costs() RETURNS TRIGGER AS $$
DECLARE
v_id integer;
overall_cost integer;
total_cost_medicines integer;
total_cost_treatments integer;
BEGIN
	v_id = NEW.visit_id;
	total_cost_medicines = (SELECT COALESCE(ROUND(SUM(cost_per_unit*units_given*(1-discount))), 0) FROM medicine_costs 
			JOIN medicines ON medicine_costs.medicine_id = medicines.id
			JOIN visit_medicines ON visit_medicines.medicine_id = medicines.id
			JOIN visits ON visits.id = visit_medicines.visit_id
			WHERE visit_medicines.visit_id = v_id AND medicine_costs.end_date IS NULL
			);
	total_cost_treatments = (SELECT COALESCE(ROUND(SUM(cost*(1-discount))),0) FROM procedure_costs 
		JOIN procedures ON procedure_costs.procedure_id = procedures.id
		JOIN treatments ON treatments.procedure_id = procedures.id
		JOIN visits ON visits.id = treatments.visit_id
		WHERE treatments.visit_id = v_id AND procedure_costs.end_date IS NULL
		);
	overall_cost = total_cost_treatments + total_cost_medicines;
	UPDATE visits SET total_charge = overall_cost WHERE id = v_id;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER update_total_costs_for_medicines_changes AFTER INSERT OR UPDATE OR DELETE ON visit_medicines FOR EACH ROW
EXECUTE PROCEDURE calculate_total_costs();

CREATE TRIGGER update_total_costs_for_treatments_changes AFTER INSERT OR DELETE ON treatments FOR EACH ROW
EXECUTE PROCEDURE calculate_total_costs();


-- calculate_overnight_stay
-- (associated with a trigger: update_overnight_stay_flag)

CREATE OR REPLACE FUNCTION calculate_overnight_stay() RETURNS TRIGGER AS $$
DECLARE
total_minutes integer;
last_treatment integer;
v_id integer;
BEGIN
	v_id = NEW.visit_id;
	total_minutes = (SELECT SUM(length_of_time) FROM procedures JOIN treatments ON treatments.procedure_id = procedures.id JOIN visits ON visits.id = treatments.visit_id AND visit_id = v_id GROUP BY visits.id);
	IF total_minutes >= 720 THEN
		UPDATE visits SET overnight_stay = TRUE WHERE id = v_id;
	ELSE
		UPDATE visits SET overnight_stay = FALSE WHERE id = v_id;
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_overnight_stay_flag AFTER INSERT OR DELETE ON treatments FOR EACH ROW
EXECUTE PROCEDURE calculate_overnight_stay();



-- -- decrease_stock_amount_after_dosage
-- -- (associated with a trigger: update_stock_amount_for_medicines)
CREATE OR REPLACE FUNCTION decrease_stock_amount_after_dosage() RETURNS TRIGGER AS $$
DECLARE
	med_id integer;
	old_stock integer;
	new_stock integer;
BEGIN
	med_id = NEW.medicine_id;
	old_stock = (SELECT stock_amount FROM medicines WHERE medicines.id = med_id);
	new_stock = old_stock - NEW.units_given;
	UPDATE medicines SET stock_amount = new_stock WHERE id = med_id;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_stock_amount_for_medicines AFTER INSERT ON visit_medicines FOR EACH ROW--HOW TO ACCOUNT FOR UPDATES????
EXECUTE PROCEDURE decrease_stock_amount_after_dosage();



--THIS WORKS

-- verify_that_medicine_requested_in_stock
-- (takes medicine_id and units_needed as arguments and returns a boolean)
CREATE OR REPLACE FUNCTION verify_that_medicine_requested_in_stock(medicine_id integer, units_needed integer) RETURNS boolean AS $$
DECLARE
	stock integer;
BEGIN
	stock = (SELECT stock_amount FROM medicines WHERE medicines.id = medicine_id);
	IF stock >= units_needed THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
$$ LANGUAGE plpgsql;




--??????? I'm assuming that 'appropriate' just means an animal_medicine record exists for the pet's animal type
--anyways, IT WORKS

-- verify_that_medicine_is_appropriate_for_pet
-- (takes medicine_id and pet_id as arguments and returns a boolean)
CREATE OR REPLACE FUNCTION verify_that_medicine_is_appropriate_for_pet(med_id integer, pet_id integer) RETURNS boolean AS $$
DECLARE
	anim_id integer;
	exists boolean;
BEGIN
	anim_id = (SELECT pets.animal_id FROM pets WHERE pets.id = pet_id);
	exists = (EXISTS(SELECT * FROM animal_medicines WHERE animal_medicines.medicine_id = med_id AND animal_medicines.animal_id = anim_id));
	RETURN exists;
END;
$$ LANGUAGE plpgsql;






-- THE TRIGGERS BELOW WORK, but the test data is input backwards, so there are no current costs because it automatically closes any null end_dates
-- but with correctly input data it works.  need to put these in after data is loaded




-- set_end_date_for_medicine_costs
-- (associated with a trigger: set_end_date_for_previous_medicine_cost)
CREATE OR REPLACE FUNCTION set_end_date_for_medicine_costs() RETURNS TRIGGER AS $$
DECLARE
	med_id integer;
	previous_cost_id integer;
BEGIN
	med_id = NEW.medicine_id;
	previous_cost_id = (SELECT id FROM medicine_costs WHERE medicine_id = med_id AND end_date IS NULL AND id != NEW.id);
	UPDATE medicine_costs SET end_date = NEW.start_date WHERE id = previous_cost_id;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_end_date_for_previous_medicine_cost AFTER INSERT ON medicine_costs FOR EACH ROW
EXECUTE PROCEDURE set_end_date_for_medicine_costs();

-- -- set_end_date_for_procedure_costs
-- -- (associated with a trigger: set_end_date_for_previous_procedure_cost)
CREATE OR REPLACE FUNCTION set_end_date_for_procedure_costs() RETURNS TRIGGER AS $$
DECLARE
	proc_id integer;
	previous_cost_id integer;
BEGIN
	proc_id = NEW.procedure_id;
	previous_cost_id = (SELECT id FROM procedure_costs WHERE procedure_id = proc_id AND end_date IS NULL AND id != NEW.id);
	UPDATE procedure_costs SET end_date = NEW.start_date WHERE id = previous_cost_id;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_end_date_for_previous_procedure_cost AFTER INSERT ON procedure_costs FOR EACH ROW
EXECUTE PROCEDURE set_end_date_for_procedure_costs();



-- CONSTRAINTS FOR PATS DATABASE
--
-- by (student_1) & (student_2)
--
--
--method types ['injection', 'oral', 'intravenous']
--notable types ['owner', 'pet', 'visit']
--foreign keys, see note 13
--discount 0<= x <=1


--FOREIGN KEYS

ALTER TABLE pets
ADD CONSTRAINT pet_animal_fk
FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE pets
ADD CONSTRAINT pet_owner_fk
FOREIGN KEY (owner_id) REFERENCES owners(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE visits
ADD CONSTRAINT visit_pet_fk
FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE medicine_costs
ADD CONSTRAINT med_cost_medicine_fk
FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE visit_medicines
ADD CONSTRAINT visit_medicine_visit_fk
FOREIGN KEY (visit_id) REFERENCES visits(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE treatments
ADD CONSTRAINT treatment_visit_fk
FOREIGN KEY (visit_id) REFERENCES visits(id) ON DELETE RESTRICT ON UPDATE CASCADE;

--allow this?
ALTER TABLE animal_medicines
ADD CONSTRAINT animal_med_animal_fk
FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE RESTRICT ON UPDATE CASCADE;
--or this?
ALTER TABLE animal_medicines
ADD CONSTRAINT animal_med_medicine_fk
FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE RESTRICT ON UPDATE CASCADE;

--possible change
ALTER TABLE visit_medicines
ADD CONSTRAINT visit_medicine_med_fk
FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE RESTRICT ON UPDATE CASCADE;


--possible change
ALTER TABLE treatments
ADD CONSTRAINT treatment_procedure_fk
FOREIGN KEY (procedure_id) REFERENCES procedures(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE procedure_costs
ADD CONSTRAINT procedure_cost_procedure_fk
FOREIGN KEY (procedure_id) REFERENCES procedures(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE notes
ADD CONSTRAINT note_user_fk
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE CASCADE;


--String constraints
ALTER TABLE medicines
ADD CONSTRAINT medicine_method
CHECK (method IN ('intravenous', 'oral', 'injection'));

--help to ensure FK actually exists, can this be done with a constraint??
ALTER TABLE notes
ADD CONSTRAINT notable_type_check
CHECK (notable_type IN ('owner', 'pet', 'visit'));

--!?!?!?!?!?!?!?!?!?!?!?!?
CREATE FUNCTION notable_check (@type text, @id int) RETURNS INT
AS
BEGIN
	DECLARE @table =  @type || 's';
	RETURN (
		SELECT count(*) FROM @table WHERE id = @id;
	);
END;

ALTER TABLE notes
ADD CONSTRAINT notable_id_check
CHECK ( notable_check() = 1);


--discount 0<= x <=1
ALTER TABLE visit_medicines
ADD CONSTRAINT med_discount_check
CHECK ( discount BETWEEN 0 AND 1);

ALTER TABLE treatments
ADD CONSTRAINT treatment_discount_check
CHECK ( discount BETWEEN 0 AND 1);

INSERT INTO medicines (name, description, stock_amount, method, unit, vaccine) VALUES ('Herbs','Ancient Chinese Herbs',15,'oral','ounces',false);
INSERT INTO animals (name, description, stock_amount, method, unit, vaccine) VALUES ('Herbs','Ancient Chinese Herbs',15,'oral','ounces',false);
INSERT INTO medicines (name, description, stock_amount, method, unit, vaccine) VALUES ('Herbs','Ancient Chinese Herbs',15,'oral','ounces',false);




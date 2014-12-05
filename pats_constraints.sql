-- CONSTRAINTS FOR PATS DATABASE
--
-- by (Jay Chopra) & (Logan Watanabe)
--
--
--method types ['injection', 'oral', 'intravenous']
--notable types ['owner', 'pet', 'visit']
--foreign keys, see note 13
--discount 0<= x <=1
--finished


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

ALTER TABLE animal_medicines
ADD CONSTRAINT animal_med_animal_fk
FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE animal_medicines
ADD CONSTRAINT animal_med_medicine_fk
FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE visit_medicines
ADD CONSTRAINT visit_medicine_med_fk
FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE RESTRICT ON UPDATE CASCADE;

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


--phone constraint
ALTER TABLE owners
ADD CONSTRAINT phone_number
CHECK (phone ~* '\d{10}');

--help to ensure FK type is there, prof h said we don't need to check actual id
ALTER TABLE notes
ADD CONSTRAINT notable_type_check
CHECK (notable_type IN ('owners', 'pets', 'visits'));

--medicine stock_amount
ALTER TABLE medicines
ADD CONSTRAINT med_stock_check
CHECK ( stock_amount >= 0 );

--discount 0<= x <=1
ALTER TABLE visit_medicines
ADD CONSTRAINT med_discount_check
CHECK ( discount BETWEEN 0 AND 1);

ALTER TABLE treatments
ADD CONSTRAINT treatment_discount_check
CHECK ( discount BETWEEN 0 AND 1);
-- Zaphod (pet id: 173; owned by Horacio Mayert) the dog comes in today for a visit and weighs 39 pounds.

-- in connection #1
BEGIN;
Insert into visits (pet_id,date,weight,overnight_stay,total_charge)
values (173,now(),39,t,0);

-- Zaphod gets an examination because he's lost some weight unexpectedly. (Last two visits he weighed 48 and 50 pounds, so 39 pounds is low for Zaphod.)

Insert into treatments (visit_id,procedure_id,successful,discount)
select t.pet_id, t.procedure_id
from visits v join treatments t on v.id = t.visit_id join procedures p t.procedure_id = p.id
where t.pet_id = 173 and t.procedure_id = (select id from procedures where name = "examination");

-- Assuming the required 500 units are in stock and the medicine is appropriate for a dog, Zaphod is given Ivermectin (medicine id: 3) to treat a nasty parasite which is responsible for the weight loss.


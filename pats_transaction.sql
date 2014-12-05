-- TRANSACTION EXAMPLE FOR PATS DATABASE
--
-- by (Jay Chopra) & (Logan Watanabe)
--
--


-- Zaphod (pet id: 173; owned by Horacio Mayert) the dog comes in today for a visit and weighs 39 pounds.

BEGIN;
Insert into visits (pet_id,date,weight,overnight_stay,total_charge)
values (173,now(),39,true,0);

-- Zaphod gets an examination because he's lost some weight unexpectedly. (Last two visits he weighed 48 and 50 pounds, so 39 pounds is low for Zaphod.)

Insert into treatments (visit_id,procedure_id,successful,discount)
values ((select id from visits where pet_id = 173 order by date desc limit 1), (select p.id from procedures p where name='Examination' limit 1), true, 0);

-- Assuming the required 500 units are in stock and the medicine is appropriate for a dog, Zaphod is given Ivermectin (medicine id: 3) to treat a nasty parasite which is responsible for the weight loss.

Insert into visit_medicines (visit_id, medicine_id, units_given, discount)
values( (select id from visits where pet_id = 173 order by date desc limit 1), 3, 500, 0);



-- Assuming the required 200 units are in stock and the medicine is appropriate for a dog, Zaphod is given Mirtazapine (medicine id: 5) to stimulate his appetite and help get his weight back up to the 50 pound range.


Insert into visit_medicines (visit_id, medicine_id, units_given, discount)
values ((select id from visits where pet_id = 173 order by date desc limit 1), 5, 200, 0);


-- Assuming no problems, then total costs for these services and medicines are calculated (no discounts for Horacio), the overnight_stay flag is evaluated and all the data is committed to the database. If there are any problems at any step, then none of this data is saved to the system.


COMMIT;



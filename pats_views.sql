-- VIEWS FOR PATS DATABASE
--
-- by (Jay Chopra) & (Logan Watanabe )
--
--

-- In terms of views, one view called 'owners_view' is to be created that joins owners, pets, and visits together. In addition, the pet's animal_id is to be replaced with the animal name (which is more meaningful).

create view owners_view as 
	select o.first_name as "Owner First Name", o.last_name as "Owner Last Name", o.street, o.city, o.state, o.zip, o.phone, o.email, o.active as "Owner Active", p.name as "Pet Name", a.name as "Animal Species", p.owner_id, p.female, p.date_of_birth, p.active as "Pet Active", v.pet_id, v.date, v.weight, v.overnight_stay, v.total_charge
	from owners o left join pets p on o.id = p.owner_id left join visits v on v.pet_id = p.id join animals a a.id = p.animal_id;
	
	select * from owners_view;

-- The second view is to be called 'medicine_views' and connects information from the medicine, animal and cost tables together. This view should also replace animal_id with the animal name. In terms of costs, the only costs that need to appear are the current cost_per_unit for the medicine (column should be called 'current cost') as well as the date the medicine's cost last changed.

create view medicine_views as 
	select m.name as "Medicine Name", m.description, m.stock_amount, m.method, m.unit, m.vaccine, mc.cost_per_unit as "Current Cost", mc.start_date as "Last Price Change", am.recm_num_units, a.name as "Animal Name", a.active
	from medicines m join medicineCosts mc on m.id = mc.medicine_id left join animalMedicines am on m.id = am.medicine_id join animals a on a.id = am.animal_id
	where mc.start_date = (SELECT MAX(mc.start_date) FROM medicineCosts mc join medicines m on m.id = mc.medicine_id );

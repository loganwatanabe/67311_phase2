-- INDEXES FOR PATS DATABASE
--
-- by (student_1) & (student_2)
--
--
--
-- add a GIN index on medicines(description) using the to_tsvector() function.

CREATE INDEX medicine_desc_idx ON medicines USING gin(to_tsvector('english',description));

--create any other indexes we might find useful
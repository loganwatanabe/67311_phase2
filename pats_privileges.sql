-- PRIVILEGES FOR pats USER OF PATS DATABASE
--
-- by (student_1) & (student_2)
--
--
-- SQL needed to create the pats user

--CREATE DB???
CREATE USER pats;

--CREATE DATABASE pats OWNER pats;


-- SQL to limit pats user access on key tables

REVOKE DELETE ON visit_medicines FROM pats;
REVOKE DELETE ON treatments FROM pats;
REVOKE UPDATE (units_given) ON visit_medicines FROM pats;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO PUBLIC;
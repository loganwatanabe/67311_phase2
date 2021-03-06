-- PRIVILEGES FOR pats USER OF PATS DATABASE
--
-- by (Jay Chopra) & (Logan Watanabe)
--
--
-- SQL needed to create the pats user

CREATE USER pats;


-- SQL to limit pats user access on key tables

REVOKE DELETE ON visit_medicines FROM pats;
REVOKE DELETE ON treatments FROM pats;
REVOKE UPDATE (units_given) ON visit_medicines FROM pats;

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO PUBLIC;
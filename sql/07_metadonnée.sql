-- Meta-données : liste_ora_constraint.sql

SELECT
  c.table_name,
  c.constraint_name,
  c.constraint_type,
  DBMS_METADATA.GET_DDL('CONSTRAINT', c.constraint_name) AS ddl_constraint
FROM user_constraints c
ORDER BY c.table_name, c.constraint_type, c.constraint_name;

-- Meta-données : liste_ora_triggers.sql

SELECT
  t.table_name,
  t.trigger_name,
  t.status,
  DBMS_METADATA.GET_DDL('TRIGGER', t.trigger_name) AS ddl_trigger
FROM user_triggers t
ORDER BY t.table_name, t.trigger_name;


-- Meta-données : liste_ora_views.sql

SELECT
  v.view_name,
  DBMS_METADATA.GET_DDL('VIEW', v.view_name) AS ddl_view
FROM user_views v
ORDER BY v.view_name;

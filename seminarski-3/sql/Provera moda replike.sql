SELECT
    MON$REPLICA_MODE AS REPLICA_MOD,
    CASE MON$REPLICA_MODE
        WHEN 0 THEN 'Nije replika (master baza)'
        WHEN 1 THEN 'Read-Only replika'
        WHEN 2 THEN 'Read-Write replika'
    END AS OPIS
FROM MON$DATABASE;

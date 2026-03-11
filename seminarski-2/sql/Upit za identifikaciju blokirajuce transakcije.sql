/* ================================================
   IDENTIFIKACIJA TRANSakCIJE KOJA BLOKIRA GARBAGE COLLECTOR
   ================================================ */
SELECT
    A.MON$USER AS KORISNIK,
    A.MON$REMOTE_ADDRESS AS IP_ADRESA,
    A.MON$REMOTE_PROCESS AS APLIKACIJA,
    T.MON$TIMESTAMP AS POCETAK,
    (CURRENT_TIMESTAMP - T.MON$TIMESTAMP) AS TRAJANJE_SEKUNDI,
    CASE T.MON$ISOLATION_MODE
        WHEN 0 THEN 'Consistency'
        WHEN 1 THEN 'Snapshot'
        WHEN 2 THEN 'RC Record Version'
        WHEN 3 THEN 'RC No Record Version'
        WHEN 4 THEN 'Read Consistency'
        ELSE 'Nepoznat'
    END AS IZOLACIJA
FROM MON$TRANSACTIONS T
JOIN MON$ATTACHMENTS A ON T.MON$ATTACHMENT_ID = A.MON$ATTACHMENT_ID
WHERE T.MON$TRANSACTION_ID = (SELECT MON$OLDEST_ACTIVE FROM MON$DATABASE);
/* ================================================
      TUMAČENJE:
       Ovaj upit pronalazi transakcije zbog kojih Garbage Collector ne može da čisti stare verzije
      MON$OLDEST_ACTIVE (OAT) = najstarija aktivna transakcija, što je OAT stariji, više verzija se gomila = BLOAT

      Ako TIME_START pokazuje da transakcija traje:
      - > 5 minuta = problem
   ================================================ */


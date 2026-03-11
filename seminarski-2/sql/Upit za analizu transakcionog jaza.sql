/* ================================================
   Pregled transakcionih markera – zdravlje baze
   ================================================ */
+
SELECT 
    MON$NEXT_TRANSACTION AS NEXT_ID,  -- Sledeći ID koji će biti dodeljen transakciji
    MON$OLDEST_TRANSACTION AS OIT,    -- Najstarija interesantna transakcija (donja granica čišćenja)
    MON$OLDEST_ACTIVE AS OAT,         -- Najstarija AKTIVNA transakcija – BLOKIRA garbage collection!
    MON$OLDEST_SNAPSHOT AS OST,       -- Najstarija snapshot transakcija (drži stare verzije)
    (MON$NEXT_TRANSACTION - MON$OLDEST_ACTIVE) AS TRANSACTION_GAP  -- Broj verzija koje GC ne može da očisti
FROM MON$DATABASE;

/* ================================================
   TUMAČENJE:

   OAT (Oldest Active Transaction):
      - Najkritičniji marker
      - Sve transakcije STARIJE od OAT-a mogu da se čiste
      - Sve novije od OAT-a moraju da se čuvaju
   
   TRANSACTION_GAP:
      - < 1000  → zdrava baza
      - 1000-10000 → umeren rizik
      - > 10000 → predstavlja ozbiljan problem jer će baza biti sve sporija
   
   OIT (Oldest Interesting Transaction):
      - Najstarija transakcija čije verzije još uvek postoje
      
   OST (Oldest Snapshot):
      - Ako je mnogo manji od NEXT_ID, neka snapshot transakcija 
        "drži" stare verzije i sprečava čišćenje

   PRIMER ZDRAVE BAZE:
   NEXT_ID = 15000, OAT = 14950, OIT = 14948, GAP = 50
   
   PRIMER PROBLEMATIČNE BAZE:
   NEXT_ID = 50000, OAT = 10000, OIT = 9995, GAP = 40000
   – transakcija ID 10000 je otvorena pre 40000 ciklusa!
   ================================================ */

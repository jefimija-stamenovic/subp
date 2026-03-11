/* ================================================
   DESCENDING INDEKS – optimizacija za ORDER BY DESC
   ================================================ */

/* 1. Kreiranje indeksa u opadajućem redosledu */
CREATE DESCENDING INDEX IDX_SALES_ORDER_DESC ON SALES (ORDER_DATE);
COMMIT;

/* 2. Upit koji traži poslednjih 10 porudžbina */
SET PLAN ON;

SELECT FIRST 10 PO_NUMBER, ORDER_DATE, TOTAL_VALUE
FROM SALES
ORDER BY ORDER_DATE DESC;

SET PLAN OFF;

/*
    PLAN (SALES ORDER IDX_SALES_ORDER_DESC)
    Select Expression
    -> First N Records
        -> Table "SALES" Access By ID
            -> Index "IDX_SALES_ORDER_DESC" Full Scan

   Objašnjenje:
   - ORDER u planu znači da indeks služi za sortiranje
   - Baza čita indeks od POSLEDNJEG ka PRVOM listu
   - Bez dodatnog sortiranja u memoriji
   - FIRST 10 prekida čitanje čim nađe 10 redova
   
   Bez DESC indeksa:
   - Morao bi da skenira celu tabelu i sortira u memoriji
   - Sporije i više memorije
   ================================================ */

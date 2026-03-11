/* ================================================
   NULL vrednosti u indeksu (Firebird)
   ================================================ */

/* 1. Provera NULL vrednosti u SHIP_DATE */
SELECT 
    COUNT(*) AS UKUPNO,
    COUNT(SHIP_DATE) AS SA_DATUMOM,
    COUNT(*) - COUNT(SHIP_DATE) AS NULL_VREDNOSTI
FROM SALES;

/* 2. Upit sa IS NULL - koristi indeks! */
SET PLAN ON;

SELECT PO_NUMBER, ORDER_DATE, SHIP_DATE
FROM SALES
WHERE SHIP_DATE IS NULL;

SET PLAN OFF;

/*
   PLAN (SALES INDEX (IDX_SALES_SHIP_DATE))
   ЕXPLAIN PLAN:
   Select Expression
    -> Filter
        -> Table "SALES" Access By ID
            -> Bitmap
                -> Index "IDX_SALES_SHIP_DATE" Range Scan (full match)
   Zašto?
   - Firebird indeksira NULL kao NAJMANJU moguću vrednost
   - Sve NULL vrednosti su na POČETKU B+ stabla
   - IS NULL = direktna navigacija do prvog lista
   - Nema Full Table Scan-a!
*/

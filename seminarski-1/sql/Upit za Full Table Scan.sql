/* ================================================
   FULL TABLE SCAN (NATURAL) – kada nema indeksa
   ================================================ */

SET PLAN ON;

SELECT * FROM EMPLOYEE 
WHERE PHONE_EXT = '222';

SET PLAN OFF;

/*
   PLAN (EMPLOYEE NATURAL)
   Select Expression
    -> Filter
        -> Table "EMPLOYEE" Full Scan
   ================================================
   Objašnjenje:
   Pošto ne postoji indeks na koloni PHONE_EXT,
   Firebird nema izbora nego da:
   
   1. Učita SVE stranice tabele EMPLOYEE sa diska
   2. Proveri SVAKI red da vidi da li je PHONE_EXT = '222'
   3. Vrati redove koji zadovoljavaju uslov
   
   Ovo je FULL TABLE SCAN (NATURAL) – najsporija strategija.
   
   ================================================
   Posledice:
   - Vreme raste LINEARNOR sa veličinom tabele
   - Na 1 milion redova = 1 milion provera
   - Zauzima I/O i CPU resurse
   
   Rešenje: Kreirati indeks na PHONE_EXT ako se često traži.
   ================================================ */

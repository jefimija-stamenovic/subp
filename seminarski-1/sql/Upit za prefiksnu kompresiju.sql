/* ================================================
   Demonstracija indeksne pretrage sa STARTING WITH
   i uloga prefiksne kompresije
   ================================================ */

/* Prvo uključujemo prikaz plana izvršavanja */
SET PLAN ON;

/*  Upit: Tražimo sve zaposlene čije prezime počinje slovom 'S'
    ORDER BY LAST_NAME osigurava sortiran rezultat */
SELECT  EMP_NO, LAST_NAME, FIRST_NAME
FROM EMPLOYEE
WHERE LAST_NAME STARTING WITH 'S'
ORDER BY LAST_NAME;

/* ================================================
   OČEKIVANI PLAN IZVRŠAVANJA: PLAN (EMPLOYEE ORDER IDX_EMP_LASTNAME)
   EXPLAIN PLAN kao što je i očekivano
        Select Expression
            -> Filter
                -> Table "EMPLOYEE" Access By ID
                    -> Index "IDX_EMP_LASTNAME" Range Scan (full match)
   Objašnjenje:
   - INDEX (IDX_EMP_LASTNAME) → koristi se indeks na last_name
   - Range Scan → pretražuje se opseg vrednosti ('S' do 'T')
   - ORDER BY ne zahteva dodatno sortiranje jer indeks već vraća sortirane vrednosti


   ================================================ */


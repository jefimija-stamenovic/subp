/* ================================================
   Primer 2: Demonstracija anomalije "Neponovljivo čitanje"
   ================================================

   Sesija A (prvi prozor) – pokreće READ COMMITTED transakciju
   ------------------------------------------------- */
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
/* Prvo čitanje – vidimo trenutnu vrednost */
SELECT SALARY 
FROM EMPLOYEE 
WHERE EMP_NO = 2;
/* -------------------------------------------------
   Sesija B (drugi prozor) – menja podatak i potvrđuje
   ------------------------------------------------- */
UPDATE EMPLOYEE 
SET SALARY = 120000 
WHERE EMP_NO = 2;

COMMIT;  -- Potvrđujemo izmenu

/* -------------------------------------------------
   Sesija A (prvi prozor) – ponovo čita ISTI red
   ------------------------------------------------- */
SELECT SALARY 
FROM EMPLOYEE 
WHERE EMP_NO = 2;

/* ================================================
   REZULTAT:
   Prvi SELECT: 105900.00  (stara vrednost)
   Drugi SELECT: 120000.00  (nova vrednost)
   
   Iako je Sesija A i dalje u ISTOJ transakciji,
   vrednost se promenila tj. došlo je do
   anomalije NEPONOVLJIVO ČITANJE.
   ================================================ */

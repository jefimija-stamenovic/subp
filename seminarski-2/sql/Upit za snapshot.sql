/* ================================================
   Primer 3: Snapshot izolacija i sprečavanje "fantomskog čitanja"

   Sesija A (prvi prozor) – pokreće SNAPSHOT transakciju
   ------------------------------------------------- */
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

/* Prvo brojanje – pamtimo trenutni broj redova */
SELECT COUNT(*) AS UKUPNO_ZAPOSLENIH 
FROM EMPLOYEE;

/* NE RADIMO COMMIT - Transakcija ostaje otvorena

   Sesija B (drugi prozor) – ubacuje NOVOG zaposlenog
   ------------------------------------------------- */
INSERT INTO EMPLOYEE (EMP_NO, FIRST_NAME, LAST_NAME, PHONE_EXT,
                      HIRE_DATE, DEPT_NO, JOB_CODE, JOB_GRADE,
                      JOB_COUNTRY, SALARY)
VALUES (999, 'Phantom', 'Read', '233','28-DEC-1988', '621', 'Eng', 2, 'USA', 97500);
COMMIT;  -- Potvrđujemo unos novog zaposlenog

/* -------------------------------------------------
   Sesija A (prvi prozor) – ponovo brojimo redove
   ------------------------------------------------- */
SELECT COUNT(*) AS UKUPNO_ZAPOSLENIH 
FROM EMPLOYEE;

/* ================================================
   REZULTAT:
   
   Prvi COUNT: 104 zaposlena
   Drugi COUNT: i dalje 104 zaposlena
   Iako je Sesija B ubacila NOVOG zaposlenog (EMP_NO = 999)
   i potvrdila ga COMMIT-om, Sesija A ga NE VIDI.
   
   Ovo je dokaz da SNAPSHOT izolacija:
   - "Zamrzava" stanje baze na trenutak pokretanja transakcije
   - Potpuno sprečava anomaliju FANTOMSKO ČITANJE
   ================================================ */

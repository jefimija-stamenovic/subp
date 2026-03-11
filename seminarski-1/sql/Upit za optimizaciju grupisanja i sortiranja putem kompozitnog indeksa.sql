/* ================================================
   Agregacija sa GROUP BY i indeksnom navigacijom
   ================================================ */

SELECT 
    e.JOB_CODE AS SIFRA_POSLA,
    e.JOB_COUNTRY AS DRZAVA,
    COUNT(e.EMP_NO) AS BROJ_RADNIKA,
    CAST(AVG(e.SALARY) AS DECIMAL(18,2)) AS PROSECNA_PLATA,
    SUM(e.SALARY) AS UKUPNI_TROSAK_PLATA
FROM EMPLOYEE e
WHERE e.JOB_COUNTRY IN ('USA', 'England', 'Canada')
GROUP BY e.JOB_CODE, e.JOB_COUNTRY
ORDER BY e.JOB_CODE ASC, e.JOB_COUNTRY ASC;
/*
   PLAN: (E ORDER IDX_EMP_JOB_COUNTRY)
   Select Expression
       -> Aggregate
           -> Filter
               -> Table "EMPLOYEE" as "E" Access By ID
                   -> Index "IDX_EMP_JOB_COUNTRY" Full Scan

   ================================================
   Tumačenje:
   1. "ORDER IDX_EMP_JOB_COUNTRY" 
      - Ključna oznaka koja nam pokazuje da se indeks koristi za sortiranje
      - Firebird čita indeks redom (JOB_CODE, JOB_COUNTRY */


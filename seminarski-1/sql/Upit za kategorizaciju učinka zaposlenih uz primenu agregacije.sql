SELECT
    e.FULL_NAME AS ZAPOSLENI,
    j.JOB_TITLE AS POZICIJA,
    d.DEPARTMENT AS ODELJENJE,
    e.SALARY AS OSNOVNA_PLATA,
    SUM(COALESCE(s.TOTAL_VALUE, 0)) AS LICNA_PRODAJA,
    CAST(SUM(COALESCE(s.TOTAL_VALUE, 0)) * 0.05 AS DECIMAL(18,2)) AS PROVIZIJA,
    (SELECT COUNT(*) FROM EMPLOYEE_PROJECT ep WHERE ep.EMP_NO = e.EMP_NO) AS BROJ_PROJEKATA,
    CASE 
        WHEN e.SALARY > 60000 THEN 'Senior Management'
        WHEN e.SALARY BETWEEN 35000 AND 60000 THEN 'Professional Staff'
        ELSE 'Junior/Support'
    END AS KATEGORIJA_OSOBLJA
FROM EMPLOYEE e
JOIN JOB j ON e.JOB_CODE = j.JOB_CODE AND e.JOB_GRADE = j.JOB_GRADE AND e.JOB_COUNTRY = j.JOB_COUNTRY
JOIN DEPARTMENT d ON e.DEPT_NO = d.DEPT_NO
LEFT JOIN SALES s ON e.EMP_NO = s.SALES_REP
GROUP BY e.FULL_NAME, j.JOB_TITLE, d.DEPARTMENT, e.SALARY, e.EMP_NO, e.JOB_CODE, e.JOB_GRADE, e.JOB_COUNTRY,
         CASE WHEN e.SALARY > 60000 THEN 'Senior Management' WHEN e.SALARY BETWEEN 35000 AND 60000 THEN 'Professional Staff' ELSE 'Junior/Support' END
HAVING (SELECT COUNT(*) FROM EMPLOYEE_PROJECT ep2 WHERE ep2.EMP_NO = e.EMP_NO) >= 1
ORDER BY LICNA_PRODAJA DESC NULLS LAST, OSNOVNA_PLATA DESC;

/*
   ================================================
   EXPLAIN PLAN:
   Sub-query
    -> Singularity Check
        -> Aggregate
            -> Filter
                -> Table "EMPLOYEE_PROJECT" as "EP2" Access By ID
                    -> Bitmap
                        -> Index "RDB$FOREIGN15" Range Scan (full match)
    Sub-query
        -> Singularity Check
            -> Aggregate
                -> Filter
                    -> Table "EMPLOYEE_PROJECT" as "EP" Access By ID
                        -> Bitmap
                            -> Index "RDB$FOREIGN15" Range Scan (full match)
    Select Expression
        -> Sort (record length: 148, key length: 24)
            -> Filter
                -> Aggregate
                    -> Sort (record length: 422, key length: 248)
                        -> Nested Loop Join (outer)
                            -> Filter
                                -> Hash Join (inner)
                                    -> Nested Loop Join (inner)
                                        -> Table "DEPARTMENT" as "D" Full Scan
                                        -> Filter
                                            -> Table "EMPLOYEE" as "E" Access By ID
                                                -> Bitmap
                                                    -> Index "RDB$FOREIGN8" Range Scan (full match)

   ================================================
   Ključni zaključci:
   - Indeksi se koriste za spajanje (JOIN) i podupite
   - Full Scanovi na malim tabelama (DEPARTMENT, JOB) su brži od indeksa
   - LEFT JOIN sa SALES koristi indeks na SALES_REP
   - Dva nivoa sortiranja: za GROUP BY i ORDER BY
   ================================================ */

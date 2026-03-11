/* ================================================
   Demonstracija LOŠE selektivnosti indeksa
   ================================================ */

/* 1. Provera distribucije vrednosti u JOB_CODE */
SELECT 
    JOB_CODE,
    COUNT(*) AS BROJ_ZAPOSLENIH  -- 62 zaposlenih
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY BROJ_ZAPOSLENIH DESC;

/* Rezultat: JOB_CODE ima malo unikatnih vrednosti,
    puno duplikata → loša selektivnost */

/* 2. Kreiramo indeks na koloni sa duplikatima */
CREATE INDEX IDX_EMP_JOBCODE ON EMPLOYEE(JOB_CODE);

/* 3. Osvežimo statistiku */
SET STATISTICS INDEX IDX_EMP_JOBCODE;

/* 4. Proverimo selektivnost indeksa */
SELECT 
    RDB$INDEX_NAME AS INDEX_NAME,
    RDB$STATISTICS AS SELECTIVITY,
    CASE 
        WHEN RDB$STATISTICS < 0.1 THEN 'Dobra'
        ELSE 'Loša (mnogo duplikata)'
    END AS SELECTIVITY_DESC
FROM RDB$INDICES
WHERE RDB$INDEX_NAME = 'IDX_EMP_JOBCODE';

/* ================================================
   Zašto je ovo LOŠ indeks za filtriranje?
   ================================================ */

SET PLAN ON;

SELECT EMP_NO, LAST_NAME, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'Eng';

/* ================================================
   Plan izvršavanja za upit sa JOB_CODE filtriranjem
   Select Expression
       -> Filter
           -> Table "EMPLOYEE" Access By ID
               -> Bitmap
                   -> Index "IDX_EMP_JOBCODE" Range Scan (full match)
   ================================================
   TUMAČENJE PLANA:
   Indeks pronalazi sve zaposlene sa traženim JOB_CODE
   "full match" = korišćen ceo ključ za pretragu
   Indeks je iskorišćen jer ima relativno malo zaposlenih.
   Čak i sa lošom selektivnošću (JOB_CODE ima duplikate),
   indeks je brži od čitanja cele tabele jer je tabela mala.
   
   Na velikoj tabeli (1M redova) optimizator bi verovatno
   izabrao NATURAL scan. */

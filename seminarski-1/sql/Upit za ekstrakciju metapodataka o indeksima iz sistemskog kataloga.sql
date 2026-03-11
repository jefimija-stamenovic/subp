/* ================================================
   Pregled svih korisničkih indeksa u bazi
   ================================================ */
SELECT
    RDB$INDEX_NAME AS INDEX_NAME,           /* Ime indeksa */
    RDB$RELATION_NAME AS TABLE_NAME,         /* Ime tabele kojoj indeks pripada */
    RDB$INDEX_ID AS INDEX_ID,                /* Interni ID indeksa */
    RDB$STATISTICS AS SELECTIVITY,           /* Selektivnost (0=idealna, 1=loša) */
    /* Čitljiviji prikaz selektivnosti */
    CASE 
        WHEN RDB$STATISTICS = 0 THEN 'Idealan (primarni ključ)'
        WHEN RDB$STATISTICS < 0.01 THEN 'Odličan'
        WHEN RDB$STATISTICS < 0.1 THEN 'Dobar'
        WHEN RDB$STATISTICS < 0.5 THEN 'Prosečan'
        ELSE 'Loš (mnogo duplikata)'
    END AS SELECTIVITY_DESC,
    RDB$UNIQUE_FLAG AS IS_UNIQUE,            /* Da li je indeks unikatan (1=da, 0=ne) */
    RDB$INDEX_INACTIVE AS IS_INACTIVE,       /* Da li je indeks neaktivan (1=da, 0=ne) */
    RDB$SEGMENT_COUNT AS SEGMENT_COUNT       /* Broj kolona u indeksu */
FROM RDB$INDICES
WHERE RDB$SYSTEM_FLAG = 0                     /* Samo korisnički indeksi */
ORDER BY
    RDB$RELATION_NAME,                        /* Sortiramo po tabeli */
    RDB$INDEX_NAME;                            /* Pa po imenu indeksa */

/* ================================================
   Detaljniji pregled – sa kolonama koje čine indeks
   ================================================ */

SELECT 
    I.RDB$INDEX_NAME AS INDEX_NAME,
    I.RDB$RELATION_NAME AS TABLE_NAME,
    I.RDB$STATISTICS AS SELECTIVITY,
    I.RDB$UNIQUE_FLAG AS IS_UNIQUE,
    LIST(S.RDB$FIELD_NAME, ', ') AS INDEXED_COLUMNS,  /* Spisak kolona u indeksu */
    I.RDB$SEGMENT_COUNT AS COLUMN_COUNT
FROM RDB$INDICES I
LEFT JOIN RDB$INDEX_SEGMENTS S ON I.RDB$INDEX_NAME = S.RDB$INDEX_NAME
WHERE I.RDB$SYSTEM_FLAG = 0
GROUP BY 
    I.RDB$INDEX_NAME, 
    I.RDB$RELATION_NAME, 
    I.RDB$STATISTICS, 
    I.RDB$UNIQUE_FLAG,
    I.RDB$SEGMENT_COUNT
ORDER BY I.RDB$RELATION_NAME, I.RDB$INDEX_NAME;

/* ================================================
   SET STATISTICS – ručno osvežavanje selektivnosti indeksa
   ================================================ */

/* 1. Prikaz trenutne (možda zastarele) selektivnosti */
SELECT RDB$INDEX_NAME, RDB$STATISTICS
FROM RDB$INDICES 
WHERE RDB$INDEX_NAME = 'IDX_SALES_SHIP_DATE';

/* 2. Ručno pokrećemo rekalkulaciju statistike */
SET STATISTICS INDEX IDX_SALES_SHIP_DATE;

/* 3. Ponovo proveravamo – sada ažurirana vrednost */
SELECT RDB$INDEX_NAME, RDB$STATISTICS 
FROM RDB$INDICES 
WHERE RDB$INDEX_NAME = 'IDX_SALES_SHIP_DATE';

/* ================================================
   Tumačenje:
   Firebird NE ažurira statistiku automatski pri svakoj izmeni.
   RDB$STATISTICS ostaje onakva kakva je bila kad je indeks kreiran
   ili kad je poslednji put rađen SET STATISTICS.
   
   Nakon puno INSERT/UPDATE/DELETE operacija, statistika postaje
   zastarela – optimizator može doneti loše odluke.
   
   SET STATISTICS prisiljava Firebird da ponovo izračuna:
   - Broj unikatnih vrednosti
   - Selektivnost = 1 / broj_unikatnih
   ================================================ */

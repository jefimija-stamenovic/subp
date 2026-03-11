/* ================================================
   INDEX SEEK – direktan pristup preko primarnog ključa
   ================================================ */

SELECT * FROM EMPLOYEE 
WHERE EMP_NO = 105;

/*
   PLAN (EMPLOYEE INDEX (RDB$PRIMARY7))
   Select Expression
    -> Filter
        -> Table "EMPLOYEE" Access By ID
            -> Bitmap
                -> Index "RDB$PRIMARY7" Unique Scan
   ================================================
   Objašnjenje:
   Umesto da čita celu tabelu, Firebird:
   1. Ulazi u indeks RDB$PRIMARY7 (B+ stablo)
   2. Pronalazi vrednost 105 u listovima indeksa
   3. Čita TAČNO JEDAN red sa data stranice

   Ovo je INDEX SEEK – najbrži mogući pristup podacima.
   Vreme izvršavanja NE ZAVISI od veličine tabele
   Bez indeksa: morao bi da pročita svih 42 reda.
   ================================================ */

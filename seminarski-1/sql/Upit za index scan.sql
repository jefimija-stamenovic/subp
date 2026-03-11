SELECT EMP_NO, LAST_NAME, FIRST_NAME
FROM EMPLOYEE
WHERE LAST_NAME STARTING WITH 'S'
ORDER BY LAST_NAME;

/*
   PLAN (EMPLOYEE ORDER IDX_EMP_LASTNAME)
   Select Expression
    -> Filter
        -> Table "EMPLOYEE" Access By ID
            -> Index "IDX_EMP_LASTNAME" Range Scan (full match)
   ================================================
   Objašnjenje:
   STARTING WITH se pretvara u opseg: 'S' ≤ LAST_NAME < 'T'
   
   Range Scan ovde znači:
   - Baza ulazi u indeks na prvom 'S' prezimenu
   - Čita redom kroz listove dok ne dođe do 'T'
   - Zahvaljujući prefiksnoj kompresiji, sva 'S' prezimena su fizički blizu
   
   ORDER BY ne zahteva dodatno sortiranje jer indeks već vraća sortirano.
   
   Bez indeksa: Full Table Scan + sortiranje u memoriji.
   ================================================ */

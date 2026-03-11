/* ================================================
   Primer 6: LOCK TIMEOUT mehanizam – čekanje sa vremenskim ograničenjem
   ================================================

   Sesija A (prvi prozor) – prva transakcija zaključava red
   ------------------------------------------------- */
UPDATE EMPLOYEE 
SET PHONE_EXT = '111' 
WHERE EMP_NO = 2;

/* NE RADIMO COMMIT! Sesija A drži zaključan red 5 sekundi
  Čekamo 5 sekundi da simulira sporu transakciju

   Sesija B (drugi prozor) – pokušava da menja ISTI red, ali sa timeout-om
   Podešavamo transakciju da čeka NAJVIŠE 3 sekunde */
SET TRANSACTION WAIT LOCK TIMEOUT 3;

UPDATE EMPLOYEE 
SET PHONE_EXT = '222' 
WHERE EMP_NO = 2;

/* ================================================
   REZULTAT:
   
   Sesija B će čekati 3 sekunde da se red oslobodi.
   Pošto Sesija A ne oslobađa red (traje 5 sekundi),
   posle 3 sekunde Sesija B dobija grešku: "lock time-out"
   – lock time-out on wait transaction
   UPDATE se ne izvršava!
   ================================================ */


/* -------------------------------------------------
   Varijanta 2: Isti primer, ali sa DOVOLJNO vremena
   Sesija A (prvi prozor) */
UPDATE EMPLOYEE 
SET PHONE_EXT = '111' 
WHERE EMP_NO = 2;
/* NE RADIMO COMMIT, ali ćemo uraditi u intervalu od 5 sekundi
   Sesija B (drugi prozor) – čeka 10 sekundi */
SET TRANSACTION WAIT LOCK TIMEOUT 10;

UPDATE EMPLOYEE 
SET PHONE_EXT = '222' 
WHERE EMP_NO = 2;

/* ================================================
   REZULTAT (ako Sesija A uradi COMMIT u roku):
   Sesija B čeka, Sesija A uradi COMMIT posle 2 sekunde,
   red se oslobađa, Sesija B nastavlja i USPEŠNO menja podatak.
   Konačna vrednost: '222'
   ================================================ */


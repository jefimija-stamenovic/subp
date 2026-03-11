/* ================================================
   Primer 5: DEADLOCK između dve transakcije

   Situacija:
   - Transakcija A zaključava red 2, pokušava da zaključa red 4
   - Transakcija B zaključava red 4, pokušava da zaključa red 2
   ------------------------------------------------- */
/* Prvo, Transakcija A ažurira red 2 */
UPDATE EMPLOYEE 
SET PHONE_EXT = '111' 
WHERE EMP_NO = 2;
/* -- NE RADIMO COMMIT -- */
/* Transakcija B ažurira red 4 */
UPDATE EMPLOYEE 
SET PHONE_EXT = '222' 
WHERE EMP_NO = 4;
/* -- NE RADIMO COMMIT -- */

/* Transakcija A pokušava da ažurira red 4 (ali red 4 je zaključan od strane B) */
UPDATE EMPLOYEE 
SET PHONE_EXT = '111' 
WHERE EMP_NO = 4;

/* Transakcija B pokušava da ažurira red 2 (ali red 2 je zaključan od strane A) */
UPDATE EMPLOYEE 
SET PHONE_EXT = '222' 
WHERE EMP_NO = 2;

/* ================================================
   REZULTAT:
   Firebird Lock Manager detektuje mrtvu petlju
   i prekida JEDNU od transakcija (obično onu koja je poslednja pokušala)
   
   Greška koju će jedna transakcija dobiti:
   "deadlock"
   – update conflicts with concurrent update
   ================================================ */

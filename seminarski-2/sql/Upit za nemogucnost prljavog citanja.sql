/* ================================================
   Primer 1: Dokaz o sprečavanju anomalije "Prljavo čitanje"

   Sesija A (prvi prozor) – pokreće izmenu bez potvrde
   ------------------------------------------------- */
UPDATE EMPLOYEE 
SET SALARY = 120000 
WHERE EMP_NO = 2;

/* -- NE RADIMO COMMIT! Transakcija ostaje otvorena --

   Sesija B (drugi prozor, paralelno) – pokušava čitanje
   ------------------------------------------------- */
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT SALARY 
FROM EMPLOYEE 
WHERE EMP_NO = 2;

/* ================================================
   REZULTAT:
   
   Iako je Sesija A izmenila platu na 120000, 
   Sesija B i dalje vidi STARU vrednost (npr. 105900).
   
   Ovo DOKAZUJE da Firebird NE DOZVOLJAVA prljavo čitanje
   – nijedna transakcija ne može videti nepotvrđene izmene!
   ================================================ */

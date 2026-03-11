/* Prikaz zaposlenih u odeljenju 622 sa njihovim fizičkim adresama */
SELECT 
    RDB$DB_KEY,           /* Fizička adresa: broj stranice + broj slota */
    EMP_NO,               /* Logički ključ (primarni ključ) */
    LAST_NAME             /* Prezime zaposlenog */
FROM EMPLOYEE
WHERE DEPT_NO = '622'     /* Filtriranje po odeljenju */
ORDER BY EMP_NO;

/* ================================================
   REZULTAT UPITA:
   
   DB_KEY     EMP_NO  LAST_NAME
   ---------- ------  ----------------
   131:1      2       Nelson
   131:5      9       Forest
   131:23     71      Burbank
   131:42     145     Guchenheimer
   
   TUMAČENJE RDB$DB_KEY:
   
   Forma: [BROJ_STRANICE] : [BROJ_SLOTA]
   
   131:1  → Stranica 131, Slot 1  → zaposleni Nelson (EMP_NO=2)
   131:5  → Stranica 131, Slot 5  → zaposleni Forest (EMP_NO=9)
   131:23 → Stranica 131, Slot 23 → zaposleni Burbank (EMP_NO=71)
   131:42 → Stranica 131, Slot 42 → zaposleni Guchenheimer (EMP_NO=145)
   
   VAŽNO: Svi zaposleni su na ISTOJ stranici (131), ali na RAZLIČITIM slotovima!
   ================================================ */

/* Prvo proverimo početno stanje i RDB$DB_KEY */
SELECT EMP_NO, PHONE_EXT, RDB$DB_KEY
FROM EMPLOYEE
WHERE EMP_NO = 2;
/*EMP_NO    PHONE_EXT    DB_KEY
    2        V3         131:1*/

/* ===== Generisanje lanca verzija ===== */
/* Prva izmena - kreiramo verziju V1 */
UPDATE EMPLOYEE SET PHONE_EXT = 'V1' WHERE EMP_NO = 2;
COMMIT;

/* Druga izmena - kreiramo verziju V2 */
UPDATE EMPLOYEE SET PHONE_EXT = 'V2' WHERE EMP_NO = 2;
COMMIT;

/* Treća izmena - kreiramo verziju V3 */
UPDATE EMPLOYEE SET PHONE_EXT = 'V4' WHERE EMP_NO = 2;
COMMIT;

/* ===== Provera ===== */
/* Gledamo samo najnoviju verziju (V4) */
SELECT EMP_NO, PHONE_EXT, RDB$DB_KEY
FROM EMPLOYEE
WHERE EMP_NO = 2;

/* VAŽNO: RDB$DB_KEY je ostao ISTI kao pre svih izmena!
   To dokazuje da se fizička lokacija (adresa) nije promenila,
   iako smo tri puta menjali podatak.
   
   Ono što se desilo "iza scene":
   - Verzija V1 (stara) i dalje postoji na disku
   - Verzija V2 (starija) i dalje postoji na disku
   - Verzija V3 (trenutna) je nova
   Sve tri su na ISTOJ adresi (RDB$DB_KEY), povezane u lanac
*/

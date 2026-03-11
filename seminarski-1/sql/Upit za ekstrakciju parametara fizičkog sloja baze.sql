SELECT
    MON$DATABASE_NAME AS DB_PATH,                    /* Putanja do .fdb fajla */
    MON$ODS_MAJOR || '.' || MON$ODS_MINOR AS ODS_VERSION,  /* Verzija On-Disk Structure */
    MON$PAGE_SIZE AS PAGE_SIZE,                       /* Veličina stranice u bajtovima */
    MON$PAGES AS TOTAL_PAGES                         /* Ukupan broj stranica u bazi */
FROM MON$DATABASE;

/* ================================================
   REZULTAT UPITA:
   
   DB_PATH                                              ODS_VERSION  PAGE_SIZE  TOTAL_PAGES
   ---------------------------------------------------- ------------ ---------- ------------
   C:\Program Files\Firebird\Firebird_5.0\examples\     13.1         8,192      2,434
   empbuild\employee.fdb
   ================================================ */

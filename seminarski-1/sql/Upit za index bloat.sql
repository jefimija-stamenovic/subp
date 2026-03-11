/* Prikaz inicijalnog stanja indeksa PRE bloat-a
    Index IDX_EMP_LASTNAME (6)
        Root page: 333, depth: 1, leaf buckets: 1, nodes: 106
        Average node length: 9.53, total dup: 5, max dup: 1
        Average key length: 8.31, compression ratio: 0.83
        Average prefix length: 1.35, average data length: 5.58
        Clustering factor: 45, ratio: 0.42 */

/* Pravimo bloat – 5000 izmena nad LAST_NAME */
EXECUTE BLOCK
AS
DECLARE i INT = 1;
DECLARE emp_no INT;
DECLARE orig_last VARCHAR(20);
BEGIN
  WHILE (i <= 5000) DO
  BEGIN
    FOR 
      SELECT EMP_NO, LAST_NAME FROM EMPLOYEE WHERE DEPT_NO = '621'
      INTO :emp_no, :orig_last
    DO
    BEGIN
      /* Prvo dodajemo tačku na prezime – menja se indeks */
      UPDATE EMPLOYEE SET LAST_NAME = LAST_NAME || '.' WHERE EMP_NO = :emp_no;
      
      /* Vraćamo originalno prezime – ponovo se menja indeks */
      UPDATE EMPLOYEE SET LAST_NAME = :orig_last WHERE EMP_NO = :emp_no;
    END
    i = i + 1;
  END
END
COMMIT;

/* Prikaz stanja indeksa POSLE bloat-a */
/*
    Index IDX_EMP_LASTNAME (6)
        Root page: 344, depth: 2, leaf buckets: 22, nodes: 30106
        Average node length: 3.03, total dup: 30005, max dup: 10001
        Average key length: 2.03, compression ratio: 2.80
        Average prefix length: 5.65, average data length: 0.02
        Clustering factor: 45, ratio: 0.00
*/

/* ================================================
   DESCENDING indeks za filter po datumu
   ================================================ */

/* 1. Kreiranje DESC indeksa */
CREATE DESCENDING INDEX IDX_SALES_ORDER_DESC ON SALES (ORDER_DATE);

SELECT * FROM SALES
WHERE ORDER_DATE BETWEEN '1993-01-01' AND '1993-12-31';
/*
   EXPLAIN PLAN:
   Select Expression
       -> Filter
           -> Table "SALES" Access By ID
               -> Bitmap
                   -> Index "IDX_SALES_ORDER_DESC" Range Scan 
                      (lower bound: 1/1, upper bound: 1/1)

   ================================================
   TUMAČENJE:
   1. Index Range Scan (lower/upper bound: 1/1)
      - DESC indeks pretražuje opseg datuma
      - 1/1 = precizno definisane granice (jan-dec 1993)
   
   2. Bitmap → Access By ID
      - Samo pronađeni redovi se čitaju sa diska
      - Nema Full Table Scan-a

   - I DESC i ASC će raditi za opseg (BETWEEN)
   - DESC je korisniji ako često tražimo najnovije
   - Jedan indeks pokriva i filter i sortiranje
   ================================================ */

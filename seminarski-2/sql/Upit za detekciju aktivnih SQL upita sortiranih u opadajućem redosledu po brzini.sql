/* ================================================
   DETEKCIJA AKTIVNIH SQL UPITA
   ================================================ */

SELECT 
    A.MON$USER AS KORISNIK,                           -- Ko izvršava upit
    ST.MON$SQL_TEXT AS SQL_UPIT,                       -- Tekst SQL upita koji se izvršava
    ST.MON$TIMESTAMP AS POCETAK,                       -- Vreme početka izvršavanja
    (CURRENT_TIMESTAMP - ST.MON$TIMESTAMP) AS TRAJANJE_SEKUNDI, -- Koliko dugo traje
    T.MON$ISOLATION_MODE AS IZOLACIJA_ID,              -- Nivo izolacije (sirovi broj)
    T.MON$TRANSACTION_ID AS TID                         -- ID transakcije kojoj upit pripada
FROM MON$STATEMENTS ST
JOIN MON$TRANSACTIONS T ON ST.MON$TRANSACTION_ID = T.MON$TRANSACTION_ID
JOIN MON$ATTACHMENTS A ON T.MON$ATTACHMENT_ID = A.MON$ATTACHMENT_ID
WHERE ST.MON$STATE = 1                                   -- 1 = aktivan upit
ORDER BY TRAJANJE_SEKUNDI DESC;                          -- Najsporiji prvi

/* ================================================
   TUMAČENJE:
   - Prikazuje SQL upite koji se UPRAVO izvršavaju
   - TRAJANJE_SEKUNDI pokazuje potencijalno spore upite
   ================================================ */

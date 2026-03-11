
/* ================================================
   Proširena verzija – SQL koji ta transakcija izvršava
   ================================================  */
SELECT 
    A.MON$USER,
    ST.MON$SQL_TEXT,
    ST.MON$TIMESTAMP
FROM MON$STATEMENTS ST
JOIN MON$TRANSACTIONS T ON ST.MON$TRANSACTION_ID = T.MON$TRANSACTION_ID
JOIN MON$ATTACHMENTS A ON T.MON$ATTACHMENT_ID = A.MON$ATTACHMENT_ID
WHERE T.MON$TRANSACTION_ID = (SELECT MON$OLDEST_ACTIVE FROM MON$DATABASE) AND ST.MON$STATE = 1;


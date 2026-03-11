CREATE OR ALTER TRIGGER TR_SALARY_LOG_REPL FOR SALARY_HISTORY
AFTER INSERT OR UPDATE
AS
BEGIN
    /* Provera: Ako sesiju vodi replikacioni agent, prekidamo izvršavanje */
    IF (RDB$GET_CONTEXT('USER_SESSION', 'REPLICATING') IS NOT NULL) THEN
        EXIT;

    /* Logika se izvršava isključivo za LOKALNE promene (aplikativni unos) */
    INSERT INTO AUDIT_LOG (EMP_NO, OPERACIJA, STARA_PLATA, NOVA_PLATA)
    VALUES (NEW.EMP_NO, 'UPDATE', NEW.OLD_SALARY, NEW.NEW_SALARY);
END;

--BEGIN TRAN

USE CORPORERM
--******** REATIVAR
UPDATE SCONTRATO SET DTCANCELAMENTO = NULL , STATUS = 'N'

WHERE CODCONTRATO = 210432

-- COMMIT

--******** CANCELAR 

 --UPDATE SCONTRATO SET DTCANCELAMENTO = GETDATE() , STATUS = 'S'

 --WHERE CODCONTRATO = 186414

-- COMMIT


--******** CONFERENCIA
-- SELECT * FROM SCONTRATO WHERE CODCONTRATO = 186754
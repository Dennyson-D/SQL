
BEGIN TRANSACTION
 
SET XACT_ABORT ON
 
BEGIN TRY
 

DELETE FROM SPARCELA  WHERE IDPERLET=270 AND CODSERVICO=89;
 
SELECT 'TRANSA��O EFETUADA COM SUCESSO!' AS [MESSAGE]
COMMIT
 
END TRY
BEGIN CATCH
 IF XACT_STATE() <> 0
 BEGIN TRY
 ROLLBACK
 SELECT
 'ROLLBACK' AS [MESSAGE]
 ,ERROR_NUMBER() AS ERRORNUMBER
 ,ERROR_SEVERITY() AS ERRORSEVERITY
 ,ERROR_STATE() AS ERRORSTATE
 ,ERROR_PROCEDURE() AS ERRORPROCEDURE
 ,ERROR_LINE() AS ERRORLINE
 ,ERROR_MESSAGE() AS ERRORMESSAGE;
 END TRY
 BEGIN CATCH
 SELECT ERROR_LINE() AS ErrorLine; 
 END CATCH
 
END CATCH

--SELECT * FROM SPARCELA WHERE IDPERLET=270 AND CODSERVICO=89

--SELECT * FROM SRESPONSAVEL WHERE IDPARCELA = 1789707
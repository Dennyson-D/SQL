BEGIN TRY 
 SELECT 1/0
END TRY
 BEGIN CATCH

 SELECT ERROR_NUMBER() AS ERRO_N
  ,ERROR_MESSAGE() AS MSG_ERRO
  ,ERROR_LINE() AS LINHA
  ,ERROR_STATE() AS STATE
  ,ERROR_PROCEDURE() AS PROCE
  ,ERROR_SEVERITY() AS SERV

 END CATCH

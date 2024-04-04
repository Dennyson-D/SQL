USE [TOTVSSPED]

DECLARE @COL_IDMOV AS VARCHAR(100)

SET @COL_IDMOV = 1000000000 - CONVERT(INT,'1'+'489963') -- COLIGADA + IDMOV


--UPDATE SPED051 SET ID_ENT = '000007' WHERE NFSE_ID = @COL_IDMOV

SELECT * FROM SPED051 WHERE NFSE_ID = @COL_IDMOV


--SELECT * FROM SPED051 WHERE RPS = 235146


--SELECT * FROM SPED055 WHERE NFSE_ID = 998519412      


                                                                                                                                                                                                                         
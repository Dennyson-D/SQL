/*
Para descobrir 'XXX', realize o cálculo abaixo:
1000000000 -  ("CODCOLIGADA" seguido do "IDMOV")
Exemplo:
Código da coligada = 1
Identificador do movimento = 123456
1000000000 - 1123456 = 998876544
----------------------------------------------
1000000000 - 1&IDMOV = XXX
----------------------------------------------
*/

USE TOTVSSPED

DECLARE @COL_IDMOV AS VARCHAR(100)

SET @COL_IDMOV = 1000000000 - CONVERT(INT,'1'+'493624')

--UPDATE SPED051 SET ID_ENT = '000009' WHERE NFSE_ID = @COL_IDMOV

SELECT * FROM SPED051 WHERE NFSE_ID = @COL_IDMOV





SELECT * FROM SPED001 WHERE ID_ENT = '000007'


SELECT * FROM SPED050

-- select STATUS,* from TSSTR1

--select * from SPED055 where NFSE_ID = @COL_IDMOV

--select LOGID, STATUS, STATUSCANC,* from SPED051 where NFSE_ID = @COL_IDMOV

--select DETALHES, * from TSS0004 where LOGID = '6a87e9aabc664000932485d57ace6b5f'



--********************************************************************************************************************************************************************************************
--********************************************************************************************************************************************************************************************
--********************************************************************************************************************************************************************************************



--SELECT STATUS, STATUSCANC, LOGID, * FROM SPED051 WHERE NFSE_ID = @COL_IDMOV
--SELECT LOTE, * FROM SPED055 WHERE NFSE_ID = @COL_IDMOV
--SELECT * FROM SPED053 WHERE LOTE = '000000000197926'
--SELECT * FROM TSSTR1 -- WHERE LOGID = @LOGID
--SELECT * FROM TSS0004 WHERE LOGID = 'SPED051-000000220629-20200415-12:00:33'  OR LOGID = '6a87e9aabc664000932485d57ace6b5f'
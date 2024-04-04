--SELECT * FROM CPERIODOINCLUSAO WHERE CODUSUARIO = '008903'

--USE [CORPORERM]

BEGIN TRAN

INSERT INTO CPERIODOINCLUSAO (CODCOLIGADA,CODUSUARIO,DATAINICIAL,DATAFINAL,BARRAALTDATA) 

SELECT DISTINCT 1,MAT.CODUSUARIO,'2020-01-01' AS DATAINICIAL, '2025-12-31',0
-- MAT.CODFILIAL,MAT.CURSO,MAT.CODTURMA,MAT.RA,MAT.ALUNO,MAT.CODPERLET
--,MAT.CODUSUARIO,SU.ACESSO, GU.CODPERFIL,GU.CODSISTEMA,MAT.STATUS,SU.CODFILIAL AS FIL
--,CONVERT(VARCHAR,CPI.DATAINICIAL,103) AS DTINI
--,CONVERT(VARCHAR,CPI.DATAFINAL,103) AS DTFIM

 FROM MAT 

LEFT JOIN GUSUARIO ON GUSUARIO.CODUSUARIO = MAT.CODUSUARIO AND GUSUARIO.STATUS = 0
LEFT JOIN SUSUARIOFILIAL SU ON SU.CODUSUARIO = MAT.CODUSUARIO 
LEFT JOIN GUSRPERFIL GU ON GU.CODUSUARIO = MAT.CODUSUARIO AND GU.CODSISTEMA = 'S' 
LEFT JOIN CPERIODOINCLUSAO AS CPI ON CPI.CODUSUARIO = MAT.CODUSUARIO

WHERE  MAT.CODFILIAL = 6 and CODPERLET = '2021' and MAT.STATUS like '%mat%' AND MAT.CODUSUARIO IS NOT NULL


--ROLLBACK
--  COMMIT
--ORDER BY ALUNO
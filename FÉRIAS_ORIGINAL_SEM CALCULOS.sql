SET DATEFORMAT DMY
SELECT PFUNC.CHAPA
,CONVERT(VARCHAR,PFUNC.DTVENCFERIAS,103) AS DTVENCFERIAS
, PFHSTFER.DTINIPERAQUIS
, PFHSTFER.DTFIMPERAQUIS
,MAX(PFUFERIASPER.DATAINICIO) INICIOFERIAS
,MAX(PFUFERIASPER.DATAFIM) FIMFERIAS
,pfunc.codfilial
--,((DATEDIFF(DD,PFHSTFER.DTINIPERAQUIS,GETDATE())*30)/365) AS DIAS_HAVER
,((DATEDIFF(MM,PFHSTFER.DTINIPERAQUIS,GETDATE())*30)/12) AS DIAS_HAVER
FROM PFUNC
LEFT JOIN PFHSTFER
  ON PFHSTFER.CHAPA = PFUNC.CHAPA
 AND PFHSTFER.CODCOLIGADA = PFUNC.CODCOLIGADA
 AND PFHSTFER.DTINIPERAQUIS = (SELECT MAX(PFHSTFER.DTINIPERAQUIS) FROM PFHSTFER WHERE PFHSTFER.CHAPA = PFUNC.CHAPA)
LEFT JOIN PFUFERIASPER ON PFUNC.CHAPA = PFUFERIASPER.CHAPA
WHERE PFUNC.CODFILIAL = 1 --:P_CODFILIAL
 -- AND PFUNC.CHAPA = :ESPELHO#2_S
GROUP BY PFUNC.CHAPA,PFUNC.DTVENCFERIAS, PFHSTFER.DTINIPERAQUIS, PFHSTFER.DTFIMPERAQUIS, pfunc.codfilial


/*
SELECT CONVERT(VARCHAR,FIMPERAQUIS,103) AS FIMPERAQUI
,CONVERT(VARCHAR,DATAINICIO,103)  AS DTINI
, CONVERT(VARCHAR,DATAFIM,103) AS DATAFIM
, NRODIASFERIAS
,*
 FROM PFUFERIASPER WHERE CHAPA = '010066'  --'010059'

*/

-- TESTE DATAS


--SELECT * FROM PFUFERIASPER WHERE CHAPA = '010066' --IN ('010066','010059','010069')






--SELECT CONVERT(VARCHAR,FIMPERAQUIS,103) AS FIMPERAQUI
--,CONVERT(VARCHAR,PFUFERIAS.INICIOPERAQUIS,103)  AS DTINI
--, CONVERT(VARCHAR,FIMPERAQUIS,103) AS DATAFIM
----, NRODIASFERIAS
--,*
-- FROM PFUFERIAS WHERE CHAPA = '010066' 
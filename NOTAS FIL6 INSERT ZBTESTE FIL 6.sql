--USE [Z.BaseTeste]

--SELECT * FROM SNOTAETAPA WHERE RA= '008544' AND IDTURMADISC = 70948 --CODETAPA = 16 AND IDTURMADISC = 70948

--SELECT * FROM SNOTAETAPA WHERE RA= '009058' AND IDTURMADISC = 70815 --CODETAPA = 16 AND IDTURMADISC = 70948


USE CORPORERM

BEGIN TRAN


INSERT INTO SNOTAETAPA (CODCOLIGADA,CODETAPA,TIPOETAPA,IDTURMADISC,RA,NOTAFALTA)

SELECT 

1 ,16,'N',TAB.IDTURMADISC,TAB.RA,TAB.NOTAFALTA

FROM
(
SELECT 
SP.CODCOLIGADA,
SP.CODFILIAL,
SP.CODTIPOCURSO,
SP.CODPERLET,
NT.CODETAPA,
NT.IDTURMADISC,
NT.TIPOETAPA,
NT.NOTAFALTA,
NT.RA,
STD.CODTURMA,
STD.CODDISC,
STD.IDHABILITACAOFILIAL

FROM SNOTAETAPA AS NT

JOIN STURMADISC AS STD ON STD.IDTURMADISC = NT.IDTURMADISC
JOIN SPLETIVO AS SP ON SP.IDPERLET = STD.IDPERLET

WHERE SP.CODFILIAL = 6 AND CODPERLET = '2020' AND NT.CODETAPA = 10 AND NT.NOTAFALTA IS NOT NULL --AND NT.RA= '009058' --'008544' --'009058' --
AND NOT EXISTS (SELECT IDTURMADISC FROM SNOTAETAPA AS A WHERE STD.IDTURMADISC = A.IDTURMADISC AND A.CODETAPA = 16)

)  AS TAB 



 /* ETAPA 10 - PROVA TRIMESTRAL --- ETAPA 16 - 1� TRIMESTRE */

-- ROLLBACK


--BEGIN TRAN

--DELETE FROM SNOTAETAPA WHERE CODETAPA = 16 AND IDTURMADISC = 70948 AND RA= '008544'


--COMMIT


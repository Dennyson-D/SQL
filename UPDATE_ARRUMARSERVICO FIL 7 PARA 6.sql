
BEGIN TRAN

UPDATE SBOLSAALUNO SET CODSERVICO = 57 WHERE IDBOLSAALUNO IN (
SELECT /*SMATRICPL.CODCOLIGADA,SMATRICPL.CODFILIAL,*/SBOLSAALUNO.IDBOLSAALUNO/*,SBOLSAALUNO.RA,SBOLSAALUNO.CODCONTRATO,SSERVICO.CODSERVICO,SPARCELA.CODSERVICO PARSERVICO,
SSERVICO.NOME SERVICO,SSERVICO.CODTIPOCURSO,SMATRICPL.IDPERLET,SMATRICPL.CODTURMA,SMATRICPL.IDHABILITACAOFILIAL,SLAN.IDLAN,SPARCELA.IDPARCELA */
FROM SCONTRATO 
 JOIN SBOLSAALUNO ON SCONTRATO.CODCONTRATO=SBOLSAALUNO.CODCONTRATO
 JOIN SSERVICO ON SSERVICO.CODSERVICO =  SBOLSAALUNO.CODSERVICO
 JOIN SMATRICPL ON SMATRICPL.RA=SCONTRATO.RA AND SCONTRATO.IDHABILITACAOFILIAL=SMATRICPL.IDHABILITACAOFILIAL
JOIN SPARCELA ON SPARCELA.CODCONTRATO=SCONTRATO.CODCONTRATO-- AND SPARCELA.CODSERVICO=SBOLSAALUNO.CODSERVICO
 JOIN SLAN ON SLAN.IDPARCELA=SPARCELA.IDPARCELA 
WHERE SCONTRATO.CODFILIAL=6 AND SMATRICPL.IDPERLET=270 AND SBOLSAALUNO.CODSERVICO=15 AND SCONTRATO.IDHABILITACAOFILIAL=SMATRICPL.IDHABILITACAOFILIAL AND SPARCELA.CODSERVICO IN(57)
--ORDER BY RA
)


--SELECT * FROM SPARCELA WHERE IDPARCELA IN (1808820,1808832,1808844)
--SELECT * FROM SLAN WHERE IDLAN IN (1530998,1537769,1537768)
--SELECT * FROM FLAN WHERE CODCFO='1530998'
--SELECT * FROM SPARCELA WHERE  CODSERVICO=15
--SELECT * FROM SCONTRATO WHERE CODFILIAL=6 
--
--SELECT * FROM SSERVICO WHERE CODSERVICO IN (15,7)

--SELECT * FROM SLAN

--SELECT * FROM SSERVICO
--SELECT * FROM SMATRICPL WHERE RA LIKE '%9860%'
--SELECT * FROM SCONTRATO WHERE CODCONTRATO=182641

--SELECT * FROM SBOLSAALUNO WHERE IDBOLSAALUNO=98238

--SELECT * FROM SPARCELA

--SELECT * FROM SLAN WHERE 

--SELECT * FROM GLINKSREL WHERE CHILDFIELD LIKE '%IDLAN%'

--SELECT * FROM FLANCOMPL



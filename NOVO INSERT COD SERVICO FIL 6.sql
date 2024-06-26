
-- ALTERAR O CODSERVICO PARA O CODSERVICO DA TABELA SPARCELA

/*INSERT INTO SBOLSAALUNO (CODCOLIGADA, IDBOLSAALUNO, RA, IDPERLET, CODCONTRATO, 
CODBOLSA, CODSERVICO, DTINICIO, DTFIM, DESCONTO, TIPODESC, OBS,
ORDEMBOLSA, PARCELAINICIAL, PARCELAFINAL, CHAPA, CODUSUARIO, DATACONCESSAO,
DATAAUTORIZACAO, TETOVALOR, ATIVA)
*/
SELECT 
SCONTRATO.CODCOLIGADA, AA.ID, SCONTRATO.RA, SCONTRATO.IDPERLET, SCONTRATO.CODCONTRATO,
AA.CODBOLSA,AA.CODSERVICO, DATEADD(YEAR,1, AA.DTINICIO) DTINICIO, DATEADD(YEAR,1, AA.DTFIM) DTFIM,
CASE WHEN AA.CODBOLSA = 82 THEN (CASE WHEN AA.DESCONTO <=2 THEN 0 ELSE AA.DESCONTO - 2 END) ELSE AA.DESCONTO END DESCONTO, AA.TIPODESC, AA.OBS,
AA.ORDEMBOLSA, AA.PARCELAINICIAL, AA.PARCELAFINAL, AA.CHAPA, 'mestre', AA.DATACONCESSAO,
AA.DATAAUTORIZACAO, AA.TETOVALOR, AA.ATIVA
FROM (
		SELECT ROW_NUMBER() OVER (ORDER BY SBOLSAALUNO.RA ASC) + (SELECT MAX(IDBOLSAALUNO) FROM SBOLSAALUNO) AS ID,  SMATRICPL.CODTURMA, 
		SBOLSAALUNO.*
		FROM SBOLSAALUNO (NOLOCK)
		JOIN SCONTRATO (NOLOCK)
		  ON SCONTRATO.CODCOLIGADA = SBOLSAALUNO.CODCOLIGADA
		 AND SCONTRATO.CODCONTRATO = SBOLSAALUNO.CODCONTRATO
		 AND SCONTRATO.RA = SBOLSAALUNO.RA
		 --LEFT JOIN SPARCELA ON(SBOLSAALUNO.RA=SPARCELA.RA AND SBOLSAALUNO.CODCONTRATO=SPARCELA.CODCONTRATO)
		JOIN SPLETIVO (NOLOCK)
		  ON SPLETIVO.CODCOLIGADA = SCONTRATO.CODCOLIGADA
		 AND SPLETIVO.CODFILIAL = SCONTRATO.CODFILIAL
		 AND SPLETIVO.IDPERLET = SCONTRATO.IDPERLET 
		 JOIN SMATRICPL (NOLOCK) ON SCONTRATO.IDPERLET = SMATRICPL.IDPERLET
		 AND SCONTRATO.RA = SMATRICPL.RA 
		 AND SCONTRATO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
		WHERE SCONTRATO.CODFILIAL IN (6)
		  AND SPLETIVO.CODPERLET = '2018'
		  AND SMATRICPL.CODSTATUS = 14
		  AND SCONTRATO.STATUS = 'N'
		  AND SBOLSAALUNO.CODSERVICO in('57','59','61','62')
		  
		  --MUDAR CODSERVICO PARA 57
		  --AND (SMATRICPL.CODTURMA LIKE 'EF.1%' OR SMATRICPL.CODTURMA LIKE 'EF.2%' 
		   -- AND SMATRICPL.CODTURMA='EF.2A.V'
		    --OR SMATRICPL.CODTURMA LIKE 'EF.3%' OR SMATRICPL.CODTURMA LIKE 'EF.4%')
		  
		  --MUDAR CODSERVICO PARA 59
		  --AND (SMATRICPL.CODTURMA LIKE 'EF.5%' OR SMATRICPL.CODTURMA LIKE 'EF.6%'
		    --OR SMATRICPL.CODTURMA LIKE 'EF.7%' OR SMATRICPL.CODTURMA LIKE 'EF.8%')
		    
		  --MUDAR CODSERVICO PARA 61  
		  --AND (SMATRICPL.CODTURMA LIKE 'EF.9%' OR SMATRICPL.CODTURMA LIKE 'EM.1%')
		  
		  --MUDAR CODSERVICO PARA 62  
		  --AND SMATRICPL.CODTURMA LIKE 'EM.2%' 
		  
		  
		  --AND SMATRICPL.CODTURMA NOT IN ('NATA��O', 'EM.3A.M', 'EM.3B.M')
		  ) AA
JOIN SCONTRATO (NOLOCK)
  ON SCONTRATO.CODCOLIGADA = AA.CODCOLIGADA
 AND SCONTRATO.RA = AA.RA
JOIN SPLETIVO (NOLOCK)
  ON SPLETIVO.CODCOLIGADA = SCONTRATO.CODCOLIGADA
 AND SPLETIVO.CODFILIAL = SCONTRATO.CODFILIAL
 AND SPLETIVO.IDPERLET = SCONTRATO.IDPERLET 
WHERE SPLETIVO.CODPERLET = '2019'
  AND SPLETIVO.CODFILIAL IN (6)
  AND SCONTRATO.CODCONTRATO  IN (SELECT SBOLSAALUNO.CODCONTRATO FROM SBOLSAALUNO) AND CODSERVICO = 59


  --SELECT * FROM SBOLSAALUNO
 -- SELECT * FROM SPARCELA WHERE IDPERLET = 270 AND CODCONTRATO = 182036

  --SELECT * FROM SCONTRATO WHERE CODCONTRATO = 182036

  --SELECT * FROM SSERVICO WHERE CODSERVICO IN (59,61)
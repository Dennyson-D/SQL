SELECT SDISCIPLINA.NOME, 
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 10 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) N1_1BIM,
MAX(CASE WHEN SPLETIVO.CODPERLET < '2017' THEN CASE WHEN SNOTAETAPA.CODETAPA = 12  THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END 
		WHEN SPLETIVO.CODPERLET >= '2017' THEN CASE WHEN SNOTAETAPA.CODETAPA = 11  THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END END) N2_1BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 13 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) MB_1BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 14 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) REC_1BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 19 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) MAR_1BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 15 THEN SNOTAETAPA.NOTAFALTA ELSE NULL END) FTS_1BIM,

MAX(CASE WHEN SNOTAETAPA.CODETAPA = 20 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) N1_2BIM,
MAX(CASE WHEN SPLETIVO.CODPERLET < '2017' THEN CASE WHEN SNOTAETAPA.CODETAPA = 22  THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END 
		WHEN SPLETIVO.CODPERLET >= '2017' THEN CASE WHEN SNOTAETAPA.CODETAPA = 21  THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END END) N2_2BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 23 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) MB_2BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 24 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) REC_2BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 29 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) MAR_2BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 25 THEN SNOTAETAPA.NOTAFALTA ELSE NULL END) FTS_2BIM,

MAX(CASE WHEN SNOTAETAPA.CODETAPA = 30 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) N1_3BIM,
MAX(CASE WHEN SPLETIVO.CODPERLET < '2017' THEN CASE WHEN SNOTAETAPA.CODETAPA = 32  THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END 
		WHEN SPLETIVO.CODPERLET >= '2017' THEN CASE WHEN SNOTAETAPA.CODETAPA = 31  THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END END) N2_3BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 33 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) MB_3BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 34 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) REC_3BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 39 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) MAR_3BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 35 THEN SNOTAETAPA.NOTAFALTA ELSE NULL END) FTS_3BIM,

MAX(CASE WHEN SNOTAETAPA.CODETAPA = 40 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) N1_4BIM,
MAX(CASE WHEN SPLETIVO.CODPERLET < '2017' THEN CASE WHEN SNOTAETAPA.CODETAPA = 42  THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END 
		WHEN SPLETIVO.CODPERLET >= '2017' THEN CASE WHEN SNOTAETAPA.CODETAPA = 41  THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END END) N2_4BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 43 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) MB_4BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 44 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) REC_4BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 49 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) MAR_4BIM,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 45 THEN SNOTAETAPA.NOTAFALTA ELSE NULL END) FTS_4BIM,

MAX(CASE WHEN SNOTAETAPA.CODETAPA = 60 THEN SNOTAETAPA.NOTAFALTA ELSE NULL END)TFT,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 50 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) MDA,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 51 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) REC,
MAX(CASE WHEN SNOTAETAPA.CODETAPA = 53 THEN REPLACE(CAST(SNOTAETAPA.NOTAFALTA AS NUMERIC(15,1)),'.',',') ELSE NULL END) MDF,

CASE WHEN SSTATUS.DESCRICAO = 'RECUPERAÇÃO BIMESTRAL' OR SSTATUS.DESCRICAO = 'RECUP BIMESTRAL'  THEN 'RECUP BIMESTRAL' ELSE /*''*/SSTATUS.DESCRICAO END AS SITUACAO, 
SMATRICULA.RA

FROM STURMADISC
JOIN SDISCIPLINA
  ON SDISCIPLINA.CODCOLIGADA = STURMADISC.CODCOLIGADA
 AND SDISCIPLINA.CODDISC = STURMADISC.CODDISC
JOIN SMATRICULA
  ON SMATRICULA.CODCOLIGADA = STURMADISC.CODCOLIGADA
 AND SMATRICULA.IDPERLET = STURMADISC.IDPERLET
 AND SMATRICULA.IDTURMADISC = STURMADISC.IDTURMADISC 
JOIN SPLETIVO
  ON SPLETIVO.CODCOLIGADA = STURMADISC.CODCOLIGADA
 AND SPLETIVO.CODFILIAL = STURMADISC.CODFILIAL
 AND SPLETIVO.IDPERLET = STURMADISC.IDPERLET
LEFT JOIN SNOTAETAPA
  ON SNOTAETAPA.CODCOLIGADA = SMATRICULA.CODCOLIGADA
 AND SNOTAETAPA.IDTURMADISC = SMATRICULA.IDTURMADISC 
 AND SNOTAETAPA.RA = SMATRICULA.RA
JOIN SSTATUS
  ON SSTATUS.CODCOLIGADA = SMATRICULA.CODCOLIGADA
 AND SSTATUS.CODSTATUS = SMATRICULA.CODSTATUS
WHERE STURMADISC.CODFILIAL = 21 --:COD_FILIAL
  AND STURMADISC.CODTURMA = 'EM3MA'
  AND SMATRICULA.RA = '00025513'--:RA1
  AND SPLETIVO.CODPERLET = '2019' --:ANO_LETIVO_S
GROUP BY SMATRICULA.RA, SDISCIPLINA.NOME, SSTATUS.DESCRICAO
ORDER BY SDISCIPLINA.NOME ASC



SELECT * FROM SMATRICPL WHERE RA='00025513'
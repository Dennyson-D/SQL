SELECT DISTINCT 
SCURSO.CODCURSO
,SCURSO.NOME AS CURSO
,MAT.RA
,PPESSOA.NOME AS ALUNO
,SBOLSA.CODBOLSA
,SBOLSA.NOME AS BOLSA
,SBOLSA.ATIVA 
FROM SBOLSAALUNO 

 JOIN SBOLSA ON SBOLSA.CODBOLSA = SBOLSAALUNO.CODBOLSA
 JOIN SMATRICPL AS MAT ON MAT.RA = SBOLSAALUNO.RA 
 JOIN SSTATUS ON SSTATUS.CODSTATUS = MAT.CODSTATUS
 JOIN SALUNO ON SALUNO.RA = MAT.RA
 JOIN PPESSOA ON PPESSOA.CODIGO = SALUNO.CODPESSOA
 JOIN SHABILITACAOFILIAL ON SHABILITACAOFILIAL.IDHABILITACAOFILIAL = MAT.IDHABILITACAOFILIAL
 JOIN SCURSO ON SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO

 WHERE SSTATUS.DESCRICAO LIKE 'MAT%' AND SBOLSA.CODTIPOCURSO IN (4,6) AND SBOLSA.ATIVA = 'S' AND SBOLSA.NOME NOT LIKE '%[%]%' AND SBOLSA.NOME NOT LIKE ('%ALUNO%')
 ORDER BY CURSO,ALUNO,BOLSA

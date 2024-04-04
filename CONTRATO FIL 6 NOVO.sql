DECLARE @FILIAL VARCHAR(2), @RA VARCHAR(15), @PERIODOLETIVO VARCHAR(6)

SET @FILIAL = 6 --:CODFILIAL; 
SET @RA = '010266' --'010445' --  '010450' --:RA_ALUNO; 
SET @PERIODOLETIVO = '2020'--:CODPERLET;

SELECT DISTINCT

ALUNO.NOME AS ALUNO,
CASE WHEN SCURSO.NOME LIKE '%ENSINO INFANTIL%' THEN 'ENSINO INFANTIL-EI'
	 WHEN SCURSO.NOME LIKE '%ENSINO FUNDAMENTAL%' THEN 'ENSINO FUNDAMENTAL-EF'
ELSE 'ENSINO M�DIO-EM' END  AS GRAU_ALUNO,
SHABILITACAO.NOME + '/'+ SMATRICPL.CODTURMA AS SERIE_ALUNO,
SMATRICPL.CODTURMA AS TURMA,
SCURSO.NOME AS CURSO_ALUNO,
SPARCPLANO.VALOR * 12 + 380 AS ANUIDADE,
SPARCPLANO.VALOR AS MENSALIDADE,
CONVERT(DECIMAL(8,2),(SBOLSAALUNO.DESCONTO)) AS DESCONTO,
--ROUND(SUM(SPARCPLANO.VALOR) /12  - ((SUM(SPARCPLANO.VALOR) /12) * (CONVERT(DECIMAL(4,2),SBOLSAALUNO.DESCONTO)/100)),2) AS MENSLIQ,
(SPARCPLANO.VALOR) - (SPARCPLANO.VALOR * (CONVERT(DECIMAL(4,2),(SBOLSAALUNO.DESCONTO))/100)) AS MENSLIQ,


COUNT(SPARCPLANO.PARCELA) AS QTDE_PARCELA,
SALUNO.RA
,DBO.fn_numero_por_extenso(REPLACE('315,00',',','.')) AS PREC_ESP1

 ,SMATRICPL.IDPERLET
 ,SPLANOPGTO.CODPLANOPGTO
 ,SCONTRATO.CODCONTRATO
 ,SBOLSAALUNO.CODSERVICO AS CODS1
 ,SSERVICO.CODSERVICO

FROM 
SMATRICPL (NOLOCK)
 --ADD
  
  JOIN SCONTRATO ON SCONTRATO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL AND SCONTRATO.RA = SMATRICPL.RA AND SCONTRATO.IDPERLET = SMATRICPL.IDPERLET 
  LEFT JOIN SBOLSAALUNO ON SBOLSAALUNO.CODCONTRATO = SCONTRATO.CODCONTRATO AND SBOLSAALUNO.RA = SCONTRATO.RA AND SBOLSAALUNO.IDPERLET = SCONTRATO.IDPERLET 
       AND SBOLSAALUNO.CODSERVICO IN(SELECT CODSERVICO FROM SSERVICO AS S1 WHERE S1.CODSERVICO = SBOLSAALUNO.CODSERVICO AND S1.NOME NOT LIKE '%ADI%' AND S1.NOME LIKE '%MENSA%')
	   
     
 --ADD
INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON 
     SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
	
INNER JOIN SPLETIVO (NOLOCK) ON 
     SPLETIVO.IDPERLET = SMATRICPL.IDPERLET
INNER JOIN SHABMODELOPGTO (NOLOCK) ON 
     SHABMODELOPGTO.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL AND
     SHABMODELOPGTO.IDPERLET = SMATRICPL.IDPERLET 
INNER JOIN SPLANOPGTO (NOLOCK) ON 
     SPLANOPGTO.CODPLANOPGTO = SCONTRATO.CODPLANOPGTO AND 
     SCONTRATO.IDPERLET = SMATRICPL.IDPERLET AND
     SPLANOPGTO.DESCRICAO LIKE /*'%SEM%'*/ '%SEGURO%' AND
	 SPLANOPGTO.DESCRICAO NOT LIKE '%ADI%'

INNER JOIN SPARCPLANO (NOLOCK) ON 
     SPARCPLANO.CODPLANOPGTO = SPLANOPGTO.CODPLANOPGTO AND 
     SPARCPLANO.IDPERLET = SMATRICPL.IDPERLET
INNER JOIN SSERVICO (NOLOCK) ON 
     SSERVICO.CODSERVICO = SPARCPLANO.CODSERVICO
INNER JOIN SSTATUS (NOLOCK) ON 
     SSTATUS.CODSTATUS = SMATRICPL.CODSTATUS
INNER JOIN SALUNO (NOLOCK) ON 
     SALUNO.RA = SMATRICPL.RA
INNER JOIN PPESSOA ALUNO (NOLOCK) ON 
     ALUNO.CODIGO = SALUNO.CODPESSOA
INNER JOIN SCURSO (NOLOCK) ON 
     SCURSO.CODCURSO = SHABILITACAOFILIAL.CODCURSO
INNER JOIN SHABILITACAO (NOLOCK) ON 
     SHABILITACAO.CODCURSO = SHABILITACAOFILIAL.CODCURSO AND 
     SHABILITACAO.CODHABILITACAO = SHABILITACAOFILIAL.CODHABILITACAO
    /*
INNER JOIN SCONTRATO (NOLOCK) ON 
     SCONTRATO.RA = SALUNO.RA
     
INNER JOIN SPARCELA (NOLOCK) ON 
     SPARCELA.RA = SALUNO.RA AND
     SPARCELA.CODCONTRATO = SCONTRATO.CODCONTRATO AND
     SPARCELA.IDPERLET = SCONTRATO.IDPERLET */

WHERE SMATRICPL.CODFILIAL = @FILIAL 
AND SMATRICPL.RA LIKE @RA
AND SPLETIVO.CODPERLET = @PERIODOLETIVO
AND SSERVICO.NOME LIKE '%MENS%'
AND SMATRICPL.CODSTATUS IN (14,15,174)
AND SCURSO.NOME LIKE '%ENSINO%'
AND SMATRICPL.CODTURMA LIKE '%' --+ :CODTURMA + '%' 

GROUP BY ALUNO.NOME, ALUNO.GRAUINSTRUCAO, SHABILITACAO.NOME,
SCURSO.NOME, SMATRICPL.CODTURMA, SALUNO.RA, SPARCPLANO.VALOR,
SPLANOPGTO.CODPLANOPGTO, SMATRICPL.IDPERLET,SPLANOPGTO.CODPLANOPGTO,SCONTRATO.CODCONTRATO,SBOLSAALUNO.DESCONTO,SSERVICO.CODSERVICO,SBOLSAALUNO.CODSERVICO
		 
ORDER BY SMATRICPL.CODTURMA,ALUNO;
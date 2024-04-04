SET DATEFORMAT DMY
set language Portugu�s


DECLARE @IDPERLET AS VARCHAR(6), @RA1 AS VARCHAR(20)

SET @RA1 = '00026157'--:RA

SET @IDPERLET = (SELECT MAX(SMATRICPL.IDPERLET) 
                   FROM SMATRICPL (NOLOCK) 
                  WHERE RA = @RA1)

SELECT PPESSOA.NOME AS NOME_ALUNO,
/*SPLETIVO.CODPERLET + '/' + SMATRICPL.CODTURMA AS ANO_SERIE,*/
       SALUNO.RA AS RA_DO_ALUNO,
       SCURSO.NOME AS NOME_CURSO, 
       SMATRICPL.CODTURMA  AS  ANO_SERIE,        
       CONVERT(VARCHAR,  PPESSOA.DTNASCIMENTO, 103)AS DTNASC_ALUNO,
       PPESSOA.NATURALIDADE AS NATUR_ALUNO,
       PPESSOA.SEXO AS SEXO_ALUNO,
       ISNULL(CASE (PPESSOA.CORRACA) 
			WHEN '0'  THEN 'IND�GENA'
			WHEN '2'  THEN 'BRANCA'
			WHEN '4'  THEN 'NEGRA'
			WHEN '6'  THEN 'AMARELA'
			WHEN '8'  THEN 'PARDA'
			WHEN '10' THEN 'N�O DECLARADA' 
       END,'') AS RACA_ALUNO,
	   /*CASE SALUNOCOMPL.RESPGUARDA WHEN '001' THEN 'X' ELSE ' ' END AS GUARDAPAI,
	   CASE SALUNOCOMPL.RESPGUARDA WHEN '002' THEN 'X' ELSE ' ' END AS GUARDAMAE,
	   CASE SALUNOCOMPL.RESPGUARDA WHEN '003' THEN 'X' ELSE ' ' END AS GUARDAAMBOS,
	   CASE SALUNOCOMPL.RESPGUARDA WHEN '004' THEN SALUNOCOMPL.OUTRORESP ELSE '          ' END AS GUARDAOUTROS,      
	   CASE SALUNOCOMPL.DOCRESP WHEN '01' THEN 'X' ELSE ' ' END AS DOCSIM,
	   CASE SALUNOCOMPL.DOCRESP WHEN '02' THEN 'X' ELSE ' ' END AS DOCNAO ,*/
	   isnull(FORMAT(SCONTRATO.DTASSINATURA,'D'), '_____________________________') DATAACEITE
       ,ISNULL((SELECT NACIONALIDADE FROM ZNACIONALIDADE WHERE ZNACIONALIDADE.CODNACIONALIDADE = PPESSOA.NACIONALIDADE),'') AS NACIONALIDADE
	   ,(PCODESTCIVIL.DESCRICAO) AS ESTADOCIVIL
	   ,ISNULL((SELECT DESCRICAO FROM EPROFISS WHERE EPROFISS.CODCLIENTE = PPESSOA.CODPROFISSAO),'N�o informada') AS PROFISSAO
	   ,PPESSOA.RUA
	   ,PPESSOA.NUMERO
	   ,PPESSOA.BAIRRO
	   ,PPESSOA.CEP
	   ,PPESSOA.ESTADO
	   ,PPESSOA.CPF
	   ,PPESSOA.CARTIDENTIDADE
	   ,FORMAT(GETDATE(),'D') AS HOJE 

 FROM SCURSO (NOLOCK) 
INNER JOIN SHABILITACAOFILIAL
   ON SHABILITACAOFILIAL.CODCURSO = SCURSO.CODCURSO
INNER JOIN SMATRICPL (NOLOCK) 
   ON SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL
INNER JOIN SALUNO (NOLOCK) 
   ON SALUNO.RA = SMATRICPL.RA
INNER JOIN PPESSOA (NOLOCK) 
   ON PPESSOA.CODIGO = SALUNO.CODPESSOA
INNER JOIN SPLETIVO (NOLOCK) 
   ON SMATRICPL.IDPERLET = SPLETIVO.IDPERLET
INNER JOIN SSTATUS (NOLOCK) 
   ON SSTATUS.CODSTATUS = SMATRICPL.CODSTATUS
/*INNER JOIN STURMA
    ON STURMA.CODTURMA = SMATRICPL.CODTURMA*/
   
   LEFT JOIN SALUNOCOMPL
   ON SALUNOCOMPL.RA = SALUNO.RA   
   
   INNER JOIN SCONTRATO ON SCONTRATO.RA = SALUNO.RA
AND SCONTRATO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
AND SCONTRATO.IDPERLET = SMATRICPL.IDPERLET
AND SCONTRATO.STATUS <> 'S'
AND SCONTRATO.TIPOCONTRATO <> 'A'

   JOIN PCODESTCIVIL ON PCODESTCIVIL.CODCLIENTE = PPESSOA.ESTADOCIVIL

WHERE PPESSOA.FUNCIONARIO = 1
AND SALUNO.RA = @RA1
AND SALUNO.CODCOLIGADA = 1 --:CODCOLIGADA
AND SPLETIVO.CODPERLET = '2019'
AND SSTATUS.CODSTATUS IN (1,2)
AND (SCURSO.NOME LIKE '%SCHOOL%')
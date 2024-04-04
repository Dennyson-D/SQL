SELECT 
 AL.RA
,P.NOME AS ALUNO
,SSTATUS.DESCRICAO AS STATUS
,FCFO.CODCFO
,FCFO.NOME AS EMPRESA
,FCFO.NOMEFANTASIA AS NOME_FANTASIA
,FCFO.CGCCFO AS CNPJ
,FCFO.TELEFONE AS TEL_EMPRESA
,FCFO.EMAIL AS EMAIL_EMPRESA
,SCONTRATO.CODCONTRATO
,CONVERT(VARCHAR,CONVERT(FLOAT,RESP.PERCENTUAL))+'%' AS PERCENTUAL
,SPLETIVO.CODPERLET
,GIMAGEM.IMAGEM

 FROM SALUNO AS AL (NOLOCK)

JOIN PPESSOA P (NOLOCK) ON P.CODIGO = AL.CODPESSOA 
JOIN SMATRICPL MAT (NOLOCK) ON MAT.RA = AL.RA
JOIN SSTATUS (NOLOCK) ON SSTATUS.CODSTATUS = MAT.CODSTATUS AND SSTATUS.DESCRICAO LIKE 'MAT%'
JOIN FCFO (NOLOCK) ON FCFO.CODCFO = AL.CODCFO
JOIN SCONTRATO (NOLOCK) ON SCONTRATO.RA= MAT.RA AND SCONTRATO.IDPERLET = MAT.IDPERLET AND SCONTRATO.IDHABILITACAOFILIAL = MAT.IDHABILITACAOFILIAL
JOIN SPLETIVO (NOLOCK) ON SPLETIVO.IDPERLET = MAT.IDPERLET
JOIN SRESPONSAVEL AS RESP (NOLOCK) ON RESP.CODCFO = FCFO.CODCFO
JOIN GFILIAL (NOLOCK) ON GFILIAL.CODFILIAL = MAT.CODFILIAL
JOIN GIMAGEM (NOLOCK) ON GIMAGEM.ID = GFILIAL.IDIMAGEM

WHERE SCONTRATO.CODFILIAL = 18

ORDER BY ALUNO



--SELECT * FROM SRESPONSAVEL WHERE CODCFO = '002363'

--SELECT * FROM SMATRICPL
--SELECT * FROM GLINKSREL WHERE MASTERTABLE = 'SRESPONSAVEL'


--SELECT * FROM PPESSOA WHERE NOME = 'ADASSA AGNER DE OLIVEIRA'


-- SELECT * FROM FCFO
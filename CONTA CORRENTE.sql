 ;WITH TABA AS (
 SELECT DISTINCT
 SH.CODFILIAL
,SA.RA
,PP.NOME AS ALUNO
,SC.CODCURSO
,SC.NOME AS CURSO

,CONVERT(SMALLMONEY,    ISNULL((SELECT SUM(CONTA1.VALOR) FROM SCONTACORRENTE AS CONTA1 WHERE NATUREZA = 'C' AND CONTA1.RA = SA.RA AND TIPO = 1 ),0) -
						ISNULL((SELECT SUM(CONTA2.VALOR) FROM SCONTACORRENTE AS CONTA2 WHERE NATUREZA = 'D' AND CONTA2.RA = SA.RA AND TIPO = 2),0)
						+ ISNULL(CRED.VALOR,0) - ISNULL(DEB.VALOR ,0)
                       )  AS SALDO

--,CRED.VALOR AS CRED_VAL
--,DEB.VALOR AS DEB_VAL
,CC.NATUREZA
,ST.DESCRICAO AS STATUS

 FROM SCONTACORRENTE(NOLOCK) AS CC
JOIN SALUNO (NOLOCK) AS SA ON SA.RA = CC.RA 
JOIN PPESSOA (NOLOCK) AS PP ON PP.CODIGO = SA.CODPESSOA
JOIN SHABILITACAOALUNO (NOLOCK) AS HA ON HA.RA = SA.RA AND HA.IDHABILITACAOFILIAL = CC.IDHABILITACAOFILIAL
JOIN SHABILITACAOFILIAL (NOLOCK) AS SH ON SH.IDHABILITACAOFILIAL = CC.IDHABILITACAOFILIAL
JOIN SCURSO (NOLOCK) AS SC ON SC.CODCURSO = SH.CODCURSO 
JOIN SSTATUS (NOLOCK) AS ST ON ST.CODTIPOCURSO = SC.CODTIPOCURSO AND ST.DESCRICAO LIKE 'MAT%'
JOIN SMATRICPL (NOLOCK) AS SM ON SM.RA = SA.RA AND SM.IDHABILITACAOFILIAL = SH.IDHABILITACAOFILIAL
JOIN SPLETIVO (NOLOCK) AS SP ON SP.IDPERLET = SM.IDPERLET

LEFT JOIN (SELECT CONVERT(SMALLMONEY,SUM(CONTA.VALOR)) AS VALOR,CREDITO.RA,CREDITO.NATUREZA
			FROM SCONTACORRENTE AS CONTA
			LEFT JOIN SCONTACORRENTE (NOLOCK) AS CREDITO ON CREDITO.IDCCORIGEM = CONTA.IDCONTACORRENTE 
			WHERE NOT EXISTS(SELECT * FROM SCONTACORRENTE WHERE SCONTACORRENTE.IDCCORIGEM = CREDITO.IDCONTACORRENTE)GROUP BY CREDITO.RA,CREDITO.NATUREZA)
			 AS CRED  
			 ON CRED.RA = CC.RA AND CRED.VALOR <> 0 AND CRED.NATUREZA='C'  

LEFT JOIN (SELECT CONVERT(SMALLMONEY,SUM(CONTA.VALOR)) AS VALOR,CREDITO.RA,CREDITO.NATUREZA
			FROM SCONTACORRENTE AS CONTA
			LEFT JOIN SCONTACORRENTE (NOLOCK) AS CREDITO ON CREDITO.IDCCORIGEM = CONTA.IDCONTACORRENTE 
			WHERE NOT EXISTS(SELECT * FROM SCONTACORRENTE WHERE SCONTACORRENTE.IDCCORIGEM = CREDITO.IDCONTACORRENTE)GROUP BY CREDITO.RA,CREDITO.NATUREZA)
			 AS DEB  
			 ON DEB.RA = CC.RA AND /*DEB.VALOR <> 0 AND*/ DEB.NATUREZA='D' 


WHERE SH.CODFILIAL = 5 AND CC.TIPO = 2 AND SP.CODPERLET = '2019' --AND CC.RA='00006768' --'00002640'

GROUP BY SH.CODFILIAL,SA.RA,PP.NOME,SC.CODCURSO,SC.NOME,CC.VALOR,CC.NATUREZA,CC.CODCFO,ST.DESCRICAO,CC.RA,CC.IDHABILITACAOFILIAL,CRED.VALOR,DEB.VALOR

)

SELECT *,IIF(SALDO<0,'D�BITO','CR�DITO') AS STATUS_CONTA FROM TABA WHERE SALDO <> 0

ORDER BY ALUNO,CODCURSO
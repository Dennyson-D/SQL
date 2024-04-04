SET LANGUAGE BRAZILIAN

;WITH

TABA AS(
SELECT 
 F.CODFILIAL
,P.RA
,PE.NOME AS ALUNO
,MAT.CODTURMA
,F.IDLAN
,P.IDPARCELA
,CONVERT(VARCHAR,F.MESDECOMPETENCIA,103) AS MESCOMP
,P.CODCONTRATO
,SP.CODPERLET
,CONVERT(VARCHAR,P.DTVENCIMENTO,103) AS DTVENCIMENTO
,S.CODSERVICO
,S.NOME AS SERVICO
,F.VALORORIGINAL


 FROM SPARCELA AS P
JOIN SSERVICO AS S ON S.CODSERVICO = P.CODSERVICO
JOIN SLAN AS SL ON SL.IDPARCELA = P.IDPARCELA
JOIN FLAN AS F ON F.IDLAN = SL.IDLAN
JOIN SPLETIVO AS SP ON SP.IDPERLET = P.IDPERLET
JOIN SALUNO AS AL ON AL.RA = P.RA
JOIN PPESSOA AS PE ON PE.CODIGO = AL.CODPESSOA
JOIN SCONTRATO AS C ON C.CODCONTRATO = P.CODCONTRATO
JOIN SMATRICPL AS MAT ON MAT.RA = C.RA AND MAT.IDHABILITACAOFILIAL = C.IDHABILITACAOFILIAL AND MAT.IDPERLET = C.IDPERLET


WHERE  SP.CODPERLET = '2020' AND S.CODSERVICO IN (163,101) AND F.CODFILIAL = 5 AND MESDECOMPETENCIA BETWEEN '01/01/2020' AND '31/12/2020' /* SERVI�OS - 163=PER ADICIONAL **** 101=ESPORTES */ 

)
,

TABB AS /* QTADE DE IDLAN POR RA */

(
   SELECT COUNT(IDLAN) AS CONT_IDLAN, RA, ALUNO FROM TABA GROUP BY RA,ALUNO
),

TABC AS /* QTDE ACORDOS*/
(
  SELECT COUNT(RA) AS CONT_AC
  ,CODFILIAL
  ,FA.IDACORDO
  ,TABA.CODTURMA
  ,RA
  ,ALUNO 
  ,FA.QTDEPARCELAS
  ,AC2.IDLAN AS IDLAN_GERADO
  ,AC2.CLASSIFICACAO
  ,TABA.SERVICO
  
  FROM TABA  

  JOIN FACORDOREL AS FLA ON FLA.IDLAN = TABA.IDLAN
  JOIN FACORDO AS FA ON FA.IDACORDO = FLA.IDACORDO AND FA.QTDEPARCELAS = 1
  JOIN FACORDOREL AS AC2 ON AC2.IDACORDO = FA.IDACORDO  AND AC2.CLASSIFICACAO = 2
  
  GROUP BY CODFILIAL,ALUNO,TABA.CODTURMA,RA,FA.IDACORDO,FA.QTDEPARCELAS,AC2.IDLAN,AC2.CLASSIFICACAO,SERVICO
),

TABD AS
(
SELECT *,(SELECT CONT_IDLAN FROM TABB WHERE TABB.RA = TABC.RA) AS CONT_IDLAN FROM TABC 

)

SELECT TABD.CODFILIAL,TABD.IDACORDO,TABD.RA,TABD.ALUNO,TABD.CODTURMA,TABD.QTDEPARCELAS,TABD.IDLAN_GERADO,TABD.SERVICO	
   ,CASE FLAN.STATUSLAN
	WHEN 0 THEN 'ABERTO'
	WHEN 1 THEN 'PAGO'
	WHEN 2 THEN 'CANCELADO'
	WHEN 3 THEN 'ACORDO'
	WHEN 4 THEN 'BX_PARCIAL' 
	END AS STATUSLAN

 FROM TABD
JOIN FLAN ON FLAN.IDLAN = TABD.IDLAN_GERADO
WHERE CONT_AC = CONT_IDLAN
ORDER BY ALUNO
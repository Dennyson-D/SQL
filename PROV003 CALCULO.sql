SELECT 
 CODFILIAL
,ROUND(CONVERT(MONEY,SUM(FERIAS)),2) AS FERIAS
,ROUND(CONVERT(MONEY,SUM(ANTERIOR)),2) AS F13ANTERIOR
,ROUND(CONVERT(MONEY,SUM(FGTS_ANT)),2) AS FGTS_ANT
,ROUND(CONVERT(MONEY,SUM(MES)),2) AS F13MES
,ROUND(CONVERT(MONEY,SUM(VALOR)),2) AS F13_ACUM
,ROUND(CONVERT(MONEY,SUM(SALARIO)),2) AS SALARIO
,ROUND(CONVERT(MONEY,SUM(MEDIAS13SAL)),2) AS MEDIAS13SAL
,ROUND(CONVERT(MONEY,SUM(FGTS)),2) AS FGTS 
,ROUND(CONVERT(MONEY,SUM(ANTERIOR) * 0.243),2) AS INSS_ANT
,ROUND(CONVERT(MONEY,SUM(MES) * 0.243),2) AS INSS
 FROM 

(

SELECT CODFILIAL
,A.ANTERIOR AS ANTERIOR
,A.FERIAS AS FERIAS
,A.MES AS MES
,A.VALOR AS VALOR
,A.AVOS AS AVOS
,A.SALARIO AS SALARIO
,A.MEDIAS13SAL AS MEDIAS13SAL
,A.FGTS_ANT AS FGTS_ANT
,TIPO_FUNC
,CASE WHEN A.TIPO_FUNC = 'Z' THEN MES * 0.02 ELSE MES * 0.08 END AS FGTS /* Nº 16*/


 FROM(
SELECT  
 -- PROVISAO.chapa, /* Nº 3*/
 -- PROVISAO.nome, /* Nº 4*/
  PROVISAO.anterior, /* Nº 5*/
  PROVISAO.ferias, /* Nº 6*/
  (ISNULL(PROVISAO.valor,0)-ISNULL(PROVISAO.anterior,0)) + ISNULL(PROVISAO.ferias,0) as MES, /* Nº 7*/
  PROVISAO.valor, /* Nº 8*/
  PROVISAO.avos, /* Nº 9*/
  PROVISAO.salario, /* Nº 10*/
  provisao.codfilial /* Nº 11*/
  ,PROVISAO.MEDIAS13SAL /* Nº 13*/
  ,CONVERT(SMALLMONEY,(CASE WHEN PROVISAO.TIPO_FUNC = 'Z' THEN ANTERIOR * 0.02 ELSE ANTERIOR * 0.08 END)) AS FGTS_ANT /* Nº 14*/
  ,PROVISAO.TIPO_FUNC /* Nº 15*/
FROM 
 (SELECT  
    pfhstprov.chapa,
    pfunc.nome,
    pfunc.codfilial,
    (SELECT HISTORICO.valprovcomabatfer FROM pfhstprov HISTORICO
            WHERE HISTORICO.mes=(case when pfhstprov.mes=1 
                                      then 12
                                      else pfhstprov.mes-1 end)
              AND HISTORICO.ano=(case when pfhstprov.mes=1 
                                      then pfhstprov.ano-1
                                      else pfhstprov.ano end)
              AND HISTORICO.chapa=pfhstprov.chapa) ANTERIOR,
    (SELECT ISNULL(Sum(F.VALOR),0) FROM PFFINANC F, PEVENTO E
        WHERE F.CODEVENTO=E.CODIGO
          AND F.CODCOLIGADA=E.CODCOLIGADA
          AND F.ANOCOMP= 2020 --:ANO_N 
          AND F.MESCOMP= 5 --:MES_N 
          AND F.CHAPA=PFHSTPROV.CHAPA
          AND F.CODCOLIGADA=1
          AND F.CODEVENTO IN  (SELECT CODIGO FROM PEVENTO  WHERE CONTADEBITO ='0026')
                               ) FERIAS,
    case when (pfunc.codsituacao<>'D' OR (pfunc.codsituacao='D' AND datademissao>'2020/05/30')) 
         then pfhstprov.valprovcomabatfer else 0 end VALOR,
    (pfhstprov.nroavosvencferdec+pfhstprov.nroavosproporcdec) AVOS,
    pfunc.salario
    ,PFHSTPROV.MEDIAS13SAL
	,PFUNC.CODTIPO AS TIPO_FUNC
  FROM 
    pfhstprov,
    pfunc
  WHERE pfhstprov.codcoligada=1 
    AND pfhstprov.codcoligada=pfunc.codcoligada
    AND pfunc.codtipo<>'D'
    AND pfunc.chapa=pfhstprov.chapa
    AND (pfunc.tipoadmissao<>'T'
    OR  (pFunc.tipoadmissao='T'
    and pfunc.dttransferencia<'2020/05/30'))
    AND pfhstprov.ano= 2020 --:ANO_N
    AND pfhstprov.mes= 5 --:MES_N
    /* AND pfunc.CODFILIAL=:ESPELHO#1*/
    AND pfunc.chapa LIKE '190002') PROVISAO
	
) A

)B


GROUP BY CODFILIAL

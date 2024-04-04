-- PROVISAO FERIAS POR FILIAL
SELECT *
,CASE WHEN A.TIPO_FUNC = 'Z' THEN MES * 0.02 ELSE MES * 0.08 END AS FGTS /* Nº 16*/
 FROM(
SELECT  
  PROVISAO.chapa, /* Nº 3*/
  PROVISAO.nome, /* Nº 4*/
  PROVISAO.anterior, /* Nº 5*/
  PROVISAO.ferias, /* Nº 6*/
  ((ISNULL(PROVISAO.valor,0)-ISNULL(PROVISAO.anterior,0)) + ISNULL(PROVISAO.ferias,0)) as MES, /* Nº 7*/
  PROVISAO.valor, /* Nº 8*/
  PROVISAO.avos, /* Nº 9*/
  PROVISAO.salario, /* Nº 10*/
  provisao.codfilial /* Nº 11*/
  ,PROVISAO.MEDIAS13SAL /* Nº 13*/
  ,CONVERT(SMALLMONEY,(CASE WHEN PROVISAO.TIPO_FUNC = 'Z' THEN ANTERIOR * 0.02 ELSE ANTERIOR * 0.08 END)) AS FGTS_ANT /* Nº 14*/
  ,PROVISAO.TIPO_FUNC /* Nº 15*/
   -- 0.243 INSS
  

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
          AND F.ANOCOMP= 2019 --:ANO_N 
          AND F.MESCOMP= 10 --:MES_N 
          AND F.CHAPA=PFHSTPROV.CHAPA
          AND F.CODCOLIGADA=1
          AND F.CODEVENTO IN  (SELECT CODIGO FROM PEVENTO  WHERE CONTADEBITO ='0026')
                               ) FERIAS,
    case when (pfunc.codsituacao<>'D' OR (pfunc.codsituacao='D' AND datademissao>'2019-10-31' /*:FIM_MES_D*/)) 
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
    and pfunc.dttransferencia<'2019-10-31'))
    AND pfhstprov.ano= 2019--:ANO_N
    AND pfhstprov.mes= 10 --:MES_N
    AND pfunc.CODFILIAL= 1
    AND pfunc.chapa = '010066'/* LIKE '%'*/) PROVISAO

) A

JOIN
   (
	    SELECT DISTINCT PFFINANC.CHAPA
		,PFFINANC.ANOCOMP
		,PFFINANC.MESCOMP
		,INSS = CASE WHEN PEVENTO.CODIGO = '0003' THEN PFFINANC.VALOR END 
		,INSS_ANT = (SELECT VALOR FROM PFFINANC PV WHERE CODEVENTO = '0003' AND MESCOMP = 9 /*:MES_N - 1*/ AND PV.CHAPA = PFFINANC.CHAPA AND ANOCOMP = 2019)

		FROM PFFINANC 

		JOIN PEVENTO ON  PEVENTO.CODIGO = PFFINANC.CODEVENTO

		WHERE  ANOCOMP = 2019/*:ANO_N */ AND MESCOMP = 10 /*:MES_N*/ AND CODEVENTO = '0003' /* EVENTO DE INSS*/
   )  INSS  ON INSS.CHAPA = A.CHAPA

order by
  A.nome
  --  386,13
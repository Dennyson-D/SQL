SET LANGUAGE BRAZILIAN

; WITH

 BDHR AS (
  
  SELECT 
   CHAPA
  ,CONVERT(VARCHAR,INICIOPERMES,103) AS INICIOPERMES
  ,CONVERT(VARCHAR,FIMPERMES,103) AS FIMPERMES
  ,CONVERT(FLOAT,VALORATUAL) AS VALOR
  ,ASB.CODEVENTO
  ,DESCRICAO AS EVENTO

  
   FROM ASALDOBANCOHORFUNDETALHE AS ASB 

  JOIN AEVECALC AS AE ON AE.CODEVENTO = ASB.CODEVENTO

  WHERE CHAPA = '051092' --'050011' --'050413' --'050198' -- -- --  --
  ),

  HREXTRAS AS (
    SELECT CONVERT(NUMERIC(18,2),SUM(VALOR)) AS EXTRA FROM BDHR WHERE CODEVENTO IN('0018','0026') 

  ),

  ATRASOS AS (
   SELECT CONVERT(NUMERIC(18,2),SUM(VALOR)) AS ATRASO FROM BDHR WHERE CODEVENTO IN('0001','0002') 
  ),

  CALC AS 
  (

  SELECT DISTINCT
   CHAPA
  ,ROUND (EXTRA/60,2) AS HREXTR 
  ,FLOOR((EXTRA/60)) AS HORAS_EXT
  ,CONVERT(INT,(EXTRA%60)) AS MINUTOS_VLR_EXT
  ------------------D�BITO----------------
  ,ROUND(ATRASO/60,2) AS HRATRASO 
  ,FLOOR(ATRASO/60) AS HORAS_ATRASO
  ,CONVERT(INT,(ATRASO % 60))  AS MINUTOS_VLR_ATR
  ,EXTRA
  ,ATRASO 

  FROM HREXTRAS AS EXT
  , ATRASOS AS ATR
  , BDHR

  ),

  TOTAIS AS 
  (

  SELECT 
   *
  ,(HORAS_EXT - HORAS_ATRASO) + CASE WHEN HORAS_EXT > HORAS_ATRASO AND MINUTOS_VLR_EXT < MINUTOS_VLR_ATR  THEN -1 ELSE 0 END AS SALDO_HORAS
  ,CONVERT(NUMERIC(18,2),ABS(MINUTOS_VLR_EXT - MINUTOS_VLR_ATR) ) AS SALDOMINUTOS
  ,MINUTOS_VLR_EXT * 0.6 AS MINUTOS_EXT

	  ,CASE WHEN HORAS_EXT > HORAS_ATRASO AND MINUTOS_VLR_EXT < MINUTOS_VLR_ATR THEN (CASE WHEN MINUTOS_VLR_EXT > MINUTOS_VLR_ATR 
	   THEN MINUTOS_VLR_EXT - MINUTOS_VLR_ATR ELSE(60-MINUTOS_VLR_ATR+MINUTOS_VLR_EXT) END)
	   ELSE
	   DATEDIFF(MI,(CONVERT(TIME,CASE WHEN MINUTOS_VLR_EXT > MINUTOS_VLR_ATR THEN '11:' ELSE '10:' END + LEFT(MINUTOS_VLR_EXT,2))),
					 CONVERT(TIME,CASE WHEN MINUTOS_VLR_EXT < MINUTOS_VLR_ATR THEN '10:' ELSE '11:' END + LEFT(MINUTOS_VLR_ATR,2))) 
					 END
		  AS MINUTOS_SALDO

  ,TOTAL_CREDITO = CONVERT(NVARCHAR,HORAS_EXT) +':'+ CASE WHEN LEN(MINUTOS_VLR_EXT)=1 THEN '0'+CONVERT(NVARCHAR,MINUTOS_VLR_EXT) ELSE CONVERT(NVARCHAR,MINUTOS_VLR_EXT)END
  ----------------------------------------------------D�BITO----------------------------------------------------------------
  ,TOTAL_ATRASO = CONVERT(NVARCHAR,HORAS_ATRASO) +':'+ CASE WHEN LEN(MINUTOS_VLR_ATR)=1 THEN '0'+CONVERT(NVARCHAR,MINUTOS_VLR_ATR) ELSE CONVERT(NVARCHAR,MINUTOS_VLR_ATR) END

   FROM CALC
   ),

   TOTAL_GERAL AS(

   SELECT * 
   
   , SALDO_ATUAL = CONVERT(NVARCHAR,SALDO_HORAS) + ':' +  CASE WHEN LEN(MINUTOS_SALDO)=1 THEN '0'+CONVERT(NVARCHAR,MINUTOS_SALDO) ELSE  CONVERT(NVARCHAR,ABS(MINUTOS_SALDO))END

   FROM TOTAIS
   )


   SELECT * FROM TOTAL_GERAL
  
--/ DIVIDA ORIGEM ACORDO /

SELECT	FLAN.CODFILIAL,
		FLAN.CODCFO,
		FACORDO.IDACORDO,
		CASE WHEN FACORDOREL.CLASSIFICACAO = 1 THEN 'LANC_ACORDO'
				WHEN FACORDOREL.CLASSIFICACAO = 2 THEN 'LANC_GERADO'
				ELSE ' VER' END AS TIPO,
				 
		FLAN.PARCELA,
		FLAN.IDLAN, 
		CAST(FLAN.DATAVENCIMENTO AS DATE) DATAVENCIMENTO, 
		
		--/ valor original /
		CAST(FLAN.VALORORIGINAL AS MONEY) VALORORIGINAL, 
		
	--	/ acrescimo /
		CAST((FLAN.VALORJUROSBX + FLAN.VALORMULTABX + FLAN.VALORJUROSACORDO + FLAN.VALORACRESCIMOACORDO + FLAN.VALOROP5) AS MONEY) ACRESCIMO,
		
		--/ desconto /
		CAST((FLAN.VALOROP8 + FLAN.VALOROP4 + FLAN.VALORDESCONTOBX + FLAN.VALORDESCONTOACORDO) AS MONEY) DESCONTO,
		
		--/ total /
		CAST((FLAN.VALORORIGINAL) +
			(FLAN.VALORJUROSBX + FLAN.VALORMULTABX + FLAN.VALORJUROSACORDO + FLAN.VALORACRESCIMOACORDO + FLAN.VALOROP5) -
			(FLAN.VALOROP8 + FLAN.VALOROP4 + FLAN.VALORDESCONTOBX + FLAN.VALORDESCONTOACORDO)
			AS MONEY) TOTAL
				
FROM FACORDO (NOLOCK)
JOIN FACORDOREL (NOLOCK) ON FACORDO.CODCOLIGADA = FACORDOREL.CODCOLIGADA AND FACORDO.IDACORDO = FACORDOREL.IDACORDO
JOIN FLAN (NOLOCK) ON FACORDOREL.CODCOLIGADA = FLAN.CODCOLIGADA AND FACORDOREL.IDLAN = FLAN.IDLAN 

WHERE	FACORDO.IDACORDO = 42927
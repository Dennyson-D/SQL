--SELECT * FROM PEVENTO WHERE RECMODIFIEDON >= '2019-10-07'



SELECT	
	PEVENTO.PROVDESCBASE
	--SUM (VALOR) AS VALOR, PFFINANC.CHAPA
	,*
	FROM 
		PFFINANC (NOLOCK)
	JOIN 
		PEVENTO (NOLOCK)
			ON 
				PFFINANC.CODCOLIGADA = PEVENTO.CODCOLIGADA 
			AND 
				PFFINANC.CODEVENTO = PEVENTO.CODIGO
			WHERE 
				PFFINANC.CHAPA = '051099'
			AND 
				PFFINANC.ANOCOMP = '2019'
			AND 
				PFFINANC.MESCOMP = '10'
			--AND 
				--PEVENTO.PROVDESCBASE = 'P'
			AND 
				PFFINANC.NROPERIODO = 2
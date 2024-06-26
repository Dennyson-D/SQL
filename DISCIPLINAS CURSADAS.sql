/*DISCIPLINAS CURSADAS *******************************************************************************************************************************/
	-- OK
	SELECT	
		DISTINCT 
	 SHABILITACAOFILIAL.CODCOLIGADA
	,SHABILITACAOFILIAL.CODCURSO
	/*,SHABILITACAOFILIAL.IDHABILITACAOFILIAL*/
	,SHABILITACAOFILIAL.CODHABILITACAO
	,SHABILITACAOFILIAL.CODTURNO
	/*,SHABILITACAOFILIAL.CODGRADE*/
	,SHISTDISCCONCLUIDAS.RA
	
	,SHISTDISCCONCLUIDAS.CODPERIODO
	      ,SHISTDISCCONCLUIDAS.CODDISC
	,SHISTDISCCONCLUIDAS.DISCIPLINA
	,SHISTDISCCONCLUIDAS.PLETIVO
	,CAST (SHISTDISCCONCLUIDAS.CH AS NUMERIC(10,2)) AS CH
	,CAST (SHISTDISCCONCLUIDAS.FALTAS AS NUMERIC(10,2)) AS FALTAS
	,CAST (SHISTDISCCONCLUIDAS.NOTA AS NUMERIC(10,2)) AS NOTA
	,SHISTDISCCONCLUIDAS.STATUS
	,SSTATUS.CODEXTERNO
	,dbo.InitCap (PPESSOA.NOME) + ' - ' + dbo.InitCap (stitulacao.nome) as ProfTit
	,AULAS.TOT_AULAS
	
	FROM 
		SHISTDISCCONCLUIDAS (NOLOCK)
	JOIN 
		SHABILITACAOFILIAL (NOLOCK)
			ON 
				SHISTDISCCONCLUIDAS.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
			AND 
				SHISTDISCCONCLUIDAS.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL  
	JOIN 
		SSTATUS (NOLOCK)
			ON 
				SSTATUS.CODCOLIGADA = SHISTDISCCONCLUIDAS.CODCOLIGADA
			AND 
				SSTATUS.CODSTATUS = SHISTDISCCONCLUIDAS.CODSTATUS
				
	JOIN 
		STURMADISC  (NOLOCK)
			ON 
				STURMADISC.CODCOLIGADA = SHISTDISCCONCLUIDAS.CODCOLIGADA
			AND 
				STURMADISC.IDTURMADISC = SHISTDISCCONCLUIDAS.IDTURMADISC
				
	LEFT JOIN			
	(
	SELECT 
		COUNT (*)TOT_AULAS, IDTURMADISC, CODCOLIGADA  
			FROM SPLANOAULA 
				GROUP BY IDTURMADISC, CODCOLIGADA
	)AULAS
		ON 
			AULAS.CODCOLIGADA = STURMADISC.CODCOLIGADA
		AND 
			AULAS.IDTURMADISC = STURMADISC.IDTURMADISC
	JOIN 
		SPROFESSORTURMA (NOLOCK)
			ON 
				SPROFESSORTURMA.CODCOLIGADA = STURMADISC.CODCOLIGADA
			AND 
				SPROFESSORTURMA.IDTURMADISC = STURMADISC.IDTURMADISC
				
	LEFT JOIN 
		SPROFESSOR (NOLOCK) 
			ON
				SPROFESSOR.CODCOLIGADA = SPROFESSORTURMA.CODCOLIGADA
			AND 
				SPROFESSOR.CODPROF = SPROFESSORTURMA.CODPROF
	LEFT JOIN 
		STITULACAO (NOLOCK)
			ON 
				STITULACAO.CODTITULACAO = SPROFESSOR.CODTITULACAO
	JOIN 
		PPESSOA (NOLOCK)
			ON 
				PPESSOA.CODIGO = SPROFESSOR.CODPESSOA
		
			WHERE
				SHISTDISCCONCLUIDAS.CODCOLIGADA = 1/*CODCOLIGADA1*/
			and 				 
				SHISTDISCCONCLUIDAS.RA = '00024091' --@RA
			--AND 
			--	SHISTDISCCONCLUIDAS.IDHABILITACAOFILIAL = 1808 --:idhabilitacaofilial1
			/*AND 
				SHISTDISCCONCLUIDAS.CODPERIODO =2--:CODPERIODO1*/
				
	
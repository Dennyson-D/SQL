/*EQUIVALENTES CONCLUIDAS - HABILITACAOALUNO*************************************************************************/
-- OK
		SELECT 
			 SHISTDISCEQUIVCONCLUIDAS.CODCOLIGADA
			,SHISTDISCEQUIVCONCLUIDAS.IDHABILITACAOFILIAL
			,SHISTDISCEQUIVCONCLUIDAS.RA
			,SHISTDISCEQUIVCONCLUIDAS.PLETIVO
			,SHISTDISCEQUIVCONCLUIDAS.CODDISC AS CODDISC_EQUIVALENTE
			,SHISTDISCEQUIVCONCLUIDAS.DISCIPLINA AS DISC_EQUIVALENTE			
			,SDISCGRUPO_EQUIVALENTE.CODDISC AS CODDISC_GRADE
			,SDISCIPLINA_EQUIVALENTE.NOME AS DISC_GRADE
			,SHISTDISCEQUIVCONCLUIDAS.STATUS
			,SHISTDISCEQUIVCONCLUIDAS.NUMCREDITOS
			,SHISTDISCEQUIVCONCLUIDAS.NOTA
			,SHISTDISCEQUIVCONCLUIDAS.CH			
		    ,0 AS CODPERIODO
		    ,SHISTDISCEQUIVCONCLUIDAS.FALTAS
		    ,'Equivalentes Concluídas' AS TIPOHISTORICO
		    ,dbo.InitCap (PPESSOA.NOME) + ' - ' + dbo.InitCap (stitulacao.nome) as ProfTit
		    ,aulas.TOT_AULAS
		   

			FROM 
		SHISTDISCEQUIVCONCLUIDAS (NOLOCK)/*47 Rows*/
	JOIN 
		SHABILITACAOFILIAL (NOLOCK) 
			ON 
				SHISTDISCEQUIVCONCLUIDAS.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
			AND 
				SHISTDISCEQUIVCONCLUIDAS.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL
	JOIN	
		SEQUIVALENCIAHABILITACAOALUNO (NOLOCK)
			ON 
				SEQUIVALENCIAHABILITACAOALUNO.CODCOLIGADA = SHISTDISCEQUIVCONCLUIDAS.CODCOLIGADA
			AND 
				SEQUIVALENCIAHABILITACAOALUNO.RA = SHISTDISCEQUIVCONCLUIDAS.RA
			AND 
				SEQUIVALENCIAHABILITACAOALUNO.IDHABILITACAOFILIAL =  SHISTDISCEQUIVCONCLUIDAS.IDHABILITACAOFILIAL
			AND 
				SEQUIVALENCIAHABILITACAOALUNO.IDGRUPOEQEQUIV = SHISTDISCEQUIVCONCLUIDAS.GREQUIV
	JOIN 
		SDISCGRUPOEQ (NOLOCK) /*49 Rows*/
			ON 
				SHISTDISCEQUIVCONCLUIDAS.CODCOLIGADA = SDISCGRUPOEQ.CODCOLIGADA 
			AND 
				SHISTDISCEQUIVCONCLUIDAS.GREQUIV  = SDISCGRUPOEQ.IDGRUPO
	 JOIN   
			SDISCGRUPOEQ AS SDISCGRUPO_EQUIVALENTE (NOLOCK)
				ON 
					SDISCGRUPO_EQUIVALENTE.CODCOLIGADA=dbo.SEQUIVALENCIAHABILITACAOALUNO.CODCOLIGADA
				AND 
					SDISCGRUPO_EQUIVALENTE.IDGRUPO=SEQUIVALENCIAHABILITACAOALUNO.IDGRUPOEQ

		 JOIN 
			SDISCIPLINA AS SDISCIPLINA_EQUIVALENTE (NOLOCK)
				ON 					 
					SDISCIPLINA_EQUIVALENTE.CODCOLIGADA = SDISCGRUPO_EQUIVALENTE.CODCOLIGADA
				AND 
					SDISCIPLINA_EQUIVALENTE.CODDISC = SDISCGRUPO_EQUIVALENTE.CODDISC
		
		JOIN 
		STURMADISC  (NOLOCK)
			ON 
				STURMADISC.CODCOLIGADA = SHISTDISCEQUIVCONCLUIDAS.CODCOLIGADA
			AND 
				STURMADISC.IDTURMADISC = SHISTDISCEQUIVCONCLUIDAS.IDTURMADISC
				
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
	LEFT JOIN 
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
	LEFT JOIN 
		PPESSOA (NOLOCK)
			ON 
				PPESSOA.CODIGO = SPROFESSOR.CODPESSOA

					WHERE 						
						SHISTDISCEQUIVCONCLUIDAS.CODCOLIGADA = 1
					AND 
						SHISTDISCEQUIVCONCLUIDAS.RA LIKE '00024091' --@RA
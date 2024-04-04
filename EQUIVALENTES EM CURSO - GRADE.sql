/*EQUIVALENTES EM CURSO - GRADE*************************************************************************/
-- OK
SELECT 
			 SHISTDISCEQUIVEMCURSO.CODCOLIGADA
			,SHISTDISCEQUIVEMCURSO.IDHABILITACAOFILIAL
			,SHISTDISCEQUIVEMCURSO.RA
			,SHISTDISCEQUIVEMCURSO.PLETIVO
			,SHISTDISCEQUIVEMCURSO.CODDISC AS CODDIS_EQUIVALENTE
			,SHISTDISCEQUIVEMCURSO.DISCIPLINA AS DISC_EQUIVALENTE
			,SEQUIVALENCIADISCGRADE.CODDISC AS CODDISC_GRADE
			,dbo.SDISCIPLINA.NOME AS DISC_GRADE
			,SHISTDISCEQUIVEMCURSO.STATUS
			,SHISTDISCEQUIVEMCURSO.NUMCREDITOS
			,SHISTDISCEQUIVEMCURSO.NOTA
			,SHISTDISCEQUIVEMCURSO.CH			
			,SEQUIVALENCIADISCGRADE.CODPERIODO AS CODPERIODO
			,SHISTDISCEQUIVEMCURSO.FALTAS
			,'Equivalentes em Curso' AS TIPOHISTORICO
			,dbo.InitCap (PPESSOA.NOME) + ' - ' + dbo.InitCap (stitulacao.nome) as ProfTit
			,aulas.TOT_AULAS
			
			
	FROM 
		SHISTDISCEQUIVEMCURSO (NOLOCK)/*47 Rows*/
	JOIN 
		SHABILITACAOFILIAL (NOLOCK) 
			ON 
				SHISTDISCEQUIVEMCURSO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA
			AND 
				SHISTDISCEQUIVEMCURSO.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL
	JOIN 
		SDISCGRUPOEQ (NOLOCK) /*49 Rows*/
			ON 
				SHISTDISCEQUIVEMCURSO.CODCOLIGADA = SDISCGRUPOEQ.CODCOLIGADA 
			AND 
				SHISTDISCEQUIVEMCURSO.GREQUIV  = SDISCGRUPOEQ.IDGRUPO

	 JOIN 
		dbo.SEQUIVALENCIADISCGRADE (NOLOCK)
			ON 
				
					SDISCGRUPOEQ.CODCOLIGADA= SEQUIVALENCIADISCGRADE.CODCOLIGADA
				AND 
					SDISCGRUPOEQ.IDGRUPO =SEQUIVALENCIADISCGRADE.IDGRUPOEQEQUIV
				AND 
					SHABILITACAOFILIAL.CODGRADE = SEQUIVALENCIADISCGRADE.CODGRADE
				 AND
					dbo.SDISCGRUPOEQ.CODDISC = SHISTDISCEQUIVEMCURSO.CODDISC
	JOIN 
		SDISCIPLINA (NOLOCK)
			ON 
				dbo.SDISCIPLINA.CODDISC     = dbo.SEQUIVALENCIADISCGRADE.CODDISC 
			AND 
				dbo.SDISCIPLINA.CODCOLIGADA = dbo.SEQUIVALENCIADISCGRADE.CODCOLIGADA
				
	JOIN 
		SPLETIVO (NOLOCK)
			ON 
				SPLETIVO.CODCOLIGADA = SHISTDISCEQUIVEMCURSO.CODCOLIGADA
			AND 
				SPLETIVO.CODPERLET = SHISTDISCEQUIVEMCURSO.PLETIVO
			AND 
				SPLETIVO.CODFILIAL = SHABILITACAOFILIAL.CODFILIAL 
			AND 
				SPLETIVO.CODTIPOCURSO = SHABILITACAOFILIAL.CODTIPOCURSO
	
	JOIN 
		STURMADISC (NOLOCK)
			ON 
				SHISTDISCEQUIVEMCURSO.CODDISC = STURMADISC.CODDISC
			AND 
				SPLETIVO.IDPERLET = STURMADISC.IDPERLET	
			AND 
				STURMADISC.CODFILIAL = SHABILITACAOFILIAL.CODFILIAL 
			AND 
				STURMADISC.CODTIPOCURSO = SHABILITACAOFILIAL.CODTIPOCURSO
				
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
		SMATRICULA (NOLOCK)
			ON 
				SMATRICULA.CODCOLIGADA = STURMADISC.CODCOLIGADA
			AND 
				SMATRICULA.IDTURMADISC = STURMADISC.IDTURMADISC
			AND 
				SMATRICULA.IDPERLET = SPLETIVO.IDPERLET
			AND 
				SMATRICULA.RA = SHISTDISCEQUIVEMCURSO.RA
			
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
				SHISTDISCEQUIVEMCURSO.CODCOLIGADA = 1
			AND 
				SHISTDISCEQUIVEMCURSO.RA LIKE '00024091' --@RA
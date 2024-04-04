SELECT ANALISECURRICULAR.CODDISC,
       ANALISECURRICULAR.DISCIPLINA,
       ANALISECURRICULAR.STATUS,
       ANALISECURRICULAR.PLETIVO,
       ANALISECURRICULAR.NUMCREDITOS,
       ANALISECURRICULAR.CH,
       ANALISECURRICULAR.NOTA,
       ANALISECURRICULAR.FALTAS,
       ANALISECURRICULAR.TIPO,
       ANALISECURRICULAR.CODCOLIGADA,
       ANALISECURRICULAR.IDHABILITACAOFILIAL,
       ANALISECURRICULAR.RA,
       ANALISECURRICULAR.GREQUIV,
       ANALISECURRICULAR.CODPERIODO,
       ANALISECURRICULAR.CONCEITO,
       ANALISECURRICULAR.CONCEITOECTS,
       ANALISECURRICULAR.MINCH,
       ANALISECURRICULAR.MINCREDITOS,
       ANALISECURRICULAR.MINDISCIPLINAS,
       ANALISECURRICULAR.NOME,
       ANALISECURRICULAR.TIPOAVALIACAO
FROM   (SELECT SHISTDISCCONCLUIDAS.CODDISC,
               SHISTDISCCONCLUIDAS.DISCIPLINA,
               SHISTDISCCONCLUIDAS.STATUS,
               SHISTDISCCONCLUIDAS.PLETIVO,
               SHISTDISCCONCLUIDAS.NUMCREDITOS,
               SHISTDISCCONCLUIDAS.CH,
               SHISTDISCCONCLUIDAS.NOTA,
               SHISTDISCCONCLUIDAS.FALTAS,
               'CONC' AS TIPO,
               SHISTDISCCONCLUIDAS.CODCOLIGADA,
               SHISTDISCCONCLUIDAS.IDHABILITACAOFILIAL,
               SHISTDISCCONCLUIDAS.RA,
               SHISTDISCCONCLUIDAS.GREQUIV,
               SHISTDISCCONCLUIDAS.CODPERIODO,
               SHISTDISCCONCLUIDAS.CONCEITO,
               SHISTDISCCONCLUIDAS.CONCEITOECTS,
               NULL   AS MINCH,
               NULL   AS MINCREDITOS,
               NULL   AS MINDISCIPLINAS,
               NULL   AS NOME,
               NULL   AS TIPOAVALIACAO
        FROM   SHISTDISCCONCLUIDAS (NOLOCK)
        WHERE  SHISTDISCCONCLUIDAS.CODCOLIGADA = 1--1
               AND SHISTDISCCONCLUIDAS.RA = '00019164' --'00019164'
               AND SHISTDISCCONCLUIDAS.IDHABILITACAOFILIAL = 1105 --1105
               AND SHISTDISCCONCLUIDAS.CODPERIODO <> 0
        UNION
        SELECT SHISTDISCPENDENTES.CODDISC,
               SHISTDISCPENDENTES.DISCIPLINA,
               SHISTDISCPENDENTES.STATUS,
               SHISTDISCPENDENTES.PLETIVO,
               SHISTDISCPENDENTES.NUMCREDITOS,
               SHISTDISCPENDENTES.CH,
               SHISTDISCPENDENTES.NOTA,
               SHISTDISCPENDENTES.FALTAS,
               'PEND' AS TIPO,
               SHISTDISCPENDENTES.CODCOLIGADA,
               SHISTDISCPENDENTES.IDHABILITACAOFILIAL,
               SHISTDISCPENDENTES.RA,
               SHISTDISCPENDENTES.GREQUIV,
               SHISTDISCPENDENTES.CODPERIODO,
               SHISTDISCPENDENTES.CONCEITO,
               SHISTDISCPENDENTES.CONCEITOECTS,
               NULL   AS MINCH,
               NULL   AS MINCREDITOS,
               NULL   AS MINDISCIPLINAS,
               NULL   AS NOME,
               NULL   AS TIPOAVALIACAO
        FROM   SHISTDISCPENDENTES (NOLOCK)
        WHERE  SHISTDISCPENDENTES.CODCOLIGADA = 1 --1
               AND SHISTDISCPENDENTES.RA = '00019164' --'00019164'
               AND SHISTDISCPENDENTES.IDHABILITACAOFILIAL = 1105 --1105
               AND SHISTDISCPENDENTES.CODPERIODO <> 0

        UNION
        SELECT SHISTDISCOPTELETIVAS.CODDISC,
               SHISTDISCOPTELETIVAS.DISCIPLINA,
               SHISTDISCOPTELETIVAS.STATUS,
               SHISTDISCOPTELETIVAS.PLETIVO,
               SHISTDISCOPTELETIVAS.NUMCREDITOS,
               SHISTDISCOPTELETIVAS.CH,
               SHISTDISCOPTELETIVAS.NOTA,
               SHISTDISCOPTELETIVAS.FALTAS,
               CASE
                 WHEN ( SHISTDISCOPTELETIVAS.CODSTATUSRES IS NOT NULL )
                       OR ( SHISTDISCOPTELETIVAS.STATUS = '*Equiv' ) THEN 'CONC'
                 ELSE 'PEND'
               END AS TIPO,
               SHISTDISCOPTELETIVAS.CODCOLIGADA,
               SHISTDISCOPTELETIVAS.IDHABILITACAOFILIAL,
               SHISTDISCOPTELETIVAS.RA,
               SHISTDISCOPTELETIVAS.GREQUIV,
               SGRUPOOPTELET.CODPERIODO,
               SHISTDISCOPTELETIVAS.CONCEITO,
               SHISTDISCOPTELETIVAS.CONCEITOECTS,
               SGRUPOOPTELET.MINCH,
               SGRUPOOPTELET.MINCREDITOS,
               SGRUPOOPTELET.MINDISCIPLINAS,
               SGRUPOOPTELET.NOME,
               SGRUPOOPTELET.TIPOAVALIACAO
        FROM   SPARAM (NOLOCK)
               JOIN SHISTDISCOPTELETIVAS (NOLOCK)
                 ON ( SPARAM.CODCOLIGADA = SHISTDISCOPTELETIVAS.CODCOLIGADA
                      AND SHISTDISCOPTELETIVAS.CODCOLIGADA = 1 --1
                      AND SHISTDISCOPTELETIVAS.RA = '00019164' --'00019164'
                      AND SHISTDISCOPTELETIVAS.IDHABILITACAOFILIAL = 1105) --1105 )
               JOIN SHABILITACAOFILIAL (NOLOCK)
                 ON ( SHABILITACAOFILIAL.CODCOLIGADA = SHISTDISCOPTELETIVAS.CODCOLIGADA
                      AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SHISTDISCOPTELETIVAS.IDHABILITACAOFILIAL )
               JOIN SGRUPOOPTELET (NOLOCK)
                 ON ( SHABILITACAOFILIAL.CODCOLIGADA = SGRUPOOPTELET.CODCOLIGADA
                      AND SHABILITACAOFILIAL.CODCURSO = SGRUPOOPTELET.CODCURSO
                      AND SHABILITACAOFILIAL.CODHABILITACAO = SGRUPOOPTELET.CODHABILITACAO
                      AND SHABILITACAOFILIAL.CODGRADE = SGRUPOOPTELET.CODGRADE )
               JOIN SDISCGRUPOOPTELET (NOLOCK)
                 ON ( SGRUPOOPTELET.CODCOLIGADA = SDISCGRUPOOPTELET.CODCOLIGADA
                      AND SGRUPOOPTELET.CODCURSO = SDISCGRUPOOPTELET.CODCURSO
                      AND SGRUPOOPTELET.CODHABILITACAO = SDISCGRUPOOPTELET.CODHABILITACAO
                      AND SGRUPOOPTELET.CODGRADE = SDISCGRUPOOPTELET.CODGRADE
                      AND SGRUPOOPTELET.IDGRUPO = SDISCGRUPOOPTELET.IDGRUPO
                      AND SHISTDISCOPTELETIVAS.CODDISC = SDISCGRUPOOPTELET.CODDISC )
               LEFT JOIN SGRADEALUNO (NOLOCK)
                 ON ( SHISTDISCOPTELETIVAS.CODCOLIGADA = SGRADEALUNO.CODCOLIGADA
                      AND SHISTDISCOPTELETIVAS.IDHABILITACAOFILIAL = SGRADEALUNO.IDHABILITACAOFILIAL
                      AND SHISTDISCOPTELETIVAS.RA = SGRADEALUNO.RA )
        WHERE  SPARAM.CODCOLIGADA = 1 --1
               AND SPARAM.CODFILIAL = 18 --:CODFILIAL_N
               AND SPARAM.CODTIPOCURSO = 4 --:CODTIPOCURSO_N
               AND SPARAM.ID = 'USAGRUPOOPTELETIVA'
               AND (SPARAM.TEXTO = '1' OR SPARAM.TEXTO = 'S')
               AND SGRUPOOPTELET.EXIBEANALISE = 'S'
               AND SGRADEALUNO.RA IS NULL
               AND SHISTDISCOPTELETIVAS.RA NOT IN (SELECT SCOMPONENTECURRALUNO.RA
                                                   FROM   SCOMPONENTECURRALUNO (NOLOCK)
                                                   WHERE  SCOMPONENTECURRALUNO.CODCOLIGADA = SHISTDISCOPTELETIVAS.CODCOLIGADA
                                                          AND SCOMPONENTECURRALUNO.IDHABILITACAOFILIAL = SHISTDISCOPTELETIVAS.IDHABILITACAOFILIAL
                                                          AND SCOMPONENTECURRALUNO.RA = SHISTDISCOPTELETIVAS.RA)

        UNION
        SELECT SHISTDISCOPTELETIVAS.CODDISC,
               SHISTDISCOPTELETIVAS.DISCIPLINA,
               SHISTDISCOPTELETIVAS.STATUS,
               SHISTDISCOPTELETIVAS.PLETIVO,
               SHISTDISCOPTELETIVAS.NUMCREDITOS,
               SHISTDISCOPTELETIVAS.CH,
               SHISTDISCOPTELETIVAS.NOTA,
               SHISTDISCOPTELETIVAS.FALTAS,
               CASE
                 WHEN ( SHISTDISCOPTELETIVAS.CODSTATUSRES IS NOT NULL )
                       OR ( SHISTDISCOPTELETIVAS.STATUS = '*Equiv' ) THEN 'CONC'
                 ELSE 'PEND'
               END AS TIPO,
               SHISTDISCOPTELETIVAS.CODCOLIGADA,
               SHISTDISCOPTELETIVAS.IDHABILITACAOFILIAL,
               SHISTDISCOPTELETIVAS.RA,
               SHISTDISCOPTELETIVAS.GREQUIV,
               SGRUPOOPTELETALUNO.CODPERIODO,
               SHISTDISCOPTELETIVAS.CONCEITO,
               SHISTDISCOPTELETIVAS.CONCEITOECTS,
               SGRUPOOPTELETALUNO.MINCH,
               SGRUPOOPTELETALUNO.MINCREDITOS,
               SGRUPOOPTELETALUNO.MINDISCIPLINAS,
               SGRUPOOPTELETALUNO.NOME,
               SGRUPOOPTELETALUNO.TIPOAVALIACAO
        FROM   SPARAM (NOLOCK)
               JOIN SHISTDISCOPTELETIVAS (NOLOCK)
                 ON ( SPARAM.CODCOLIGADA = SHISTDISCOPTELETIVAS.CODCOLIGADA
                      AND SHISTDISCOPTELETIVAS.CODCOLIGADA = 1
                      AND SHISTDISCOPTELETIVAS.RA = '00019164'
                      AND SHISTDISCOPTELETIVAS.IDHABILITACAOFILIAL = 1105 )
               JOIN SGRUPOOPTELETALUNO (NOLOCK)
                 ON ( SHISTDISCOPTELETIVAS.CODCOLIGADA = SGRUPOOPTELETALUNO.CODCOLIGADA
                      AND SHISTDISCOPTELETIVAS.IDHABILITACAOFILIAL = SGRUPOOPTELETALUNO.IDHABILITACAOFILIAL
                      AND SHISTDISCOPTELETIVAS.RA = SGRUPOOPTELETALUNO.RA )
               JOIN SDISCGRUPOOPTELETALUNO (NOLOCK)
                 ON ( SGRUPOOPTELETALUNO.CODCOLIGADA = SDISCGRUPOOPTELETALUNO.CODCOLIGADA
                      AND SGRUPOOPTELETALUNO.IDHABILITACAOFILIAL = SDISCGRUPOOPTELETALUNO.IDHABILITACAOFILIAL
                      AND SGRUPOOPTELETALUNO.RA = SDISCGRUPOOPTELETALUNO.RA
                      AND SGRUPOOPTELETALUNO.IDGRUPO = SDISCGRUPOOPTELETALUNO.IDGRUPO
                      AND SHISTDISCOPTELETIVAS.CODDISC = SDISCGRUPOOPTELETALUNO.CODDISC )
               LEFT JOIN SGRADEALUNO (NOLOCK)
                 ON ( SHISTDISCOPTELETIVAS.CODCOLIGADA = SGRADEALUNO.CODCOLIGADA
                      AND SHISTDISCOPTELETIVAS.IDHABILITACAOFILIAL = SGRADEALUNO.IDHABILITACAOFILIAL
                      AND SHISTDISCOPTELETIVAS.RA = SGRADEALUNO.RA )
        WHERE  SPARAM.CODCOLIGADA = 1--1
		
               AND SPARAM.CODFILIAL = 18--:CODFILIAL_N
               AND SPARAM.CODTIPOCURSO = 4--:CODTIPOCURSO_N
               AND SPARAM.ID = 'USAGRUPOOPTELETIVA'
               AND (SPARAM.TEXTO = '1' OR SPARAM.TEXTO = 'S')
               AND SGRUPOOPTELETALUNO.EXIBEANALISE = 'S'
               AND ( SGRADEALUNO.RA IS NOT NULL
                      OR SHISTDISCOPTELETIVAS.RA IN (SELECT SCOMPONENTECURRALUNO.RA
                                                     FROM   SCOMPONENTECURRALUNO (NOLOCK)
                                                     WHERE  SCOMPONENTECURRALUNO.CODCOLIGADA = SHISTDISCOPTELETIVAS.CODCOLIGADA
                                                            AND SCOMPONENTECURRALUNO.IDHABILITACAOFILIAL = SHISTDISCOPTELETIVAS.IDHABILITACAOFILIAL
                                                            AND SCOMPONENTECURRALUNO.RA = SHISTDISCOPTELETIVAS.RA) )) ANALISECURRICULAR


															

ORDER  BY ANALISECURRICULAR.RA,
          ANALISECURRICULAR.CODPERIODO,
          ANALISECURRICULAR.NOME
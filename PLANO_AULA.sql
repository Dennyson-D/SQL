SET LANGUAGE BRAZILIAN

SELECT 
 IDTD.CODFILIAL
,IDTD.IDTURMADISC
,IDTD.CODTURMA
,PL.CODPERLET
,IDTD.CODDISC
,DISC.NOME AS DISCIPLINA
--,IDTD.CODTURNO
--,IDTD.IDHABILITACAOFILIAL
,PA.AULA
--,PA.IDHORARIOTURMA
,CONVERT(VARCHAR,PA.DATA,103) AS DATA
,HR.HORAINICIAL
,HR.HORAFINAL
,PA.CONTEUDO
,PES.NOME AS PROFESSOR
--,PA.CONFIRMADO

 FROM STURMADISC (NOLOCK) AS IDTD

 JOIN SPLANOAULA (NOLOCK) AS PA ON PA.IDTURMADISC = IDTD.IDTURMADISC

 JOIN SPROFESSORTURMA (NOLOCK) AS PT ON PT.IDTURMADISC = IDTD.IDTURMADISC

 JOIN SPROFESSOR (NOLOCK) AS PROF  ON PROF.CODPROF = PT.CODPROF

 JOIN PPESSOA (NOLOCK) AS PES ON PES.CODIGO = PROF.CODPESSOA

 JOIN SHORARIO (NOLOCK) AS HR ON HR.CODHOR = PA.CODHOR

 JOIN SPLETIVO (NOLOCK) AS PL ON PL.IDPERLET = IDTD.IDPERLET

 JOIN SDISCIPLINA (NOLOCK) AS DISC ON DISC.CODDISC = IDTD.CODDISC

 WHERE IDTD.CODTURMA = 'EM1MA' AND DISC.NOME LIKE '%MATEMATICA%' AND CODPERLET = '2019' AND IDTD.CODFILIAL = 21

 ORDER BY PROFESSOR,AULA
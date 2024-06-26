
IF OBJECT_ID('tempdb.dbo.##HIST', 'U') IS NOT NULL
  DROP TABLE ##HIST;

SELECT * INTO ##HIST


FROM
(
SELECT DISTINCT
  HDC.CODCURSOHIST
, HDC.RA
, HDC.ANO
, HDC.CODDISCHIST
, D.NOME AS DISCIPLINA
, HDC.CODSERIEHIST
, CASE HDC.CODPARTEHIST WHEN 1 THEN 'COMUM' WHEN 2 THEN 'DIVERSIFICADA' END AS BASE_NACIONAL
, HDC.POSICAO
, HDC.NOTA
, HDC.FALTAS
, HDC.CODSTATUS
, HAC.CARGAHORARIA
, HAC.DIASLETIVOS
, HAC.DIRETOR
, I.NOME AS INSTITUICAO
, HAC.CODSERIEHIST AS SERIE


 FROM SHISTDISCCOL AS HDC

LEFT JOIN SDISCIPLINA AS D ON D.CODDISCHIST = HDC.CODDISCHIST AND CODTIPOCURSO = 12
LEFT JOIN SHISTALUNOCOL AS HAC ON HAC.RA = HDC.RA AND HAC.ANO = HDC.ANO AND HAC.CODCURSOHIST = HDC.CODCURSOHIST AND HAC.CODSERIEHIST = HDC.CODSERIEHIST
LEFT JOIN SINSTITUICAO AS I ON I.CODINST = HAC.CODINST

WHERE HDC.RA= '00025908'
) AS AAA




--  SELECT * FROM ##HIST
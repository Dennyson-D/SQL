SELECT * FROM(
 SELECT M.RA
 ,NOME
,P.CODPERLET
,PAR.PARCELA
,CONVERT(SMALLMONEY,PAR.VALOR) AS VALOR

FROM SMATRICPL M (NOLOCK)

JOIN SPLETIVO P (NOLOCK) ON P.IDPERLET = M.IDPERLET
JOIN SPARCELA PAR (NOLOCK) ON PAR.RA = M.RA AND PAR.IDPERLET = M.IDPERLET AND TIPOPARCELA = 'P'
JOIN SALUNO AL (NOLOCK) ON AL.RA = M.RA
JOIN PPESSOA PE (NOLOCK) ON PE.CODIGO = AL.CODPESSOA

WHERE M.CODFILIAL = 5 AND CODPERLET IN ('2018','2019') AND CODSERVICO = 1


) AS A

PIVOT (MAX(VALOR) FOR PARCELA IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])       --CODPERLET IN ([2018/1],[2018/2],[2019/1],[2019/2]) 

) AS COL

ORDER BY 2

--SELECT * FROM GLINKSREL WHERE MASTERTABLE = 'SCONTRATO'



--SELECT * FROM SCONTRATO WHERE CODCONTRATO IN(173203,183929)

--SELECT * FROM SPARCELA WHERE RA= '00000730' AND IDPERLET = 265


--SELECT * FROM SMATRICPL (NOLOCK) WHERE RA= '00025535'

SELECT * FROM SLOGPLETIVO 

JOIN SSTATUS ON SLOGPLETIVO.CODSTATUS = SSTATUS.CODSTATUS AND CODTIPOCURSO = 12

WHERE RA= '00025626' AND IDPERLET = 269


--  SELECT TOP 1 * FROM SLOGPLETIVO 
--SELECT TOP 1 * FROM SSTATUS
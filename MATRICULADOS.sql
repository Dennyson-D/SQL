SET LANGUAGE PORTUGU�S

SELECT CODTURMA,RA,DTMATRICULA,SSTATUS.DESCRICAO FROM SMATRICPL

JOIN SSTATUS ON SSTATUS.CODSTATUS = SMATRICPL.CODSTATUS
JOIN SPLETIVO ON SPLETIVO.IDPERLET = SMATRICPL.IDPERLET

WHERE CODTURMA LIKE '%SCHOOL%' AND SPLETIVO.CODPERLET = '2018' --AND SSTATUS.DESCRICAO LIKE '%MAT%' AND DTMATRICULA <= '14/02/2018'


--SELECT * FROM SMATRICPL WHERE RA = '00024258'


SELECT ROW_NUMBER() OVER(PARTITION BY IDTURMADISC ORDER BY IDTURMADISC) AS N,* FROM SLOGMATRICULA WHERE RA='00005613' --AND IDTURMADISC = '45539' -- EF9MD


--SELECT * FROM SSTATUS WHERE CODSTATUS = 8 TRANSFERIDO

--SELECT * FROM STURMADISC  WHERE IDTURMADISC = 45539


SELECT * FROM SLOGMATRICULA WHERE RA= '00013255' AND DTALTERACAO LIKE '%2018%' AND CODSTATUS=11


SELECT * FROM SSTATUS WHERE CODSTATUS IN (11,8,173)



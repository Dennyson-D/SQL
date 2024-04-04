/* TIRAR VISUALIZAÇÃO DE TODAS AS NOTAS DAS FILIAIS*/

/*
   EXIBENAWEB = 'S' - HABILITAR NO PORTAL
   EXIBENAWEB = 'N' - TIRAR DO PORTAL
   ALTERAR O TIPOETAPA PARA O STATUS ATUAL E O EXIBENAWEB PARA O STATUS DESEJADO
*/

/*********  INICIO  **********/
BEGIN TRAN

UPDATE SETAPAS SET EXIBENAWEB = 'S' WHERE IDTURMADISC IN (SELECT IDTURMADISC FROM STURMADISC 
                                                         JOIN SPLETIVO ON SPLETIVO.IDPERLET = STURMADISC.IDPERLET
														 WHERE STURMADISC.CODFILIAL = 21 AND SPLETIVO.CODPERLET = '2020' /*AND CODTURMA LIKE 'EF%'*/) 
                                          AND TIPOETAPA = 'N'

----  ROLLBACK
----  COMMIT

/*********  FIM  **********/



/**************CONFERENCIA**************/

--SELECT SETAPAS.CODETAPA,STURMADISC.IDTURMADISC,SETAPAS.EXIBENAWEB FROM STURMADISC 
--JOIN SETAPAS ON SETAPAS.IDTURMADISC = STURMADISC.IDTURMADISC AND TIPOETAPA= 'N'
--JOIN SPLETIVO ON SPLETIVO.IDPERLET = STURMADISC.IDPERLET
--WHERE STURMADISC.CODFILIAL = 21 AND SPLETIVO.CODPERLET = '2020'


/****TESTES*****/

--SELECT * FROM SETAPAS WHERE IDTURMADISC= 72144

--SELECT * FROM SPLETIVO WHERE CODPERLET ='2020' AND CODFILIAL = 5

--SELECT * FROM GLINKSREL WHERE MASTERTABLE = 'SETAPAS'
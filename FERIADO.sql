SELECT * FROM GCALEND WHERE GCALEND.CODIGO LIKE '%30%'

/*begin tran
insert into GTPFERIADO (CODCLIENTE,CODINTERNO,DESCRICAO,PODEALTERAR) values ('0005','0005','F�RIAS',1)*/
select * from GTPFERIADO --TFFERIADO WHERE CODCALENDARIO LIKE '%30%'

select * FROM GCAMPOS WHERE TABELA = 'TFFERIADO'


SELECT * FROM TFFERIADO


SELECT * FROM SMATRICPL WHERE CODFILIAL = 19 --AND IDPERLET = 266


SELECT * FROM SPLETIVO WHERE CODPERLET='2019' AND CODFILIAL = 19
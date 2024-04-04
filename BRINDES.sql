select * from smatricpl where ra='00026200'


select * from SSTATUS where CODSTATUS = 5

select idmov,tmov.CODTMV,tmov.CODFILIAL,ttmv.NOME from tmov 
join TTMV on ttmv.codtmv = tmov.codtmv

where tmov.CODTMV = '1.2.00'
group by tmov.CODTMV,tmov.codfilial,ttmv.NOME,tmov.idmov   --where codtmv =  '1.2.00'

order by tmov.idmov,tmov.codtmv
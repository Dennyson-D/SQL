select 
	x.codcoligada,
	x.codfilial,
	x.chapa,
	x.nome,
	x.codsituacao,
	x.funcao,
	x.codsecao,
	x.descricao,
	x.dataadmissao,
	x.inicioperaquis,
	x.fimperaquis,

          
case	
				WHEN CONVERT(VARCHAR,X.FIMPERAQUIS,103) > CONVERT(VARCHAR,GETDATE(),103) THEN 0
                when count(x.nrodiasferias) <=1 and sum(x.diasparcial)+sum(x.nrodiasferias)=30 and sum(x.faltas) is null then ISNULL(sum(x.diasparcial),0)
                when count(x.nrodiasferias) <=1 and sum(x.diasparcial)+sum(x.nrodiasferias)>30 and sum(x.faltas) is null then ISNULL(sum(x.diasparcial),0)
        	when count(x.nrodiasferias) <=1 and (sum(x.diasparcial)+sum(x.nrodiasferias)=30 and sum(x.faltas) <=5) then ISNULL(sum(x.diasparcial),0)
                when count(x.nrodiasferias) >=2 and sum(x.diasparcial)=30 then ISNULL(sum(x.diasparcial) - sum(x.nrodiasferias),0)
                when count(x.nrodiasferias) >=2 and sum(x.nrodiasferias)<30 then ISNULL((sum(x.provisaodias)-30) - sum(x.nrodiasferias),0)
else ISNULL(sum(x.provisaodias),0) end provisaodias, --- CONFERIR

	sum(x.nrodiasferias)nrodiasferias,

case        when sum(x.diasparcial)<=30 then sum(x.diasparcial) else null end diasparcial,
	
                sum(x.faltas)faltas,
case        when count(x.nrodiasferias)>=2  then count(x.nrodiasferias) else null end,
	x.limite,
	x.alerta


from

(

select distinct
	a.codcoligada,
	a.chapa,
	a.nome,
	a.codfilial,
	a.codsituacao,
    e.nome as funcao,
	a.codsecao,
	c.descricao,
	a.dataadmissao,
	b.inicioperaquis,
	b.fimperaquis,
	d.nrodiasferias,
	case when (cast(b.fimperaquis+1-b.inicioperaquis as int)/12)<=30 and (cast(b.fimperaquis+1-b.inicioperaquis as int)/12) - (cast(d.datafim-d.datainicio as int))>0 then ((cast(b.fimperaquis+1-b.inicioperaquis as int)/12) - (cast(d.datafim-d.datainicio as int))-1) + isnull(d.nrodiasferiado,0)
                        when (cast(b.fimperaquis+1-b.inicioperaquis as int)/12)>=31 and (cast(b.fimperaquis+1-b.inicioperaquis as int)/12) - (cast(d.datafim-d.datainicio as int))>0 then (30 - (cast(d.datafim-d.datainicio as int))-1) + isnull(d.nrodiasferiado,0)
	         when (cast(GETDATE ( ) +1 -b.inicioperaquis as int)/12) >=30 then 30
	else
	null end diasparcial,

 (

select 

	case when sum(dias)<1 then null else round(sum(dias),1) end

from

(

select

case when v.valhordiaref ='D'then sum(f.ref) else sum(f.ref) / (cast(z.jornadamensal/60 as numeric)/30) end as dias --CONFERIR 3

from pffinanc f join pevento v on
	f.codcoligada = v.codcoligada and
	f.codevento = v.codigo
		join pfuferias u on
		f.codcoligada = u.codcoligada and
		f.chapa = u.chapa and
		u.periodoaberto=1
			join pfunc z on
			f.codcoligada = z.codcoligada and
			f.chapa = z.chapa

 where 
 	
	v.codigocalculo=8
and v.valhordiaref in ('H','D')
and f.codcoligada=1
and f.chapa=b.chapa
and ((f.mescomp>=month(b.inicioperaquis) and f.anocomp=year(b.inicioperaquis)) or (f.mescomp<=month(b.fimperaquis)and f.anocomp=year(b.fimperaquis)))

group by 

z.jornadamensal,

valhordiaref

)x

 ) faltas,	

 (

select 

	case         when round(sum(dias),1) >5.5 and round(sum(dias),1) <15  and d.nrodiasferias >0 then 24 - d.nrodiasferias 
		 when round(sum(dias),1) >14.5 and round(sum(dias),1) <24 and d.nrodiasferias >0 then 18 - d.nrodiasferias 
		 when round(sum(dias),1) >23.5 and round(sum(dias),1) <33 and d.nrodiasferias >0 then 12 - d.nrodiasferias 
		 when round(sum(dias),1) >5.5 and round(sum(dias),1) <15  and d.nrodiasferias is null then 24 -- CONFERIR 2
		 when round(sum(dias),1) >14.5 and round(sum(dias),1) <24 and d.nrodiasferias is null then 18
		 when round(sum(dias),1) >23.5 and round(sum(dias),1) <33 and d.nrodiasferias is null then 12
	     when round(sum(dias),1) >32.5 then 0 
	     when (cast(GETDATE ( ) +1 -b.inicioperaquis as int)/12) >=30 then 30
    else null end

from

(

select

case when v.valhordiaref ='D'then sum(f.ref) else sum(f.ref) / (cast(z.jornadamensal/60 as numeric)/30) end as dias

from pffinanc f join pevento v on
	f.codcoligada = v.codcoligada and
	f.codevento = v.codigo
		join pfuferias u on
		f.codcoligada = u.codcoligada and
		f.chapa = u.chapa and
		u.periodoaberto=1
			join pfunc z on
			f.codcoligada = z.codcoligada and
			f.chapa = z.chapa

 where 
 	
	v.codigocalculo=8
and v.valhordiaref in ('H','D')
and f.codcoligada=1
and f.chapa=b.chapa
and ((f.mescomp>=month(b.inicioperaquis) and f.anocomp=year(b.inicioperaquis)) or (f.mescomp<=month(b.fimperaquis)and f.anocomp=year(b.fimperaquis)))

group by 

z.jornadamensal,
valhordiaref

)x

 ) provisaodias,	


                 b.fimperaquis+320 as limite,
	
	case 
                        when (getdate() > b.fimperaquis+320 and getdate() <= b.fimperaquis+364) and d.datainicio is null then 'alerta: faltam menos de 45 dias para vencimento do 2º período'
                        when getdate() > b.fimperaquis+365 and d.datainicio is null then 'alerta: Funcionário com o 2º período Vencido'
	else null
	end as alerta,
                d.dataaviso,
                d.datapagto,
                d.datainicio,
                d.datafim,
	
	case when d.nrodiasabono<>0 then 'SIM' else null end abono1,
    case when d.nrodiasabono<>0 then d.nrodiasabono else null end abono2,
	case when d.nrodiasabono<>0 then d.datafim+1 else null end abono3,
	case when d.nrodiasabono<>0 then d.datafim+d.nrodiasabono else null end abono4,
	case when d.paga1aparc13o=1 then 'SIM'else null end as paga1aparc13o


from pfunc a left join pfuferias b on
	 a.codcoligada = b.codcoligada and
	 a.chapa = b.chapa
	 	left join psecao c on
	 	a.codcoligada = c.codcoligada and
	 	a.codsecao = c.codigo
	 		left join pfuferiasper d on 
	 		b.codcoligada = d.codcoligada and
	 		b.chapa = d.chapa and
	 		b.fimperaquis = d.fimperaquis
					left join pfuncao e on
 	 	            a.codcoligada = e.codcoligada and
					a.codfuncao = e.codigo


where 
a.codcoligada = 1 and
a.codtipo not in ('D','T') and
a.codsituacao <>'D' and
b.periodoaberto = 1 AND
A.CHAPA = 210021 -- 190031 --'190076'--:CHAPA1
   
)x

group by

	x.chapa,
	x.nome,
	x.codsituacao,
	x.funcao,
	x.codsecao,
	x.descricao,
	x.dataadmissao,
	x.inicioperaquis,
	x.fimperaquis,
	x.limite,
	x.alerta,
	x.codfilial,
	x.codcoligada
		,X.diasparcial
		,X.NRODIASFERIAS
		,X.alerta

order by 11
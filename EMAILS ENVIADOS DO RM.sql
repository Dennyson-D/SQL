SELECT * FROM GMAILSEND 
WHERE 

--SENDTIME BETWEEN '2021-01-08' AND '2021-01-09' --AND 
--CODUSUARIO= '180733'
CONVERT(VARCHAR,TOADDR) LIKE '%rubia.pontili@gmail.com%'


--/*sender = 'Colégio São José' AND*/ SENDTIME BETWEEN '2020-09-03 00:00' AND '2020-09-03 23:59'

--AND TOADDR LIKE 'marcos@alarmforce.com.br' --OR TOADDR LIKE 'ka_cz@hotmail.com'
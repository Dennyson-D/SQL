 SET LANGUAGE PORTUGU�S
/*--------------------------------------CONTRATANTE---------------------------------------------------------------------------- */
/*
SELECT 
NOME+CHAR(13)+CHAR(10)+NOMEFANTASIA AS NOMES,
NOME +' - '+ NOMEFANTASIA+', CNPJ n� '+CGC+', situada a '+RUA+', n� '+NUMERO+', '+BAIRRO+', '+CIDADE+'/'+ESTADO+'.'  AS CONTRATANTE
,FORMAT(GETDATE(),'D') AS DATA
,CIDADE
FROM GFILIAL
 WHERE CODFILIAL = 18--:CODFIL
 */
/*------------------------------------------------------------------------------------------------------------------------------ */



 /*--------------------------------------CONTRATADO---------------------------------------------------------------------------- */
SELECT TOP 1 
(PFUNC.NOME+', '+PFUNCAO.NOME+', CPF: '+CASE WHEN LEN(PPESSOA.CPF)=11 THEN substring(PPESSOA.CPF ,1,3) + '.' + substring(PPESSOA.CPF ,4,3) + '.' + substring(PPESSOA.CPF ,7,3) + '-' + substring(PPESSOA.CPF ,10,2) ELSE PPESSOA.CPF END 
+', CTPS n� '+PPESSOA.CARTEIRATRAB+', s�rie:'+PPESSOA.SERIECARTTRAB+'/' + CHAR(13) 
+PPESSOA.UFCARTTRAB+', residente na '+PPESSOA.RUA+', n� '+PPESSOA.NUMERO+' '+PPESSOA.COMPLEMENTO+', '+PPESSOA.BAIRRO+', '+PPESSOA.CIDADE+'/'+PPESSOA.ESTADO+'.') AS CONTRATADO

,PFUNC.CODFILIAL
 FROM PFUNC 

JOIN PPESSOA ON PFUNC.CODPESSOA = PPESSOA.CODIGO
JOIN PFUNCAO ON PFUNCAO.CODIGO = PFUNC.CODFUNCAO
WHERE CHAPA =180693  OR PFUNC.NOME LIKE '%GIOVANA MARIA DE OLIVEIRA%' AND CODSITUACAO ='A'
--------------------------------------------------------------------------------------------------------------------------------------------------------


/*--------------------------------------TESTEMUNHAS---------------------------------------------------------------------------- */
/*
  SELECT TOP 1 NOME
  ,CASE WHEN CHARINDEX('-',CARTIDENTIDADE,1)=0 AND CHARINDEX('.',CARTIDENTIDADE,1)=0  THEN CONVERT(VARCHAR,FORMAT(CONVERT(DECIMAL,(SUBSTRING(CARTIDENTIDADE,1,LEN(CARTIDENTIDADE)-1))),'#,0.','PT-BR'))
   + CONVERT(VARCHAR,RIGHT(FORMAT(CONVERT(DECIMAL,(CARTIDENTIDADE)),'##############-#','PT-BR'),2))
   ELSE CARTIDENTIDADE END 
   +'/'+ UFCARTIDENT
   AS IDENTIDADE
   
  FROM PPESSOA WHERE CARTIDENTIDADE IS NOT NULL AND  NOME LIKE '%DIEGO ARAUJO DOS SANTOS%' --CODUSUARIO LIKE '%DIEGO%'

  --SELECT CARTIDENTIDADE,* FROM PPESSOA WHERE NOME LIKE '%DIEGO ARA�JO%' 

  --FORMAT(CONVERT(DECIMAL,(CARTIDENTIDADE)),'#,000.','PT-BR')
  --FORMAT(CONVERT(DECIMAL,(CARTIDENTIDADE)),'##############-#','PT-BR')
  */
/*----------------------------------------------------------------------------------------------------------------------------- */






--SELECT * FROM PFUNC WHERE CODPESSOA=16015  -- CHAPA=180693

--SELECT CARTIDENTIDADE,* FROM PPESSOA WHERE   CARTIDENTIDADE IS NOT NULL --CODIGO = 96957

--SELECT * FROM PFUNCAO  WHERE CODIGO = 0274

--SELECT FORMAT(CONVERT(MONEY,(/*CARTIDENTIDADE*/'123456789')),'#######-#') FROM PPESSOA WHERE CODUSUARIO LIKE '%DENNYSON%'

--SANTO CANDEU
--MARIA LIDIA DOS SANTOS STAVITZKI
--SIRLEY TEREZINHA FILIPAK
DECLARE @COD_ACC_SISTEMA AS VARCHAR(50) = '63843900949'  -- CÓDIGO DE ACESSO AO SISTEMA Este é mesmo código que é informado para acessar o sistema (código da contabilidade)
DECLARE @ASP AS VARCHAR = ''''
DECLARE @VAZIO AS VARCHAR = @ASP+@ASP
DECLARE @LINHAS AS VARCHAR
DECLARE @CONTA_N AS INT 
DECLARE @DATA_EMISSAO AS DATE = '01/01/2018'  -- ESCOLHER DATA EMISSAO
DECLARE @DATA_FIM AS DATE = GETDATE()         -- ESCOLHER DATA FINAL
DECLARE @FILIAL AS VARCHAR(2) = 21             -- ESCOLHER FILIAL

SET DATEFORMAT DMY
SET LANGUAGE PORTUGUÊS

 
/*------------------------------------------------------------------REGISTRO HEADER INICIO----------------------------------------------------------------------------------------------------------------------*/
; WITH TAB_H AS
(
SELECT 
1 AS TIPOREGISTRO,
1 AS TPIDENTIFICACAO,
CONVERT(BIGINT,(SELECT REPLACE(REPLACE(REPLACE(CGC,'-',''),'.',''),'/','') AS CNPJ FROM TFFILIAL WHERE CODFILIAL = @FILIAL)) AS CNPJ,
'00000000' AS Ccm,
'02' AS VERSAOLAYOUT
,' ' AS FILLER 
 ),
/*------------------------------------------------------------------REGISTRO HEADER FIM----------- --------------------------------------------------------------------------------------------------------------*/



/*------------------------------------------------------------------REGISTROS DETALHE NF COMEÇO----------------------------------------------------------------------------------------------------------------------*/

 TAB_N AS
  
 (
 SELECT 
 1 AS TIPODEREGISTRO,
 TMV.NUMEROSEQUENCIAL AS SEQUENCIALNF, --ROW() OVER()
 ISNULL(REPLICATE('0', 8 - LEN(MV.NUMEROMOV))+ MV.NUMEROMOV,'00000000') AS NF, --,MV.SERIE,MV.TIPO,GF.CGC,MV.VALORBRUTO,TMV.IDPRD 
 1 AS SITUACAONF,
 REPLACE(CONVERT(VARCHAR,MV.DATAEMISSAO,103),'/','') AS DATAEMISSAO,
 LEFT(REPLACE(REPLACE(GF.CODATIVFED,'.',''),'-',''),6) AS CODATIVIDADE, --**************************VERIFICAR  
 MV.CODIGOSERVICO AS CFPS, --**************************VERIFICAR  MV.CODTB1FAT
 MV.SERIE,
 REPLACE (REPLACE(REPLACE(FCFO.CGCCFO,'/',''),'.',''),'-','') AS CNPJCPF,
 FCFO.NOME AS TOMADOR,
 ISNULL(FCFO.CEP,0) AS CEP,
 UPPER(ISNULL((FCFO.RUA +' Nº '+ FCFO.NUMERO),'')) AS ENDERECO,
 UPPER(ISNULL(FCFO.BAIRRO,'')) AS BAIRRO,
 UPPER(ISNULL(FCFO.CIDADE,'')) AS CIDADE,
 UPPER(ISNULL(FCFO.CODETD,'')) AS ESTADOS,

 UPPER(ISNULL((FCFO.RUAPGTO +' Nº '+ FCFO.NUMEROPGTO + ' BAIRRO ' + FCFO.BAIRROPGTO + ' '+ FCFO.CIDADEPGTO +'-'+ FCFO.CODETDPGTO), 
 (ISNULL(FCFO.RUA,'')+' Nº '+ ISNULL(FCFO.NUMERO,'') + ' BAIRRO ' + ISNULL(FCFO.BAIRRO,'') + ' '+ ISNULL(FCFO.CIDADE,'') +'-'+ ISNULL(FCFO.CODETD,'')))) AS ENDERECOCOBRANCA,

 ISNULL(FCFO.EMAIL,'') AS EMAIL,
 'N' AS ENVIARNFPOREMAIL,
 'N' AS IMPRETIDO,
  MV.VALORLIQUIDO AS VLRSERVICO,
  0 VLRDEDUCOES,
  0 VLRIMPOSTO,
  0 ALIQUOTA,
  MV.VALORLIQUIDO AS VLRTOTALNOTA,
  0 VLRCOFINS,
  0 VLRPIS,
  0 VLRIRRF,
  0 VLRINSS,
  0 VLRCSLL,
  0 RPS,
  'F' MODELO,
  MV.CAMPOLIVRE1 OBSERVACAO,


  ---------------------------------ddddddddddddddddddddddddddddddddddd**--------------------------------------------------------------------------------
	   FROM TMOV MV (NOLOCK)
	   JOIN GFILIAL GF (NOLOCK) ON (GF.CODFILIAL = MV.CODFILIAL)
	   LEFT JOIN TITMMOV TMV ON (TMV.IDMOV = MV.IDMOV)
	   LEFT JOIN FCFO ON MV.CODCFO = FCFO.CODCFO

	   WHERE MV.DATAEMISSAO BETWEEN @DATA_EMISSAO AND @DATA_FIM AND MV.CODFILIAL = @FILIAL
	   GROUP BY MV.IDMOV,MV.DATAEMISSAO,MV.NUMEROMOV,MV.SERIE,MV.TIPO,GF.CGC,MV.VALORBRUTO,TMV.IDPRD
	   

	   
),

CONTA_NN AS
(
SELECT COUNT(*) AS CONTA,(SUM(CAST(VALORBRUTO AS DECIMAL(18,2)))) AS VALBRUTO FROM TAB_N
),

 /*------------------------------------------------------------------REGISTROS DETALHE NF FIM------------------------------------------------------------------------------------------------------------------------*/


/*------------------------------------------------------------------REGISTROS I INICIO----------------------------------------------------------------------------------------------------------------------*/
  TAB_I AS
  (
  SELECT  CONVERT(VARCHAR,(CONVERT(VARCHAR,C.IDMOV)+'/'+CONVERT(VARCHAR,C.NUMEROSEQUENCIAL))) AS UM, (@ASP+'3'+','+@ASP+'I'+@ASP+','+CONVERT(VARCHAR,C.IDPRD)+','+CONVERT(VARCHAR,CAST(C.VALORLIQUIDO AS DECIMAL(18,2)))+','+'0'+','+'0'+','+'0')AS REGISTRO /* REGISTRO I*/
  FROM (SELECT MV.IDMOV,MV.NUMEROMOV,MV.DATAEMISSAO,MV.SERIE,MV.TIPO,GF.CGC,TMV.VALORLIQUIDO,TMV.IDPRD,TMV.NUMEROSEQUENCIAL
 
		FROM TMOV MV (NOLOCK)
		JOIN GFILIAL GF (NOLOCK) ON (GF.CODFILIAL = MV.CODFILIAL)
		LEFT JOIN TITMMOV TMV ON (TMV.IDMOV = MV.IDMOV)
		WHERE MV.DATAEMISSAO BETWEEN @DATA_EMISSAO AND @DATA_FIM AND MV.CODFILIAL = @FILIAL /*AND MV.IDMOV=TMV.IDMOV*/

		GROUP BY MV.DATAEMISSAO,MV.NUMEROMOV,MV.SERIE,MV.TIPO,GF.CGC,TMV.VALORLIQUIDO,TMV.IDPRD,MV.IDMOV,TMV.NUMEROSEQUENCIAL

  ) AS C
   
   ),
/*------------------------------------------------------------------REGISTROS I FIM------------------------------------------------------------------------------------------------------------------------*/
 

 
 /*-----------------------------------------------------------------REGISTROS T INICIO----------------------------------------------------------------------------------------------------------------------*/

 TAB_T AS
 (
  SELECT CONVERT(VARCHAR,'Z') AS UM,(@ASP+'3'+@ASP+','+@ASP+'T'+@ASP+','+CONVERT(VARCHAR,N.CONTA)+','+CONVERT(VARCHAR,N.CONTA)+','+CONVERT(VARCHAR,CAST(N.VALBRUTO AS DECIMAL(18,2)))+','+'0'+','+'0'+','+'0'+',' 
  +'0'+','+CONVERT(VARCHAR,N.VALBRUTO) +','+'0'   )AS REGISTRO /*REGISTRO T*/
  FROM CONTA_NN N

  GROUP BY N.CONTA,N.VALBRUTO
 ),


 TAB_TOTAL AS 
 (SELECT UM,REGISTRO FROM TAB_H
 UNION
 SELECT UM,REGISTRO FROM TAB_N
 UNION
 SELECT UM,REGISTRO FROM TAB_I
 UNION 
 SELECT UM,REGISTRO FROM TAB_T
  GROUP BY UM,REGISTRO
 )

 SELECT REGISTRO FROM TAB_TOTAL
 
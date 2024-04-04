USE [CORPORERM]
GO

DECLARE @RC int
DECLARE @IDLAN int
DECLARE @STATUS INT

-- TODO: Set parameter values here.

 SET @IDLAN = 1741163
/*1730516,
1730517,
1730518,
1730519,
1730520,
1730521*/
 
 SET @STATUS = 1  --  1 -  Remetido		2 -  Registrado	

EXECUTE @RC = [dbo].[SP_UP_CNAB_LAN_BOL] 
   @IDLAN
  ,@STATUS

GO
---------------------------------------------------------------------------------------------------------------------------------------
-- APENAS VERIFICAÇÃO DE STATUS
/*
    SELECT FLAN.IDLAN,FLAN.CNABSTATUS,FLANBOLETO.IDBOLETO,FBOLETO.CNABSTATUS AS CNABBOL FROM FLAN
	JOIN FLANBOLETO ON FLANBOLETO.IDLAN = FLAN.IDLAN
	JOIN FBOLETO ON FBOLETO.IDBOLETO = FLANBOLETO.IDBOLETO
	 WHERE FLAN.IDLAN =  1676334   @IDLAN
*/


	 	/*
	************ CNAB STATUS BOLETO ************     ************ CNAB STATUS FLAN ************
	0 -  Não Remetido								 0 - Não Remetido 
	1 -  Remetido									 1 - Remetido	
	2 -  Registrado									 2 - Registrado
	3 -  Recusado									 3 - Recusado
	4 -  Baixado									 4 - Baixado
	5 -  Registrado Online							 5 - Cancelado
	6 -  Cancelado
	7 -  Pendente Remessa
	*/
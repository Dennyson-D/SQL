--  USE CORPORERM

--  GO 

--  ALTER PROCEDURE SP_UP_CNAB_LAN_BOL
  
--  /*
--   ATUALIZAR STATUSCNAB FLAN E FBOLETO PARA REMETIDO
--  */

--   @IDLAN AS INT
   
--   AS

--UPDATE FLAN SET CNABSTATUS = 1 
--	WHERE FLAN.IDLAN = @IDLAN

-----------------------------------------------------------------------------------------------------------------------------------------
---- UPDATE FBOLETO
--	UPDATE FBOLETO SET CNABSTATUS = 1 WHERE FBOLETO.IDBOLETO IN (

--	SELECT FB.IDBOLETO FROM FLAN 

--	LEFT JOIN FLANBOLETO FB ON FB.IDLAN = FLAN.IDLAN

--	WHERE FLAN.IDLAN = @IDLAN
--	) 
--	COMMIT
-----------------------------------------------------------------------------------------------------------------------------------------
---- APENAS VERIFICAÇÃO DE STATUS
--	SELECT FLAN.IDLAN,FLAN.CNABSTATUS,FLANBOLETO.IDBOLETO,FBOLETO.CNABSTATUS AS CNABBOL FROM FLAN
	
--	JOIN FLANBOLETO ON FLANBOLETO.IDLAN = FLAN.IDLAN
--	JOIN FBOLETO ON FBOLETO.IDBOLETO = FLANBOLETO.IDBOLETO
--	 WHERE FLAN.IDLAN =  @IDLAN
	 

	  EXECUTE SP_UP_CNAB_LAN_BOL ('VAL1,VA2')
--BEGIN TRAN  -- FLAN CNABSTATUS = 1 / FBOLETO CNABSTATUS = 1  (REMETIDO)

DECLARE @IDLAN AS INT

-- UPDATE FLAN

SET @IDLAN = 
1621537	
--1621544
--1628532	
--1621395
--1622412
--1611955
--1622061
--1622759
--1621528
--1628527
--1628524
--1628525   -- 1º COLOCAR IDLAN
  
UPDATE FLAN SET CNABSTATUS = 1
	WHERE FLAN.IDLAN = @IDLAN

---------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE FBOLETO
	UPDATE FBOLETO SET CNABSTATUS = 1 WHERE FBOLETO.IDBOLETO IN (

	SELECT FB.IDBOLETO FROM FLAN 

	LEFT JOIN FLANBOLETO FB ON FB.IDLAN = FLAN.IDLAN

	WHERE FLAN.IDLAN = @IDLAN
	) 
	--COMMIT
---------------------------------------------------------------------------------------------------------------------------------------
-- APENAS VERIFICAÇÃO DE STATUS
	SELECT FLAN.IDLAN,FLAN.CNABSTATUS,FLANBOLETO.IDBOLETO,FBOLETO.CNABSTATUS AS CNABBOL FROM FLAN
	
	JOIN FLANBOLETO ON FLANBOLETO.IDLAN = FLAN.IDLAN
	JOIN FBOLETO ON FBOLETO.IDBOLETO = FLANBOLETO.IDBOLETO
	 WHERE FLAN.IDLAN =  @IDLAN
	
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
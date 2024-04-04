--*******************************************************************************************************************************
-----------------------------------FILIAL 18-----------------------------------  
--*******************************************************************************************************************************

---------DESABILITAR 18
  
  DISABLE TRIGGER TR_LOCK_GER_PARC_F18 ON FLAN ;
  GO

  DISABLE TRIGGER TR_SCONTRATO_F18 ON SCONTRATO ;
  GO

  -- Olá, sua trigger foi desabilitada com sucesso!
----------HABILITAR 18

  ENABLE TRIGGER TR_LOCK_GER_PARC_F18 ON FLAN ;
  GO

  ENABLE TRIGGER TR_SCONTRATO_F18 ON SCONTRATO;
  GO

--*******************************************************************************************************************************
  -----------------------------------FILIAL 5-----------------------------------
--*******************************************************************************************************************************
 
  ---------DESABILITAR 5
   DISABLE TRIGGER TR_SCONTRATO_F05 ON SCONTRATO;

  ------------HABILITAR 5
   ENABLE TRIGGER TR_SCONTRATO_F05 ON SCONTRATO;

   
--*******************************************************************************************************************************
-----------------------------------FILIAL 6 -----------------------------------
--*******************************************************************************************************************************
   
  ---------DESABILITAR 6
   DISABLE TRIGGER TR_SCONTRATO_F06 ON SCONTRATO;
   DISABLE TRIGGER TR_SMATRICPL_F06 ON SMATRICPL;

  ------------HABILITAR 6
   ENABLE TRIGGER TR_SCONTRATO_F06 ON SCONTRATO;
   ENABLE TRIGGER TR_SMATRICPL_F06 ON SMATRICPL;

--------------------------------------------------------EXEMPLOS--------------------------------------------------------
/*ALTER TABLE tableName DISABLE TRIGGER triggername
ALTER TABLE tableName ENABLE TRIGGER triggername


--To disable / enable all triggers...
ALTER TABLE tableName DISABLE TRIGGER ALL
ALTER TABLE tableName ENABLE TRIGGER ALL


*/
--To disable / enable selective triggers...
--DISABLE TRIGGER triggername ON tableName
--ENABLE TRIGGER triggername ON tableName 

/*
--To disable / enable all triggers...
DISABLE TRIGGER ALL ON tableName [optional:All server]
ENABLE TRIGGER ALL ON tableName [optional:All server] 
*/
USE [CORPORERM]


GO
CREATE TRIGGER TRG_LOGFLAN ON FLAN

AFTER INSERT , UPDATE , DELETE NOT FOR REPLICATION

AS
BEGIN
  DECLARE @USUARIO VARCHAR(100) = SYSTEM_USER
  DECLARE @HOST VARCHAR(100) = HOST_NAME()
  DECLARE @IP AS VARCHAR(100)
  DECLARE @APPNAME AS VARCHAR(200)
  DECLARE @DATAALTER AS DATETIME = SYSDATETIME()


  SELECT @IP = IPADDRESS, @APPNAME = APPNAME FROM fn_GetContext()

  IF (EXISTS(SELECT * FROM INSERTED) AND EXISTS(SELECT * FROM DELETED) AND NOT EXISTS(SELECT * FROM LOGFLAN JOIN  INSERTED ON INSERTED.USUARIO = LOGFLAN.USUARIO AND @IP = LOGFLAN.IP AND @HOST = LOGFLAN.HOST AND @APPNAME = LOGFLAN.APPNAME AND LOGFLAN.OPERACAO =  'UPDATE' AND USER_RM = LOGFLAN.USER_RM AND INSERTED.IDLAN = LOGFLAN.IDLAN AND INSERTED.DATAVENCIMENTO = LOGFLAN.DTVENC AND	INSERTED.DATACANCELAMENTO = LOGFLAN.DTCANC AND INSERTED.STATUSLAN = LOGFLAN.STATUSLAN AND INSERTED.VALORORIGINAL = LOGFLAN.VALORORIGINAL AND INSERTED.VALORDESCONTO = LOGFLAN.VALORDESCONTO AND INSERTED.VALORJUROS = LOGFLAN.VALORJUROS AND INSERTED.VALORMULTA = LOGFLAN.VALORMULTA AND INSERTED.VALOROP1 = LOGFLAN.VALOROP1 AND INSERTED.VALOROP2 = LOGFLAN.VALOROP2 AND INSERTED.VALOROP3 = LOGFLAN.VALOROP3 AND INSERTED.VALOROP4 = LOGFLAN.VALOROP4 AND INSERTED.VALOROP5 = LOGFLAN.VALOROP5 AND INSERTED.VALOROP6 = LOGFLAN.VALOROP6 AND INSERTED.VALOROP7 = LOGFLAN.VALOROP7 AND INSERTED.VALOROP8 = LOGFLAN.VALOROP8)) 

   BEGIN

    INSERT INTO LOGFLAN -- SE UPDATE

    SELECT @USUARIO,@DATAALTER,@IP,@HOST,@APPNAME,'UPDATE',CASE WHEN @USUARIO = 'RM' THEN I.USUARIO ELSE @USUARIO END AS USUARIO,I.IDLAN,I.DATAVENCIMENTO,I.DATACANCELAMENTO,I.STATUSLAN,I.VALORORIGINAL,I.VALORDESCONTO,I.VALORCHEQUE,I.VALORJUROS,I.VALORMULTA,I.VALOROP1,I.VALOROP2,I.VALOROP3,I.VALOROP4,I.VALOROP5,I.VALOROP6,I.VALOROP7,I.VALOROP8
	FROM INSERTED I
	JOIN DELETED D ON I.USUARIO <> D.USUARIO OR I.IDLAN <> D.IDLAN OR I.DATAVENCIMENTO <> D.DATAVENCIMENTO OR I.DATACANCELAMENTO  <> D.DATACANCELAMENTO OR I.STATUSLAN  <> D.STATUSLAN OR I.VALORORIGINAL  <> D.VALORORIGINAL OR I.VALORDESCONTO <> D.VALORDESCONTO OR I.VALORJUROS <> D.VALORJUROS OR I.VALORMULTA <> D.VALORMULTA OR I.VALOROP1 <> D.VALOROP1 OR I.VALOROP2 <> D.VALOROP2 OR I.VALOROP3 <> D.VALOROP3 OR I.VALOROP4 <> D.VALOROP4 OR I.VALOROP5 <> D.VALOROP5 OR I.VALOROP6 <> D.VALOROP6 OR I.VALOROP7 <> D.VALOROP7 OR I.VALOROP8 <> D.VALOROP8
   END

  ELSE BEGIN  

   IF(EXISTS(SELECT * FROM INSERTED) AND NOT EXISTS (SELECT * FROM DELETED) AND @USUARIO <> 'RM')  

   BEGIN 

    INSERT INTO LOGFLAN -- SE INSERT

    SELECT @USUARIO,@DATAALTER,@IP,@HOST,@APPNAME,'INSERT',CASE WHEN @USUARIO = 'RM' THEN USUARIO ELSE @USUARIO END AS USUARIO,IDLAN,DATAVENCIMENTO,DATACANCELAMENTO,STATUSLAN,VALORORIGINAL,VALORDESCONTO,VALORCHEQUE,VALORJUROS,VALORMULTA,VALOROP1,VALOROP2,VALOROP3,VALOROP4,VALOROP5,VALOROP6,VALOROP7,VALOROP8
	FROM INSERTED

   END
   ELSE BEGIN 

    
	IF (EXISTS(SELECT * FROM DELETED) AND NOT EXISTS(SELECT * FROM INSERTED) AND NOT EXISTS(SELECT * FROM INSERTED JOIN LOGFLAN ON INSERTED.USUARIO = LOGFLAN.USUARIO AND INSERTED.DATAALTERACAO = LOGFLAN.DATAALTERACAO AND @IP = LOGFLAN.IP AND @HOST = LOGFLAN.HOST AND @APPNAME = LOGFLAN.APPNAME AND USER_RM = LOGFLAN.USER_RM AND INSERTED.IDLAN = LOGFLAN.IDLAN AND INSERTED.DATAVENCIMENTO = LOGFLAN.DTVENC AND INSERTED.DATACANCELAMENTO = LOGFLAN.DTCANC AND INSERTED.STATUSLAN = LOGFLAN.STATUSLAN AND INSERTED.VALORORIGINAL = LOGFLAN.VALORORIGINAL AND INSERTED.VALORDESCONTO = LOGFLAN.VALORDESCONTO AND INSERTED.VALORJUROS = LOGFLAN.VALORJUROS AND INSERTED.VALORMULTA = LOGFLAN.VALORMULTA AND INSERTED.VALOROP1 = LOGFLAN.VALOROP1 AND INSERTED.VALOROP2 = LOGFLAN.VALOROP2 AND INSERTED.VALOROP3 = LOGFLAN.VALOROP3 AND INSERTED.VALOROP4 = LOGFLAN.VALOROP4 AND INSERTED.VALOROP5 = LOGFLAN.VALOROP5 AND INSERTED.VALOROP6 = LOGFLAN.VALOROP6 AND INSERTED.VALOROP7 = LOGFLAN.VALOROP7 AND INSERTED.VALOROP8 = LOGFLAN.VALOROP8))
	BEGIN

	INSERT INTO LOGFLAN -- SE DELETE
	
	SELECT @USUARIO,@DATAALTER,@IP,@HOST,@APPNAME,'DELETE',CASE WHEN @USUARIO = 'RM' THEN USUARIO ELSE @USUARIO END AS USUARIO,IDLAN,DATAVENCIMENTO,DATACANCELAMENTO,STATUSLAN,VALORORIGINAL,VALORDESCONTO,VALORCHEQUE,VALORJUROS,VALORMULTA,VALOROP1,VALOROP2,VALOROP3,VALOROP4,VALOROP5,VALOROP6,VALOROP7,VALOROP8
	FROM DELETED 

	END

	END

    END
END

GO

--  SELECT * FROM LOGFLAN


--  DELETE FROM LOGFLAN


--BEGIN TRAN
--UPDATE FLAN SET VALORDESCONTO = 44 WHERE IDLAN= 1711810

--COMMIT
USE [CORPORERM]
GO
/****** Object:  UserDefinedFunction [dbo].[CON_MIN_EM_HR]    Script Date: 16/10/2019 17:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[CON_MIN_EM_HR](@VAR1 AS INT)

RETURNS VARCHAR(8)

AS
BEGIN
 
declare @minutos int, @HORA_MIN VARCHAR(8), @X INT

set @minutos = @VAR1

SET @X = LEN(@minutos / 60) 
 
SET @HORA_MIN = RIGHT('0'+cast (@minutos / 60 as varchar(8)),@X) + ':' + RIGHT('0'+cast (ABS( @minutos % 60) as varchar(2)),2)    /* @minutos - ((@minutos / 60) * 60)*/

RETURN @HORA_MIN
END
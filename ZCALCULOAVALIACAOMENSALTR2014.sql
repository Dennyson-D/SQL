USE [CORPORERM]
GO
/****** Object:  StoredProcedure [dbo].[ZCALCULOAVALIACAOMENSALTR2014]    Script Date: 18/09/2020 13:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================
-- Author:	Juliane
-- Create date: 30/04/2014
-- Description:	Procedure criada para jogar as notas das avaliações nas etapas de notas
-- Procedure.
-- Executada através de um relatório no RM Classis.
-- ================================================

ALTER PROCEDURE [dbo].[ZCALCULOAVALIACAOMENSALTR2014]
@CODFILIAL			INTEGER,		--Solicita a Filial para o calculo.
@CODPERLET			VARCHAR(10),	--Solicita o Período Letivo.
@RA					VARCHAR(20),	--RA do discente
@IDTURMADISC		INTEGER,		--IDTURMADISC
@CODETAPA			INTEGER			-- CODETAPA.

AS
BEGIN

	DECLARE @COMPUTADOR		VARCHAR(100) -- Computador do Usuário.
	DECLARE @USUARIO		VARCHAR(100) -- Usuário do Sistema RM.
	DECLARE @SISTEMA		VARCHAR(2)  -- Sistema que foi feito a alteração
	DECLARE @TIPO			VARCHAR(1)  -- Tipo de Alteração - I insert, U update, D delete.
	DECLARE @ID				INTEGER -- ID do registro inserido no log.
	DECLARE @PROCESSO		VARCHAR(2000) -- Descrição do processo.
	DECLARE @DADOS			VARCHAR(2000) -- Grava todos os paramentros utlizados.
	DECLARE @SOMANOTAS		FLOAT -- Grava soma das notas para cáculo da média.
	DECLARE @MEDIANOTA		FLOAT -- Grava a média das avaliações.
	DECLARE @VERIFICALAN	INTEGER -- Verifica lançamentos para insert ou update.
	DECLARE @NFATORVARIAVEL	INTEGER -- Verifica lançamentos para insert ou update.
	DECLARE @CODIGOTURMA	VARCHAR(20) -- Grava Código da turma

	--Setando o código da ID na variável.
	SELECT @ID = (MAX(ZLOGRM.IDLOGRM) + 1) 
	FROM ZLOGRM

	--Setando o tipo da operação. U = UPDATE    I = INSERT    D = DELETE.
	SELECT @TIPO = 'U' 
	--FROM INSERTED

	--Setando a descrição do processo.
	SELECT @PROCESSO = 'PROCEDURE - ZCALCULOAVALIACAOMENSAL - Processa a média das avaliações das etapas do Colégio São José'
	--FROM INSERTED

	--Setando os dados utilizandos na procedure.
	SELECT @DADOS = CAST(@CODFILIAL AS VARCHAR) + 
					CAST(@CODPERLET AS VARCHAR) +'-'+ 
					CAST(@RA AS VARCHAR) +'-'+
					CAST(@IDTURMADISC AS VARCHAR) +'-'+
					CAST(@CODETAPA AS VARCHAR)
	--FROM INSERTED

	--Setando o computador utilizado para a operação.
	SELECT @COMPUTADOR = host_name()
	--FROM INSERTED

	--Setando o sistema que foi feito a operação.
	SELECT @SISTEMA = 'S'
	--FROM INSERTED

	--Grava nome do usuário na variável --
	SELECT @USUARIO = USERNAME
	FROM GLOGIN
	WHERE GLOGIN.COMPUTERNAME = HOST_NAME()
	GROUP BY USERNAME

	IF @CODETAPA IN(13, 23, 33, 43)
	BEGIN

		--Se quantidade de notas >= 1, então calcula a média entre elas, senão média = NULL
		--Verifica a quantidade de notas para média --
		SELECT @NFATORVARIAVEL = COUNT(*)
		FROM (  SELECT SNOTAS.IDTURMADISC, SNOTAS.NOTA, ROW_NUMBER() OVER (ORDER BY SNOTAS.NOTA ASC) SEQ
				FROM SNOTAS
				JOIN SMATRICULA
				  ON SMATRICULA.CODCOLIGADA = SNOTAS.CODCOLIGADA
				 AND SMATRICULA.IDTURMADISC = SNOTAS.IDTURMADISC
				 AND SMATRICULA.RA = SNOTAS.RA
				JOIN SPLETIVO
				  ON SPLETIVO.CODCOLIGADA = SMATRICULA.CODCOLIGADA
				 AND SPLETIVO.IDPERLET = SMATRICULA.IDPERLET 
				WHERE SNOTAS.RA = @RA
				  AND SNOTAS.CODETAPA = @CODETAPA
				  AND SNOTAS.IDTURMADISC = @IDTURMADISC
				  AND SNOTAS.NOTA IS NOT NULL
				  AND SPLETIVO.CODPERLET = @CODPERLET) AA   

		-- No caso de apenas uma nota para a disciplina, a mesma deve estar direto na etapa --
		IF @NFATORVARIAVEL >= 1
		BEGIN 

			-- Grava soma total das notas --
			SELECT @SOMANOTAS = SUM(AA.NOTA)
			FROM (  SELECT SNOTAS.IDTURMADISC, SNOTAS.NOTA, ROW_NUMBER() OVER (ORDER BY SNOTAS.NOTA ASC) SEQ
					FROM SNOTAS
					JOIN SMATRICULA
					  ON SMATRICULA.CODCOLIGADA = SNOTAS.CODCOLIGADA
					 AND SMATRICULA.IDTURMADISC = SNOTAS.IDTURMADISC
					 AND SMATRICULA.RA = SNOTAS.RA
					JOIN SPLETIVO
					  ON SPLETIVO.CODCOLIGADA = SMATRICULA.CODCOLIGADA
					 AND SPLETIVO.IDPERLET = SMATRICULA.IDPERLET 
					WHERE SNOTAS.RA = @RA
					  AND SNOTAS.CODETAPA = @CODETAPA
					  AND SNOTAS.IDTURMADISC = @IDTURMADISC
					  AND SNOTAS.NOTA IS NOT NULL
					  AND SPLETIVO.CODPERLET = @CODPERLET) AA
          
			-- Calcula a média dos conceitos --
			SET @MEDIANOTA = ((@SOMANOTAS / @NFATORVARIAVEL))

			-- Arredonda a média dos conceitos --
			SET @MEDIANOTA = CONVERT(NUMERIC(10,0),ROUND(@MEDIANOTA,0))
   
		END
		ELSE
		BEGIN
			SET @MEDIANOTA = NULL --Quantidade de notas <= 0
		END
	  
		-- Verifica se já existe nota para essa etapa/disciplina/aluno (verifica a qtde de registros) --
		SELECT @VERIFICALAN = COUNT(*)
		FROM SNOTAETAPA
		WHERE SNOTAETAPA.RA = @RA
		  AND SNOTAETAPA.IDTURMADISC = @IDTURMADISC
		  AND SNOTAETAPA.CODETAPA = @CODETAPA
		  --AND SNOTAETAPA.NOTAFALTA IS NOT NULL/*traz registro com nota*/
		 
		--Se tem registro, então...
		IF @VERIFICALAN > 0
		BEGIN 

			--	Se média não é null (mais de uma nota de avaliação lançada), então update na etapa, Senão, não faz nata, nota lançada na etapa pelo prof.
			IF (@MEDIANOTA IS NOT NULL)
			BEGIN
				UPDATE SNOTAETAPA
				SET SNOTAETAPA.NOTAFALTA = @MEDIANOTA
				FROM SNOTAETAPA
				WHERE SNOTAETAPA.RA = @RA
				  AND SNOTAETAPA.IDTURMADISC = @IDTURMADISC
				  AND SNOTAETAPA.CODETAPA = @CODETAPA
			END
		
		END
		ELSE --Senão tem registro, então...
		BEGIN
		
			--Se média não é null, então insert na etapa, Senão, não faz nada...faltam as notas.
			IF (@MEDIANOTA IS NOT NULL)
				INSERT INTO SNOTAETAPA (CODCOLIGADA, CODETAPA, TIPOETAPA, IDTURMADISC, RA, IDGRUPO, NOTAFALTA, AULASDADAS)
				VALUES (1,@CODETAPA, 'N', @IDTURMADISC, @RA, NULL, @MEDIANOTA, NULL)
			
		END
	END
END
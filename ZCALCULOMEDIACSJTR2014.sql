USE [CORPORERM]
GO
/****** Object:  StoredProcedure [dbo].[ZCALCULOMEDIACSJTR2014]    Script Date: 18/09/2020 14:04:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--- ==============================================
-- Author:	Juliane
-- Create date: 30/04/2014
-- Description:	Calculo das médias Colégio São José
-- Filial: 06
-- Para algumas disciplinas, copia a nota antes de calcular a média (ZCOPIANOTASSAOJOSE).
-- Ensino Fundamental do EF1: Não tem nota
-------------------------------------------------
-- Ensino Fundamental do EF2 ao EF4:
-- 004	CIÊNCIAS
-- 010	GEOGRAFIA
-- 011	HISTÓRIA
-- 015	LÍNGUA PORTUGUESA
-- 017	L.E.M. - INGLÊS
-- 018	MATEMÁTICA
-- Fórmula: (prova bimestral + avaliação mensal) / 2
-- 009	FORMAÇÃO HUMANA
-- Fórmula: a nota bimestral é a mesma da avaliação mensal
-- Disciplinas que não tem nota:
-- 002	ARTE
-- 005	EDUCAÇÃO FÍSICA
-- 006	ENSINO RELIGIOSO
-- 013	INFORMÁTICA
-------------------------------------------------
-- Ensino Fundamental do EF5:
-- 004	CIÊNCIAS
-- 010	GEOGRAFIA
-- 011	HISTÓRIA
-- 017	L.E.M. - INGLÊS
-- 015	LÍNGUA PORTUGUESA
-- 018	MATEMÁTICA
-- Fórmula: (prova bimestral + sabatina) / 2
-- 009	FORMAÇÃO HUMANA
-- Fórmula: a nota bimestral é a mesma da sabatina
-- Disciplinas que não tem nota:
-- 002	ARTE
-- 005	EDUCAÇÃO FÍSICA
-- 006	ENSINO RELIGIOSO
-- 013	INFORMÁTICA
-------------------------------------------------
-- Ensino Fundamental do EF6 ao EF9:
-- 002	ARTE
-- 004	CIÊNCIAS
-- 010	GEOGRAFIA
-- 011	HISTÓRIA
-- 015	LÍNGUA PORTUGUESA
-- 016	L.E.M. - ESPANHOL
-- 017	L.E.M. - INGLÊS
-- 018	MATEMÁTICA
-- 020	OFICINA DE PRODUÇÃO DE TEXTO
-- Fórmula: (sabatina + conceito + prova bimestral) /2 + bônus
-- 005	EDUCAÇÃO FÍSICA
-- 006	ENSINO RELIGIOSO
-- 012	HISTÓRIA DO PARANÁ
-- Fórmula: prova bimestral + bônus
-- 014	LABORATÓRIO DE CIÊNCIAS NATURAIS nas turmas EF.6C.V , EF.6D.V , EF.6E.V , EF.7C.V , 
-- EF.7D.V , EF.7E.V, EF.8C.V, EF.8E.V o cálculo é (sabatina + conceito + prova bimestral) /2 + bônus
-- para as turmas EF.6A.M, EF.6B.M, EF.7A.M, EF.7B.M, EF.8A.M, EF.8B.M, EF.8C.M, EF.9A.M, EF.9B.M, EF.9C.M
-- e EF.9D.M o cálculo é prova bimestral + bônus
-------------------------------------------------
-- Ensino Médio do EM1 ao EM2
-- 001	ARTE
-- 003	BIOLOGIA
-- 007	FILOSOFIA
-- 008	FÍSICA
-- 010	GEOGRAFIA
-- 011	HISTÓRIA
-- 016	L.E.M. - ESPANHOL
-- 017	L.E.M. - INGLÊS
-- 018	MATEMÁTICA
-- 019	MATEMÁTICA E GEOMETRIA
-- 021	REDAÇÃO
-- 022	QUÍMICA
-- 032	LÍNGUA PORTUGUESA E LITERATURA
-- Fórmula: (sabatina + conceito + prova bimestral) /2 + bônus
-- 005	EDUCAÇÃO FÍSICA
-- 006	ENSINO RELIGIOSO
-- 023	SOCIOLOGIA
-- Fórmula: prova bimestral + bônus
-------------------------------------------------
-- Ensino Médio EM3
-- 001	ARTE
-- 003	BIOLOGIA
-- 007	FILOSOFIA
-- 008	FÍSICA
-- 010	GEOGRAFIA
-- 011	HISTÓRIA
-- 016	L.E.M. - ESPANHOL
-- 017	L.E.M. - INGLÊS
-- 018	MATEMÁTICA
-- 019	MATEMÁTICA E GEOMETRIA
-- 021	REDAÇÃO
-- 022	QUÍMICA
-- 023	SOCIOLOGIA
-- 032	LÍNGUA PORTUGUESA E LITERATURA
-- Fórmula: (simulado + prova bimestral) / 2 + bônus
-- 005	EDUCAÇÃO FÍSICA
-- Fórmula: a nota bimestral é a mesma da prova bimestral
-- ==============================================

ALTER PROCEDURE [dbo].[ZCALCULOMEDIACSJTR2014]
@CODFILIAL			INTEGER,		--Solicita a Filial para o calculo.
@PERLET				VARCHAR(10),	--Solicita o Período Letivo.
@RA					VARCHAR(20),	--RA do discente
@IDTURMADISC		INTEGER,		--IDTURMADISC
@CODIGODISC			VARCHAR(3),		-- Grava Código da disciplina.
@CODETAPA			INTEGER	,		--IDTURMADISC
@CODIGOTURMA		VARCHAR(20)		-- Grava Código da turma.

AS
BEGIN

	DECLARE @COMPUTADOR		VARCHAR(100)	-- Computador do Usuário.
	DECLARE @USUARIO		VARCHAR(100)	-- Usuário do Sistema RM.
	DECLARE @SISTEMA		VARCHAR(2)		-- Sistema que foi feito a alteração
	DECLARE @TIPO			VARCHAR(1)		-- Tipo de Alteração - I insert, U update, D delete.
	DECLARE @ID				INTEGER			-- ID do registro inserido no log.
	DECLARE @PROCESSO		VARCHAR(2000)	-- Descrição do processo.
	DECLARE @DADOS			VARCHAR(2000)	-- Grava todos os paramentros utlizados.
	DECLARE @ETAPA			INTEGER			-- Grava etapa para calculo média	- Etapa = 16,26,36,46.
	DECLARE @ETAPASABATINA	INTEGER			-- Grava etapa da sabatina			- Etapa = 11,21,31,41.
	DECLARE @ETAPACONCEITO	INTEGER			-- Grava etapa do coceito			- Etapa = 12,22,32,42.
	DECLARE @ETAPAAVALMENSAL INTEGER		-- Grava etapa da Avaliação mensal	- Etapa = 13,23,33,43.
	DECLARE @ETAPANOTABIM	INTEGER			-- Grava etapa da nota bimestral	- Etapa = 10,20,30,40.
	DECLARE @ETAPABONUS		INTEGER			-- Grava etapa da Bonus				- Etapa = 14,24,34,44.
	DECLARE @ETAPASIMULADO	INTEGER			-- Grava etapa da simulado			- Etapa = 15,25,35,45.
	DECLARE @NOTASABATINA	FLOAT			-- Grava nota da sabatina.			- Etapa - 11,21,31,41.
	DECLARE @NOTACONCEITO	FLOAT			-- Grava nota do coceito			- Etapa - 12,22,32,42.
	DECLARE @NOTAAVALMENSAL INTEGER			-- Grava nota da Avaliação mensal	- Etapa = 13,23,33,43.
	DECLARE @NOTANOTABIM	FLOAT			-- Grava nota da nota bimestral		- Etapa - 10,20,30,40.
	DECLARE @NOTABONUS		FLOAT			-- Grava nota da bonus				- Etapa - 14,24,34,44.
	DECLARE @NOTASIMULADO	FLOAT			-- Grava nota da simulado.			- Etapa - 15,25,35,45.
	DECLARE @MEDIANOTA		FLOAT			-- Grava a média do bimestre			- Etapa = 16,26,36,46.
	DECLARE @VERIFICALAN	INTEGER			-- Verifica lançamentos para insert ou update.
	DECLARE @NFATORVARIAVEL	INTEGER			-- Verifica lançamentos para insert ou update.
    --DECLARE @TESTE			VARCHAR(20)		-- TESTE
      
	--Setando o código da ID na variável.
	SELECT @ID = (MAX(ZLOGRM.IDLOGRM) + 1) 
	FROM ZLOGRM
	--Setando o tipo da operação. U = UPDATE    I = INSERT    D = DELETE.
	SELECT @TIPO = 'U' 
	--FROM INSERTED
	--Setando a descrição do processo.
	SELECT @PROCESSO = 'PROCEDURE - ZCALCULOMEDIASAOJOSE - Processa a média do colégio São José'
	--FROM INSERTED
	--Setando os dados utilizandos na procedure.
	SELECT @DADOS = CAST(@CODFILIAL AS VARCHAR) +'-'+ 
					CAST(@PERLET AS VARCHAR) +'-'+
					CAST(@RA AS VARCHAR) +'-'+
					CAST(@IDTURMADISC AS VARCHAR)
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
	
	--Seta a etapa conforme o bimestre informado - COLÉGIO SÃO JOSÉ --
	IF @CODETAPA IN(10, 11, 12, 13, 14, 15)
	BEGIN
		SET @ETAPA = 16
		SET @ETAPASABATINA = 11
		SET @ETAPACONCEITO = 12
		SET @ETAPAAVALMENSAL = 13
		SET @ETAPANOTABIM = 10
		SET @ETAPABONUS = 14
		SET @ETAPASIMULADO = 15
	END
	ELSE
	IF @CODETAPA IN(20, 21, 22, 23, 24, 25)
	BEGIN
		SET @ETAPA = 26
		SET @ETAPASABATINA = 21
		SET @ETAPACONCEITO = 22
		SET @ETAPAAVALMENSAL = 23
		SET @ETAPANOTABIM = 20
		SET @ETAPABONUS = 24
		SET @ETAPASIMULADO = 25
	END
	ELSE
	IF @CODETAPA IN(30, 31, 32, 33, 34, 35)
	BEGIN
		SET @ETAPA = 36
		SET @ETAPASABATINA = 31
		SET @ETAPACONCEITO = 32
		SET @ETAPAAVALMENSAL = 33
		SET @ETAPANOTABIM = 30
		SET @ETAPABONUS = 34
		SET @ETAPASIMULADO = 35
	END
	ELSE
	IF @CODETAPA IN(40, 41, 42, 43, 44, 45)
	BEGIN
		SET @ETAPA = 46
		SET @ETAPASABATINA = 41
		SET @ETAPACONCEITO = 42
		SET @ETAPAAVALMENSAL = 43
		SET @ETAPANOTABIM = 40
		SET @ETAPABONUS = 44
		SET @ETAPASIMULADO = 45
	END
	ELSE
	BEGIN
		SET @ETAPA = 0
		SET @ETAPASABATINA = 0
		SET @ETAPACONCEITO = 0
		SET @ETAPANOTABIM = 0
		SET @ETAPAAVALMENSAL = 0
		SET @ETAPABONUS = 0
		SET @ETAPASIMULADO = 0
	END
    
	-- Soma nota de bonus referente ao bimestre e etapa --
	SELECT @NOTABONUS = SUM(SNOTAS.NOTA)
	FROM SNOTAS
	JOIN SMATRICULA
	  ON SMATRICULA.CODCOLIGADA = SNOTAS.CODCOLIGADA
	 AND SMATRICULA.IDTURMADISC = SNOTAS.IDTURMADISC
	 AND SMATRICULA.RA = SNOTAS.RA
	JOIN SPLETIVO
	  ON SPLETIVO.CODCOLIGADA = SMATRICULA.CODCOLIGADA
	 AND SPLETIVO.IDPERLET = SMATRICULA.IDPERLET 
	WHERE SNOTAS.RA = @RA
	  AND SNOTAS.CODETAPA = @ETAPABONUS
	  AND SNOTAS.IDTURMADISC = @IDTURMADISC
	  AND SNOTAS.NOTA IS NOT NULL
	  AND SPLETIVO.CODPERLET = @PERLET
          
	-- Grava nota Conceito --
	SELECT @NOTACONCEITO = MAX(SNOTAETAPA.NOTAFALTA)
	FROM SNOTAETAPA
	WHERE SNOTAETAPA.RA = @RA
	  AND SNOTAETAPA.CODETAPA = @ETAPACONCEITO
	  AND SNOTAETAPA.IDTURMADISC = @IDTURMADISC
  
    -- Grava nota Avaliação Mensal --
	SELECT @NOTAAVALMENSAL = MAX(SNOTAETAPA.NOTAFALTA)
	FROM SNOTAETAPA
	WHERE SNOTAETAPA.RA = @RA
	  AND SNOTAETAPA.CODETAPA = @ETAPAAVALMENSAL
      AND SNOTAETAPA.IDTURMADISC = @IDTURMADISC
   
	-- Grava nota Simulado --
	SELECT @NOTASIMULADO = MAX(SNOTAETAPA.NOTAFALTA)
	FROM SNOTAETAPA
	WHERE SNOTAETAPA.RA = @RA
	  AND SNOTAETAPA.CODETAPA = @ETAPASIMULADO
	  AND SNOTAETAPA.IDTURMADISC = @IDTURMADISC

	-- Grava nota Sabatina --
	SELECT @NOTASABATINA = MAX(SNOTAETAPA.NOTAFALTA)
	FROM SNOTAETAPA
	WHERE SNOTAETAPA.RA = @RA
	  AND SNOTAETAPA.CODETAPA = @ETAPASABATINA
	  AND SNOTAETAPA.IDTURMADISC = @IDTURMADISC

	-- Grava nota Nota Bimestral --
	SELECT @NOTANOTABIM = MAX(SNOTAETAPA.NOTAFALTA)
	FROM SNOTAETAPA
	WHERE SNOTAETAPA.RA = @RA
	  AND SNOTAETAPA.CODETAPA = @ETAPANOTABIM
	  AND SNOTAETAPA.IDTURMADISC = @IDTURMADISC

	-- Seta as variáveis com valor zero --
	IF @NOTASABATINA IS NULL 
		SET @NOTASABATINA = 0
	IF @NOTACONCEITO IS NULL
		SET @NOTACONCEITO = 0
	IF @NOTANOTABIM IS NULL
		SET @NOTANOTABIM = 0
	IF @NOTABONUS IS NULL
		SET @NOTABONUS = 0
	IF @NOTASIMULADO  IS NULL
		SET @NOTASIMULADO = 0	
					
	   -- Se turmas forem do EF.2, EF.3 ou EF.4 entra aqui
  IF (SUBSTRING(@CODIGOTURMA,1,4) = 'EF.2' OR SUBSTRING(@CODIGOTURMA,1,4) = 'EF.3' OR SUBSTRING(@CODIGOTURMA,1,4) = 'EF.4')
  BEGIN
	-- Verifica se as disciplinas são: CIÊNCIAS, GEOGRAFIA, HISTÓRIA, LÍNGUA PORTUGUESA, L.E.M. - INGLÊS ou MATEMÁTICA
    IF (@CODIGODISC = '004' OR @CODIGODISC = '010' OR @CODIGODISC = '011' OR 
        @CODIGODISC = '015' OR @CODIGODISC = '017' OR @CODIGODISC = '018')
    BEGIN    
       SET @MEDIANOTA = ROUND(((@NOTANOTABIM + @NOTAAVALMENSAL) / 2),0) 
    END
    -- Para a disciplina de FORMAÇÃO HUMANA a nota bimestral será a mesma da avaliação mensal
    IF @CODIGODISC = '009'
      BEGIN
        SET @MEDIANOTA = @NOTAAVALMENSAL
    END       
  END
  
	-- Se turma for igual a EF.5 entra aqui
  IF SUBSTRING(@CODIGOTURMA,1,4) = 'EF.5'
  BEGIN
	-- Verifica se as disciplinas são: CIÊNCIAS, GEOGRAFIA, HISTÓRIA, LÍNGUA PORTUGUESA, L.E.M. - INGLÊS ou MATEMÁTICA
    IF (@CODIGODISC = '004' OR @CODIGODISC = '010' OR @CODIGODISC = '011' OR 
        @CODIGODISC = '015' OR @CODIGODISC = '017' OR @CODIGODISC = '018')
    BEGIN    
       SET @MEDIANOTA = ROUND(((@NOTANOTABIM + @NOTAAVALMENSAL) / 2),0) /******* ALTERADO ROUND(((@NOTANOTABIM + @NOTASABATINA) / 2),0) */
    END
    -- Para a disciplina de FORMAÇÃO HUMANA a nota bimestral será a mesma da sabatina
    IF @CODIGODISC = '009'
      BEGIN
        SET @MEDIANOTA = @NOTASABATINA
	END
  END
    
    -- Se turmas forem do EF.6, EF.7, EF.8 ou EF.9 entra aqui
  IF (SUBSTRING(@CODIGOTURMA,1,4) = 'EF.6' OR SUBSTRING(@CODIGOTURMA,1,4) = 'EF.7' OR 
	  SUBSTRING(@CODIGOTURMA,1,4) = 'EF.8' OR SUBSTRING(@CODIGOTURMA,1,4) = 'EF.9')
  BEGIN
	-- Verifica se as disciplinas são: ARTE, CIÊNCIAS, GEOGRAFIA, HISTÓRIA, LÍNGUA PORTUGUESA,
    -- L.E.M. - ESPANHOL, L.E.M. - INGLÊS, MATEMÁTICA ou OFICINA DE PRODUÇÃO DE TEXTO
    IF (@CODIGODISC = '002' OR @CODIGODISC = '004' OR @CODIGODISC = '010' OR 
        @CODIGODISC = '011' OR @CODIGODISC = '015' OR @CODIGODISC = '016' OR
        @CODIGODISC = '017' OR @CODIGODISC = '018' OR @CODIGODISC = '020')
    BEGIN    
       SET @MEDIANOTA = ROUND((((@NOTACONCEITO + @NOTANOTABIM) / 2) + @NOTABONUS),0) /* -- ALTERADO ROUND((((@NOTASABATINA + @NOTACONCEITO + @NOTANOTABIM) / 2) + @NOTABONUS),0)*/
    END
    -- Verifica se as disciplinas são: EDUCAÇÃO FÍSICA, ENSINO RELIGIOSO, HISTÓRIA DO PARANÁ
	-- ou LABORATÓRIO DE CIÊNCIAS NATURAIS
    IF (@CODIGODISC = '005' OR @CODIGODISC = '006' OR @CODIGODISC = '012')
      BEGIN
        SET @MEDIANOTA = @NOTANOTABIM + @NOTABONUS
	END
	-- 014	LABORATÓRIO DE CIÊNCIAS NATURAIS para as turmas EF.6A.M, EF.6B.M, EF.7A.M, EF.7B.M, 
	-- EF.8A.M, EF.8B.M, EF.9A.M, EF.9B.M, EF.9C.M
	-- e EF.9D.M o cálculo é prova bimestral + bônus
	IF (@CODIGOTURMA IN('EF.6A.M', 'EF.6B.M', 'EF.7A.M', 'EF.7B.M', 'EF.7C.M',  'EF.8A.M', 'EF.8B.M', 'EF.8C.M',
						'EF.9A.M', 'EF.9B.M', 'EF.9C.M', 'EF.9D.M') AND @CODIGODISC = '014')
	  BEGIN
	    SET @MEDIANOTA = @NOTANOTABIM + @NOTABONUS
	END
    -- 014	LABORATÓRIO DE CIÊNCIAS NATURAIS para as turmas EF.6C.V , EF.6D.V , EF.6E.V , EF.7C.M, EF.7C.V , 
	-- EF.7D.V , EF.7E.V  e EF.8C.V o cálculo é (sabatina + conceito + prova bimestral) /2 + bônus
	IF (@CODIGOTURMA IN('EF.6C.V', 'EF.6D.V', 'EF.6E.V', 'EF.6F.V', 'EF.7C.V', 'EF.7D.V', 'EF.7E.V', 'EF.7F.V',
						'EF.8C.V', 'EF.8D.V', 'EF.8E.V') AND @CODIGODISC = '014')
	  BEGIN
		SET @MEDIANOTA = @NOTANOTABIM + @NOTABONUS
	    --SET @MEDIANOTA = ROUND((((@NOTASABATINA + @NOTACONCEITO + @NOTANOTABIM) / 2) + @NOTABONUS),0)
	END



  END
	
    -- Se turmas forem do EM.1 ou EM.2
  IF (SUBSTRING(@CODIGOTURMA,1,4) = 'EM.1' OR SUBSTRING(@CODIGOTURMA,1,4) = 'EM.2') 
  BEGIN
    -- Verifica se as disciplinas são: ARTE, BIOLOGIA, FILOSOFIA, FÍSICA, GEOGRAFIA, HISTÓRIA, 
	-- L.E.M. - ESPANHOL, L.E.M. - INGLÊS, MATEMÁTICA, MATEMÁTICA E GEOMETRIA, REDAÇÃO,
	-- QUÍMICA ou LÍNGUA PORTUGUESA E LITERATURA
    IF (@CODIGODISC = '001' OR @CODIGODISC = '003' OR @CODIGODISC = '007' OR 
        @CODIGODISC = '008' OR @CODIGODISC = '010' OR @CODIGODISC = '011' OR
        @CODIGODISC = '016' OR @CODIGODISC = '017' OR @CODIGODISC = '018' OR
        @CODIGODISC = '019' OR @CODIGODISC = '021' OR @CODIGODISC = '022' OR
        @CODIGODISC = '032' /*ACRESCIMO TULIO*/ OR @CODIGODISC = '015' OR @CODIGODISC = '023')
     BEGIN    
       SET @MEDIANOTA = ROUND((((@NOTACONCEITO + @NOTANOTABIM) / 2) + @NOTABONUS),0) /*--ALTERADO  ROUND((((@NOTASABATINA + @NOTACONCEITO + @NOTANOTABIM) / 2) + @NOTABONUS),0)*/
    END    
    -- Verifica se as disciplinas são: EDUCAÇÃO FÍSICA, ENSINO RELIGIOSO ou SOCIOLOGIA
    IF (@CODIGODISC = '005' OR @CODIGODISC = '006' /*RETIRADO POR TULIO - OR @CODIGODISC = '023'*/)
      BEGIN
        SET @MEDIANOTA = @NOTANOTABIM + @NOTABONUS	
	END
  END
  
    -- Se turma for do EM.3
  IF SUBSTRING(@CODIGOTURMA,1,4) = 'EM.3' 
  BEGIN
    -- Verifica se as disciplinas são: ARTE, BIOLOGIA, FILOSOFIA, FÍSICA, GEOGRAFIA, HISTÓRIA, 
	-- L.E.M. - ESPANHOL, L.E.M. - INGLÊS, MATEMÁTICA, MATEMÁTICA E GEOMETRIA, REDAÇÃO,
	-- QUÍMICA, SOCIOLOGIA, ou LÍNGUA PORTUGUESA E LITERATURA
    IF (@CODIGODISC = '001' OR @CODIGODISC = '003' OR @CODIGODISC = '007' OR 
        @CODIGODISC = '008' OR @CODIGODISC = '010' OR @CODIGODISC = '011' OR
        @CODIGODISC = '016' OR @CODIGODISC = '017' OR @CODIGODISC = '018' OR
        @CODIGODISC = '019' OR @CODIGODISC = '021' OR @CODIGODISC = '022' OR
        @CODIGODISC = '023' OR @CODIGODISC = '032')
     BEGIN    
       SET @MEDIANOTA = ROUND((((@NOTASIMULADO + @NOTANOTABIM) / 2) + @NOTABONUS),0)
    END    
    -- Verifica se a disciplinas é EDUCAÇÃO FÍSICA
    IF @CODIGODISC = '005'
      BEGIN
        SET @MEDIANOTA = @NOTANOTABIM
	END
  END
-----------------------------------------------------------------------------------------------

	-- Verifica se a nota fica superior a 100 e arredonda para 100 --
	IF @MEDIANOTA > 100 
		SET @MEDIANOTA = 100

	-- Verifica se já existe nota para essa etapa / disciplina --
	SELECT @VERIFICALAN = COUNT(*)
	FROM SNOTAETAPA
	WHERE SNOTAETAPA.RA = @RA
	 AND SNOTAETAPA.IDTURMADISC = @IDTURMADISC
	 AND SNOTAETAPA.CODETAPA = @ETAPA
  
	-- Caso tenha nota, tem que apagar para gravar nova nota calculada --
	IF @VERIFICALAN <> 0
	BEGIN
		DELETE
		FROM SNOTAETAPA
		WHERE SNOTAETAPA.RA = @RA
		  AND SNOTAETAPA.IDTURMADISC = @IDTURMADISC
		  AND SNOTAETAPA.CODETAPA = @ETAPA
	END

	--Inserindo dados na tabela SNOTAETAPA --
	IF @MEDIANOTA IS NOT NULL
	BEGIN
		INSERT INTO SNOTAETAPA (CODCOLIGADA, CODETAPA, TIPOETAPA, IDTURMADISC, RA, IDGRUPO, NOTAFALTA, AULASDADAS)
		VALUES (1,@ETAPA, 'N', @IDTURMADISC, @RA, NULL, ROUND(@MEDIANOTA, 0), NULL)
	END
  
	--Inserindo dados na tabela de Log --
	INSERT ZLOGRM (IDLOGRM,DATAHORA,USUARIO,COMPUTADOR,SISTEMA,TIPO,PROCESSO,DADOS) VALUES
	(@ID,GETDATE(),@USUARIO,@COMPUTADOR,@SISTEMA,@TIPO,@PROCESSO,@DADOS)

END


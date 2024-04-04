

 
DECLARE @Mes INT
,@Ano INT
 


 SELECT
 @Mes = 1,
 @Ano = 2019
 
  IF EXISTS(SELECT * FROM TEMPDB.SYS.all_objects WHERE NAME LIKE '#TEMP_CAL%') 

  DELETE FROM #TEMP_CAL  
 
 ELSE
 
	 CREATE TABLE #TEMP_CAL

 (ID INT IDENTITY(1,1) PRIMARY KEY
 ,MES INT
 ,DOMINGO INT
 ,SEGUNDA INT
 ,TERCA INT
 ,QUARTA INT
 ,QUINTA INT
 ,SEXTA INT
 ,SABADO INT
 ,ANO INT
 );

 WHILE @ANO <= 2999
 BEGIN
	 WHILE @MES<=12
		 BEGIN
		;WITH CTE (Data) AS
		(
		  SELECT DATEADD(year, @Ano - 1900, DATEADD(month, @Mes - 1, 0))
		  UNION ALL
		  SELECT Data+1
		  FROM CTE
		  WHERE MONTH(Data + 1) = @Mes
		)

 
	INSERT INTO #TEMP_CAL (MES,DOMINGO,SEGUNDA,TERCA,QUARTA,QUINTA,SEXTA,SABADO,ANO) 


	SELECT
	@MES AS MES
	, [1] AS [Domingo]
	, [2] AS [Segunda-Feira]
	, [3] AS [Terça-Feira]
	, [4] AS [Quarta-Feira]
	, [5] AS [Quinta-Feira]
	, [6] AS [Sexta-Feira]
	, [7] AS [Sábado]
	,@ANO AS ANO
	FROM (
		SELECT DAY(Data) AS Dia, DATEPART(weekday, Data) DiaSemana, DATEPART(week, Data) Semana
		FROM CTE
	) AS Datas
	
	PIVOT
	(
		MAX(Dia) FOR DiaSemana
		IN ([1], [2], [3], [4], [5], [6], [7])
	) 
	AS A
	SET @MES=@MES+1
	
	END
	
	SET @ANO=@ANO+1
	END

	
	 SELECT * FROM  #TEMP_CAL
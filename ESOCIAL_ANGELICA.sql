--USE TAF

--BEGIN TRAN

--UPDATE T1V010 SET  T1V_ATIVO  = 1 WHERE T1V_CPF = '07222062750'	AND T1V_DTALT = '20201102'

--COMMIT

SELECT * FROM T1V010 WHERE T1V_CPF = '07222062750'	AND T1V_DTALT = '20201102'
BEGIN TRAN
UPDATE SMATRICULA SET TIPODISCIPLINA='N' FROM SMATRICULA M WHERE EXISTS(
SELECT * FROM SMATRICULA WHERE  M.RA=RA AND TIPODISCIPLINA='E' AND IDPERLET=232  AND TIPODISCIPLINA='E')
AND TIPODISCIPLINA='E' AND IDPERLET=232

COMMIT
--ROLLBACK

SELECT * FROM SMATRICULA WHERE TIPODISCIPLINA='E' AND IDPERLET=232
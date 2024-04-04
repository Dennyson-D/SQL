
BEGIN TRAN

INSERT INTO SUSUARIOFILIAL (CODCOLIGADA,CODTIPOCURSO,CODFILIAL,CODUSUARIO,ACESSO)

SELECT DISTINCT 1,10,18,GUSRPERFIL.CODUSUARIO,2 FROM GUSRPERFIL

JOIN GUSUARIO ON GUSUARIO.CODUSUARIO = GUSRPERFIL.CODUSUARIO
JOIN SUSUARIOFILIAL ON SUSUARIOFILIAL.CODUSUARIO = GUSUARIO.CODUSUARIO

WHERE CODSISTEMA = 'S' AND CODPERFIL  NOT IN ('18_ALUNO_GRA','18_ALUNO_POS','18_ALU_GRA','18_ALU_POS','18_ALUNO_FAC','18_EAD_POS') AND CODPERFIL LIKE '%18%' AND STATUS = 1
AND SUSUARIOFILIAL.CODTIPOCURSO <> 10 AND GUSUARIO.CODUSUARIO NOT IN ('180701','180680')

COMMIT
 
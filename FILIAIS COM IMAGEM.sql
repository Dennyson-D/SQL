SELECT FIL.CGC
, FIL.CIDADE
, FIL.CODFILIAL
, IM.IMAGEM
, FIL.NOME
, FIL.NOMEFANTASIA
  FROM GFILIAL(NOLOCK) AS FIL

JOIN GIMAGEM (NOLOCK) AS IM ON FIL.IDIMAGEM = IM.ID
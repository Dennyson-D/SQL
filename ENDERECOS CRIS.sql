SELECT NOME,
'ENDERE�O: RUA ' +ISNULL(RUA,'')+' N�'+ ISNULL(NUMERO,'') + ISNULL(CASE WHEN COMPLEMENTO IS NULL THEN '' ELSE 'COMPLEMENTO ' END,0) +ISNULL(COMPLEMENTO,0) +' BAIRRO ' +BAIRRO +' CIDADE ' +CIDADE +' ESTADO ' +ESTADO + ' CEP ' +CEP AS ENDERECO
,'CARTEIRA DE TRABALHO N� '+CARTEIRATRAB + ' S�RIE ' + SERIECARTTRAB + ' UF -'+ UFCARTTRAB AS CARTEIRA_TRABALHO
 FROM PPESSOA WHERE CODUSUARIO = '210001' 
PROCEDURE apu3
SELECT icd_10
SET ORDER TO 
SET FILTER TO ast='+' AND d_code<>' '
GOTO top
DO WHILE NOT EOF()
  lc_code=d_code
  lc_dcode=code
  lc_codew=d_code_w
  lc_dcodew=code_w
  replace code WITH lc_code, d_code WITH lc_dcode, code_W WITH lc_codew, d_code_w WITH lc_dcodew, ast WITH '*'
  SKIP  
ENDDO
return
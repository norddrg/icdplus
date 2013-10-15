Procedure apu
lc_code=' '
lc_dcode=' '
GOTO top
DO WHILE NOT EOF()
  IF code=lc_code AND d_code=lc_dcode
     DELETE
  ELSE
     lc_code=code
     lc_dcode=d_code
  ENDIF 
  SKIP
  loop
ENDDO 
RETURN 
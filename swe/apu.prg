PROCEDURE apu
SELECT old
GOTO top
DO WHILE NOT EOF()
  SELECT icd_10
  SEEK old.code
  IF FOUND()
    replace reldate WITH old.reldate
    replace text WITH old. old_text
    replace valid WITH .f.
  ELSE
    WAIT WINDOW 'Ei l�ydy'
  endif
  SELECT old
  SKIP 
ENDDO 
RETURN 
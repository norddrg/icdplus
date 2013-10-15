PROCEDURE remplus
SELECT icd10plus
lc_ord=ord
DEFINE WINDOW linkki FROM 1,max_x/2 to max_y/2, max_x FONT  max_foty,  max_fosi
Activate WINDOW linkki
IF reldate=CTOD(SPACE(8))
  replace icd10plus.reldate WITH DATE()
endif
lc_loop=.t.
lc_rel=reldate
DO WHILE lc_loop
  WAIT WINDOW NOWAIT 'Check the date of removal! Return without deleting code [PgDn]'
  @ 2,5 say icd10plus.ord
  @ 3,5 say icd10plus.code
  @ 2,14 say icd10plus.text
  @ 4,5 get lc_rel
  READ
  EXIT 
ENDDO 
IF LASTKEY()=3 OR LASTKEY()=18
  replace icd10plus.reldate WITH CTOD(SPACE(8))
  RETURN 
ENDIF 
replace icd10plus.reldate WITH lc_rel
replace released WITH .t.
IF NOT who AND code_est=' ' AND code_den=' ' AND code_fin=' ' and code_ice=' ' AND code_lat=' ' AND code_nor=' ' AND code_swe=' '
   DELETE
   PACK
ENDIF
SEEK lc_ord
DO ..\icd10plus\naytto
RETURN


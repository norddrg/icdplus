PROCEDURE newconf
IF NOT icd10plus.who
* linking to existing addition of ICD10PLUS
  nc_code=icd10plus.ord
  nc_recno=RECNO()
  nc_text=icd10plus.text
  nc_ast=icd10plus.ast
  IF icd10plus.code_fin<>' ' AND icd10plus.code_fin<>icd_10.code
    * as synonymous to existing added code
    APPEND BLANK 
    REPLACE ord WITH nc_code, text WITH nc_text, code_fin WITH icd_10.code
    nc_recno=RECNO()
  ELSE 
    replace icd10plus.code_fin WITH icd_10.code
  ENDIF 
  SET ORDER TO CODE_FIN   && CODE_FIN+D_CODE_FIN
  SEEK icd_10.code
  DO WHILE icd10plus.code_fin=icd_10.code AND NOT EOF()
    IF RECNO()<>nc_recno
      replace code_fin WITH ' '
    ENDIF
    SELECT icd10plus
    SKIP
  ENDDO 
  SEEK icd_10.code
  SET ORDER TO ORD   && ORD+IIF(CODE#" ","A","B")  
  replace icd_10.code_w WITH icd10plus.ord
  IF nc_text=' '
    nc_text=icd_10.text_2
  endif 
  ACTIVATE WINDOW linkki
  @ 15,5 get nc_code
  @ 22,5 get nc_ast
  @ 16,5 get nc_text
  @ 17,5 say 'Correct the text if necessary, accept with [Enter]'
  READ
  RELEASE WINDOW linkki
  replace icd_10.text_2 WITH nc_text
  replace icd10plus.text WITH nc_text
  DO naytto
  RETURN
ENDIF
* linking to an original ICD10 code
SELECT icd10plus
nc_text=text
nc_code=code
nc_loop=.t.
nc_ast=ast
nc_letter=64
DO WHILE nc_loop
  nc_letter=nc_letter+1
  nc_code2=SUBSTR(nc_code,1,4)+CHR(nc_letter)
  SEEK nc_code2
  IF NOT FOUND()
    EXIT
  ENDIF 
ENDDO 
ACTIVATE WINDOW linkki
@ 15,5 get nc_code2
@ 15,12 get nc_ast
@ 16,5 get nc_text
@ 17,5 say 'Correct code or text if necessary'
READ
RELEASE WINDOW linkki
SELECT icd10plus
APPEND BLANK
REPLACE ord WITH nc_code2, code WITH nc_code2, text WITH nc_text, code_fin WITH icd_10.code, ast WITH nc_ast
replace change WITH DATE(), who WITH .f.
nc_recno=RECNO()
replace icd_10.text_2 WITH nc_text
replace icd_10.code_w WITH nc_code2
SELECT icd10plus 
SET ORDER TO CODE_FIN   && CODE_FIN+D_CODE_FIN
SEEK icd_10.code
DO WHILE icd10plus.code_fin=icd_10.code AND NOT EOF()
  IF RECNO()<>nc_recno
    replace code_fin WITH ' '
  ENDIF
  SELECT icd10plus
  SKIP
ENDDO 
SELECT icd10plus
SET ORDER TO ORD   && ORD+IIF(CODE#" ","A","B")
SEEK nc_code2
DO naytto
RETURN


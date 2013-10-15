PROCEDURE linkconf
  DEFINE WINDOW linkki FROM 1,max_x/2 to max_y/2, max_x FONT  max_foty,  max_fosi
SELECT icd10plus
lc_ord=ord
IF icd10plus.code=' '
  WAIT WINDOW 'Linkage with (national) subcode? Y/N' 
  IF NOT (LASTKEY()=121 OR lastkey()=89)
    replace icd_10.text_2 WITH icd10plus.text
    SEEK lc_ord
  ENDIF 
ENDIF 
replace icd_10.code_w WITH icd10plus.ord
lc_ast=ast
lc_recno=RECNO()
DO case
CASE p_kieli='Dan'
  DO dan
CASE p_kieli='Est'
  DO est
CASE p_kieli='Fin'
  DO fin
CASE p_kieli='Eng'
  DO eng
CASE p_kieli='Ice'
  DO ice
CASE p_kieli='Lat'
 DO lat
CASE p_kieli='Nor'
 DO nor
CASE p_kieli='Swe'
 DO swe
ENDCASE

SELECT icd10plus 
SET ORDER TO ORD   && ORD+IIF(CODE#" ","A","B") 
SEEK lc_ord
IF icd10plus.ast='*'
  ACTIVATE WINDOW linkki
  @ 12,5 say 'Check the english text for the combined code'
  @ 13,5 get icd_10.text_2
  READ 
  SELECT icd10plus
  SET ORDER TO ORD   && ORD
  SEEK icd_10.d_code_w
  SET FILTER TO  icd10plus.ast<>'*' AND icd10plus.code<>'+' AND icd10plus.code<>'_' AND NOT icd10plus.released
  BROWSE WINDOW icd_com FIELDS code:7, ast:2, text:100, code_den:12, code_est:12, code_fin:12, code_ice:12, code_lat:12, code_nor:12, code_swe:12 nowait save nomodify
  DEFINE WINDOW linkki FROM 1,max_x/2 to max_y/2, max_x FONT  max_foty,  max_fosi
  ACTIVATE WINDOW linkki
  @ 2,5 say icd_10.code 
  @ 2,14 say icd_10.d_code
  @ 2,23 say icd_10.text

  @ 4,5 say 'is to be linked with'

  @ 6,5 say icd10plus.code
  @ 6,13 say icd10plus.ast
  @ 6,24 say icd10plus.text

  @ 8,5 say 'Select an etiological code from ICD10PLUS table and press [F12)'
  @ 10,5 say 'To leave the mapping without etiology, press [F11]'
  @ 12,5 say 'Search for ICD10PLUS with [Alt][F]'
  SELECT icd_10
  ON KEY LABEL ALT+F do plushaku
  ON KEY LABEL F12 do ..\icd10plus\secconf
  DEFINE WINDOW haku FROM max_y/2+5, max_x-45 TO max_y-10, max_x FONT max_foty, max_fosi
  ACTIVATE WINDOW haku
  return
ENDIF
SELECT icd_10   
DO ..\icd10plus\naytto
RETURN

PROCEDURE fin
ACTIVATE WINDOW linkki
lc_recno=RECNO()
new_link=.f.
@ 6,5 say icd10plus.ord
@ 6,24 say icd10plus.text
IF icd10plus.code_fin=' '
  replace icd10plus.code_fin WITH icd_10.code
  IF icd_10.text_2=' '
    replace icd_10.text_2 WITH icd10plus.text
  ENDIF 
ELSE 
  WAIT WINDOW 'Replace existing code [Y]/[N]'
  IF LASTKEY()=121 OR lastkey()=89
    replace icd10plus.code_fin WITH icd_10.code
    replace icd_10.text_2 WITH icd10plus.text
  ELSE 
    new_link=.t.
  ENDIF 
ENDIF 
SELECT icd10plus
IF ICD_10.text_2 =' ' 
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
  IF icd_10.d_code<>' '
    SEEK icd_10.d_code_w
    replace icd_10.text_2 WITH TRIM(icd_10.text_2)+"; "+icd10plus.text
  ENDIF 
ENDIF 
SET ORDER TO CODE_fin   
SEEK TRIM(icd_10.code)
DO WHILE icd10plus.code_fin=icd_10.code 
  IF RECNO()<>lc_recno 
    replace code_fin with ' '
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
ACTIVATE WINDOW linkki
@ 12,5 say 'Check the english text'
@ 13,5 get icd_10.text_2
READ 
IF new_link 
  SELECT icd10plus
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_fin WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
RETURN 

PROCEDURE swe
ACTIVATE WINDOW linkki
lc_recno=RECNO()
new_link=.f.
@ 6,5 say icd10plus.ord
@ 6,24 say icd10plus.text
IF icd10plus.code_swe=' '
  replace icd10plus.code_swe WITH icd_10.code
  IF icd_10.text_2=' '
    replace icd_10.text_2 WITH icd10plus.text
  ENDIF 
ELSE 
  WAIT WINDOW 'Replace existing code [Y]/[N]'
  IF LASTKEY()=121 OR lastkey()=89
    replace icd10plus.code_swe WITH icd_10.code
    replace icd_10.text_2 WITH icd10plus.text
  ELSE 
    new_link=.t.
  ENDIF 
ENDIF 
SELECT icd10plus
IF ICD_10.text_2 =' ' 
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
  IF icd_10.d_code<>' '
    SEEK icd_10.d_code_w
    replace icd_10.text_2 WITH TRIM(icd_10.text_2)+"; "+icd10plus.text
  ENDIF 
ENDIF 
SET ORDER TO CODE_SWE   
SEEK TRIM(icd_10.code)
DO WHILE icd10plus.code_swe=icd_10.code 
  IF RECNO()<>lc_recno 
    replace code_swe with ' '
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
ACTIVATE WINDOW linkki
@ 12,5 say 'Check the english text'
@ 13,5 get icd_10.text_2
READ 
IF new_link 
  SELECT icd10plus
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_swe WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
RETURN 

PROCEDURE est
ACTIVATE WINDOW linkki
lc_recno=RECNO()
new_link=.f.
@ 6,5 say icd10plus.ord
@ 6,24 say icd10plus.text
IF icd10plus.code_est=' '
  replace icd10plus.code_est WITH icd_10.code
  IF icd_10.text_2=' '
    replace icd_10.text_2 WITH icd10plus.text
  ENDIF 
ELSE 
  WAIT WINDOW 'Replace existing code [Y]/[N]'
  IF LASTKEY()=121 OR lastkey()=89
    replace icd10plus.code_est WITH icd_10.code
    replace icd_10.text_2 WITH icd10plus.text
  ELSE 
    new_link=.t.
  ENDIF 
ENDIF 
SELECT icd10plus
IF ICD_10.text_2 =' ' 
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
  IF icd_10.d_code<>' '
    SEEK icd_10.d_code_w
    replace icd_10.text_2 WITH TRIM(icd_10.text_2)+"; "+icd10plus.text
  ENDIF 
ENDIF 
SET ORDER TO CODE_EST   
SEEK TRIM(icd_10.code)
DO WHILE icd10plus.code_est=icd_10.code 
  IF RECNO()<>lc_recno 
    replace code_est with ' '
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
ACTIVATE WINDOW linkki
@ 12,5 say 'Check the english text'
@ 13,5 get icd_10.text_2
READ 
IF new_link 
  SELECT icd10plus
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_est WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
RETURN 

PROCEDURE ice
ACTIVATE WINDOW linkki
lc_recno=RECNO()
new_link=.f.
@ 6,5 say icd10plus.ord
@ 6,24 say icd10plus.text
IF icd10plus.code_ice=' '
  replace icd10plus.code_ice WITH icd_10.code
  IF icd_10.text_2=' '
    replace icd_10.text_2 WITH icd10plus.text
  ENDIF 
ELSE 
  WAIT WINDOW 'Replace existing code [Y]/[N]'
  IF LASTKEY()=121 OR lastkey()=89
    replace icd10plus.code_ice WITH icd_10.code
    replace icd_10.text_2 WITH icd10plus.text
  ELSE 
    new_link=.t.
  ENDIF 
ENDIF 
SELECT icd10plus
IF ICD_10.text_2 =' ' 
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
  IF icd_10.d_code<>' '
    SEEK icd_10.d_code_w
    replace icd_10.text_2 WITH TRIM(icd_10.text_2)+"; "+icd10plus.text
  ENDIF 
ENDIF 
SET ORDER TO CODE_ICE   
SEEK TRIM(icd_10.code)
DO WHILE icd10plus.code_ice=icd_10.code 
  IF RECNO()<>lc_recno 
    replace code_ice with ' '
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
ACTIVATE WINDOW linkki
@ 12,5 say 'Check the english text'
@ 13,5 get icd_10.text_2
READ 
IF new_link 
  SELECT icd10plus
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_ice WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
RETURN 

PROCEDURE lat
ACTIVATE WINDOW linkki
lc_recno=RECNO()
new_link=.f.
@ 6,5 say icd10plus.ord
@ 6,24 say icd10plus.text
IF icd10plus.code_lat=' '
  replace icd10plus.code_lat WITH icd_10.code
  IF icd_10.text_2=' '
    replace icd_10.text_2 WITH icd10plus.text
  ENDIF 
ELSE 
  WAIT WINDOW 'Replace existing code [Y]/[N]'
  IF LASTKEY()=121 OR lastkey()=89
    replace icd10plus.code_lat WITH icd_10.code
    replace icd_10.text_2 WITH icd10plus.text
  ELSE 
    new_link=.t.
  ENDIF 
ENDIF 
SELECT icd10plus
IF ICD_10.text_2 =' ' 
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
  IF icd_10.d_code<>' '
    SEEK icd_10.d_code_w
    replace icd_10.text_2 WITH TRIM(icd_10.text_2)+"; "+icd10plus.text
  ENDIF 
ENDIF 
SET ORDER TO CODE_lat   
SEEK TRIM(icd_10.code)
DO WHILE icd10plus.code_lat=icd_10.code 
  IF RECNO()<>lc_recno 
    replace code_lat with ' '
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
ACTIVATE WINDOW linkki
@ 12,5 say 'Check the english text'
@ 13,5 get icd_10.text_2
READ 
IF new_link 
  SELECT icd10plus
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_lat WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
RETURN 

PROCEDURE nor
ACTIVATE WINDOW linkki
lc_recno=RECNO()
new_link=.f.
@ 6,5 say icd10plus.ord
@ 6,24 say icd10plus.text
IF icd10plus.code_nor=' '
  replace icd10plus.code_nor WITH icd_10.code
  IF icd_10.text_2=' '
    replace icd_10.text_2 WITH icd10plus.text
  ENDIF 
ELSE 
  WAIT WINDOW 'Replace existing code [Y]/[N]'
  IF LASTKEY()=121 OR lastkey()=89
    replace icd10plus.code_nor WITH icd_10.code
    replace icd_10.text_2 WITH icd10plus.text
  ELSE 
    new_link=.t.
  ENDIF 
ENDIF 
SELECT icd10plus
IF ICD_10.text_2 =' ' 
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
  IF icd_10.d_code<>' '
    SEEK icd_10.d_code_w
    replace icd_10.text_2 WITH TRIM(icd_10.text_2)+"; "+icd10plus.text
  ENDIF 
ENDIF 
SET ORDER TO CODE_nor   
SEEK TRIM(icd_10.code)
DO WHILE icd10plus.code_nor=icd_10.code 
  IF RECNO()<>lc_recno 
    replace code_nor with ' '
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
ACTIVATE WINDOW linkki
@ 12,5 say 'Check the english text'
@ 13,5 get icd_10.text_2
READ 
IF new_link 
  SELECT icd10plus
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_nor WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
RETURN 

PROCEDURE dan
ACTIVATE WINDOW linkki
lc_recno=RECNO()
new_link=.f.
@ 6,5 say icd10plus.ord
@ 6,24 say icd10plus.text
lc_ord=icd10plus.ord
lc_text=icd10plus.text
IF icd_10.d_code_w<>' '
  SET ORDER TO CODE_DEN
  SEEK icd_10.code+'*'
  IF NOT FOUND()
    APPEND blank
    replace ord WITH lc_ord, code_den WITH icd_10.code+'*', ast WITH '*', usedate WITH icd_10.usedate, text WITH lc_text
    lc_recno=RECNO()
  ENDIF 
ELSE  
  IF icd10plus.code_den=' '
    replace icd10plus.code_den WITH icd_10.code
    IF icd_10.text_2=' '
      replace icd_10.text_2 WITH icd10plus.text
    ENDIF 
  ELSE 
    WAIT WINDOW 'Replace existing code [Y]/[N]'
    IF LASTKEY()=121 OR lastkey()=89
      replace icd10plus.code_den WITH icd_10.code
      replace icd_10.text_2 WITH icd10plus.text
    ELSE 
      new_link=.t.
    ENDIF 
  ENDIF 
ENDIF 
SELECT icd10plus
SET ORDER TO CODE   && UPPER(CODE)+UPPER(D_CODE)
IF ICD_10.text_2 =' ' 
  replace icd_10.text_2 WITH lc_text
  IF LEN(TRIM(icd_10.d_code_w))>0
    SEEK icd_10.d_code_w
    replace icd_10.text_2 WITH TRIM(icd_10.text_2)+"; "+icd10plus.text
  ENDIF 
ENDIF 
SET ORDER TO CODE_den
den_code=icd_10.code
IF LEN(TRIM(icd_10.d_code_w))>0
  den_code=den_code+'*'
ENDIF 
SEEK TRIM(den_code)
DO WHILE icd10plus.code_den=den_code
  IF RECNO()<>lc_recno 
    replace code_den with ' '
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
ACTIVATE WINDOW linkki
@ 12,5 say 'Check the english text'
@ 13,5 get icd_10.text_2
READ 
IF new_link 
  SELECT icd10plus
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_den WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
RETURN 

PROCEDURE eng
ACTIVATE WINDOW linkki
lc_recno=RECNO()
new_link=.f.
@ 6,5 say icd10plus.ord
@ 6,24 say icd10plus.text
IF icd10plus.code_who=' '
  replace icd10plus.code_who WITH icd_10.code
  IF icd_10.text_2=' '
    replace icd_10.text_2 WITH icd10plus.text
  ENDIF 
ELSE 
  WAIT WINDOW 'Replace existing code [Y]/[N]'
  IF LASTKEY()=121 OR lastkey()=89
    replace icd10plus.code_who WITH icd_10.code
    replace icd_10.text_2 WITH icd10plus.text
  ELSE 
    new_link=.t.
  ENDIF 
ENDIF 
SELECT icd10plus
IF ICD_10.text_2 =' ' 
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
  IF icd_10.d_code<>' '
    SEEK icd_10.d_code_w
    replace icd_10.text_2 WITH TRIM(icd_10.text_2)+"; "+icd10plus.text
  ENDIF 
ENDIF 
SET ORDER TO CODE_WHO   
SEEK TRIM(icd_10.code)
DO WHILE icd10plus.code_who=icd_10.code 
  IF RECNO()<>lc_recno 
    replace code_who with ' '
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
ACTIVATE WINDOW linkki
@ 12,5 say 'Check the english text'
@ 13,5 get icd_10.text_2
READ 
IF new_link 
  SELECT icd10plus
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_who WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
RETURN 
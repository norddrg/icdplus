PROCEDURE nextcase
SELECT icd10plus
SET FILTER TO 
DELETE ALL FOR code_who=' ' AND code_fin=' ' AND code_swe=' ' AND code_nor=' ' AND code_den=' ' AND code_est=' ' AND code_lat=' ' AND code_ice=' '
PACK
SELECT icd_10
SET FILTER TO 
GOTO TOP 
DO WHILE NOT EOF()
  SELECT icd10plus
  SET FILTER TO reldate=CTOD(SPACE(8))
  DO case
  CASE p_kieli='Fin'
    SET ORDER TO code_fin
  CASE p_kieli='Swe'
    SET ORDER TO code_swe
  CASE p_kieli='Nor'
    SET ORDER TO CODE_NOR   && CODE_NOR
  CASE p_kieli='Den'
    SET ORDER TO CODE_DEN   && CODE_DEN
  CASE p_kieli='Est'
    SET ORDER TO CODE_EST   && CODE_EST
  CASE p_kieli='Lat'
    SET ORDER TO CODE_LAT   && CODE_LAT
  CASE p_kieli='Ice'
    SET ORDER TO CODE_ICE   && CODE_LAT  
  CASE p_kieli='Dan'
    SET ORDER TO CODE_DEN   && CODE_DEN  
  CASE p_kieli='Eng'
    SET ORDER TO code_who
  ENDCASE  
  f_d_code=.t.
  f_code=.t.
  lc_text_a=' '
  lc_text_d=' '
  lc_icd=icd_10.code
  IF p_kieli='Dan'
    lc_icd=SUBSTR(icd_10.code,2,7)
    DO case
    CASE icd_10.code='M'
      lc_icd= '_'+SUBSTR(lc_icd,2,5)
    CASE icd_10.code='U'
      lc_icd= '+'+SUBSTR(lc_icd,2,5)
    ENDCASE 
  ENDIF 
  IF LEN(TRIM(icd_10.code))>0
    SEEK icd_10.code
    IF p_kieli='Dan' AND LEN(TRIM(icd_10.d_code_w))>0
       SEEK icd_10.code+'*'
    ENDIF 
    IF FOUND()
      DO CASE 
      CASE p_kieli='Fin'
        replace relfin WITH icd_10.reldate, usefin WITH icd_10.usedate
      CASE p_kieli='Swe'
        replace relswe WITH icd_10.reldate, useswe WITH icd_10.usedate
      CASE p_kieli='Nor'
        replace relnor WITH icd_10.reldate, usenor WITH icd_10.usedate
      CASE p_kieli='Den'
        replace relden WITH icd_10.reldate, usedan WITH icd_10.usedate
      CASE p_kieli='Est'
        replace relest WITH icd_10.reldate, useest WITH icd_10.usedate
      CASE p_kieli='Lat'
        replace rellat WITH icd_10.reldate, uselat WITH icd_10.usedate
      CASE p_kieli='Ice'
        replace relice WITH icd_10.reldate, useice WITH icd_10.usedate
      ENDCASE  
   ENDIF 
    IF icd10plus.ord<>icd_10.code_w OR NOT FOUND() OR (reldate<icd_10.reldate AND reldate<>CTOD(SPACE(9)))
      f_code=.f.
    ELSE 
      lc_text_a=TRIM(text)
    ENDIF 
  ENDIF 
  IF LEN(TRIM(icd_10.d_code))>0 
    SEEK (TRIM(icd_10.d_code))
    IF TRIM(icd_10.d_code_w) <> TRIM(icd10plus.ord) OR NOT FOUND() OR (reldate<icd_10.reldate AND reldate<>CTOD(SPACE(9)))
      f_d_code=.f.
    endif
  ENDIF 
  IF LEN(TRIM(icd_10.d_code_w))>0 
    SET ORDER to CODE   && CODE
    SEEK icd_10.d_code_w
    IF FOUND()
      DO CASE 
      CASE p_kieli='Fin'
        replace relfin WITH icd_10.reldate
      CASE p_kieli='Swe'
        replace relswe WITH icd_10.reldate
      CASE p_kieli='Nor'
        replace relnor WITH icd_10.reldate
      CASE p_kieli='Est'
        replace relest WITH icd_10.reldate
      CASE p_kieli='Lat'
        replace rellat WITH icd_10.reldate
      CASE p_kieli='Ice'
        replace relice WITH icd_10.reldate
      CASE p_kieli='Dan'
        replace reldan WITH icd_10.reldate
      ENDCASE  
      IF (usewho=CTOD(SPACE(8)) OR relwho<>CTOD(SPACE(8))) AND (useden=CTOD(SPACE(8)) OR reldan<>CTOD(SPACE(8))); 
      AND (useest=CTOD(SPACE(8)) OR relest<>CTOD(SPACE(8))) AND (usefin=CTOD(SPACE(8)) OR relfin<>CTOD(SPACE(8))); 
      AND (useice=CTOD(SPACE(8)) OR relice<>CTOD(SPACE(8))) AND (uselat=CTOD(SPACE(8)) OR rellat<>CTOD(SPACE(8))); 
      AND (usenor=CTOD(SPACE(8)) OR relnor<>CTOD(SPACE(8))) AND (useswe=CTOD(SPACE(8)) OR  relswe<>CTOD(SPACE(8))) 
        replace released WITH .t.
        IF reldate=CTOD(SPACE(8))
          replace reldate WITH CTOD(STR(YEAR(date()),4)+'/12/31')
        endif
        IF reldate>reldan AND reldan<>CTOD(SPACE(8))
          replace reldate WITH reldan
        ENDIF 
        IF reldate>relest AND relest<>CTOD(SPACE(8))
          replace reldate WITH relest
        ENDIF 
        IF reldate>relfin AND relfin<>CTOD(SPACE(8))
          replace reldate WITH relfin
        ENDIF 
        IF reldate>relice AND relice<>CTOD(SPACE(8))
          replace reldate WITH relice
        ENDIF 
        IF reldate>rellat AND rellat<>CTOD(SPACE(8))
           replace reldate WITH rellat
        ENDIF 
        IF reldate>relnor AND relnor<>CTOD(SPACE(8))
           replace reldate WITH relnor
        ENDIF 
        IF reldate>relswe AND relswe<>CTOD(SPACE(8))
           replace reldate WITH relswe
        ENDIF
        IF usedate>reldate
           DELETE
        ENDIF  
      ENDIF 
    ENDIF 
    IF TRIM(icd_10.d_code_w) <> TRIM(icd10plus.ord) OR NOT FOUND() OR (reldate<icd_10.reldate AND reldate<>CTOD(SPACE(9)))
      f_d_code=.f.
    endif
  ENDIF 
  DO case
  CASE f_code=.f. AND f_d_code=.f.
    WAIT WINDOW 'Error in linkage, neither code nor d_code was not found in ICD10PLUS' NOWAIT 
  CASE f_code=.t. AND f_d_code=.f.
    WAIT WINDOW 'Error in linkage, d_code was not found in ICD10PLUS' NOWAIT
  CASE f_code=.f. AND f_d_code=.t.
    WAIT WINDOW 'Error in linkage, code was not found in ICD10PLUS' NOWAIT 
  CASE LEN(TRIM(icd_10.code_w))=0
    WAIT WINDOW 'No linkage!' nowait
    f_code=.f.
  OTHERWISE
    IF icd10plus.usedate = CTOD(space(9)) OR (icd10plus.usedate>icd_10.usedate AND NOT icd_10.usedate=CTOD(SPACE(9)))
      replace icd10plus.usedate WITH icd_10.usedate
    ENDIF 
    SELECT icd_10
    IF icd_10.usedate=CTOD(space(9))
      replace icd_10.usedate WITH icd10plus.usedate
    ENDIF 
    IF text_2=' '
      IF d_code_w<>' '
        SELECT icd10plus
        SET ORDER TO ORD   && ORD
        SEEK icd_10.code_w
        replace icd_10.text_2 WITH icd10plus.text
        SEEK icd_10.d_code_w
        replace icd_10.text_2 WITH TRIM(icd_10.text_2)+'; '+icd10plus.text
        SELECT icd_10
      ELSE 
        replace text_2 WITH icd10plus.text
      ENDIF 
    ENDIF 
    SKIP 
    LOOP 
  ENDCASE
  SELECT icd10plus
  SET ORDER TO ord
  IF f_d_code=.f.
     SEEK TRIM(icd_10.code_w)
     IF icd10plus.ord=TRIM(icd_10.code_w)+'0'
       lc_text_a=TRIM(text)
     endif
     SEEK TRIM(icd_10.d_code_w)
     IF icd10plus.ord=TRIM(icd_10.d_code)+'0' OR icd10plus.ord=SUBSTR(icd_10.d_code_w,1,4)+'0'
        replace icd_10.d_code_w WITH icd10plus.ord
        IF p_kieli='Dan'
           lc_ord=ord
           lc_text_d=text
           APPEND BLANK
           replace ord WITH lc_ord, usedate WITH icd_10.usedate, code_den WITH icd_10.code+'+'
           IF icd_10.text_2<>' '
             replace text WITH icd_10.text_2
           ELSE 
             replace text WITH lc_text_a+'; '+lc_text_d 
           ENDIF 
        ENDIF 
     ELSE 
        EXIT 
     ENDIF
     IF f_code=.t.
        EXIT 
     ENDIF  
  ENDIF  
  IF f_code=.f.
    SEEK TRIM(icd_10.code_w)
    IF icd10plus.ord=TRIM(lc_icd)+'0'; 
    OR icd10plus.ord=SUBSTR(icd_10.code_w,1,4)+'0'; 
    OR icd10plus.ord='+'+UPPER(TRIM(lc_icd))
      IF NOT (p_kieli='Dan' AND icd_10.d_code_w<>' ')
        DO autoupda
      ELSE 
        replace icd_10.code_w WITH ord
        lc_ord=ord
        lc_text_a=text
        APPEND BLANK
        replace ord WITH lc_ord, usedate WITH icd_10.usedate, code_den WITH icd_10.code+'*'
        IF icd_10.text_2<>' '
          replace text WITH icd_10.text_2
        ELSE 
          replace text WITH lc_text_a+'; '+lc_text_d
        ENDIF 
        EXIT          
      ENDIF 
      IF f_d_code=.f.
        EXIT 
      ENDIF 
    ELSE 
      IF (lc_icd='V' OR lc_icd='W' OR lc_icd='X' OR lc_icd='Y') and LEN(TRIM(icd_10.code_w))=5 
        IF NOT FOUND()
           SET ORDER TO CODE_SWE 
           SEEK TRIM(lc_icd)
        ENDIF
        IF FOUND()
          DO autoext 
        ENDIF 
      ELSE 
        EXIT 
      ENDIF 
    ENDIF 
    SELECT icd_10
    SKIP
    LOOP 
  ENDIF 
  exit
ENDDO 
SELECT icd10plus
pack
SELECT icd_10
do ..\icd10plus\naytto
RETURN 

PROCEDURE autoupda
SELECT icd10plus
SET FILTER TO 
SET ORDER TO ord
lc_ord=ord
IF icd10plus.code=' '
  SEEK lc_ord
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
  SELECT icd10plus
  SET ORDER TO ORD   && ORD
  SEEK icd_10.d_code_w
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
  @ 12,5 say 'Serch for ICD10PLUS with [Alt][F]'
  SET FILTER TO  icd10plus.ast<>'*' AND icd10plus.code<>'+' AND icd10plus.code<>'_' AND NOT icd10plus.released
  BROWSE WINDOW icd_com FIELDS code:7, ast:2, text:100, code_den:12, code_est:12, code_fin:12, code_ice:12, code_lat:12, code_nor:12, code_swe:12 nowait save nomodify
  SELECT icd_10
  ON KEY LABEL ALT+F do plushaku
  ON KEY LABEL F12 do ..\icd10plus\secconf
  DEFINE WINDOW haku FROM max_y/2+5, max_x-45 TO max_y-10, max_x FONT max_foty, max_fosi
  ACTIVATE WINDOW haku
  RETURN 
ENDIF
SELECT icd_10   
DO ..\icd10plus\naytto
RETURN

PROCEDURE autoext
lc_ord=icd10plus.ord
IF icd_10.text_2=' '
  replace icd_10.text_2 WITH icd10plus.text
ENDIF 
SELECT icd10plus
SET ORDER TO CODE_SWE
SEEK icd_10.code
IF NOT FOUND()
  SEEK TRIM(icd_10.code)
ENDIF 
IF NOT FOUND()
  APPEND BLANK
  REPLACE ord WITH lc_ord, text WITH icd_10.text_2, usedate WITH icd_10.usedate
  replace icd_10.code_w WITH icd10plus.ord
ELSE 
  replace icd_10.code_w WITH icd10plus.ord
ENDIF 
DO case
CASE p_kieli='Dan'
  replace code_den WITH icd_10.code
CASE p_kieli='Est'
  replace code_est WITH icd_10.code
CASE p_kieli='Fin'
  replace code_fin WITH icd_10.code
CASE p_kieli='Eng'
  replace code_eng WITH icd_10.code
CASE p_kieli='Ice'
  replace code_ice WITH icd_10.code
CASE p_kieli='Lat'
  replace code_lat WITH icd_10.code
CASE p_kieli='Nor'
  replace code_nor WITH icd_10.code
CASE p_kieli='Swe'
  replace code_swe WITH icd_10.code
ENDCASE
RETURN 
 
PROCEDURE fin
IF icd10plus.code_fin=' '
  replace icd10plus.code_fin WITH icd_10.code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
endif
SET ORDER TO CODE_FIN   && CODE_FIN+D_CODE_FIN
SEEK TRIM(icd_10.code)
loc_found=.f.
DO WHILE icd10plus.code_fin=icd_10.code 
  IF icd10plus.ord<> icd_10.code_w OR lc_recno<>RECNO()
    replace code_fin with ' '
  ELSE
    loc_found=.t.
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_fin WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
SELECT icd_10   
DO ..\icd10plus\naytto
RETURN 

PROCEDURE swe
IF icd10plus.code_swe=' '
  replace icd10plus.code_swe WITH icd_10.code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
endif
SET ORDER TO CODE_SWE   
SEEK TRIM(icd_10.code)
loc_found=.f.
DO WHILE icd10plus.code_swe=icd_10.code 
  IF icd10plus.ord<> icd_10.code_w OR lc_recno<>RECNO()
    replace code_swe with ' '
  ELSE
    loc_found=.t.
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_swe WITH icd_10.code, ast WITH lc_ast,usedate WITH icd_10.usedate
ENDIF   
SELECT icd_10   
DO ..\icd10plus\naytto
RETURN 

PROCEDURE est
IF icd10plus.code_est=' '
  replace icd10plus.code_est WITH icd_10.code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
endif
SET ORDER TO CODE_EST
SEEK TRIM(icd_10.code)
loc_found=.f.
DO WHILE icd10plus.code_est=icd_10.code 
  IF icd10plus.ord<> icd_10.code_w OR lc_recno<>RECNO()
    replace code_est with ' '
  ELSE
    loc_found=.t.
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_est WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
SELECT icd_10   
DO ..\icd10plus\naytto
RETURN 

PROCEDURE ice
IF icd10plus.code_ice=' '
  replace icd10plus.code_ice WITH icd_10.code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
endif
SET ORDER TO CODE_ICE
SEEK TRIM(icd_10.code)
loc_found=.f.
DO WHILE icd10plus.code_ice=icd_10.code 
  IF icd10plus.ord<> icd_10.code_w OR lc_recno<>RECNO()
    replace code_ice with ' '
  ELSE
    loc_found=.t.
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_ice WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
SELECT icd_10   
DO ..\icd10plus\naytto
RETURN 

PROCEDURE lat
IF icd10plus.code_lat=' '
  replace icd10plus.code_lat WITH icd_10.code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
endif
SET ORDER TO CODE_LAT
SEEK TRIM(icd_10.code)
loc_found=.f.
DO WHILE icd10plus.code_lat=icd_10.code 
  IF icd10plus.ord<> icd_10.code_w OR lc_recno<>RECNO()
    replace code_lat with ' '
  ELSE
    loc_found=.t.
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_lat WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
SELECT icd_10   
DO ..\icd10plus\naytto
RETURN 

PROCEDURE nor
IF icd10plus.code_nor=' '
  replace icd10plus.code_nor WITH icd_10.code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
endif
SET ORDER TO CODE_nor
SEEK TRIM(icd_10.code)
loc_found=.f.
DO WHILE icd10plus.code_nor=icd_10.code 
  IF icd10plus.ord<> icd_10.code_w OR lc_recno<>RECNO()
    replace code_nor with ' '
  ELSE
    loc_found=.t.
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_nor WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
SELECT icd_10   
DO ..\icd10plus\naytto
RETURN 

PROCEDURE dan
IF icd10plus.code_den=' '
  replace icd10plus.code_den WITH icd_10.code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  replace icd_10.text_2 WITH icd10plus.text
endif
SET ORDER TO CODE_den
SEEK TRIM(icd_10.code)
loc_found=.f.
DO WHILE icd10plus.code_den=icd_10.code 
  IF icd10plus.ord<> icd_10.code_w OR lc_recno<>RECNO()
    replace code_den with ' '
  ELSE
    loc_found=.t.
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_den WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
SELECT icd_10   
DO ..\icd10plus\naytto
RETURN 

PROCEDURE eng
IF icd10plus.code_who=' '
  replace icd10plus.code_who WITH icd_10.code
endif
SELECT icd10plus
SET ORDER TO CODE_who
SEEK TRIM(icd_10.code)
loc_found=.f.
DO WHILE icd10plus.code_who=icd_10.code 
  IF icd10plus.ord<> icd_10.code_w OR lc_recno<>RECNO()
    replace code_who with ' '
  ELSE
    loc_found=.t.
  ENDIF
  IF EOF()
    EXIT 
  ENDIF 
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text, code_who WITH icd_10.code, ast WITH lc_ast, usedate WITH icd_10.usedate
ENDIF 
SELECT icd_10   
DO ..\icd10plus\naytto
RETURN 
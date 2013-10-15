PROCEDURE secconf
replace icd_10.d_code_w WITH icd10plus.code
lc1_text=' '
SET FILTER TO NOT icd10plus.released

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

replace reldate WITH icd_10.reldate
IF icd_10.text_2=' '
  IF icd_10.d_code<>' '
    IF icd_10.d_code_w<>' '
      SELECT icd10plus
      SEEK icd_10.d_code_w
      IF FOUND()
        replace icd_10.text_2 WITH TRIM(lc1_text)+'; '+icd10plus.text
      ENDIF 
    ENDIF 
  ELSE 
    replace icd_10.text_2 WITH lc1_text
  ENDIF 
ENDIF 

DO ..\icd10plus\naytto
RETURN

PROCEDURE fin
IF icd10plus.code_fin=' '
  replace icd10plus.code_fin WITH icd_10.d_code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  lc1_text= icd10plus.text
endif
SET ORDER TO CODE_FIN   && CODE_FIN+D_CODE_FIN
SEEK TRIM(icd_10.code)
loc_found=.f.
DO WHILE icd10plus.code_fin=icd_10.code AND NOT EOF()
  IF icd10plus.ord<> icd_10.code_w
    replace code_fin with ' '
  ELSE
    loc_found=.t.
  ENDIF
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_fin WITH icd_10.code
ENDIF 
RETURN 

PROCEDURE swe
IF icd10plus.code_swe=' '
  replace icd10plus.code_swe WITH icd_10.d_code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  lc1_text= icd10plus.text
endif
SET ORDER TO CODE_SWE   && CODE_SWE+D_CODE_SWE
SEEK TRIM(icd_10.d_code)
loc_found=.f.
DO WHILE icd10plus.code_swe=icd_10.d_code AND NOT EOF()
  IF icd10plus.ord<> icd_10.d_code_w
    replace code_swe with ' '
  ELSE
    loc_found=.t.
  ENDIF
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_swe WITH icd_10.code
ENDIF 
RETURN 

PROCEDURE est
IF icd10plus.code_est=' '
  replace icd10plus.code_est WITH icd_10.d_code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  lc1_text= icd10plus.text
endif
SET ORDER TO CODE_EST   && CODE_SWE+D_CODE_SWE
SEEK TRIM(icd_10.d_code)
loc_found=.f.
DO WHILE icd10plus.code_est=icd_10.d_code AND NOT EOF()
  IF icd10plus.ord<> icd_10.d_code_w
    replace code_est with ' '
  ELSE
    loc_found=.t.
  ENDIF
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_est WITH icd_10.code
ENDIF 
RETURN 

PROCEDURE ice
IF icd10plus.code_ice=' '
  replace icd10plus.code_ice WITH icd_10.d_code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  lc1_text= icd10plus.text
endif
SET ORDER TO CODE_ICE   && CODE_SWE+D_CODE_SWE
SEEK TRIM(icd_10.d_code)
loc_found=.f.
DO WHILE icd10plus.code_ice=icd_10.d_code AND NOT EOF()
  IF icd10plus.ord<> icd_10.d_code_w
    replace code_ice with ' '
  ELSE
    loc_found=.t.
  ENDIF
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_ice WITH icd_10.code
ENDIF 
RETURN 

PROCEDURE lat
IF icd10plus.code_lat=' '
  replace icd10plus.code_lat WITH icd_10.d_code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  lc1_text= icd10plus.text
endif
SET ORDER TO CODE_lat   && CODE_SWE+D_CODE_SWE
SEEK TRIM(icd_10.d_code)
loc_found=.f.
DO WHILE icd10plus.code_lat=icd_10.d_code AND NOT EOF()
  IF icd10plus.ord<> icd_10.d_code_w
    replace code_lat with ' '
  ELSE
    loc_found=.t.
  ENDIF
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_lat WITH icd_10.code
ENDIF 
RETURN 

PROCEDURE nor
IF icd10plus.code_nor=' '
  replace icd10plus.code_nor WITH icd_10.d_code
endif
SELECT icd10plus
IF ICD_10.text_2 =' '
  SEEK icd_10.code_w
  lc1_text= icd10plus.text
endif
SET ORDER TO CODE_nor   && CODE_SWE+D_CODE_SWE
SEEK TRIM(icd_10.d_code)
loc_found=.f.
DO WHILE icd10plus.code_nor=icd_10.d_code AND NOT EOF()
  IF icd10plus.ord<> icd_10.d_code_w
    replace code_nor with ' '
  ELSE
    loc_found=.t.
  ENDIF
  skip
ENDDO 
IF NOT loc_found
  APPEND BLANK
  REPLACE ord WITH icd_10.code_w, text WITH icd_10.text_2, code_nor WITH icd_10.code
ENDIF 
RETURN 

PROCEDURE dan
lc_ord=icd10plus.ord
SELECT icd10plus
SET ORDER TO CODE_DEN   && CODE_DEN
SEEK icd_10.code+'+'
IF NOT FOUND()
   APPEND BLANK 
   replace ord WITH lc_ord, usedate WITH icd_10.usedate, text WITH icd_10.text_2, code_den WITH icd_10.code+'+'
ENDIF 
SEEK icd_10.code+'*'
IF FOUND()
  replace text WITH icd_10.text_2
ENDIF 
RETURN 
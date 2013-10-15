procedure naytto
lc_alias = ALIAS()
DEFINE WINDOW icd_com FROM 1,5 TO max_y/2, max_x-50 FONT max_foty, max_fosi
ACTIVATE WINDOW icd_com
DEFINE WINDOW icd_loc FROM max_y/2+1, 5 TO max_y, max_x-50 FONT max_foty, max_fosi
ACTIVATE WINDOW icd_loc
ON KEY LABEL ALT+F do ..\icd10plus\haku
ON KEY LABEL F12 do ..\icd10plus\linkage
Release WINDOW linkki
IF lc_alias='ICD10PLUS'
  SET FILTER TO 
  SET ORDER TO ORD   && ORD
  SELECT icd_10
  IF icd10plus.ast='*'
    IF p_kieli='Dan'
       SET ORDER TO CODE_W   && CODE_W+D_CODE_W
    ELSE 
      SET ORDER TO D_CODE_W   && D_CODE_W+D_CODE
    ENDIF 
    SEEK TRIM(icd10plus.ord)
    IF NOT FOUND()
       SET ORDER TO CODE_W   && UPPER(CODE_W+D_CODE_W)
       SEEK TRIM(icd10plus.ord)
    ENDIF
  ELSE
    SET ORDER TO CODE_W   && UPPER(CODE_W+D_CODE_W)
    SEEK TRIM(icd10plus.ord)
  ENDIF 
  IF FOUND()
    SET FILTER TO (icd_10.code_w=TRIM(icd10plus.ord) OR icd_10.d_code_w=TRIM(icd10plus.ord))
  ELSE 
    SET FILTER TO (icd_10.code_w=SUBSTR(icd10plus.ord,1,3) OR icd_10.d_code_w=SUBSTR(icd10plus.ord,1,3))
  ENDIF 
ELSE
  SET FILTER TO
  SELECT icd10plus 
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
  CASE p_kieli='Ice'
    SET ORDER TO CODE_ICE   && CODE_EST
  CASE p_kieli='Lat'
    SET ORDER TO CODE_LAT   && CODE_LAT
  CASE p_kieli='Dan'
    SET ORDER TO CODE_DEN   && CODE_DEN
  CASE p_kieli='Eng'
    SET ORDER TO CODE_WHO   && CODE_WHO
  ENDCASE  
  f_d_code=.t.
  f_code=.t.
  IF LEN(TRIM(icd_10.code))>0
    SEEK TRIM(icd_10.code)
    IF p_kieli='Dan' AND len(TRIM(icd_10.d_code_w))>0
       SEEK icd_10.code+'*'
    ENDIF 
    IF TRIM(icd10plus.ord)<>TRIM(icd_10.code_w) OR NOT FOUND() OR (icd10plus.reldate<icd_10.reldate AND icd10plus.reldate<>CTOD(SPACE(9)))
      f_code=.f.
    ENDIF 
  ENDIF 
  IF LEN(TRIM(icd_10.d_code))>0 
    SEEK (TRIM(icd_10.d_code))
    IF TRIM(icd_10.d_code_w) <> TRIM(icd10plus.ord) OR NOT FOUND() OR (icd10plus.reldate<icd_10.reldate AND icd10plus.reldate<>CTOD(SPACE(9)))
      f_d_code=.f.
    endif
  ENDIF 
  IF LEN(TRIM(icd_10.d_code_w))>0 
    SET ORDER to CODE   && CODE
    SEEK icd_10.d_code_w
    IF TRIM(icd_10.d_code_w) <> TRIM(icd10plus.ord) OR NOT FOUND() OR (reldate<DATE() AND reldate<>CTOD(SPACE(9)))
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
    IF icd10plus.released
       WAIT WINDOW 'ICDPLUS code not in use' NOWAIT 
    else
      WAIT WINDOW 'Linkage OK' nowait
    endif
  ENDCASE 
  IF f_code AND f_d_code
    SET FILTER TO (icd10plus.ord = icd_10.code_w OR icd10plus.ord = icd_10.d_code_w) 
  ELSE
    IF p_kieli='Dan'
      SET FILTER TO (icd10plus.ord=SUBSTR(icd_10.code,2,3) OR icd10plus.ord=SUBSTR(icd_10.code_w,1,3) OR icd10plus.ord =SUBSTR(icd_10.d_code_w,1,3))
    ELSE 
      SET FILTER TO (icd10plus.ord=SUBSTR(icd_10.code,1,3)or icd10plus.ord=SUBSTR(icd_10.d_code,1,3); 
      OR icd10plus.ord=SUBSTR(icd_10.code_w,1,3) OR icd10plus.ord=SUBSTR(icd_10.d_code_w,1,3))
    ENDIF 
  ENDIF
ENDIF 
SELECT icd10plus
SET ORDER TO ord 
IF lc_alias='ICD_10'
  GOTO top
  SEEK TRIM(icd_10.code_w) 
ENDIF 
BROWSE WINDOW icd_com FIELDS ord:10,code:10, ast:2, text:75, usedate:5, reldate:5, who: 3, code_who:12, code_den:12, code_est:12, code_fin:12, code_ice:12, code_lat:12, code_nor:12, code_swe:12 nowait save nomodify
SELECT icd_10
SET ORDER TO CODE   && UPPER(CODE+D_CODE) 
BROWSE WINDOW icd_loc FIELDS code:10, ast:2, d_code:10, code_w:10, d_code_w:12, usedate:5, reldate:5, text:100, text_2:100 nowait save nomodify
return


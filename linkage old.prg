PROCEDURE linkage
lc_alias=ALIAS()
SELECT icd10plus
SET ORDER TO ord
IF icd_10.code_w<>' '
  SEEK icd_10.code_w
ELSE
  DO case
  CASE p_kieli='Dan'
    SET ORDER TO CODE_DEN   && CODE_DEN
  CASE p_kieli='Est'
    SET ORDER TO CODE_EST   && CODE_EST
  CASE p_kieli='Fin'
    SET ORDER TO CODE_FIN   && CODE_FIN
  CASE p_kieli='Eng'
    SET ORDER TO CODE   && CODE
  CASE p_kieli='Ice'
    SET ORDER TO CODE_ICE   && CODE_ICE
  CASE p_kieli='Lat'
    SET ORDER TO CODE_LAT   && CODE_LAT
  CASE p_kieli='Nor'
    SET ORDER TO CODE_NOR   && CODE_NOR
  CASE p_kieli='Swe'
     SET ORDER TO CODE_SWE   && CODE_SWE
  ENDCASE
  SEEK icd_10.code
endif
IF NOT FOUND()
  SET ORDER TO ord 
  SEEK SUBSTR(icd_10.code,1,4)
  IF NOT FOUND()
    SEEK SUBSTR(icd_10.code,1,3)  
  ENDIF 
ENDIF 
SET ORDER TO ORD   && ORD
SET FILTER TO NOT icd10plus.released
BROWSE WINDOW icd_com FIELDS ord:7, code:7, ast:2, text:100, code_den:12, code_est:12, code_fin:12, code_ice:12, code_lat:12, code_nor:12, code_swe:12 nowait save nomodify
SELECT icd_10
SET FILTER TO

DEFINE WINDOW linkki FROM 1,max_x/2 to max_y/2, max_x FONT  max_foty,  max_fosi
Activate WINDOW linkki
@ 2,5 say icd_10.code 
@ 2,14 say icd_10.d_code
@ 2,23 say icd_10.text
@ 3,23 say icd_10.text_2

@ 4,5 say 'is to be linked with'

@ 6,5 say icd10plus.ord
@ 6,24 say icd10plus.text

@ 8,5 say 'Select the codes that shall be linked from the tables'
@ 9,5 say 'Accept with [F12] / reject with [F11]'
@ 10,5 say 'Serch for ICD10PLUS with [Alt][F]'

ON KEY LABEL f12 DO ..\icd10plus\linkconf
ON KEY LABEL ALT+F do ..\icd10plus\plushaku

return


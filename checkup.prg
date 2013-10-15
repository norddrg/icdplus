PROCEDURE checkup
release WINDOW icd_com
release WINDOW icd_loc
SELECT icd10plus 
SET FILTER TO code<>'_' AND code<>'+' AND NOT released
SELECT ICD_10
SET FILTER TO ast<>'A'
GOTO top
DO WHILE NOT EOF()
  lc_code=icd_10.code
  lc_dcode=icd_10.d_code
  * Check-up of linkage from national version
  IF icd_10.code_w=' '
    SELECT icd10plus
    SET FILTER TO
    SET ORDER TO code_fin 
    SEEK icd_10.code
    IF FOUND()
      replace icd_10.code_w WITH icd10plus.ord
      WAIT WINDOW 'Automatic assignment of local link '  + icd_10.code
    ELSE 
      WAIT WINDOW 'No linkage '  + icd_10.code
    ENDIF 
    SELECT icd_10
    SET ORDER TO CODE   && UPPER(CODE+D_CODE)
    DO ..\icd10plus\naytto
    exit
  ENDIF 
  * Check-up of correctness of existing linkage from national version
  SELECT icd10plus
  SET ORDER TO ORD   && ORD+IIF(CODE#" ","A","B")
  SEEK icd_10.code_w
  IF NOT FOUND() 
    WAIT WINDOW NOWAIT 'Error in linkage '  + icd_10.code
    SELECT icd_10
    DO ..\icd10plus\naytto
    EXIT
  ELSE 
  * Check-up of English text in national version
  *  IF icd_10.text_2=' '
       lc1_text = icd10plus.text
  *  ENDIF  
  * Check-up and automatic creation of linkage from ICD10PLUS to national version
    IF icd10plus.code_fin = ' '
      replace icd10plus.code_fin WITH icd_10.code
    ELSE 
      SET ORDER To CODE_FIN   && CODE_FIN+D_CODE_FIN
      SEEK icd_10.code
      IF NOT FOUND()
        WAIT WINDOW 'Mapping back in ICD10PLUS is missing ' + icd_10.code
        DO ..\icd10plus\naytto
        exit
      ENDIF 
    ENDIF 
  ENDIF 
  * Check-up and automatic creation of second code linkage from national version
  IF icd_10.d_code<>' '
    IF icd_10.d_code_w = ' '
      SELECT icd10plus
      SET ORDER TO CODE_FIN   && CODE_FIN+D_CODE_FIN
      SEEK icd_10.d_code
      IF FOUND()
        replace icd_10.d_code_w WITH icd10plus.ord
        lc2_text=icd10plus.text
      ELSE 
        WAIT WINDOW 'No linkage of second code ' + icd_10.code+' '+icd_10.d_code
        SELECT icd_10
        DO ..\icd10plus\naytto
        EXIT
      ENDIF 
    ELSE
      SELECT icd10plus 
      SET ORDER TO ORD   && ORD+IIF(CODE#" ","A","B")
      SEEK icd_10.d_code_w
      IF NOT FOUND()
        WAIT WINDOW 'Error in second code linkage ' + icd_10.code+' '+icd_10.d_code
        SELECT icd_10
        DO ..\icd10plus\naytto
        EXIT 
      ELSE
        lc2_text=icd10plus.text
        IF icd10plus.code_fin=' '
          replace icd10plus.code_fin WITH icd_10.d_code
        ENDIF 
      ENDIF 
    ENDIF
    IF icd_10.text_2 = ' '
      replace icd_10.text_2 WITH TRIM(lc1_text)+'; '+lc2_text
    ENDIF 
  ELSE
    IF icd_10.text_2=' '
      replace icd_10.text_2 WITH lc1_text
    ENDIF 
  ENDIF 
  IF icd_10.d_code_w<>' '
    SELECT icd10plus
    SEEK icd_10.code_w
    IF FOUND() AND icd10plus.ast='*'
      replace icd_10.ast WITH '*'
    ELSE 
      SEEK icd_10.d_code_w
      IF FOUND() AND icd10plus.ast='*'
        replace icd_10.ast WITH '+'
      ENDIF 
    ENDIF 
  ENDIF 
  SELECT icd_10
  skip
ENDDO 
SELECT icd10plus
DELETE ALL FOR NOT who AND code_est=' ' AND code_den=' ' AND code_fin=' ' and code_ice=' ' AND code_lat=' ' AND code_nor=' ' AND code_swe=' '
pack
SELECT icd_10
DO ..\icd10plus\naytto
RETURN


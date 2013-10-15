PROCEDURE icdupda
CLEAR all
SET DATE YMD
SELECT 0
USE ..\fin\icd10_2013.dbf ALIAS new
SELECT 0
use icd_10
SET ORDER TO code
SET FILTER TO d_code<>' ' OR (SUBSTR(code,4,1)='.' OR SUBSTR(code,4,1)=' ')
replace ALL valid WITH .f.
SET FILTER TO
SELECT new
SET FILTER TO not(lehtisolmu='F')
GOTO TOP 
DO WHILE NOT EOF()
  lc_oir=' '
  IF AT('*',tunniste)>0
    lc_oir=SUBSTR(koodi1,1,6)+' '
    lc_syy=SUBSTR(koodi2,1,6)+' '
  ENDIF
  IF at('+',tunniste)>0 
    lc_oir=SUBSTR(koodi2,1,6)+' '
    lc_syy=SUBSTR(koodi1,1,6)+' '
  ENDIF 
  IF lc_oir=' '
    lc_oir=SUBSTR(koodi1,1,6)+' '
    lc_syy=SPACE(7)
  ENDIF
  IF AT('.',lc_oir)=4
    lc_oir=SUBSTR(lc_oir,1,3)+SUBSTR(lc_oir,5,2)+'  '
  ENDIF
  IF AT('.',lc_syy)=4
    lc_syy=SUBSTR(lc_syy,1,3)+SUBSTR(lc_syy,5,2)+'  '
  ENDIF 
  SELECT ICD_10
  SEEK lc_oir+lc_syy
  IF FOUND()
    IF new.voimassao1=CTOD('2020/12/31')
      replace valid WITH .t.
    ELSE
      replace reldate WITH new.voimassao1
    ENDIF 
    IF TRIM(new.pitk__nimi)<>TRIM(text) OR TRIM(text)<>TRIM(new.pitk__nimi)
      replace text WITH new.pitk__nimi
    ENDIF 
    replace usedate WITH new.voimassaol
  ELSE
    APPEND BLANK
    replace code WITH lc_oir, d_code WITH lc_syy, prim WITH .t., headline WITH .f., text WITH new.pitk__nimi, valid WITH .t., usedate WITH new.voimassaol
    IF new.voimassao1<>CTOD('2020/12/31')
       replace reldate WITH new.voimassao1
    ENDIF 
  ENDIF 
  IF AT('#', new.tunniste)>0
    replace ast with '#'
  ENDIF
  IF AT('&', new.tunniste)>0   
    replace ast WITH '&'
  ENDIF
  IF AT('*',new.tunniste)>0
    replace ast WITH '*'
  ENDIF 
  IF lc_syy<>' '
    replace ast WITH '*'
    SEEK lc_oir
    IF FOUND()
      replace valid WITH .t.
    ELSE
      APPEND BLANK
      replace code WITH lc_oir, prim WITH .t., headline WITH .f., text WITH new.pitk__nimi, valid WITH .t., usedate WITH new.voimassaol
      IF new.voimassao1<>CTOD('2020/12/31')
        replace reldate WITH new.voimassao1
      ENDIF       
    endif
    SEEK lc_syy
    IF FOUND()
      replace valid WITH .t.
      IF reldate<>CTOD(SPACE(8))
        replace text WITH DTOC(reldate)+' Used only in code pair'
        REPLACE reldate WITH CTOD(SPACE(8))
      ENDIF 
    ELSE
      APPEND BLANK
      replace code WITH lc_syy, prim WITH .t., headline WITH .f., text WITH new.pitk__nimi, valid WITH .t., usedate WITH new.voimassaol
      IF new.voimassao1<>CTOD('2020/12/31')
        replace reldate WITH new.voimassao1
      ENDIF       
    ENDIF 
  ENDIF 
  SELECT new
  skip
ENDDO 
RETURN

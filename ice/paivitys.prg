PROCEDURE paivitys
CLEAR ALL
USE c:\data\icd10plus\ice\icd_10.dbf
replace ALL valid WITH .f.
SET ORDER TO code
SELECT 0
USE c:\data\icd10plus\ice\icd10_2013.dbf ALIAS uusi
replace ALL code WITH SUBSTR(code,1,3)+SUBSTR(code,5,3) FOR SUBSTR(code,4,1)='.'
GOTO TOP 
DO WHILE NOT EOF()
  SELECT icd_10 
  SEEK uusi.code
  IF FOUND()
    replace valid WITH .t.
    replace text WITH uusi.text
  ELSE 
    APPEND blank
    replace code WITH uusi.code, text WITH uusi.text, usedate WITH CTOD('2013/01/01'), prim WITH .t., headline WITH .f.
  ENDIF 
  SELECT uusi
  SKIP  
ENDDO 
SELECT icd_10
SET FILTER TO reldate=CTOD(SPACE(9)) AND NOT valid
replace ALL reldate WITH CTOD('2012/12/31')
RETURN
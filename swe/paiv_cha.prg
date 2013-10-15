Procedure paiv_cha
SELECT icd_10
SET FILTER TO 
select 0
use 'icd_10_swe_changes2014.dbf' ALIAS cha
goto top
do while not eof()
  SELECT icd_10
  SEEK cha.code
  IF FOUND()
    IF NOT (TRIM(cha.text)=TRIM(icd_10.text) AND TRIM(cha.text)=TRIM(icd_10.text))
      replace icd_10.text WITH cha.text
    ENDIF 
    IF cha.in_out='OUT'
      replace icd_10.reldate WITH cha.reldate
    ENDIF 
    IF cha.in_out='IN'
      replace icd_10.reldate WITH CTOD(SPACE(9))
    endif 
  ELSE  
    IF cha.in_out='IN'
       APPEND BLANK
       replace code WITH cha.code, text WITH cha.text, usedate WITH cha.usedate
    ENDIF 
  ENDIF 
  select cha
  skip
enddo
return
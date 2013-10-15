Procedure ksh_upd
clear all
use icd_10
set order to code
replace ALL valid WITH .f.
select 0
use icd10swe2013.dbf alias cha
goto top
do while not eof()
  select icd_10
  seek cha.kod
  IF NOT FOUND()
     append blank
     replace code with cha.kod, text with cha.text, change with ctod('2013/01/01'), valid with .t. , who with .f., prim with .t., headline with .f.
  else
     replace valid with .t.
     IF NOT (TRIM(text)=TRIM(cha.text) AND TRIM(cha.text)=TRIM(text))
       replace text WITH cha.text
    endif
  endif
  select cha
  skip
enddo
return
Procedure paivitys
select icd_10
set order to code
replace all valid with .f.
select 0
use icd_10_2014 alias uusi
set filter to len(trim(code))>3
goto top
SKIP 1
do while not eof()
*  wait window nowait uusi.code
  select icd_10
  seek uusi.code
  if found() and uusi.code = code
    replace valid with .t., headline with .f., text with uusi.text
  else
    if len(trim(uusi.code))>4
      append blank
      replace code with uusi.code, usedate with ctod('2014/01/01'), text with uusi.text, prim with .t., headline with .f., valid with .t., who with .f.
    endif
  endif
  select uusi
  skip
ENDDO
SELECT icd_10
SET FILTER TO NOT valid
replace ALL reldate WITH CTOD('2013/12/31')
return
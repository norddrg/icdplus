Procedure lang_def
SET SAFETY OFF 
WAIT WINDOW NOWAIT 'Writing all national versions text versions'
SELECT 0
use ..\icd10plus\fin\icd_10
set order to code
ERASE ('..\icd10plus\text\fin_icd_10.txt')
COPY TO ('..\icd10plus\text\fin_icd_10.txt') DELIMITED WITH CHAR ';'
use ..\icd10plus\swe\icd_10
set order to code
ERASE ('..\icd10plus\text\swe_icd_10.txt')
COPY TO ('..\icd10plus\text\swe_icd_10.txt') DELIMITED WITH CHAR ';'
use ..\icd10plus\dan\icd_10
set order to code
ERASE ('..\icd10plus\text\den_icd_10.txt')
COPY TO ('..\icd10plus\text\den_icd_10.txt') DELIMITED WITH CHAR ';'
use ..\icd10plus\nor\icd_10
set order to code
use ..\icd10plus\est\icd_10
set order to code
ERASE ('..\icd10plus\text\nor_icd_10.txt')
COPY TO ('..\icd10plus\text\nor_icd_10.txt') DELIMITED WITH CHAR ';'
use ..\icd10plus\ice\icd_10
set order to code
ERASE ('..\icd10plus\text\ice_icd_10.txt')
COPY TO ('..\icd10plus\text\ice_icd_10.txt') DELIMITED WITH CHAR ';'
use ..\icd10plus\eng\icd_10
set order to code
ERASE ('..\icd10plus\text\eng_icd_10.txt')
COPY TO ('..\icd10plus\text\eng_icd_10.txt') DELIMITED WITH CHAR ';'
use ..\icd10plus\lat\icd_10
set order to code
ERASE ('..\icd10plus\text\lat_icd_10.txt')
COPY TO ('..\icd10plus\text\lat_icd_10.txt') DELIMITED WITH CHAR ';'
use
SET SAFETY ON

public p_kieli 
p_kieli='-'
do while p_kieli='-'
  define popup lansel
  define bar 1 of lansel prompt 'Danish'
  define bar 2 of lansel prompt 'Finish'
  define bar 3 of lansel prompt 'Swedish'
  define bar 4 of lansel prompt 'Norwegian'
  define bar 5 of lansel prompt 'Estonian'
  define bar 6 of lansel prompt 'Icelandic'
  DEFINE BAR 7 OF lansel PROMPT 'Latvian'
  define bar 8 of lansel prompt 'English'
  on selection popup lansel do language with prompt()
  wait window nowait 'Select the language!'
  activate popup lansel at 10,15
  release popup lansel
enddo
*do ..\icd10plus\ohje
*do ..\icd10plus\naytto
return

procedure language
parameter lc_lan
on error select 0
select ncsp_sec
use
on error
p_kieli=substr(lc_lan,1,3)
public p_filt
select 0
do case
case p_kieli='Fin'
  use ..\icd10plus\fin\icd_10
  set order to code
  set filter to valid AND NOT headline AND prim
case p_kieli='Swe'
  use ..\icd10plus\swe\icd_10
  set order to code
  set filter to valid AND NOT headline AND prim
case p_kieli='Dan'
  use ..\icd10plus\dan\icd_10
  set order to code
  set filter to valid AND NOT headline AND prim
case p_kieli='Nor'
  use ..\icd10plus\nor\icd_10
  set order to code
  set filter to valid AND NOT headline AND prim
case p_kieli='Est'
  use ..\icd10plus\est\icd_10
  set order to code
  set filter to valid AND NOT headline AND prim
case p_kieli='Ice'
  use ..\icd10plus\ice\icd_10
  set order to code
  set filter to valid AND NOT headline AND prim
case p_kieli='Eng'
  use ..\icd10plus\eng\icd_10
  set order to code
  set filter to valid AND NOT headline AND prim
case p_kieli='Lat'
  use ..\icd10plus\lat\icd_10
  set order to code
  set filter to valid AND NOT headline AND prim
otherwise
  p_kieli='-'
  return
endcase
*do ..\icd10plus\naytto
deactivate popup lansel
return

procedure sec_sel
select 0
return

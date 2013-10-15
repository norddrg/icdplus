PROCEDURE siirto
PUBLIC old_incl
old_incl=DATE()-5*365
SET SAFETY OFF 
DO com_siir
SELECT icd_10
USE

* SWE siirto
use ..\icd10plus\swe\icd_10
set order to code
set filter to valid AND NOT headline AND prim
COPY next 0 to c:\data\swe_icd
SELECT 0
use c:\data\swe_icd.dbf ALIAS trans 
DO nat_siir
SELECT plus
SET RELATION TO code_swe INTO icd_10
replace ALL plus.code_swe2 WITH icd_10.code, text_swe WITH icd_10.text, relswe WITH icd_10.reldate
SELECT trans 
USE

* Fin siirto
SELECT icd_10
use ..\icd10plus\fin\icd_10
set order to code
set filter to valid AND NOT headline AND prim
COPY next 0 to c:\data\fin_icd
SELECT 0
use c:\data\fin_icd.dbf ALIAS trans 
DO nat_siir
SELECT plus
SET RELATION TO UPPER(code_fin) INTO icd_10
replace ALL plus.code_fin2 WITH icd_10.code, text_fin WITH icd_10.text, relfin WITH icd_10.reldate
SELECT trans 
USE

* Est siirto
SELECT icd_10
use ..\icd10plus\est\icd_10
set order to code
set filter to valid AND NOT headline AND prim
COPY next 0 to c:\data\est_icd
SELECT 0
use c:\data\est_icd.dbf ALIAS trans 
DO nat_siir
SELECT plus
SET RELATION TO UPPER(code_est) INTO icd_10
replace ALL plus.code_est2 WITH icd_10.code, text_est WITH icd_10.text, relest WITH icd_10.reldate
SELECT trans 
USE

* Lat siirto
SELECT icd_10
use ..\icd10plus\lat\icd_10
set order to code
set filter to valid AND NOT headline AND prim
COPY next 0 to c:\data\lat_icd
SELECT 0
use c:\data\lat_icd.dbf ALIAS trans 
DO nat_siir
SELECT plus
SET RELATION TO code_lat INTO icd_10
replace ALL plus.code_lat2 WITH icd_10.code, text_lat WITH icd_10.text, rellat WITH icd_10.reldate
SELECT trans 
USE

* Ice siirto
SELECT icd_10
use ..\icd10plus\ice\icd_10
set order to code
set filter to valid AND NOT headline AND prim
COPY next 0 to c:\data\ice_icd
SELECT 0
use c:\data\ice_icd.dbf ALIAS trans 
DO nat_siir
SELECT plus
SET RELATION TO UPPER(code_ice) INTO icd_10
replace ALL plus.code_ice2 WITH icd_10.code, text_ice WITH icd_10.text, relice WITH icd_10.reldate
SELECT trans 
USE

* Nor siirto
SELECT icd_10
use ..\icd10plus\nor\icd_10
set order to code
set filter to valid AND NOT headline AND prim
COPY next 0 to c:\data\nor_icd
SELECT 0
use c:\data\nor_icd.dbf ALIAS trans 
DO nat_siir
SELECT plus
SET RELATION TO code_nor INTO icd_10
replace ALL plus.code_nor2 WITH icd_10.code, text_nor WITH icd_10.text, relnor WITH icd_10.reldate
SELECT trans 
USE

* Dan siirto
SELECT icd_10
use ..\icd10plus\dan\icd_10
set order to code
set filter to valid AND NOT headline AND prim
COPY next 0 to c:\data\dan_icd
SELECT 0
use c:\data\dan_icd.dbf ALIAS trans 
DO nat_siir
SELECT plus
SET RELATION TO SUBSTR(code_den,1,6) INTO icd_10
replace ALL plus.code_den2 WITH icd_10.code, text_den WITH icd_10.text, relden WITH icd_10.reldate
SELECT trans 
USE

* Eng siirto
SELECT icd_10
use ..\icd10plus\eng\icd_10
set order to code
set filter to valid AND NOT headline AND prim
COPY next 0 to c:\data\eng_icd
SELECT 0
use c:\data\eng_icd.dbf ALIAS trans 
DO nat_siir
SELECT plus
SET RELATION TO code_who INTO icd_10
replace ALL plus.code_who WITH icd_10.code, relwho WITH icd_10.reldate
SELECT trans 
USE

* Siirto loppu

* Clear released cases
SELECT plus
GOTO top
DO WHILE NOT EOF()
  IF relden<>CTOD(SPACE(8))
     replace code_den WITH ' '
  ENDIF
  IF relest<>CTOD(SPACE(8))
     replace code_est WITH ' '
  ENDIF
  IF relfin<>CTOD(SPACE(8))
     replace code_fin WITH ' '
  ENDIF
  IF relice<>CTOD(SPACE(8))
     replace code_ice WITH ' '
  ENDIF
  IF rellat<>CTOD(SPACE(8))
     replace code_lat WITH ' '
  ENDIF
  IF relnor<>CTOD(SPACE(8))
     replace code_nor WITH ' '
  ENDIF
  IF relswe<>CTOD(SPACE(8))
     replace code_swe WITH ' '
  ENDIF
  IF (code_den=' ' OR relden<>CTOD(SPACE(8))) AND (code_est=' ' OR relest<>CTOD(SPACE(8))) AND (code_fin=' ' OR relfin<>CTOD(SPACE(8))); 
  AND (code_ice=' ' OR relice<>CTOD(SPACE(8))) AND (code_lat=' ' OR rellat<>CTOD(SPACE(8)))AND (code_nor=' ' OR relnor<>CTOD(SPACE(8)))AND(code_swe=' ' OR relswe<>CTOD(SPACE(8)));
  AND code=' ' 
     replace released WITH .t., reldate WITH CTOD(STR(YEAR(DATE()))+'/12/31')
     IF relden<reldate AND relden<>CTOD(SPACE(8))
       replace reldate WITH relden
     ENDIF 
     IF relest<reldate AND relest<>CTOD(SPACE(8))
       replace reldate WITH relest
     ENDIF 
     IF relfin<reldate AND relfin<>CTOD(SPACE(8))
       replace reldate WITH relfin
     ENDIF 
     IF relice<reldate AND relice<>CTOD(SPACE(8))
       replace reldate WITH relice
     ENDIF 
     IF rellat<reldate AND rellat<>CTOD(SPACE(8))
       replace reldate WITH relnor
     ENDIF 
     IF relnor<reldate AND relnor<>CTOD(SPACE(8))
       replace reldate WITH rellat
     ENDIF 
     IF relswe<reldate AND relswe<>CTOD(SPACE(8))
       replace reldate WITH relswe
     ENDIF      
  ENDIF 
  IF NOT reldate=CTOD(SPACE(8))
    replace text WITH 'Deleted '+DTOC(reldate)+' - '+TRIM(text)
  ENDIF 
  SELECT plus
  skip
enddo
SELECT plus
COPY TO c:\data\icd_10_plus_dbf4 TYPE FOXPLUS
GOTO TOP 
plus_N=1
DO WHILE NOT EOF()
  COPY TO 'c:\data\plus_'+STR(plus_n,1)+'.XLS' NEXT 15000 TYPE XL5
  IF NOT EOF()
    SKIP
  endif
  plus_N=plus_N+1
ENDDO 
SET SAFETY ON 
DO ..\icd10plus\_icd10plus 
return

PROCEDURE nat_siir
SELECT icd_10
SET FILTER TO reldate=CTOD(SPACE(8)) OR reldate>old_incl
GOTO top
DO WHILE NOT EOF()
  IF AT('-',code)>0 OR AT('-',d_code)>0
    SKIP
    loop
  ENDIF 
  SELECT trans
  APPEND BLANK
  replace usedate WITH icd_10.usedate, valid WITH .t., code WITH icd_10.code, d_code WITH icd_10.d_code,;
  ast WITH icd_10.ast, who WITH icd_10.who, code_w WITH icd_10.code_w, d_code_w WITH icd_10.d_code_w,; 
  prim WITH icd_10.prim, headline WITH icd_10.headline, text_2 WITH icd_10.text_2
  replace text WITH icd_10.text
  lc_text=text
  IF NOT icd_10.reldate=CTOD(SPACE(8))
    IF trans.d_code<>' '
      SELECT icd_10
      SEEK trans.code
      IF FOUND() AND valid
         SEEK trans.d_code
         IF FOUND() AND valid
           replace trans.text WITH 'Codepair - '+ TRIM(lc_text)
         ENDIF 
      ENDIF 
      IF NOT FOUND() OR NOT valid
        SEEK UPPER(trans.code+trans.d_code)
        SELECT trans
        replace trans.text WITH 'Deleted '+DTOC(icd_10.reldate)+' - '+TRIM(icd_10.text)
      ENDIF 
      SELECT icd_10
      SEEK UPPER(trans.code+trans.d_code)
    ELSE
      replace text WITH 'Deleted '+DTOC(icd_10.reldate)+' - '+TRIM(icd_10.text)
    ENDIF 
  ENDIF 
  SELECT icd_10
  SKIP 
  DO WHILE code=trans.code AND d_code=trans.d_code AND NOT EOF()
    skip
  ENDDO 
enddo
return

PROCEDURE com_siir
SELECT 0
USE icd10plus_str
COPY next 0 to c:\data\icd_10_plus
USE c:\data\icd_10_plus ALIAS plus
SELECT icd10plus
SET FILTER TO 
GOTO top
DO WHILE NOT EOF()
  SELECT plus
  APPEND BLANK
  replace ord WITH icd10plus.ord, code WITH icd10plus.code, ast WITH icd10plus.ast, who WITH icd10plus.who,;
  usedate WITH icd10plus.usedate, prim WITH icd10plus.prim, headline WITH icd10plus.headline, ;
  code_who WITH icd10plus.code_who, code_den WITH icd10plus.code_den, code_est WITH icd10plus.code_est, ;
  code_fin WITH icd10plus.code_fin, code_lat WITH icd10plus.code_lat, code_nor WITH icd10plus.code_nor, ;
  code_swe WITH icd10plus.code_swe, code_ice WITH icd10plus.code_ice, ;
  usewho WITH icd10plus.usewho, useden WITH icd10plus.useden, useest WITH icd10plus.useest, ;
  usefin WITH icd10plus.usefin, uselat WITH icd10plus.uselat, usenor WITH icd10plus.usenor, ;
  useswe WITH icd10plus.useswe, useice WITH icd10plus.useice, ;
  relwho WITH icd10plus.relwho, relden WITH icd10plus.reldan, relest WITH icd10plus.relest, ;
  relfin WITH icd10plus.relfin, rellat WITH icd10plus.rellat, relnor WITH icd10plus.relnor, ;
  relswe WITH icd10plus.relswe, relice WITH icd10plus.relice, ;  
  group WITH SUBSTR(icd10plus.ord,1,3), dec WITH SUBSTR(icd10plus.ord,4,3)
  replace text WITH icd10plus.text
  lc_text=text
  SELECT icd10plus
  SKIP 
ENDDO
SELECT plus
SET FILTER TO code<>' ' AND (reldate=CTOD(SPACE(8)) OR reldate>old_incl)
COPY TO c:\data\icd_com FIELDS ord, code, ast, text, who, usedate
SET FILTER TO 
return

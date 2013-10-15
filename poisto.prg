PROCEDURE poisto
SELECT ICD_10
IF d_code<>' '
  WAIT WINDOW 'Remove linkage of the single codes and correct pairs afterwards!'
  DO ..\icd10plus\naytto
  RETURN 
ENDIF 
lc_pois=icd_10.code
replace code_w WITH ' ', d_code_w WITH ' '
SELECT icd10plus
SET ORDER TO code_fin
SEEK lc_pois
IF FOUND()
  replace code_fin WITH ' '
ENDIF 
SELECT icd_10
DO ..\icd10plus\naytto
RETURN


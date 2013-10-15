PROCEDURE linknew
DEFINE WINDOW linkki FROM 1,max_x/2 to max_y/2, max_x FONT  max_foty,  max_fosi
Activate WINDOW linkki
clear
@ 2,5 say icd_10.code 
@ 2,14 say icd_10.d_code
@ 2,23 say icd_10.text
@ 3,23 say icd_10.text_2

@ 4,5 say 'Check the new ICD10PLUS code and the text - existing code is not accepted'

lc_new=icd_10.code
lc_newtext=icd_10.text
@ 6,5 get lc_new
@ 7,5 get lc_newtext
READ
SELECT icd10plus
SEEK lc_new
IF FOUND()
  WAIT WINDOW 'Existing code cannot be used'
  SELECT icd_10
  DO ..\icd10plus\naytto
  RETURN 
ENDIF    
APPEND BLANK
REPLACE ord WITH lc_new, code WITH lc_new, text WITH lc_newtext, ast WITH lc_ast
DO case
CASE p_kieli='Dan'
  replace code_den WITH icd_10.code
CASE p_kieli='Est'
  replace code_est WITH icd_10.code
CASE p_kieli='Fin'
  replace code_fin WITH icd_10.code
CASE p_kieli='Eng'
  replace code_eng WITH icd_10.code
CASE p_kieli='Ice'
  replace code_ice WITH icd_10.code
CASE p_kieli='Lat'
  replace code_lat WITH icd_10.code
CASE p_kieli='Nor'
  replace code_nor WITH icd_10.code
CASE p_kieli='Swe'
  replace code_swe WITH icd_10.code
ENDCASE

DO ..\icd10plus\naytto
RETURN 
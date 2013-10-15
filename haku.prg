PROCEDURE haku
SELECT ICD_10
DEFINE WINDOW haku FROM max_y/2+5, max_x-45 TO max_y-10, max_x FONT max_foty, max_fosi
ACTIVATE WINDOW haku
lc_icd=SPACE(8)
lc_loop =.t.
  @ 2,2 say 'Search for national ICD-10 code, give a valid code!'
  @ 4,2 get lc_icd picture '!!!!!!!'
  READ
RELEASE WINDOWS haku
SEEK TRIM(lc_icd)
DO ..\icd10plus\naytto
RETURN 
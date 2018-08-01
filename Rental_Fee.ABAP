 METHOD compute_ZK3GAMTRM.

*   IMPORTING
*     request     type rsrequest
*     datapackid  type rsdatapid
*     SOURCE_FIELDS-/BIC/ZK3GAMTRF TYPE /BIC/OIZK3GAMTRF
*     SOURCE_FIELDS-/BIC/ZK3GAMTRD TYPE /BIC/OIZK3GAMTRD
*    EXPORTING
*      RESULT type _ty_s_TG_1-/BIC/ZK3GAMTRM

    DATA:
      MONITOR_REC    TYPE rsmonitor.

*$*$ begin of routine - insert your code only below this line        *-*
... "insert your code here
*--  fill table "MONITOR" with values of structure "MONITOR_REC"
*-   to make monitor entries
... "to cancel the update process
*    raise exception type CX_RSROUT_ABORT.
... "to skip a record"
*    raise exception type CX_RSROUT_SKIP_RECORD.
... "to clear target fields
*    raise exception type CX_RSROUT_SKIP_VAL.


    DATA(lv_Type) = SOURCE_FIELDS-/BIC/ZK3GAMTRF.
    DATA(lv_Time) = SOURCE_FIELDS-/BIC/ZK3GAMTRD.
    DATA lv_temp type dmbtr.
    DATA lv_Result type dmbtr.


*BREAK-POINT.

CASE lv_Type.

*CAB DB Standard
WHEN  '050000'.

*Miete bei mehr als einem Tag
   if lv_Time > 1440.
     lv_Result = trunc( lv_Time / 1440 ) * 15 .
*Abrechnung halbstündlich deshalb nochmal trunc / +1 für jede
*angefangene halbe Stunde
     lv_temp =  trunc( frac( lv_Time / 1440 ) * 1440 / 30 ) + 1.
     if lv_temp > 15.
        lv_Result = lv_Result + 15 .
     ELSEIF lv_temp < 15.
        lv_Result = lv_Result + lv_temp.
     endif.

*Miete bei weniger als einem Tag (max. 15 €)
   elseif lv_time < 1440.
     lv_Temp = trunc( lv_Time / 30 ) + 1 .
     if lv_Temp > 15.
       lv_Result = 15.
     ELSEIF lv_Temp < 15.
       lv_Result = trunc( lv_Time / 30 ) + 1 .
     endif.
   endif.

*CAB DB Pedelec
WHEN '050001'.

   lv_temp = lv_time * '0.12' .
   if lv_temp > '22.50'.
     lv_Result = '22.50'.
   ELSEIF lv_temp < '22.50'.
     lv_Result = lv_time * '0.12'.
   ENDIF.



*StadtRAD Hamburg
WHEN '051000'.
    if lv_Time < 30.
     lv_Result = 0.

*Miete bei mehr als einem Tag
    elseif lv_Time > 1440.
     lv_Result = trunc( lv_Time / 1440 ) * 12 .
     lv_temp =  '0.08' * trunc( ( frac( lv_Time / 1440 ) * 1440 ) ) .
     if lv_temp > 12.
        lv_Result = lv_Result + 12 .
     ELSEIF lv_temp < 12.
        lv_Result = lv_Result + lv_temp.
     endif.

*Miete bei weniger als einem Tag (max. 12 €)
   elseif lv_time < 1440.
     lv_Temp = ( lv_Time - 30 ) * '0.08' .
     if lv_Temp > 12.
       lv_Result = 12.
     ELSEIF lv_Temp < 12.
       lv_Result = ( lv_Time - 30 ) * '0.08' .
     endif.
   endif.


*Konrad (Nextbike)
WHEN '053000'.

*Miete bei mehr als einem Tag
   if lv_Time > 1440.
     lv_Result = trunc( lv_Time / 1440 ) * 9 .
*Abrechnung halbstündlich deshalb nochmal trunc / +1 für jede
*angefangene halbe Stunde
     lv_temp =  trunc( frac( lv_Time / 1440 ) * 1440 / 30 ) + 1.
     if lv_temp > 9.
        lv_Result = lv_Result + 9 .
     ELSEIF lv_temp < 9.
        lv_Result = lv_Result + lv_temp.
     endif.

*Miete bei weniger als einem Tag (max. 15 €)
   elseif lv_time < 1440.
     lv_Temp = trunc( lv_Time / 30 ) + 1 .
     if lv_Temp > 9.
       lv_Result = 9.
     ELSEIF lv_Temp < 9.
       lv_Result = trunc( lv_Time / 30 ) + 1 .
     endif.
   endif.


ENDCASE.

     RESULT = lv_Result .

*$*$ end of routine - insert your code only before this line         *-*
  ENDMETHOD.                    "compute_ZK3GAMTRM
rem ********************************************************************
rem * Filename          : db_pgadvice.sql - Version 1.0
rem * Author            : Henk Uiterwijk
rem * Original          : 12-DEC-2011
rem * Last Update       : 
rem * Update            : 
rem * Description       : Advice PGA Memory Size
rem ********************************************************************

set lines 132
set pages 66

SELECT round(PGA_TARGET_FOR_ESTIMATE/1024/1024) target_mb,
      ESTD_PGA_CACHE_HIT_PERCENTAGE cache_hit_perc,
      ESTD_OVERALLOC_COUNT
FROM   v$pga_target_advice
/

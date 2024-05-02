rem ********************************************************************
rem * Filename          : rac_sesino.sql - Version 2.1
rem * Author            : Henk Uiterwijk
rem * Original          : 12-apr-97
rem * Last Update       : 12-sep-02
rem * Update            : Use view DBA_USERS instaed of USER$
rem * Description       : Monitor database session info for RAC
rem ********************************************************************

set lines 132
set pages 60

column oracle      format a11
column os          format a25
column pid         format a08
column oracle_id   format a09
column typ         format a03
column program     format a20
column command     format a07
column pga         format a04
column uga         format a04

SELECT                                                                          
       S.INST_ID, 
       SUBSTR                                                                   
       (DECODE(S.TYPE,'BACKGROUND','INTERNAL',S.USERNAME),1,11) ORACLE                                                           
     , SUBSTR                                                                   
       (DECODE                                                                  
        (S.MACHINE                                                              
        ,NULL,''                                                                
        ,S.MACHINE||':')||                                                      
         DECODE                                                                 
         (S.OSUSER                                                              
         ,'OraUser',DECODE                                                      
                    (DP.PADDR                                                   
                    ,NULL,DECODE                                                
                         (SS.PADDR                                              
                         ,NULL,DECODE                                           
                               (SIGN(INSTR(UPPER(P.PROGRAM),'TCP'))             
                               ,1,'<SQLNet V1>'                                 
                               ,DECODE                                          
                                (SIGN(INSTR(UPPER(P.PROGRAM),'TNS'))            
                                ,1,'<SQLNet V2>'                                
                                ,'<SQLNet V?>'                                  
                                )                                               
                               )                                                
                         ,'<SQLNet V2>'                                         
                         )                                                      
                    ,'<SQLNet V2>'                                              
                    )                                                           
         ,S.OSUSER                                                              
         )                                                                      
       ,1,25)                                                                   
       OS                                                                       
     , SUBSTR(P.SPID,1,8) PID                                                   
     , SUBSTR                                                                   
       (S.SID||','||S.SERIAL#||                                     
        DECODE                                                                  
        (S.STATUS                                                               
        ,'KILLED','*'                                                           
        ,'')                                                                    
       ,1,9) ORACLE_ID                                                          
     , SUBSTR                                                                   
       (DECODE                                                                  
        (S.TYPE                                                                 
        ,'BACKGROUND','BCK'                                                     
        ,DECODE                                                                 
         (DP.PADDR                                                              
         ,NULL,DECODE                                                           
               (SS.PADDR                                                        
               ,NULL,'DED'                                                      
               ,'SHR')                                                          
         ,'DSP'                                                                 
         )                                                                      
        )                                                                       
       ,1,3                                                                     
       )                                                                        
       TYP                                                                      
     , UPPER                                                                    
       (SUBSTR                                                                  
        (decode                                                                 
         (DECODE                                                                
          (S.TYPE                                                               
          ,'BACKGROUND','B'                                                     
          ,DECODE                                                               
           (DP.PADDR                                                            
           ,NULL,DECODE                                                         
                 (SS.PADDR                                                      
                 ,NULL,'D'                                                      
                ,'M')                                                           
           ,'M'                                                                 
           )                                                                    
          )                                                                     
         ,'M',substr(p.program,instr(p.program,'(')+1,4)||':'                   
         ,''                                                                    
         )                                                                      
         ||                                                                     
         DECODE                                                                 
         (S.TYPE                                                                
         ,'BACKGROUND',SUBSTR(P.PROGRAM,LENGTH(P.PROGRAM)-4,4)                  
         ,decode                                                                
          (instr(upper(s.program),'.EXE')                                       
          ,0,decode                                                             
             (instr(s.program,'@')                                              
             ,0,s.program                                                       
             ,substr(s.program,1,instr(s.program,'@')-1)                        
             )                                                                  
          ,substr(s.program,1,instr(upper(s.program),'.EXE')-1)                 
          )                                                                     
         )                                                                      
        ,1,20                                                                   
        )                                                                       
       )                                                                        
       PROGRAM                                                                  
     , SUBSTR                                                                   
       (DECODE                                                                  
        (S.LOCKWAIT                                                             
        ,NULL,DECODE                                                            
              (S.COMMAND                                                        
              ,0,'NOTHING'                                                      
              ,1,'CR TAB'                                                       
              ,2,'INSERT'                                                       
              ,3,'SELECT'                                                       
              ,4,'CR CLU'                                                       
              ,5,'AL CLU'                                                       
              ,6,'UPDATE'                                                       
              ,7,'DELETE'                                                       
              ,8,'DROP'                                                         
              ,9,'CR IND'                                                       
              ,10,'DR IND'                                                      
              ,11,'AL IND'                                                      
              ,12,'DR TAB'                                                      
              ,13,'CR SEQ'                                                      
              ,14,'AL SEQ'                                                      
              ,15,'AL TAB'                                                      
              ,16,'DR SEQ'                                                      
              ,17,'GRANT'                                                       
              ,18,'REVOKE'                                                      
              ,19,'CR SYN'                                                      
              ,20,'DR SYN'                                                      
              ,21,'CR VW'                                                       
              ,22,'DR VW'                                                       
              ,23,'VAL IND'                                                     
              ,24,'CR PROC'                                                     
              ,25,'AL PROC'                                                     
              ,26,'LCK TAB'                                                     
              ,27,'NO-OPER'                                                     
              ,28,'RENAME'                                                      
              ,29,'COMMEN'                                                      
              ,30,'AUDIT'                                                       
              ,31,'NOAUD'                                                       
              ,32,'CR DBLK'                                                     
              ,33,'DR DBLK'                                                     
              ,34,'CR DB'                                                       
              ,35,'AL DB'                                                       
              ,36,'CR RBS'                                                      
              ,37,'AL RBS'                                                      
              ,38,'DR RBS'                                                      
              ,39,'CR TSPC'                                                     
              ,40,'AL TSPC'                                                     
              ,41,'DR TSPC'                                                     
              ,42,'AL SESS'                                                     
              ,43,'AL USER'                                                     
              ,44,'COMMIT'                                                      
              ,45,'ROLLBCK'                                                     
              ,46,'SAVEPNT'                                                     
              ,47,'PLS EXE'                                                     
              ,48,'SET TR'                                                      
              ,49,'SWI LOG'                                                     
              ,50,'EXPLAIN'                                                     
              ,51,'CR USER'                                                     
              ,52,'CR ROLE'                                                     
              ,53,'DR USER'                                                     
              ,54,'DR ROLE'                                                     
              ,55,'SETROLE'                                                     
              ,56,'CR SCHM'                                                     
              ,57,'CR CFIL'                                                     
              ,58,'AL TRAC'                                                     
              ,59,'CR TRIG'                                                     
              ,60,'AL TRIG'                                                     
              ,61,'DR TRIG'                                                     
              ,62,'AN TABL'                                                     
              ,63,'AN INDX'                                                     
              ,64,'AN CLUS'                                                     
              ,65,'CR PROF'                                                     
              ,67,'DR PROF'                                                     
              ,68,'AL PROF'                                                     
              ,69,'DR PROC'                                                     
              ,70,'AL RESC'                                                     
              ,71,'CR SNLG'                                                     
              ,72,'AL SNLG'                                                     
              ,73,'DR SNLG'                                                     
              ,74,'CR SNAP'                                                     
              ,75,'AL SNAP'                                                     
              ,76,'DR SNAP'                                                     
              ,79,'AL ROLE'                                                     
              ,85,'TR TABL'                                                     
              ,86,'TR CLUS'                                                     
              ,88,'AL VIEW'                                                     
              ,91,'CR FUNC'                                                     
              ,92,'AL FUNC'                                                     
              ,93,'DR FUNC'                                                     
              ,94,'CR PACK'                                                     
              ,95,'AL PACK'                                                     
              ,96,'DR PACK'                                                     
              ,95,'CR PCKB'                                                     
              ,95,'AL PCKB'                                                     
              ,95,'DR PCKB'                                                     
              ,'OTH:'||to_char(s.command)                                       
              )                                                                 
        ,'WAITING'                                                              
        )                                                                       
       ,1,7                                                                     
       )                                                                        
       COMMAND                                                                  
     , s.logon_time
 FROM  SYS.gV_$PROCESS       P                                                   
 ,     SYS.gV_$SESSTAT       PGA                                                 
 ,     SYS.gV_$SESSTAT       UGA                                                 
 ,     SYS.gV_$SESSION       S                                                   
 ,     SYS.gV_$DISPATCHER    DP                                                  
 ,     SYS.gV_$SHARED_SERVER SS                                                  
-- ,     DBA_USERS             U
 ,     SYS.gv_$SESSTAT       CGA                                                   
 WHERE P.ADDR               = S.PADDR
 AND   P.INST_ID            = S.INST_ID                                           
-- AND   S.USERNAME           = U.USERNAME   (+)
-- AND   S.INST_ID            = U.INST_ID (+)                                      
 AND   P.ADDR               = SS.PADDR (+) 
 AND   P.INST_ID            = SS.INST_ID (+)                                     
 AND   P.ADDR               = DP.PADDR (+)  
 AND   P.INST_ID            = DP.INST_ID (+)                                    
 AND   UGA.STATISTIC#       = 15                                                
 AND   PGA.STATISTIC#       = 20
 AND   CGA.STATISTIC#       = 12                                                
 AND   S.SID                = UGA.SID
 AND   S.INST_ID            = UGA.INST_ID                                           
 AND   S.SID                = CGA.SID
 AND   S.INST_ID            = CGA.INST_ID
 AND   S.SID                = PGA.SID    
 AND   S.INST_ID            = PGA.INST_ID                                       
 ORDER BY 3;

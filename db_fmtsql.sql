set lines 255
set feedback off
set verify off
set serveroutput on size 1000000 format wrapped

--accept sid       prompt 'Sid       : '
--accept serial    prompt 'Serial    : '    
accept address    prompt 'Address   : '

spool afiedt.buf

DECLARE
--
-- COMMAND_TYPE SUBSTR
-- ------------ ------
--            2 INSERT
--            3 SELECT
--            6 UPDATE
--            7 DELETE
--           42 ALTER
--           44 COMMIT
--           47 BEGIN
--           47 DECLARE
--           49 ALTER


   TYPE     SqlRec IS RECORD ( INDENT   number
                             , TEKST    varchar2(8192)
                             );
      

   TYPE     SqlTab IS TABLE of SqlRec INDEX BY BINARY_INTEGER;


   Memo     SqlTab;

   cursor   cSql  is
   select   t.piece
   ,        replace(t.sql_text,chr(9),' ') as sql_text
   ,        t.command_type
   ,        t.address
   from     v$sqltext_with_newlines    t
   where    t.address     = '&address'
   order by t.piece;


--   select   PIECE
--   ,        SQL_TEXT
--   ,        COMMAND_TYPE
--   ,        ADDRESS
--   from     V$SQLTEXT_WITH_NEWLINES
--   where    HASH_VALUE   = pHash
--   and      COMMAND_TYPE = 3
--   order by PIECE;

   rSql     cSql%ROWTYPE;


   i        integer;
   Hash     number;
   Insp     number;
   Pos      number;

   SqlText  varchar2(32767);
   Buffer   varchar2(16384);
   Sqlrgl   varchar2(8192);





   FUNCTION LineInsert( pLine in integer, pRegel in varchar2, pAppnd in varchar2 )  RETURN integer
   --
   -- Functie om een regel te inserten in de SQLtabel
   --
   IS
   
      Line    integer;
      Insp    number;
      Apnd    number;
   
   BEGIN
   
      Apnd := 0;
      if pAppnd = 'App'  then
         Apnd := 1;
      end if;   
         
      Line := nvl( Memo.LAST, 0 ) + 1;
      while nvl( Line, 0 ) > ( pLine + Apnd )  loop
            Memo( Line ).TEKST  := Memo( Memo.PRIOR( Line ) ).TEKST;
            Memo( Line ).INDENT := Memo( Memo.PRIOR( Line ) ).INDENT;
            Insp                := nvl( Memo( Memo.PRIOR( Line ) ).INDENT, 0 );
            Line                := Memo.PRIOR( Line );
      end loop;
      Memo( pLine + Apnd ).TEKST  := pRegel;
      Memo( pLine + Apnd ).INDENT := Insp;
      
      RETURN ( pLine + Apnd ); 
 
   END LineInsert;




   FUNCTION FindComma( pTekst in varchar2, pVanaf in number )  RETURN number
   --
   -- Functie om in een regel de eerstvolgende buitenhaakse en buitenquote komma te vinden
   --
   IS
   
      QuoteD   boolean;
      QuoteS   boolean;

      Haakje   number;
      Pointr   number;
      Lengte   number;

      Letter   varchar2(1);
      
   BEGIN
   
      QuoteD := FALSE;
      QuoteS := FALSE;

      Haakje := 0;
      Pointr := pVanaf;
      Lengte := length( pTekst );
      
      while Pointr <= Lengte  loop
      
            Letter := substr( pTekst, Pointr, 1 );
            
            if     Letter = chr(39)  then             -- Single-quote
                   if not QuoteD then                 -- Switch wijzigen als niet tussen double-quotes
                      QuoteS := not QuoteS;
                   end if;   
                      
            elsif  Letter = chr(34)  then             -- Double-quote
                   if not QuoteS then                 -- Switch wijzigen als niet tussen single-quotes
                      QuoteD := not QuoteD;
                   end if;
            
            elsif  Letter = chr(40)  then             -- Haakje openen
                   if not ( QuoteD or QuoteS )  then  -- indien niet tussen quotes
                      Haakje := Haakje + 1;
                   end if;

            elsif  Letter = chr(41)  then             -- Haakje sluiten
                   if not ( QuoteD or QuoteS )  then  -- indien niet tussen quotes
                      Haakje := Haakje - 1;
                   end if;
                      
            elsif  Letter = chr(44)  then             -- De komma die we zoeken          
                   if not ( QuoteD or QuoteS )  then  -- mag niet tussen quotes staan
                      if Haakje <= 0  then            -- of tussen haakjes
                         RETURN Pointr;
                      end if;
                   end if;      
            
            end if;
            
            Pointr := Pointr + 1;
            
      end loop;
   
      RETURN 0;
   
   END FindComma;
      





   FUNCTION SplitLine( pLine in integer, pMarge in number )  RETURN integer
   --
   -- Functie om een regel met komma-separated velden op te splitsen in meerdere regels
   --
   IS
   
      Rglnr    integer;
      Point    integer;
      Tekst    varchar2(8192);
      Regel    varchar2(1024);
      
   BEGIN
   
      -- Komt de komma voor in de regel ?
      -- 
      Rglnr := pLine;
      Tekst := ltrim( Memo(Rglnr).TEKST );
      Point := FindComma( Tekst, 1 );
      
      while Point > 0  loop
      
            -- Splits het stuk voor de komma af
            --
            Regel := substr( Tekst, 1, Point - 1 );
            Tekst := substr( Tekst, Point );

            -- Begint de regel met een komma of met een keyword ?
            --
            if substr( Regel, 1, 1 ) = chr(44)  then
               Point := 1;
            else
               if upper( substr( Regel, 1, 5 ) ) in ( 'GROUP', 'ORDER' )  then
                  Point := instr( Regel, ' ', 1, 2 );
                  Regel := replace( substr( Regel, 1, Point ), ' ' ) || substr( Regel, Point );
                  Regel := substr( Regel, 1, 5 ) || ' ' || substr( Regel, 6 );
                  Point := 9;
               else
                  Point := instr( Regel, ' ' );
               end if;   
            end if;
            Regel := rpad( substr( Regel, 1, Point ), pMarge ) || rtrim( ltrim( substr( Regel, Point + 1 ) ) );

            Memo(Rglnr).TEKST := Tekst;
            Rglnr             := LineInsert( Rglnr, Regel, 'Ins' );
            Rglnr             := nvl( Memo.NEXT(Rglnr), Memo.LAST + 1 );
            Point             := FindComma( Tekst, 2 );

      end loop;
      
      
      if substr( Tekst, 1, 1 ) = chr(44)  then
         Point := 1;
      else
         if upper( substr( Tekst, 1, 5 ) ) in ( 'GROUP', 'ORDER' )  then
            Point := instr( Tekst, ' ', 1, 2 );
            Tekst := replace( substr( Tekst, 1, Point ), ' ' ) || substr( Tekst, Point );
            Tekst := substr( Tekst, 1, 5 ) || ' ' || substr( Tekst, 6 );
            Point := 9;
         else
            Point := instr( Tekst, ' ' );
         end if;   
      end if;

      Tekst             := rpad( substr( Tekst, 1, Point ), pMarge ) || rtrim( ltrim( substr( Tekst, Point + 1 ) ) );
      Memo(Rglnr).TEKST := Tekst;

      RETURN Rglnr;
   
   END SplitLine;






  
   FUNCTION  FindKeyword( pText in varchar2 )  RETURN varchar2
   --
   -- Functie om het eerst voorkomende keyword op te zoeken in een string
   -- en die te retourneren. Niet gevonden is NULL.
   --
   IS

      Kan      boolean;

      Wrd      varchar2(256);
      Ltr      varchar2(1);

      Len      integer;
      Tel      integer;

   BEGIN

      Wrd := '';
      Kan := TRUE;
      Len := length( pText );
      Tel := 1;

      while Tel <= Len  loop

            Ltr := substr( pText, Tel, 1 );

            if    'ABCDEFGHIJKLMNOPQRSTUVWXYZ' like upper( '%'||Ltr||'%' )  then

               -- Als het een letter is, dan kan het een deel van een keyword zijn
               --
               if Kan  then

                  -- Volgende letter van het woord
                  --
                  Wrd := Wrd || Ltr;

               else

                  -- Keywords alleen na een spatie of een haakje
                  --
                  if substr( pText, Tel -1, 1 ) in ( '(', ')', ' ' )  then
                     Wrd := Ltr;
                     Kan := TRUE;
                  else
                     Wrd := '';
                     Kan := FALSE;
                  end if;

               end if;


            elsif '0123456789' like '%'||Ltr||'%'  then

                  -- Direct na een cijfer is onmogelijk
                  --
                  Kan := FALSE;
                  Wrd := '';


            elsif Ltr in ( ' ', '(' )  then

               -- Alleen een spatie of een openhaak kan een keyword afsluiten
               --
               if Kan  then
                  if Upper( Wrd ) in ( 'SELECT', 'FROM', 'WHERE', 'AND', 'OR', 'GROUP', 'HAVING', 'ORDER', 'CONNECT', 'START', 'UNION', 'INTERSECT', 'MINUS' )  then
                     RETURN Wrd;
                  end if;
               end if;
               Kan := FALSE;

            else
               Kan := FALSE;
               Wrd := '';
            end if;

            Tel := Tel + 1;

      end loop;

      -- Aan het einde is niet mogelijk
      --
      RETURN null;

   END FindKeyword;






   PROCEDURE SplitKeyword( pTekst in varchar2 )
   IS

      i        integer;
      Point    integer;
      Regel    varchar2(8192);
      Woord    varchar2(512);
      Tekst    varchar2(32767);

   BEGIN

      Tekst := rtrim( pTekst );


      -- Splits de SQLtekst op in regels beginnend met een keyword
      --
      while Tekst is not null  loop

            Tekst := ltrim( Tekst );
            Point   := instr( Tekst, ' ' );
            if Point > 0  then

               -- Eerste keyword afsplitsen van SQLtekst
               --
               Regel := rtrim( substr( Tekst, 1, Point ) );
               Tekst := ltrim( substr( Tekst, Point ) );

               -- Eerstvolgende keyword opzoeken
               --
               Woord := FindKeyword( Tekst );

               if Woord is not null  then

                  -- Positie van dat keyword bepalen en alle SQLtekst tot aan dat keyword
                  -- achter het zojuist afgesplitste keyword plaatsen
                  --
                  Point := instr( Tekst, Woord||' ' );
                  Regel := rtrim( Regel || ' ' || substr( Tekst, 1, Point -1  ) );
                  Tekst := substr( Tekst, Point );

               else

                  -- Geen keywords meer, rest van de SQLtekst eraan plakken
                  --
                  Regel := rtrim( Regel || ' ' || Tekst );
                  Tekst := '';

               end if;

            else

               -- Onduidelijke laatste regel
               --
               if Tekst is not null  then
                  Regel := Tekst;
                  Tekst := '';
               end if;

            end if;

            -- Regel toevoegen aan tabel
            --
            i := nvl( Memo.LAST, 0 ) + 1;
            Memo(i).INDENT := 0;
            Memo(i).TEKST  := Regel;

      end loop;

   END SplitKeyword;






   FUNCTION CountHook( pTekst in varchar2 ) RETURN number
   --
   -- Functie om het aantal haken te tellen
   --
   IS

      QuoteD   boolean;
      QuoteS   boolean;

      Haakje   number;
      Pointr   number;
      Lengte   number;

      Letter   varchar2(1);

   BEGIN

      QuoteD := FALSE;
      QuoteS := FALSE;

      Haakje := 0;
      Pointr := 1;
      Lengte := length( pTekst );
      
      while Pointr <= Lengte  loop
      
            Letter := substr( pTekst, Pointr, 1 );
            
            if     Letter = chr(39)  then             -- Single-quote
                   if not QuoteD then                 -- Switch wijzigen als niet tussen double-quotes
                      QuoteS := not QuoteS;
                   end if;   
                      
            elsif  Letter = chr(34)  then             -- Double-quote
                   if not QuoteS then                 -- Switch wijzigen als niet tussen single-quotes
                      QuoteD := not QuoteD;
                   end if;
            
            elsif  Letter = chr(40)  then             -- Haakje openen
                   if not ( QuoteD or QuoteS )  then  -- indien niet tussen quotes
                      Haakje := Haakje + 1;
                   end if;

            elsif  Letter = chr(41)  then             -- Haakje sluiten
                   if not ( QuoteD or QuoteS )  then  -- indien niet tussen quotes
                      Haakje := Haakje - 1;
                   end if;
            
            end if;
            
            Pointr := Pointr + 1;
            
      end loop;
   
      RETURN Haakje;

   END  CountHook; 






   FUNCTION FindHook( pTekst in varchar2, pHook in varchar2, pVanaf in number ) RETURN number
   --
   -- Functie om in een regel de eerstvolgende buitenquote open of sluithaak te vinden
   --
   IS
   
      Haakje    number;
      Lengte    number;
      Direct    number;
      Pointr    number;

      QuoteD    boolean;
      Quotes    boolean;
      Loopje    boolean;
      
      Letter    varchar2(1);
            
   BEGIN

      Haakje := 0;
      Lengte := length( pTekst );

      QuoteD := FALSE;
      QuoteS := FALSE;
      Loopje := ( Lengte > 0 );

      if pHook = chr(40)  then
         Direct := -1;
         Pointr := Lengte;
      else
         Direct := 1;
         Pointr := 1 + pVanaf;
      end if;      
      
      while Loopje  loop
      
            Letter := substr( pTekst, Pointr, 1 );
            
            if     Letter = chr(39)  then             -- Single-quote
                   if not QuoteD then                 -- Switch wijzigen als niet tussen double-quotes
                      QuoteS := not QuoteS;
                   end if;   
                      
            elsif  Letter = chr(34)  then             -- Double-quote
                   if not QuoteS then                 -- Switch wijzigen als niet tussen single-quotes
                      QuoteD := not QuoteD;
                   end if;
            
            elsif  Letter = chr(40)  then             -- Haakje openen
                   if not ( QuoteD or QuoteS )  then  -- indien niet tussen quotes
                      Haakje := Haakje + Direct;
                      if ( Haakje + pVanaf ) = 0  then
                         RETURN Pointr;
                      end if;   
                   end if;

            elsif  Letter = chr(41)  then             -- Haakje sluiten
                   if not ( QuoteD or QuoteS )  then  -- indien niet tussen quotes
                      Haakje := Haakje - Direct;
                      if Haakje < 0  then
                         RETURN Pointr;
                      end if;   
                   end if;
            
            end if;

            
            Pointr := Pointr + Direct;

            if Direct = 1  then
               Loopje := Pointr <= Lengte;
            else
               Loopje := Pointr > 0;
            end if;      

      end loop;
   
      RETURN 0;

   END  FindHook; 





   FUNCTION RemoveComment( pRegel in varchar2 )  RETURN varchar2
   --
   -- Functiee om van een regel het commentaar te verwijderen
   --
   IS

      Pointr    number;
      Lengte    number;
      
      Letter    varchar2(1);

      QuoteD    boolean;
      QuoteS    boolean;
      Cmment    boolean;
      
   
   BEGIN

      Quoted := FALSE;
      Quotes := FALSE;
      Cmment := FALSE;

      Pointr := 1;
      Lengte := length( pRegel );

      while Pointr <= Lengte  loop
      
            Letter := substr( pRegel, Pointr, 1 );
            
            if     Letter = chr(39)  then             -- Single-quote
                   if not QuoteD then                 -- Switch wijzigen als niet tussen double-quotes
                      QuoteS := not QuoteS;
                   end if;   
                   Cmment := FALSE;
                      
            elsif  Letter = chr(34)  then             -- Double-quote
                   if not QuoteS then                 -- Switch wijzigen als niet tussen single-quotes
                      QuoteD := not QuoteD;
                   end if;
                   Cmment := FALSE;
            
            elsif  Letter = chr(45)  then             -- Streepje
                   if not ( QuoteD or QuoteS )  then  -- indien niet tussen quotes
                      if Cmment then                  -- tweede streepje, vanaf hier commentaar
                         RETURN rtrim( substr( pRegel, 1, Pointr - 2 ) );
                      else
                         Cmment := TRUE;  
                      end if;   
                   end if;

            else   
                   Cmment := FALSE;

            end if;
      
            Pointr := Pointr + 1;
            
      end loop;
      
      RETURN rtrim( pRegel );

   END RemoveComment;




   PROCEDURE LineIndent
   --
   -- Procedure om alle regels door te lopen en de indent te bepalen
   --
   IS

      TYPE      TabType IS TABLE of number INDEX BY BINARY_INTEGER;

      Indents   TabType;
      Haken     integer;
   
      Rglnr     number;
      Vlgnd     number;
      Aantl     number;
      Point     number;
      
      Tekst     varchar2(8192);
      
   BEGIN

      Haken          := 0;
      Indents(Haken) := 0;


      Rglnr := Memo.FIRST;

      while Rglnr is not null  loop
   
            Tekst              := rtrim( Memo(Rglnr).TEKST );             
            Aantl              := CountHook( Tekst );
            Memo(Rglnr).INDENT := Indents(Haken);

            -- Het aantal haakjes openen
            --
            if Aantl > 0  then

               while Aantl > 0  loop
                     
                     Point := FindHook( Tekst, '(', Aantl );
                     Tekst := rtrim( substr( Tekst, 1, Point ) || ' ' || ltrim( substr( Tekst, Point + 1 ) ) );
                     Point := FindHook( Tekst, '(', Aantl );
             
                     -- Als deze aan het einde van de regel voorkomt,
                     -- dan de volgende regel erachter plakken
                     --
                     if Point = length( Tekst )  then
                        Vlgnd := Memo.NEXT(Rglnr);
                        if Vlgnd is not null  then
                           Tekst := Tekst || ' ' || Memo(Vlgnd).TEKST;
                           Memo.DELETE(Vlgnd);
                        end if;   
                     end if;
                     
                     -- Indent in stack-tabel opslaan
                     --
                     Haken          := Haken + 1;
                     Indents(Haken) := Memo(Rglnr).INDENT + Point + 1;
                     Aantl          := Aantl - 1;

               end loop;      
               
               Memo(Rglnr).TEKST := rtrim( Tekst );
               
            end if;


            -- Het aantal haakjes sluiten
            --            

            if Aantl < 0  then

               Tekst := Memo(Rglnr).TEKST;

               while Aantl < 0 loop

                     Point              := FindHook( Tekst, ')', 1 );
                     Memo(Rglnr).TEKST  := rtrim( substr( Tekst, 1, Point - 1 ) );
                     Tekst              := ltrim(substr( Tekst, Point ));
                     Rglnr              := LineInsert( Rglnr, Tekst, 'App' );
                     Memo(Rglnr).INDENT := Indents(Haken) - 2;
                     Haken              := Haken - 1;
                     Aantl              := Aantl + 1;

               end loop;
            

            end if;

            -- Volgende regel
            --
            Rglnr := Memo.NEXT(Rglnr);

       
      end loop;
        
      Indents.DELETE;
   
   
   END LineIndent;






   PROCEDURE Afdruk
   --
   -- Procedure om de tabel met tekst af te drukken
   --
   IS
   
      Rglnr    number;
      Regel    varchar2(8192);

   BEGIN
   
      Rglnr := Memo.FIRST;
      while Rglnr is not NULL loop

            Regel := rpad( ' ', Memo(Rglnr).INDENT ) || Memo(Rglnr).TEKST;
            while length( Regel ) > 255  loop
                  dbms_output.put_line( substr( Regel, 1, 255 ) );
                  Regel := substr( Regel, 256 );
            end loop;
            dbms_output.put_line( substr( Regel, 1, 255 ) );
            Rglnr := Memo.NEXT(Rglnr);
      
      end loop;

      dbms_output.put_line( '/' );

   END Afdruk;
   



BEGIN

   Insp    := 0;
   Buffer  := '';
   SqlText := '';
   Sqlrgl  := '';
   
   for rSql in cSql loop
   
       Buffer  := Buffer || rSql.SQL_TEXT;
       Pos     := instr( Buffer, chr(10) );

       while Pos > 0  loop
             Sqlrgl  := substr( Buffer, 1, Pos - 1 );
             Buffer  := ltrim( substr( Buffer, Pos + 1 ) );
             Sqlrgl  := RemoveComment( Sqlrgl );
             SqlText := rtrim( SqlText || ' ' || Sqlrgl );
             Pos     := instr( Buffer, chr(10) );
       end loop;
       
   end loop;

   if Buffer is not null  then
      Sqlrgl  := RemoveComment( Buffer );
      SqlText := rtrim( SqlText || ' ' || Sqlrgl );
   end if;     

   SplitKeyword( SqlText );

   i := Memo.FIRST;
   while i is not null  loop
         i := SplitLine( i, 9 );
         i := Memo.NEXT(i);
   end loop;               

   LineIndent;

   Afdruk;   
   
   Memo.DELETE;

END;
/



-- select   hash_value
-- ,        disk_reads
-- ,        buffer_gets
-- ,        executions
-- ,        sql_text
-- from     v$sqlarea
-- where    buffer_gets > ( select avg(buffer_gets)
--                          from   v$sqlarea
--                          where  buffer_gets > 0 )
-- order by buffer_gets desc

spool off

--get afiedt.buf
--@restsettings
set feedback on
set lines 80
set verify on



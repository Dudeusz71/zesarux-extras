CR CR
.( CALENDAR FOR THE JUPITER ACE) CR
.( AUTHOR: RICARDO F. LOPES - 2007) CR
.( LICENSE: PUBLIC DOMAIN) CR CR

.( USAGE: <YEAR> <MONTH>   ) CR
.( EXAMPLE: 2007 JANUARY   ) CR

\ Ported to ZX81 Toddy Forth by
\ Kelly A. Murta - JAN/2010.

\ Weekday calculation
\ [[month*26-54]/10 + day + [year-1900] + [year-1900]/4 - 34] MOD 7
\ SUN=0, MON=1,.. SAT=6

: TASK ;

: SPACES  ( n -- )        ( emit n ASCII blanks to the screen )
   ?DUP IF 0 DO SPACE LOOP THEN ;
: MOD  ( n1 n2 -- n3)     ( signed remainder )
   /MOD DROP ;
: [COMPILE]  ( -- )       ( compile immediate words )
   ' , ; IMMEDIATE
: DEFINER  ( -- )         ( The JUPITER ACE's DEFINER word )
   [COMPILE] : COMPILE CREATE ;

: WEEKDAY ( year month day -- weekday )
   SWAP DUP 3 < ( Jan & Feb considered as..)
   IF           ( ..months 13 and 14 of last year)
      12 + ROT
      1- ROT ROT
   THEN             ( year day month )
   26 * 54 - 10 / + ( year days)
   SWAP 1900 -      ( days year)
   DUP 4 / + + 34 - ( days)
   7 MOD ;          ( weekday)

\ Print calendar
\ I have to include an IF clause here because divergence of true flag
\ between Toddy Forth (true = -1) and ACE Forth (true = 1).
\ The original sentence was "I 10 < 1+ SPACES".
: CAL ( weekday days -- )
   CR ." sun�mon�tue�wed�thu�fri�sat"
   CR
   OVER 4 * SPACES   ( Position of the first day )
   1+ 1
   DO                ( Stack: weekday )
      I 10 < DUP IF 2+
      THEN 1+ SPACES ( Print tab )
      I .              ( Print day )
      1+               ( Increment day )
      DUP 6 >          ( Last column? )
      IF
         CR DROP 0       ( Next line )
      THEN 
   LOOP
   DROP ;

\ Check if leap year 
: LEAPYEAR? ( year -- flag )
   DUP 100 MOD 0= 0=
   OVER 400 MOD 0= OR
   SWAP 4 MOD 0= AND ;

\ Month definer
DEFINER MONTH  ( month days -- )
   C, C,
DOES>  ( year -- )
   OVER LEAPYEAR?  ( Stack: year pfa leapyear? )
   OVER 1+ C@      ( Stack: year pfa leapyear? month )
   SWAP OVER       ( Stack: year pfa month leapyear? month )
   2 = AND         ( Stack: year pfa month +1? )
   ROT C@ +        ( Stack: year month days )
   ROT ROT 1       ( Stack: days year month 1 )
   WEEKDAY         ( Stack: days weekday )
   SWAP            ( Stack: weekday days )
   CAL ;

\ Months
1  31 MONTH JANUARY
2  28 MONTH FEBRUARY
3  31 MONTH MARCH
4  30 MONTH APRIL
5  31 MONTH MAY
6  30 MONTH JUNE
7  31 MONTH JULY
8  31 MONTH AUGUST
9  30 MONTH SEPTEMBER
10 31 MONTH OCTOBER
11 30 MONTH NOVEMBER
12 31 MONTH DECEMBER
 
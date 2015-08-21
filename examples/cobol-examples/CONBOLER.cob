      * Taken from here: https://github.com/yujisakata/CoinBoller
      * This code was written by Yuji Sakata
      * (https://github.com/yujisakata)
123456*8901234567890123456789012345678901234567890
       IDENTIFICATION    DIVISION.
       PROGRAM-ID.       CONBOLER.
       DATA              DIVISION.
       WORKING-STORAGE   SECTION.
      *INIT
       77 LV    PIC X(1).
       01 MAP-CONF.
           03 ISSET    PIC X(1).
           03 WIDTH    PIC 9(2).
           03 HEIGHT   PIC 9(2).
           03 N-MINE     PIC 9(2).
       01 CONF-B PIC X(7) VALUE "Y090910".
       01 CONF-I PIC X(7) VALUE "Y161640".
       01 CONF-V PIC X(7) VALUE "Y261699".
      *SCREEN
       01 POS-INDEX-LIST VALUE "abcdefghijklmnopqrstuvwxyz".
           03 POS-INDEX PIC X OCCURS 26.
       01 CMN-IDX-DISP.
           03 CMN-IDX-DISP-SP PIC X.
           03 CMN-IDX-DISP-BODY PIC X OCCURS 26.
       01 ROW-DISP.
           03 ROW-IDX PIC X.
           03 ROW-BODY PIC X(26).
       01 DISP-MARK.
           03 UNKNOWN PIC X VALUE "O".
           03 MINE PIC X VALUE "F".
           03 NEAR-MINES VALUE "12345678.".
               05 NEAR-MINE PIC X OCCURS 9.
           03 EX-MINE PIC X VALUE "B".
           03 SUSPECT PIC X VALUE "?".
       01 MINE-MARK.
           03 ISSAFE PIC 9 VALUE 0.
           03 ISMINE PIC 9 VALUE 1.
      *MAP
       01 GAME-MAP.
           03 CLMN OCCURS 16.
             05 ROW VALUE ALL " ".
               07 CELL PIC X OCCURS 26.
             05 MINE-ROW.
               07 MINE-CELL PIC 9 OCCURS 26.
           03 N-OPEN PIC 9(3).
       77 FIXED-POS PIC 9(3).
      *CONTROLL
       77 ON-GAME PIC X.
       01 EDGE.
           03 UP-EDGE PIC X.
           03 DOWN-EDGE PIC X.
           03 LEFT-EDGE PIC X.
           03 RIGHT-EDGE PIC X.
       01 CHK-STACK.
           03 CHK-STACK-XY OCCURS 200.
               05 CHK-STACK-X PIC 9(2).
               05 CHK-STACK-Y PIC 9(2).
           03 CHK-STACK-C PIC 9(3) VALUE 0.
       77 CHK-STACK-C-PREV PIC 9(3) VALUE 0.
       01 CMD-STR.
          03 X-STR PIC X.
          03 Y-STR PIC X.
          03 C-STR PIC X.
       01 CMD.
          03 X PIC 9(2).
          03 Y PIC 9(2).
          03 C PIC X.
        01 CURRENT-TIME.
            05 FILLER PIC 9(4).
            05 CT-SECONDS PIC 9(2).
            05 CT-HUNDREDTHS-OF-SECS PIC 9(2).
        77 SEED PIC 9(4).
      *JUST WORK
       01 PXY.
           03 PX PIC 9(2).
           03 PY PIC 9(2).
       77 FG-A PIC X.
       77 N-NEAR-MINE PIC 9.
       01 CHK-XY.
           03 CHK-X PIC 9(2).
           03 CHK-Y PIC 9(2).
       77 DUMMY PIC X.
       77 DUMMY-N PIC 9(1)V9(5).
      *COUNTER
       77 CNTI PIC 9(3).
       77 CNTJ PIC 9(3).

       PROCEDURE        DIVISION.
       MAIN SECTION.
           PERFORM INIT-START THRU EXIT-INIT.
      *    DISPLAY "N-OPEN" N-OPEN.
           PERFORM DISP THRU EXIT-PLAY UNTIL ON-GAME NOT = " ".
           EVALUATE ON-GAME
               WHEN 'E'
                   DISPLAY 'YOU LOSE'
               WHEN 'W'
                   DISPLAY 'YOU WIN'
               WHEN OTHER
                   CONTINUE
           END-EVALUATE.
       STOP RUN.

       INIT SECTION.
       INIT-START.
       ACCEPT CURRENT-TIME FROM TIME.
       COMPUTE SEED = CT-SECONDS * 60 + CT-HUNDREDTHS-OF-SECS.
       COMPUTE DUMMY-N = FUNCTION RANDOM(SEED).
       SEL-LEVEL.
           DISPLAY "WELCOME TO COINBOLLER!".
           PERFORM UNTIL ISSET = "Y"
               DISPLAY "SELECT b)EGGINER/ i)NTERMERDIATE/ v)ETERAN"
               ACCEPT LV
               EVALUATE LV
                   WHEN "b"
                       MOVE CONF-B TO MAP-CONF
                   WHEN "i"
                       MOVE CONF-I TO MAP-CONF
                   WHEN "v"
                       MOVE CONF-V TO MAP-CONF
                   WHEN OTHER
                       DISPLAY "WRONG INPUT"
                       CONTINUE
               END-EVALUATE
           END-PERFORM.
           COMPUTE N-OPEN = (WIDTH * HEIGHT) - N-MINE.
           DISPLAY 'YOU SELECT LV-' LV ' ' N-OPEN.
       SET-MINE.
           PERFORM VARYING CNTI FROM 1 BY 1 UNTIL CNTI > N-MINE
               MOVE "A" TO FG-A
               PERFORM UNTIL FG-A = " "
                   COMPUTE PX = FUNCTION RANDOM * (WIDTH + 1)
                   COMPUTE PY = FUNCTION RANDOM * (HEIGHT + 1)
                   MOVE " " TO FG-A
                   IF MINE-CELL(PY, PX) = ISMINE
                       THEN
                           MOVE "A" TO FG-A
                   END-IF
               END-PERFORM
      *        DISPLAY "MINE " PXY
               MOVE ISMINE TO MINE-CELL(PY, PX)
           END-PERFORM.
       INIT-SCREEN.
           PERFORM VARYING CNTI FROM 1 BY 1 UNTIL CNTI > WIDTH
               MOVE POS-INDEX(CNTI) TO CMN-IDX-DISP-BODY(CNTI)
           END-PERFORM.
       INIT-MAP.
           PERFORM VARYING CNTI FROM 1 BY 1 UNTIL CNTI > HEIGHT
               PERFORM VARYING CNTJ FROM 1 BY 1 UNTIL CNTJ > WIDTH
                   MOVE UNKNOWN TO CELL(CNTI, CNTJ)
               END-PERFORM
           END-PERFORM.
       EXIT-INIT.
           EXIT.

       PLAY SECTION.
       DISP.
           PERFORM SCREEN-OUT THRU EXIT-SCREEN-OUT.
      *    PERFORM MINE-SCREEN-OUT THRU EXIT-MINE-SCREEN-OUT.
      *    DISPLAY "N-OPEN= " N-OPEN.
       GET-INPUT.
           PERFORM WITH TEST AFTER UNTIL C NOT = " "
               DISPLAY "GUESS XYC m)INE/o)K/s)USPECT/u)NKNOWN : "
               ACCEPT CMD-STR
               PERFORM PARSE-CMD THRU EXIT-PARSE-CMD
               IF CELL(Y, X) NOT = "O" AND NOT = "?" AND NOT = "F"
                   THEN
                       DISPLAY "NOT EFFECTIVE COMMAND"
                       MOVE " " TO C
           END-PERFORM.
      *    DISPLAY CMD.
       EXECUTE-CMD.
           EVALUATE C
               WHEN "m"
                   MOVE MINE TO CELL(Y, X)
               WHEN "s"
                   MOVE SUSPECT TO CELL(Y, X)
               WHEN "u"
                   MOVE UNKNOWN TO CELL(Y, X)
               WHEN "o"
                   IF MINE-CELL(Y,X) = ISMINE
                       THEN
                           MOVE "E" TO ON-GAME
                       ELSE
                           PERFORM CHK-START THRU EXIT-CHK-START
                   END-IF
               WHEN OTHER
                   CONTINUE
           END-EVALUATE.
       CHK-WIN.
           IF N-OPEN = 0
               THEN
                   MOVE "W" TO ON-GAME
           END-IF.
       EXIT-PLAY.
           EXIT.

       CHK-START.
           ADD 1 TO CHK-STACK-C.
           MOVE X TO CHK-STACK-X(CHK-STACK-C).
           MOVE Y TO CHK-STACK-Y(CHK-STACK-C).
           PERFORM CHK-MINE THRU EXIT-CHK-MINE UNTIL CHK-STACK-C < 1.
       EXIT-CHK-START.
           EXIT.

       CHK-MINE.
      *    PERFORM DISP-CHK-STACK THRU EXIT-DISP-CHK-STACK.
           MOVE CHK-STACK-XY(CHK-STACK-C) TO CHK-XY.
           SUBTRACT 1 FROM CHK-STACK-C.
           MOVE CHK-STACK-C TO CHK-STACK-C-PREV.
           PERFORM CHK-NEAR THRU EXIT-CHK-NEAR
      *    DISPLAY "CHK " CHK-XY.
      *    DISPLAY "NEAR-MINE= " N-NEAR-MINE.
           IF N-NEAR-MINE = 0
               THEN
                   MOVE NEAR-MINE(9) TO CELL(CHK-Y,CHK-X)
                   SUBTRACT 1 FROM N-OPEN
                   MOVE CHK-STACK-C-PREV TO CNTI
                   PERFORM VARYING CNTI
                       FROM 1 BY 1 UNTIL CNTI > CHK-STACK-C
                       MOVE NEAR-MINE(9)
                           TO CELL(CHK-STACK-Y(CNTI), CHK-STACK-X(CNTI))
                   END-PERFORM
                   PERFORM CHK-MINE THRU EXIT-CHK-MINE
                       UNTIL CHK-STACK-C < 1
               ELSE
                   MOVE NEAR-MINE(N-NEAR-MINE) TO CELL(CHK-Y,CHK-X)
                   SUBTRACT 1 FROM N-OPEN
                   MOVE CHK-STACK-C-PREV TO CHK-STACK-C
           END-IF.
       EXIT-CHK-MINE.
           EXIT.

       CMN SECTION.
       SCREEN-OUT.
           DISPLAY CMN-IDX-DISP.
           PERFORM VARYING CNTI FROM 1 BY 1 UNTIL CNTI > HEIGHT
               MOVE POS-INDEX(CNTI) TO ROW-IDX
               MOVE ROW(CNTI) TO ROW-BODY
               DISPLAY ROW-DISP
           END-PERFORM.
       EXIT-SCREEN-OUT.
           EXIT.
       PARSE-CMD.
           INITIALIZE CMD.
           PERFORM VARYING CNTI FROM 1 BY 1 UNTIL CNTI > WIDTH
               IF X-STR = POS-INDEX(CNTI)
                   THEN
                       MOVE CNTI TO X
               END-IF
           END-PERFORM.
           PERFORM VARYING CNTI FROM 1 BY 1 UNTIL CNTI > HEIGHT
               IF Y-STR = POS-INDEX(CNTI)
                   THEN
                       MOVE CNTI TO Y
               END-IF
           END-PERFORM.
           IF X NOT = 0  AND Y NOT = 0
               THEN
                   IF C-STR = "m" OR "o" OR "s" OR "u"
                       THEN
                           MOVE C-STR TO C
                   END-IF
           END-IF.
       EXIT-PARSE-CMD.

       CHK-NEAR.
           PERFORM CHK-EDGE THRU EXIT-CHK-EDGE.
           INITIALIZE N-NEAR-MINE.
      *    DISPLAY EDGE.
           IF UP-EDGE = " "
               THEN
                   ADD MINE-CELL(CHK-Y - 1,CHK-X) TO N-NEAR-MINE
                   IF CELL(CHK-Y - 1,CHK-X) = UNKNOWN OR SUSPECT
                       THEN
                           ADD 1 TO CHK-STACK-C
                           COMPUTE CHK-STACK-X(CHK-STACK-C) = CHK-X
                           COMPUTE CHK-STACK-Y(CHK-STACK-C) = CHK-Y - 1
                   END-IF
           END-IF.
           IF UP-EDGE = " " AND LEFT-EDGE = " "
               THEN
                   ADD MINE-CELL(CHK-Y - 1,CHK-X - 1) TO N-NEAR-MINE
                   IF CELL(CHK-Y - 1,CHK-X - 1) = UNKNOWN OR SUSPECT
                       THEN
                           ADD 1 TO CHK-STACK-C
                           COMPUTE CHK-STACK-X(CHK-STACK-C) = CHK-X - 1
                           COMPUTE CHK-STACK-Y(CHK-STACK-C) = CHK-Y - 1
                   END-IF
           END-IF.
           IF LEFT-EDGE = " "
               THEN
                   ADD MINE-CELL(CHK-Y,CHK-X - 1) TO N-NEAR-MINE
                   IF CELL(CHK-Y,CHK-X - 1) = UNKNOWN OR SUSPECT
                       THEN
                           ADD 1 TO CHK-STACK-C
                           COMPUTE CHK-STACK-X(CHK-STACK-C) = CHK-X - 1
                           COMPUTE CHK-STACK-Y(CHK-STACK-C)  = CHK-Y
                   END-IF
           END-IF.
           IF DOWN-EDGE = " " AND LEFT-EDGE = " "
               THEN
                   ADD MINE-CELL(CHK-Y + 1,CHK-X - 1) TO N-NEAR-MINE
                   IF CELL(CHK-Y + 1,CHK-X - 1) = UNKNOWN OR SUSPECT
                       THEN
                           ADD 1 TO CHK-STACK-C
                           COMPUTE CHK-STACK-X(CHK-STACK-C) = CHK-X - 1
                           COMPUTE CHK-STACK-Y(CHK-STACK-C)  = CHK-Y + 1
                   END-IF
           END-IF.
           IF DOWN-EDGE = " "
               THEN
                   ADD MINE-CELL(CHK-Y + 1,CHK-X) TO N-NEAR-MINE
                   IF CELL(CHK-Y + 1,CHK-X) = UNKNOWN OR SUSPECT
                       THEN
                           ADD 1 TO CHK-STACK-C
                           COMPUTE CHK-STACK-X(CHK-STACK-C) = CHK-X
                           COMPUTE CHK-STACK-Y(CHK-STACK-C)  = CHK-Y + 1
                   END-IF
           END-IF.
           IF DOWN-EDGE = " " AND RIGHT-EDGE = " "
               THEN
                   ADD MINE-CELL(CHK-Y + 1,CHK-X + 1) TO N-NEAR-MINE
                   IF CELL(CHK-Y + 1,CHK-X + 1) = UNKNOWN OR SUSPECT
                       THEN
                           ADD 1 TO CHK-STACK-C
                           COMPUTE CHK-STACK-X(CHK-STACK-C) = CHK-X + 1
                           COMPUTE CHK-STACK-Y(CHK-STACK-C)  = CHK-Y + 1
                   END-IF
           END-IF.
           IF RIGHT-EDGE = " "
               THEN
                   ADD MINE-CELL(CHK-Y ,CHK-X + 1) TO N-NEAR-MINE
                   IF CELL(CHK-Y ,CHK-X + 1) = UNKNOWN OR SUSPECT
                       THEN
                           ADD 1 TO CHK-STACK-C
                           COMPUTE CHK-STACK-X(CHK-STACK-C) = CHK-X + 1
                           COMPUTE CHK-STACK-Y(CHK-STACK-C)  = CHK-Y
                   END-IF
           END-IF.
           IF UP-EDGE = " " AND RIGHT-EDGE = " "
               THEN
                   ADD MINE-CELL(CHK-Y - 1  ,CHK-X + 1) TO N-NEAR-MINE
                   IF CELL(CHK-Y - 1  ,CHK-X + 1) = UNKNOWN OR SUSPECT
                       THEN
                           ADD 1 TO CHK-STACK-C
                           COMPUTE CHK-STACK-X(CHK-STACK-C) = CHK-X + 1
                           COMPUTE CHK-STACK-Y(CHK-STACK-C) = CHK-Y - 1
                   END-IF
           END-IF.
       EXIT-CHK-NEAR.
           EXIT.

       CHK-EDGE.
           INITIALIZE EDGE.
           IF CHK-X = 1
               THEN
                   MOVE "E" TO LEFT-EDGE
               ELSE
                   IF CHK-X = WIDTH
                       THEN
                           MOVE "E" TO RIGHT-EDGE
                   END-IF
           END-IF.
           IF CHK-Y = 1
               THEN
                   MOVE "E" TO UP-EDGE
               ELSE
                   IF CHK-Y = HEIGHT
                       THEN
                           MOVE "E" TO DOWN-EDGE
                   END-IF
           END-IF.
       EXIT-CHK-EDGE.
           EXIT.

       DEBUG SECTION.
       MINE-SCREEN-OUT.
           DISPLAY CMN-IDX-DISP.
           PERFORM VARYING CNTI FROM 1 BY 1 UNTIL CNTI > HEIGHT
               MOVE POS-INDEX(CNTI) TO ROW-IDX
               MOVE MINE-ROW(CNTI) TO ROW-BODY
               DISPLAY ROW-DISP
           END-PERFORM.
       EXIT-MINE-SCREEN-OUT.
           EXIT.
       DISP-CHK-STACK.
           PERFORM VARYING CNTI FROM 1 BY 1 UNTIL CNTI > CHK-STACK-C
               DISPLAY "- " CNTI " " CHK-STACK-X(CNTI) " "
       CHK-STACK-Y(CNTI) " " CELL(CHK-STACK-Y(CNTI), CHK-STACK-X(CNTI))
           END-PERFORM.
       EXIT-DISP-CHK-STACK.
           EXIT.

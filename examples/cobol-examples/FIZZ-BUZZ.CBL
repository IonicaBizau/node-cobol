      * https://github.com/Rosetta-FizzBuzz/cobol-FizzBuzz
       IDENTIFICATION DIVISION.
       PROGRAM-ID. FIZZ-BUZZ.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 CT PIC 999 VALUE 1.
       01 FZ PIC 999 VALUE 1.
       01 BZ PIC 999 VALUE 1.

       PROCEDURE DIVISION.
       FIZZ-BUZZ-MAIN SECTION.
           PERFORM 100 TIMES
                   IF FZ = 3
                        THEN IF BZ = 5
                           THEN DISPLAY "FizzBuzz"
                           COMPUTE BZ = 0
                           ELSE DISPLAY "Fizz"
                           END-IF
                           COMPUTE FZ = 0
                        ELSE IF BZ = 5
                        THEN DISPLAY "Buzz"
                                COMPUTE BZ = 0
                        ELSE
                                DISPLAY CT
                        END-IF
                END-IF
                ADD 1 TO CT
                ADD 1 TO FZ
                ADD 1 TO BZ
           END-PERFORM
           STOP RUN.


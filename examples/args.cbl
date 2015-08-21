       IDENTIFICATION DIVISION.
       PROGRAM-ID. CLIOPTIONS.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 argv                 pic x(100) value spaces.

       PROCEDURE DIVISION.
       ACCEPT argv FROM argument-value
       DISPLAY "Your name is:" argv
       STOP RUN.

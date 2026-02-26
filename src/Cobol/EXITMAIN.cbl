CBL NODYNAM,OBJECT,RENT,APOST
      CBL NODYNAM,OBJECT,RENT,APOST
      *---------------------------------------------------------------*
      *  Licensed Materials - Property of IBM                         *
      *  CICS XFCREQ SAMPLE - PROGRAM EXITMAIN                        *
      *  (c) Copyright IBM Corp. 2026 All Rights Reserved             *
      *  US Government Users Restricted Rights - Use, duplication or  *
      *  disclosure restricted by GSA ADP Schedule Contract with      *
      *  IBM Corp                                                     *
      *---------------------------------------------------------------*
      * ------------------------------------------------------------- *
       IDENTIFICATION DIVISION.
      * ------------------------------------------------------------- *
       PROGRAM-ID. EXITMAIN.
      *REMARKS
      *****************************************************************
      * PROGRAM WILL EITHER:                                          *
      * - ENABLE THE XFCREQ EXIT POINT FOR PROGRAM SMPFCREQ           *
      * - LOCATE THE GWA                                              *
      * - BUILD THE GWA CONTENT                                       *
      * - ENABLE WITH START THE XFCREQ EXIT                           *
      * OR                                                            *
      * - STOP AND DISABLE THE XFCREQ EXIT POINT                      *
      * OR                                                            *
      * - DISPLAY KEY DATA FROM THE GWA FOR THE EXIT POINT            *
      *                                                               *
      * STARTING:                                                     *
      * TRAN ENABLE A|B Y|N A|B HHMMSS.TTTTTT                         *
      * TRAN DISPLAY                                                  *
      * TRAN DISABLE                                                  *
      * TRAN UPDATE A|B Y|N A|B SS.TTTTTT                             *
      *                                                               *
      *                                                               *
      * Y|N - Switch to be time based. If Y, then HHMMSS.TTTTTT is    *
      *       the reference time.                                     *
      * HHMMSS.TTTTTT is the reference time for switching             *
      *                                                               *
      *****************************************************************
      * ------------------------------------------------------------- *
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM370 WITH DEBUGGING MODE.
      * ------------------------------------------------------------- *
      * ------------------------------------------------------------- *
       DATA DIVISION.
      * ------------------------------------------------------------- *
      * ------------------------------------------------------------- *
       WORKING-STORAGE SECTION.
      * ------------------------------------------------------------- *
      *
      *
       COPY DFHAID SUPPRESS.
       COPY HEXTRAN.
       COPY EXITDATA.
      *
       01 WS-WORKING-STORAGE.
          03  FILLER                   PIC X(04) VALUE 'BWS:'.
          03  WS-RESP                  PIC S9(8) BINARY.
          03  WS-RESP-CONV             PIC S9(8) BINARY.
          03  WS-START-CODE            PIC X(02).
      *
       01 WS-ABSTIME                   PIC S9(15) COMP-3.
       01 WS-FORMATTED-DATE            PIC X(10).
       01 WS-FORMATTED-TIME            PIC X(08).
       01 WS-INITPARM-LENGTH           PIC S9(04) BINARY.
       01 WS-INITPARM-LENGTH-DISPLAY   PIC 9(04) USAGE DISPLAY.
       01 WS-INITPARM-DATA.
          03 WS-INITPARM-COMMAND       PIC X(07).
          03 FILLER                    PIC X(01).
          03 WS-INITPARM-FILESETP      PIC X(01).
          03 FILLER                    PIC X(01).
          03 WS-INITPARM-TIME-BASED    PIC X(01).
          03 FILLER                    PIC X(01).
          03 WS-INITPARM-FILESETN      PIC X(01).
          03 FILLER                    PIC X(01).
          03 WS-INITPARM-SWITCH-TIME   PIC X(13).

       01 WS-INPUT-DATA                PIC X(30).

       01 WS-PASS-DATA.
          03 WS-TRAN                   PIC X(04).
          03 FILLER                    PIC X(01).
          03 WS-COMMAND                PIC X(07).
          03 FILLER                    PIC X(01).
          03 WS-FILESETP               PIC X(01).
          03 FILLER                    PIC X(01).
          03 WS-TIME-BASED             PIC X(01).
          03 FILLER                    PIC X(01).
          03 WS-FILESETN               PIC X(01).
          03 FILLER                    PIC X(01).
          03 WS-SWITCH-TIME            PIC X(13).
      *
       01 WS-MSG-HDR.
          03  WS-HDR-TIME              PIC X(08).
          03  FILLER                   PIC X(01) VALUE SPACES.
          03  WS-HDR-TERM              PIC X(04).
          03  FILLER                   PIC X(01) VALUE SPACES.
          03  WS-HDR-TRAN              PIC X(04).
          03  FILLER                   PIC X(01) VALUE SPACES.
          03  WS-HDR-TASKNUM           PIC 9(07) USAGE DISPLAY.
          03  FILLER                   PIC X(01) VALUE SPACES.
          03  WS-HDR-TEXT              PIC X(53).
      *
       01 WS-MESSAGES.
          03 WS-MSG-CMD-FAILED.
             05  FILLER                PIC X(13) VALUE
                 ' : FAILED,FN='.
             05  WS-MSG-FAILED-FN      PIC 9(05) USAGE DISPLAY.
             05  FILLER                PIC X(03) VALUE
              ',R='.
             05  WS-MSG-FAILED-RESP    PIC 9(08).
             05  FILLER                PIC X(04) VALUE
              ',R2='.
             05  WS-MSG-FAILED-RESP2   PIC 9(08).
             05  FILLER                PIC X(14) VALUE SPACES.
      *
          03 WS-MSG-GWASET.
             05  FILLER                PIC X(13) VALUE
                 'GWA ADDRESS: '.
             05  WS-MSG-GWAADDR        PIC 9(08) USAGE DISPLAY.
             05  FILLER                PIC X(12) VALUE
                 ',LENGTH IS: '.
             05  WS-MSG-GWALEN         PIC 9(04) USAGE DISPLAY.
             05  FILLER                PIC X(16) VALUE SPACES.
      *
          03 WS-MSG-END                PIC X(53) VALUE
             'TRANSACTION IS ENDING, SEE PREVIOUS MSGS FOR STATUS  '.
      *
          03 WS-MSG-FILESETERROR       PIC X(53) VALUE
             'FILESET VALUE FOR ENABLE & UPDATE MUST BE A OR B     '.
      *
          03 WS-MSG-SWITCHERROR       PIC X(53) VALUE
             'TIMED SWITCH VALUE FOR ENABLE & UPDATE MUST BE Y OR N'.
      *
          03 WS-MSG-INPUTERR           PIC X(53) VALUE
             'INPUT ERROR, SPECIFY - UPDATE|ENABLE|DISPLAY|DISABLE '.
      *
          03 WS-MSG-EXITENABLED        PIC X(53) VALUE
             'XFCREQ EXIT POINT HAS BEEN SUCCESSFULLY ENABLED      '.
      *
          03 WS-MSG-EXITDISABLED       PIC X(53) VALUE
             'XFCREQ EXIT POINT HAS BEEN SUCCESSFULLY DISABLED     '.
      *
          03 WS-MSG-GWAINIT            PIC X(53) VALUE
             'XFCREQ GWA HAS BEEN INITIALISED                      '.
      *
          03 WS-MSG-DISP-FILESET.
             05  FILLER                PIC X(12) VALUE
                 'FILESET(P): '.
             05  WS-MSG-FILESETP       PIC X(01).
             05  FILLER                PIC X(13) VALUE
                 ',FILESET(N): '.
             05  WS-MSG-FILESETN       PIC X(01).
             05  FILLER                PIC X(14) VALUE
                 ',TIME SWITCH: '.
             05  WS-MSG-SWITCH         PIC X(01).
             05  FILLER                PIC X(11) VALUE SPACES.
      *
          03 WS-MSG-SET-FILESET.
             05  FILLER                PIC X(16) VALUE
                 'FILESET(P) SET: '.
             05  WS-MSG-SETFILESETP    PIC X(01).
             05  FILLER                PIC X(17) VALUE
                 ',FILESET(N) SET: '.
             05  WS-MSG-SETFILESETN    PIC X(01).
             05  FILLER                PIC X(16) VALUE
                 ',TIMED SWITCH: '.
             05  WS-MSG-SETSWITCH      PIC X(01).
             05  FILLER                PIC X(01) VALUE SPACES.
      *
          03 WS-MSG-DIS-FILESET.
             05  FILLER                PIC X(15) VALUE
                 'FILESET(P) IS: '.
             05  WS-MSG-DISFILESETP    PIC X(01).
             05  FILLER                PIC X(16) VALUE
                 ',FILESET(N) IS: '.
             05  WS-MSG-DISFILESETN    PIC X(01).
             05  FILLER                PIC X(16) VALUE
                 ',TIMED SWITCH : '.
             05  WS-MSG-DISSWITCH      PIC X(01).
             05  FILLER                PIC X(03) VALUE SPACES.
      *
          03 WS-MSG-DIS-SWITCH.
             05  FILLER                PIC X(24) VALUE
                 'CURRENT SWITCH TIME IS: '.
             05  WS-MSG-DISSWITCHTIME  PIC X(13).
             05  FILLER                PIC X(16) VALUE SPACES.
      *
          03 WS-MSG-EXITSTARTED        PIC X(53) VALUE
             'XFCREQ EXIT HAS BEEN SUCCESSFULLY STARTED            '.
      *
       01 WS-WORKING-STORAGE-END.
          03  FILLER                   PIC X(04) VALUE ':EWS'.
      *
      * ------------------------------------------------------------- *
       LINKAGE SECTION.
      * ------------------------------------------------------------- *
       COPY HEXTRANL.
       COPY GWAMAP.
      *
       EJECT
      * ------------------------------------------------------------- *
       PROCEDURE DIVISION.
      * ------------------------------------------------------------- *
      *
      * CHECK THAT WE HAVE A COMMAREA
      *
       A-10-MAIN SECTION.

           MOVE ZERO TO WS-RESP.
           MOVE SPACES TO WS-PASS-DATA.

       A-100-START.
           EXEC CICS
                ASSIGN
                STARTCODE(WS-START-CODE)
                INITPARM(WS-INITPARM-DATA)
                INITPARMLEN(WS-INITPARM-LENGTH)
           END-EXEC.


           DISPLAY 'START CODE IS ' WS-START-CODE

           EVALUATE WS-START-CODE
      *
              WHEN 'TD'
                PERFORM
                   EXEC CICS
                        RECEIVE
                        INTO(WS-INPUT-DATA)
                        LENGTH(LENGTH OF WS-INPUT-DATA)
                        RESP(WS-RESP)
                  END-EXEC
                END-PERFORM
      *
              WHEN 'SD'
                PERFORM
                   EXEC CICS
                        RETRIEVE
                        INTO(WS-PASS-DATA)
                        LENGTH(LENGTH OF WS-INPUT-DATA)
                        RESP(WS-RESP)
                  END-EXEC
                END-PERFORM
      *
              WHEN 'U '
                PERFORM
                    MOVE WS-INITPARM-LENGTH TO
                         WS-INITPARM-LENGTH-DISPLAY
                    DISPLAY 'INPUT DERIVED FROM INITPARM'
                    DISPLAY 'INITPARM COMMAND '
                            WS-INITPARM-COMMAND
                    DISPLAY 'INITPARM FILESET(P) '
                            WS-INITPARM-FILESETP
                    DISPLAY 'INITPARM TIME BASED '
                            WS-INITPARM-TIME-BASED
                    DISPLAY 'INITPARM FILESET(N) '
                            WS-INITPARM-FILESETN
                    DISPLAY 'INITPARM SWITCH TIME '
                            WS-INITPARM-SWITCH-TIME
                    DISPLAY 'INITPARM LENGTH '
                            WS-INITPARM-LENGTH-DISPLAY
                    IF WS-INITPARM-LENGTH = 27
                      MOVE WS-INITPARM-COMMAND TO WS-COMMAND
                      MOVE WS-INITPARM-FILESETP TO WS-FILESETP
                      MOVE WS-INITPARM-TIME-BASED TO WS-TIME-BASED
                      MOVE WS-INITPARM-FILESETN TO WS-FILESETN
                      MOVE WS-INITPARM-SWITCH-TIME TO WS-SWITCH-TIME
                    END-IF
                END-PERFORM
      *
              WHEN OTHER
                PERFORM
                   EXEC CICS
                        RETURN
                   END-EXEC
                END-PERFORM
      *
           END-EVALUATE.

      *
       A-200-SETUP.
           EXEC CICS
                HANDLE CONDITION ERROR(Z-000-ERROR)
           END-EXEC.

           MOVE EIBTRNID TO WS-HDR-TRAN.
           MOVE EIBTRMID TO WS-HDR-TERM.
           MOVE EIBTASKN TO WS-HDR-TASKNUM.
      *
       A-300-EVALUATE.
      *
           IF WS-START-CODE NOT = 'U '
              UNSTRING WS-INPUT-DATA DELIMITED BY ALL SPACE
                       INTO WS-TRAN,
                            WS-COMMAND,
                            WS-FILESETP,
                            WS-TIME-BASED,
                            WS-FILESETN,
                            WS-SWITCH-TIME
           END-IF.
      *
           EVALUATE WS-COMMAND
              WHEN 'ENABLE'
                PERFORM B-10-ENABLE
              WHEN 'DISPLAY'
                PERFORM C-10-DISPLAY
              WHEN 'DISABLE'
                PERFORM D-10-DISABLE
              WHEN 'UPDATE'
                PERFORM E-10-UPDATE
              WHEN OTHER
                PERFORM
                  MOVE WS-MSG-INPUTERR TO WS-HDR-TEXT
                  PERFORM H-000-WRITE-MSG
                  PERFORM A-999-TERMINATE
                END-PERFORM
      *
           END-EVALUATE.
      *
       A-999-TERMINATE.

           MOVE WS-MSG-END TO WS-HDR-TEXT
           PERFORM H-000-WRITE-MSG

           IF WS-START-CODE = 'TD'
              EXEC CICS
                   SEND CONTROL FREEKB
              END-EXEC
           END-IF.
           EXEC CICS
                RETURN
           END-EXEC.
      *
           GOBACK.
           EJECT
      *
      * ------------------------------------------------------------- *
      *                    End of program                             *
      * ------------------------------------------------------------- *
      * ------------------------------------------------------------- *
      * ENABLE THE EXIT SECTION                                       *
      * ------------------------------------------------------------- *
       B-10-ENABLE SECTION.

           DISPLAY 'ENTERING ENABLE SECTION'.

       B-100-CHECK.
           IF WS-FILESETP = 'A' OR
              WS-FILESETP = 'B' OR
              WS-FILESETN = 'A' OR
              WS-FILESETN = 'B'
              NEXT SENTENCE
           ELSE
              MOVE WS-MSG-FILESETERROR TO WS-HDR-TEXT
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.
           IF WS-TIME-BASED = 'Y' OR
              WS-TIME-BASED = 'N'
              NEXT SENTENCE
           ELSE
              MOVE WS-MSG-SWITCHERROR TO WS-HDR-TEXT
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.

       B-200-ENABLE.
           MOVE LENGTH OF GWAMAP TO EXIT-GWALEN.

           EXEC CICS ENABLE PROGRAM(EXIT-PROGRAM)
                EXIT('XFCREQ')
                GALENGTH(EXIT-GWALEN) GALOCATION(DFHVALUE(LOC31))
                RESP(WS-RESP)
           END-EXEC.

           IF WS-RESP = DFHRESP(NORMAL)
              MOVE WS-MSG-EXITENABLED TO WS-HDR-TEXT
              PERFORM H-000-WRITE-MSG
           ELSE
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.
           EXEC CICS ENABLE PROGRAM(EXIT-PROGRAM-TWO)
                EXIT('XFCREQ')
                GALENGTH(EXIT-GWALEN) GALOCATION(DFHVALUE(LOC31))
                RESP(WS-RESP)
           END-EXEC.

           IF WS-RESP = DFHRESP(NORMAL)
              MOVE WS-MSG-EXITENABLED TO WS-HDR-TEXT
              PERFORM H-000-WRITE-MSG
           ELSE
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.

       B-300-EXTRACT.

           EXEC CICS EXTRACT EXIT PROGRAM(EXIT-PROGRAM)
                ENTRYNAME(EXIT-PROGRAM)
                GASET(EXIT-GWAPTR)
                GALENGTH(EXIT-GWALEN)
                RESP(WS-RESP)
           END-EXEC.

           IF WS-RESP = DFHRESP(NORMAL)
              SET HEX-INADDR     TO ADDRESS OF EXIT-GWAPTR
              SET HEX-OUTADDR    TO ADDRESS OF WS-MSG-GWAADDR
              MOVE 4  TO HEX-INLENGTH
              PERFORM F-100-HEXTRAN
              MOVE EXIT-GWALEN   TO WS-MSG-GWALEN
              MOVE WS-MSG-GWASET TO WS-HDR-TEXT
              PERFORM H-000-WRITE-MSG
           ELSE
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.

       B-400-INIT.
           SET ADDRESS OF GWAMAP TO EXIT-GWAPTR.
           MOVE EXIT-GWAEYEC     TO GWA-EYE.
           MOVE WS-FILESETP      TO GWA-FILESET.
           MOVE WS-FILESETN      TO GWA-FILESET-NEXT.

           IF WS-TIME-BASED = 'Y'
              MOVE 'Y' TO GWA-TIME-SWITCH
              MOVE WS-SWITCH-TIME  TO GWA-EVENT-TIME
           ELSE
              MOVE 'N' TO GWA-TIME-SWITCH
              MOVE '235959.999999' TO GWA-EVENT-TIME
           END-IF.

           MOVE EXIT-FILELIST    TO GWA-FILELIST.

           MOVE WS-MSG-GWAINIT   TO WS-HDR-TEXT.
           PERFORM H-000-WRITE-MSG.

           MOVE GWA-FILESET      TO WS-MSG-SETFILESETP.
           MOVE GWA-FILESET-NEXT TO WS-MSG-SETFILESETN.
           MOVE GWA-TIME-SWITCH  TO WS-MSG-SETSWITCH.
           MOVE WS-MSG-SET-FILESET TO WS-HDR-TEXT.
           PERFORM H-000-WRITE-MSG.

           MOVE GWA-EVENT-TIME   TO WS-MSG-DISSWITCHTIME.
           MOVE WS-MSG-DIS-SWITCH  TO WS-HDR-TEXT.
           PERFORM H-000-WRITE-MSG.

       B-500-START.
           EXEC CICS ENABLE PROGRAM(EXIT-PROGRAM)
                START
                RESP(WS-RESP)
           END-EXEC.

           IF WS-RESP = DFHRESP(NORMAL)
              MOVE WS-MSG-EXITSTARTED TO WS-HDR-TEXT
              PERFORM H-000-WRITE-MSG
           ELSE
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.

       B-999-TERMINATE.
           EXIT.
      * ------------------------------------------------------------- *
      * DISPLAY THE EXIT SECTION                                      *
      * ------------------------------------------------------------- *
       C-10-DISPLAY SECTION.

           DISPLAY 'ENTERING DISPLAY SECTION'.

           EXEC CICS EXTRACT EXIT PROGRAM(EXIT-PROGRAM)
                ENTRYNAME(EXIT-PROGRAM)
                GASET(EXIT-GWAPTR)
                GALENGTH(EXIT-GWALEN)
                RESP(WS-RESP)
           END-EXEC.

           IF WS-RESP = DFHRESP(NORMAL)
              SET ADDRESS OF GWAMAP TO EXIT-GWAPTR
              MOVE GWA-FILESET TO WS-MSG-DISFILESETP
              MOVE GWA-FILESET-NEXT TO WS-MSG-DISFILESETN
              MOVE GWA-TIME-SWITCH  TO WS-MSG-DISSWITCH
              MOVE WS-MSG-DIS-FILESET TO WS-HDR-TEXT
              PERFORM H-000-WRITE-MSG
              MOVE GWA-EVENT-TIME   TO WS-MSG-DISSWITCHTIME
              MOVE WS-MSG-DIS-SWITCH  TO WS-HDR-TEXT
              PERFORM H-000-WRITE-MSG
           ELSE
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.



       C-999-TERMINATE.
           EXIT.
      * ------------------------------------------------------------- *
      * DISABLE THE EXIT SECTION                                      *
      * ------------------------------------------------------------- *
       D-10-DISABLE SECTION.

           DISPLAY 'ENTERING DISABLE SECTION'.

           EXEC CICS DISABLE PROGRAM(EXIT-PROGRAM)
                EXIT('XFCREQ')
                RESP(WS-RESP)
           END-EXEC.

           IF WS-RESP = DFHRESP(NORMAL)
              MOVE WS-MSG-EXITDISABLED TO WS-HDR-TEXT
              PERFORM H-000-WRITE-MSG
           ELSE
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.

       D-999-TERMINATE.
           EXIT.
      * ------------------------------------------------------------- *
      * UPDATE  THE GWA  SECTION                                      *
      * ------------------------------------------------------------- *
       E-10-UPDATE  SECTION.

           DISPLAY 'ENTERING UPDATE SECTION'.

       E-100-CHECK.
           IF WS-FILESETP = 'A' OR
              WS-FILESETP = 'B' OR
              WS-FILESETN = 'A' OR
              WS-FILESETN = 'B'
              NEXT SENTENCE
           ELSE
              MOVE WS-MSG-FILESETERROR TO WS-HDR-TEXT
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.
           IF WS-TIME-BASED = 'Y' OR
              WS-TIME-BASED = 'N'
              NEXT SENTENCE
           ELSE
              MOVE WS-MSG-SWITCHERROR TO WS-HDR-TEXT
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.

       E-200-EXTRACT.

           EXEC CICS EXTRACT EXIT PROGRAM(EXIT-PROGRAM)
                ENTRYNAME(EXIT-PROGRAM)
                GASET(EXIT-GWAPTR)
                GALENGTH(EXIT-GWALEN)
                RESP(WS-RESP)
           END-EXEC.

           IF WS-RESP = DFHRESP(NORMAL)
              SET ADDRESS OF GWAMAP   TO EXIT-GWAPTR
              IF WS-TIME-BASED = 'Y'
                 MOVE 'Y' TO GWA-TIME-SWITCH
                 MOVE WS-SWITCH-TIME  TO GWA-EVENT-TIME
              ELSE
                 MOVE 'N' TO GWA-TIME-SWITCH
                 MOVE '235959.999999' TO GWA-EVENT-TIME
              END-IF
              MOVE WS-FILESETP        TO GWA-FILESET, WS-MSG-SETFILESETP
              MOVE WS-FILESETN        TO GWA-FILESET-NEXT,
                                         WS-MSG-SETFILESETN
              MOVE WS-TIME-BASED      TO GWA-TIME-SWITCH,
                                         WS-MSG-SETSWITCH
              MOVE WS-MSG-SET-FILESET TO WS-HDR-TEXT
              PERFORM H-000-WRITE-MSG
              MOVE GWA-EVENT-TIME   TO WS-MSG-DISSWITCHTIME
              MOVE WS-MSG-DIS-SWITCH  TO WS-HDR-TEXT
              PERFORM H-000-WRITE-MSG
           ELSE
              PERFORM I-000-WRITE-DIAGNOSTIC
              EXIT SECTION
           END-IF.

       E-999-TERMINATE.
           EXIT.
      *
      * ---------------------------------------------------------------
      * ROUTINE : F-100-HEXTRAN
      * ---------------------------------------------------------------
       F-100-HEXTRAN SECTION.

           MOVE 0 TO HEX-RETCODE, HEX-SUB.

           IF HEX-INLENGTH = 0
              MOVE 8 TO HEX-RETCODE
              GO TO F-100-HEXTRAN-EXIT
           END-IF.

           MOVE HEX-INADDR-X  TO HEX-PTR1-X.
           MOVE HEX-OUTADDR-X TO HEX-PTR2-X.

           PERFORM HEX-INLENGTH TIMES
              SET ADDRESS OF HEX-LINKIN  TO HEX-PTR1
              SET ADDRESS OF HEX-LINKOUT TO HEX-PTR2
              MOVE HEX-LINKIN-BYTE1 TO HEX-SUB-BYTE
              ADD 1 TO HEX-SUB
              MOVE HEXTAB-ARRAY(HEX-SUB) TO HEX-LINKOUT-BYTES
              ADD 1 TO HEX-PTR1-X
              ADD 2 TO HEX-PTR2-X
           END-PERFORM.

       F-100-HEXTRAN-EXIT.
           EXIT.

       H-000-WRITE-MSG SECTION.
      ****************************************************************
      *  FUNCTION: WRITES MSG TO TERMINAL iS TERMiNAL ATTACHED       *
      *          - IF DEBUG MODE, WRITE MSGS TO TS QUEUE             *
      ****************************************************************
           EXEC CICS
                ASKTIME ABSTIME(WS-ABSTIME)
           END-EXEC.

           EXEC CICS
                FORMATTIME ABSTIME(WS-ABSTIME)
                TIME(WS-FORMATTED-TIME) TIMESEP
           END-EXEC.

           MOVE WS-FORMATTED-TIME TO WS-HDR-TIME.

           EXEC CICS
                WRITEQ TS QUEUE('EADEDIAG')
                FROM(WS-MSG-HDR)
                LENGTH(LENGTH OF WS-MSG-HDR)
           END-EXEC.

           IF WS-START-CODE = 'TD'
              EXEC CICS SEND TEXT
                   FROM(WS-MSG-HDR) ERASE
                   LENGTH(LENGTH OF WS-MSG-HDR)
              END-EXEC
           END-IF.

       H-999-EXIT.
           EXIT.
      *
       I-000-WRITE-DIAGNOSTIC SECTION.
      *****************************************************************
      *  FUNCTION : GENERATES DIAGNOSTIC MESSAGE CONTENT             **
      *****************************************************************
           SET HEX-INADDR     TO ADDRESS OF EIBFN
           SET HEX-OUTADDR    TO ADDRESS OF WS-MSG-FAILED-FN
           MOVE 2  TO HEX-INLENGTH
           PERFORM F-100-HEXTRAN

           MOVE EIBRESP           TO WS-MSG-FAILED-RESP.
           MOVE EIBRESP2          TO WS-MSG-FAILED-RESP2.
           MOVE WS-MSG-CMD-FAILED TO WS-HDR-TEXT.

           PERFORM H-000-WRITE-MSG.

       I-999-EXIT.
           EXIT.
       Z-000-ERROR SECTION.
      ****************************************************************
      *  FUNCTION : GENERIC MESSAGE FOR UNHANDLE CONDITIONS          *
      ****************************************************************

           PERFoRM I-000-WRITE-DIAGNOSTIC.

           EXEC CICS
                RETURN
           END-EXEC.

       E-9999-EXIT.

           EXIT.

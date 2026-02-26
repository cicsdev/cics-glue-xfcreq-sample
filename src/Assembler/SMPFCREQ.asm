*---------------------------------------------------------------------*
*  Licensed Materials - Property of IBM                               *
*  CICS XFCREQ SAMPLE - SMPFCREQ ASSEMBLER PROGRAM                    *
*  (c) Copyright IBM Corp. 2026 All Rights Reserved                   *
*  US Government Users Restricted Rights - Use, duplication or        *
*  disclosure restricted by GSA ADP Schedule Contract with            *
*  IBM Corp                                                           *
*---------------------------------------------------------------------*
*ASM XOPTS(CICS,SP,NOPROLOG,NOEPILOG)
         TITLE 'SMPFCREQ - Sample XFCREQ Exit Program'
***********************************************************************
*                                                                     *
* MODULE NAME = SMPFCREQ                                              *
*                                                                     *
* DESCRIPTIVE NAME = Sample global user exit program for XFCREQ       *
*                                                                     *
*                                                                     *
*                                                                     *
*     Licensed Materials - Property of IBM                            *
*                                                                     *
*     "Restricted Materials of IBM"                                   *
*                                                                     *
*     5655-YA1                                                        *
*                                                                     *
*     (C) Copyright IBM Corp. 2001"                                   *
*                                                                     *
*                                                                     *
*                                                                     *
*                                                                     *
* STATUS = 7.4.0                                                      *
*                                                                     *
* FUNCTION =                                                          *
*                                                                     *
*   This program provides sample processing for the File Control      *
*   file state GLobal User Exit (GLUE) XFCREQ.                        *
***********************************************************************
* BACKGROUND                                                          *
* ----------                                                          *
* This GLUE has been written to provide a mechanism to change the     *
* FILENAME passed by the calling program to a different filename.     *
*                                                                     *
* This will allow file switching between two logical sets of files    *
* which we will call FILESETA and FILESETB.                           *
*                                                                     *
* The calling program will reference the file by a common static      *
* filename, FILE1 say; FILE1, will not be defined to CICS, instead    *
* #ILE1 and $ILE1 will be defined.                                    *
*                                                                     *
* The design requires that a task instance only uses the files of a   *
* single FILESET.  This will be determined at first file access time  *
* by using the UEPTSTOK chain to store the FILESET information.       *
*                                                                     *
* To achieve this the current FILESET will be defined in the GWA.     *
* A separate management task will have the ability to switch the      *
* fileset in the GWA.                                                 *
*                                                                     *
* The first time a file is used by a task is deemed to be the start   *
* time of the task.                                                   *
*                                                                     *
* First file access will be determined by check our task token area   *
* which will be chained off UEPTSTOK.                                 *
*                                                                     *
* By default, UEPTSTOK -> EISEXITT which is initialised as nulls.     *
*                                                                     *
*                                                                     *
* If EISEXITT is not set then this program will access the GWA to     *
* determine the current fileset and save this in our task token area. *
* Subsequent calls to XFCREQ will use the FILESET saved our           *
* task token area, thus ensuring consistency.                         *
*                                                                     *
* Once the exit knows the FILESET to use, if will examine the         *
* FILENAME being accessed by the program and change the value to      *
* that of the correct logical filename for that FILESET.              *
*                                                                     *
* For simplicity, this exit just changes the first character of the   *
* filename based on the fileset: SET A ($), SET B (#).                *
* If specific filename changes are needed, the GWAFLIST could be      *
* changed to 24 byte entries made up of: FILENAME,SETANAME,SETBNAME   *
* - this would provide greater flexibility and also allow for more    *
*   than two filesets to be used.                                     *
*                                                                     *
* NOTES                                                               *
* -----                                                               *
* o The PLT or management task would set the correct FILESET. This    *
*   will likely be driven by batch automation.                        *
* o The management task would extract the EXIT, get the GWA and set   *
*   current FILESET name.                                             *
*                                                                     *
* DESIGN                                                              *
* ------                                                              *
* o Check a GWA has been defined for the exit point                   *
*   - If not GWA then no further processing can be performed          *
* o Check the UEPTSTOK Field which by default points to EISEXITT      *
*   which is set to nulls.                                            *
* o If first file access, set up our task token area and initialise   *
*   to the correct fileset based on the current fileset information   *
*   from the GWA.                                                     *
* o If subsequent file access, then determine the FILESET to use      *
*   from our task token area which will be chained of EISEXITT.       *
* o Determine whether the file is a file to be mapped. if it is in    *
*   the eligible file mapping list, alter the name in the input parm  *
*   list to specify the new file name.                                *
*                                                                     *
***********************************************************************
* INCLUDE DSECTS                                                      *
***********************************************************************
         COPY GWAMAP
         COPY UEPTSMAP
***********************************************************************
* Ensure AMODE(31) and RMODE(ANY).                                    *
***********************************************************************
SMPFCREQ CSECT
SMPFCREQ AMODE 31
SMPFCREQ RMODE ANY
***********************************************************************
*   -Generate the prolog code with the DFHEIENT macro.                *
*      Specify CODEREG, DATAREG and EIBREG.                           *
*      This enables use of EXEC CICS (API) calls.                     *
***********************************************************************
         DFHEIENT CODEREG=3,DATAREG=10,EIBREG=11
***********************************************************************
*   -Include DSECTS needed for:                                       *
*      User Exit Parameter List - DFHUEPAR                            *
***********************************************************************
         DFHUEXIT TYPE=EP,ID=XFCREQ      DFHUEPAR plist for XFCREQ
*
         DFHREGS                         Register equates
*
         COPY DFHFCEDS                   API COMMAND STRUCTURE
***********************************************************************
* DFHEISTG working storage.                                           *
***********************************************************************
         DFHEISTG                        Start working storage
MSGX     DS    0H
MSGXLEN  DS    H                         Dynamic area for WTO MF=E
MSGXMSG  DS    CL50                      Length of messages
         ORG   MSGXMSG+22                Par to be altered
MSGXNAM  DS    CL8                       altered 8 bytes
         ORG
*
MINISAVE DS    5F                        Mini save area
FILENTRY DS    F                         Pointer to the file entry
GETMLEN  DS    F                         Length for GETMAIN
OURTSTOK DS    F                         Address of our UEPTSTOK
CICSRESP DS    F                         EXEC CICS RESPONSE CODE
INVAL    DS    F                         Binary input for display
DISPVAL  DS    CL08                      Display area
*
NOTSTOK  DS    CL1                       Our UEPTKTOK not found
FMATCH   DS    CL1                       File match found in GWA
LOWS     DC    XL1'00'                   File match found in GWA
         DS    0D                        Doubleword align
*
         DFHEIEND                        End working storage
         EJECT
***********************************************************************
***                                                                 ***
***                                                                 ***
***  S T A R T    O F    C O N T R O L    S E C T I O N             ***
***                                                                 ***
***                                                                 ***
***********************************************************************
SMPFCREQ CSECT
***********************************************************************
*   -Address the DFHUEPAR parameter list.                             *
***********************************************************************
         LR   R6,R1
         USING DFHUEPAR,R6                    Param List
***********************************************************************
*    WTO to say entry to exit (huh!?)                                 *
***********************************************************************
         MVC   MSGXMSG,MSG0              Load message
         MVC   MSGXLEN,=H'50'
         WTO   TEXT=MSGX,MF=(E,WTOLIST)
***********************************************************************
*    Check whether we have a GWA                                      *
*    - A value is 0 mean a GWA wasn't requested when exit enabled.    *
*    - Then check the length is as expected based on our GWAMAP length*
***********************************************************************
         WTO   'XFCREQ: CHECKING GWA ADDRESS'
*
         L     R4,UEPGAA                 Load address of GWA
         ST    R4,INVAL                  Save in WS
         BAL   R2,DISPADDR               Branch to display routine
         LTR   R4,R4                     Test the GWA address
         JZ    NOGWA                     Its zero
*
         L     R1,UEPGAL                 Load address of GWA Length
         LH    R1,0(R1)                  Load the length
         LA    R2,GWALEN                 Load expected length
         CR    R2,R1                     Compare lengths
         JNE   GWAWRONG                  Length mismatch
         J     INITIAL0
*
NOGWA    WTO   'XFCREQ: NO GWA DEFINED'
         J     RETURN_TO_CICS
*
GWAWRONG WTO   'XFCREQ: GWA LENGTH INCORRECT'
         J     RETURN_TO_CICS
***********************************************************************
*                                                                     *
*    Now check whether the UEPTSTOK has been set up                   *
*                                                                     *
*    - Given UEPTSTOK can be used by multiple exits we need to follow *
*      the convention whereby blocks are chained to this address.     *
*    - By default UEPTSTOK points to EISEXITT which is nulls.         *
*    - We therfore need to check UEPEXITT to see if a token has been  *
*      specified.                                                     *
*    - If the address is zero, we are the first and possible only     *
*      exit and we've not run this exit already. i,e. this is the     *
*      first time the exit has run.                                   *
*    - If the address is zero, getmain a block, initialise the        *
*      content and add address to EISEXITT.                           *
*    - If EISEXITT is not zero, check if its ours. If it is, use it,  *
*      if not, find ours by chaining down the first word address of   *
*      the block checking the eyecatcher.                             *
*    - If we find ours, use it.  if we don't allocate and add the     *
*      address to the last block in to the chain.                     *
*                                                                     *
***********************************************************************
INITIAL0 DS    0H
         WTO   'XFCREQ: DISPLAYING ADDRESS IN UEPTSTOK'
         L     R4,UEPTSTOK               Load addr of task token addr
         ST    R4,INVAL                  Save in WS
         BAL   R2,DISPADDR               Branch to display routine
*
         WTO   'XFCREQ: DISPLAYING ADDRESS IN EISEXITT'
         L     R4,0(R4)                  Is there a UEPTSTOK?
         ST    R4,INVAL                  Save in WS
         BAL   R2,DISPADDR               Branch to display routine
         LTR   R4,R4                     Test the value
         JZ    INITIAL1                  It's Zero, so we need to add
*
         WTO   'XFCREQ: NON-ZERO ADDRESS FOUND IN EISEXITT'
         BAL   R5,TSTOKFND               Find our TSTOK Block
         CLI   NOTSTOK,C'N'              Did we find our block?
         JE    INITIAL2                  Yes, bypass allocate and add
*
INITIAL1 DS    0H
         WTO   'XFCREQ: OUR TASK TOKEN NOT LOCATED'
         BAL   R5,TSTOKALC               Allocate a TSTOK area
         BAL   R5,TSTOKADD               Add TSTOK AREA to chain
*
INITIAL2 DS    0H
         WTO   'XFCREQ: OUR TASK TOKEN LOCATED. DISPLAYING ADDRESS'
         L     R9,OURTSTOK               Address our TSTOK'area
         ST    R9,INVAL                  Save in WS
         BAL   R2,DISPADDR               Branch to display routine
         USING UEPTSMAP,R9               Set addressability
*
***********************************************************************
* At this point we have either allocated a new UEPTSTOK block or      *
* found our block from a previous call to this exit by the same task. *
* Either way UEPTSMAP will contain the information we need to scan    *
* the GWA structure and determine whether a file name change should   *
* be performed.                                                       *
***********************************************************************
MAINPROC DS    0H
         L     R7,UEPCLPS                PArm list address
         USING FC_ADDR_LIST,R7
         L     R8,FC_ADDR1               Get file file name
         MVC   MSGXMSG,MSG1
         MVC   MSGXLEN,=H'50'
         MVC   MSGXNAM,0(R8)
         WTO   TEXT=MSGX,MF=(E,WTOLIST)
*
CHECKIT  DS    0H
         WTO   'XFCREQ: SCANNING GWA FILE LIST FOR A MATCH'
         MVI   FMATCH,C'N'               Set file not found to start
         BAL   R5,SCANFILE               Call the scanloop
         CLI   FMATCH,C'Y'               Was there a match?
         JE    CHANGEIT                  Yes. Make the change
*
         WTO   'XFCREQ: FILE NOT FOUND IN GWA FILE LIST'
         B     RETURN_TO_CICS
*
CHANGEIT DS    0H
         WTO   'XFCREQ: FILE LOCATED IN GWA FILE LIST'
         MVC   UEPLFILE,0(R8)            Name of file from parmlist
         MVC   UEPNFILE,UEPLFILE         New filename location
         MVC   UEPNFILE(1),UEPFCHAR      Overwrite first character
         LA    R1,UEPNFILE               Address of new file name
         ST    R1,FC_ADDR1
*
         MVC   MSGXMSG,MSG2              Load message
         MVC   MSGXLEN,=H'50'            with
         MVC   MSGXNAM,UEPNFILE          new file name
         WTO   TEXT=MSGX,MF=(E,WTOLIST)
*
***********************************************************************
*   -Generate epilog code with the DFHEIRET macro                     *
*    The DFHEIRET macro frees DFHEISTG working storage,               *
*    restores caller's registers, and sets R15 before exiting         *
***********************************************************************
RETURN_TO_CICS DS 0H
***********************************************************************
*    WTO to say exit from exit                                        *
***********************************************************************
         WTO   'XFCREQ: EXIT'
         LA     R15,UERCNORM             No errors
         DFHEIRET RCREG=15               Return with rc in R15
*
         EJECT
***********************************************************************
* Subroutines                                                         *
***********************************************************************
***********************************************************************
* SCANFILE: Scans the GWAFLIST for the file. If found, set FMATCH=Y   *
***********************************************************************
SCANFILE DS    0H
         L     R4,UEPGAA                 Address global work area
         USING GWAMAP,R4                 Set addressability to GWA
         L     R1,=AL4(GWAFILEN)          Load number of entries
         LTR   R1,R1                     Test if counter is zero
         BZR   R5                        No entries, return to caller
         LA    R2,GWAFLIST
*
LOOP1    DS    0H                        Control loop
         CLC   0(8,R2),0(R8)             Compare the file name
         JE    SCANFND                   Found a match
         LA    R2,8(R2)                  Increment to next file
         BCT   R1,LOOP1                  Round the loop if more entries
         BR    R5                        End of list, return to caller
*
SCANFND  DS    0H
         MVI   FMATCH,C'Y'               Set match found
         ST    R2,FILENTRY               Save file location in GWA
         BR    R5                        Return to caller
*
         DROP  R4                        Drop addressability to GWA
***********************************************************************
* TSTOKALC: Getmain and intialise the UEPTSTOK block.                 *
*    - Getmain and initialise the block                               *
*    - Save the address in OURTSTOK                                   *
*    - Dont save address in EISEXITT, this will be done by TSTOKADD   *
***********************************************************************
TSTOKALC DS    0H
         WTO   'XFCREQ: ALLOCATING TASK TOKEN BLOCK'
         MVC   GETMLEN,=AL4(UEPTSLEN)
*
         EXEC CICS GETMAIN SET(R9) FLENGTH(GETMLEN)                    X
                   RESP(CICSRESP) INITIMG(LOWS)
*
         CLC   CICSRESP,DFHRESP(NORMAL)  Check response
         BNE   STG_ERR                   Getmain failed
         WTO   'XFCREQ: GETMAIN FOR TASK TOKEN BLOCK SUCCESSFUL'
         ST    R9,OURTSTOK               Load the address of our area
         ST    R9,INVAL                  Save in WS
         BAL   R2,DISPADDR               Branch to display routine
*
         USING UEPTSMAP,R9               Addressability to our TSTOK
         L     R4,UEPGAA                 Load GWA Address
         USING GWAMAP,R4                 Set addressability to GWA
         MVC   UEPPROG,UEPPGMNM          Save name of program
         MVC   UEPFSET,GWAFSET           Save which fileset to use
         MVC   UEPEYE,UEPEYEC            Move in the eyecatcher
*
         MVC   MSGXMSG,MSG5              File set message
         MVC   MSGXLEN,=H'50'            length of message
*
         CLC   UEPFSET,GWAFSETA          Is it fileset A
         JNE   TOKALC1                   No, its fileset B
         MVC   UEPFCHAR,UEPFSETA         SET FILESET A mask value
         MVC   MSGXNAM,FILESETA          Indicate fileset A used
         B     TOKMSG
*
TOKALC1  DS    0H
         MVC   UEPFCHAR,UEPFSETB         SET FILESET B mask value
         MVC   MSGXNAM,FILESETB          Indicate fileset B used
*
TOKMSG   DS    0H
         WTO   TEXT=MSGX,MF=(E,WTOLIST)  Issue the message
         BR    R5                        Return to caller
*
STG_ERR  DS    0H
         WTO   'XFCREQ: ERROR GETMAINING TASK TOKEN BLOCK'
         B     RETURN_TO_CICS            Return control to CICS
*
         DROP  R4                        Drop addressability to GWA
         DROP  R9                        Drop addressability to TSTOK
***********************************************************************
* TSTOKFND: Find our UEPTSTOK Block.                                  *
*    - Our TSTOK could be pointed to by EISEXITT or chained off it    *
*    - Scan the chain looking for ours and save in OURTSTOK           *
*    - If we don't find it, then indicate it wasn't found             *
***********************************************************************
TSTOKFND DS    0H
         WTO   'XFCREQ: SCANNING FOR OUR TOKEN AREA'
         MVI   NOTSTOK,C'Y'              Indicate area not found
         L     R9,UEPTSTOK               Load address from UEPTSTOK
         L     R4,0(R9)                  Get the address of first block
         USING UEPTSMAP,R4               Set addressability
*
TOKFND0  DS    0H
         ST    R4,INVAL
         BAL   R2,DISPADDR
         WTO   'XFCREQ: CHECKING TOKEN EYECATCHER'
         CLC   UEPPROG,UEPPGMNM          Check for our program name
         JE    TOKFND1                   Yes, its our one
         L     R1,UEPNEXT                Load address of next pointer
         LTR   R1,R1                     Check if its zero
         JZ    TOKFND2                   Yes, we didn't find it
         LR    R4,R1                     Save next area in chain
         J     TOKFND0                   round the loop again
*
TOKFND1  DS    0H
         WTO   'XFCREQ: UEPTSTOK EYECATCHER MATCH'
         MVI   NOTSTOK,C'N'              SET THAT WE FOUND IT
         ST    R4,OURTSTOK               Save address of our token
         BR    R5                        Return to caller
*
TOKFND2  DS    0H
         WTO   'XFCREQ: OUR TASK TOKEN NOT FOUND'
         BR    R5                        Return to caller
*
         DROP  R4                        Drop addressability
***********************************************************************
* TSTOKADD: Add our UEPTSTOK Block to the end of the chain.           *
*    - To start UEPTSTOK will point to EISEXITT which will be zero    *
*    - If EISEXITT Is zero then add our area to this field            *
*    - If EISEXITT is not zero then chain down the blocks and add our *
*      UEPTSTOK address to the end of the chain                       *
***********************************************************************
TSTOKADD DS    0H
         WTO   'XFCREQ: ADDING OUR UEPTSTOK TO EISEXITT CHAIN'
*
         WTO   'XFCREQ: DISPLAYING CURRENT EISEXITT VALUE'
*
         L     R9,UEPTSTOK               Load current UEPTSTOK address
         L     R4,0(R9)                  Load the addr in EISEXITT
         ST    R4,INVAL                  Save in WS
         BAL   R2,DISPADDR               Branch to display routine
         USING UEPTSMAP,R4               Set addressability
         LTR   R4,R4                     Test its contents
         JNZ   TOKADD1                   It's not zero, we're not first
         L     R1,OURTSTOK               We are the first entry so
         ST    R1,0(R9)                  Save it in the UEPTSTOK area
         BR    R5
*
TOKADD1  DS    0H
         L     R1,UEPNEXT                Load address of next TSTOK
         LTR   R1,R1                     Test its contents
         JNZ   TOKADD2                   Its not the last block
         L     R1,OURTSTOK               It is zero, load our area addr
         ST    R1,UEPNEXT                Save it in forward pointer
         BR    R5                        Return to caller
*
TOKADD2  DS    0H
         WTO   'XFCREQ: LOADING THE NEXT ADDRESS IN CHAIN'
         L     R4,UEPNEXT                Move to next area
         ST    R4,INVAL                  Save in WS
         BAL   R2,DISPADDR               Branch to display routine
         B     TOKADD1                   round the loop again
*
         DROP  R4                        Drop addressability to TSTOK
***********************************************************************
* Routine to convert the 4 bytes in BINVAL to display and store in    *
* 8 byte DISPVAL AREA.  Then issue a WTO to DISPLAY the value         *
***********************************************************************
DISPADDR DS    0H
         STM   R4,R8,MINISAVE            Save registers
         WTO   'XFCREQ: DISPLAY ROUTINE ENTERED'
         L     R4,INVAL                  Load input value
         LA    R5,DISPVAL                Output area address
         LA    R6,8                      Number of time round loop
*
CONVLOOP DS    0H
         LR    R7,R4                     Input value
         SRL   R7,28                     Shift content right
         N     R7,=F'15'                 Mask to get nibble
         LA    R1,HEXTAB                 Address of hextab
         AR    R1,R7                     Ofset into table
         MVC   0(1,R5),0(R1)             Move the corresponding byte
         LA    R5,1(R5)                  Next output bytes address
         SLL   R4,4                      Move to next nibble
         BCT   R6,CONVLOOP               Round the loop again
*
         MVC   MSGXMSG,MSG3              Load message
         MVC   MSGXLEN,=H'50'            with
         MVC   MSGXNAM,DISPVAL           the address value
         WTO   TEXT=MSGX,MF=(E,WTOLIST)
*
         LM    R4,R8,MINISAVE            Restore registers
         BR    R2                        Return to caller
***********************************************************************
* Other constants.                                                    *
***********************************************************************
HEXTAB   DC    X'F0F1F2F3F4F5F6F7F8F9C1C2C3C4C5C6'
FILESETA DC    CL8'SET A($)'
FILESETB DC    CL8'SET B(#)'
*
WTOLIST  WTO TEXT=(*),MF=L
WTOLISTL EQU *-WTOLIST
*
MSG0     DC  CL50'XFCREQ: ASSEMBLED : &SYSDATE AT &SYSTIME'
MSG1     DC  CL50'XFCREQ: FILE NAME IS: XXXXXXXX'
MSG2     DC  CL50'XFCREQ: SWITCHING TO: XXXXXXXX'
MSG3     DC  CL50'XFCREQ: HEX VALUE IS: XXXXXXXX'
MSG4     DC  CL50'XFCREQ: PROGRAM NAME: XXXXXXXX'
MSG5     DC  CL50'XFCREQ: TASK FILESET: XXXXXXXX'
*
         COPY  EXITDATA                  Constants for DSECTS
*
***********************************************************************
* End of SMPFCREQ                                                     *
***********************************************************************
         DROP
         END SMPFCREQ

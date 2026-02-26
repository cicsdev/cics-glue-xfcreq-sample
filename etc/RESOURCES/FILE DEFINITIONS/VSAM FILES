//*-------------------------------------------------------------------*
//*  Licensed Materials - Property of IBM                             *
//*  CICS XFCREQ SAMPLE - DFHCSDUP INPUT                              *
//*  (c) Copyright IBM Corp. 2026 All Rights Reserved                 *
//*  US Government Users Restricted Rights - Use, duplication or      *
//*  disclosure restricted by GSA ADP Schedule Contract with          *
//*  IBM Corp                                                         *
//*-------------------------------------------------------------------*
//AEADE1S1 JOB (NONE,A4101),'A.EADE',MSGCLASS=H,
//        MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*********************************************************
//* THIS FILE CONTAINS 6 JOBS TO DEFINE 6 TEST FILES      *
//* -DATASET1.V1 - ACCESSED AS $MPFILE1 IN CICS REGION    *
//* -DATASET2.V1 - ACCESSED AS $MPFILE2 IN CICS REGION    *
//* -DATASET3.V1 - ACCESSED AS $MPFILE3 IN CICS REGION    *
//* -DATASET1.V2 - ACCESSED AS #MPFILE1 IN CICS REGION    *
//* -DATASET2.V2 - ACCESSED AS #MPFILE2 IN CICS REGION    *
//* -DATASET3.V2 - ACCESSED AS #MPFILE3 IN CICS REGION    *
//*                                                       *
//*********************************************************
//*********************************************************
//* JOBCARD                                               *
//*********************************************************
//MYLIB JCLLIB ORDER=(AEADE.MASTER.JCL)
//*********************************************************
//DEFINE   EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//AMSDUMP  DD SYSOUT=A
//SYSIN    DD *
  DELETE FINANCE.DATASET1.V1 PURGE CLUSTER
  SET MAXCC=0
  DEFINE CLUSTER (                             -
                NAME( FINANCE.DATASET1.V1) -
                CYL(2 1)                       -
                VOLUME(SYSDA)                  -
                CONTROLINTERVALSIZE( 8192 )    -
                BUFFERSPACE ( 11468 )       -
                SHAREOPTIONS( 2 3 )         -
                LOG(NONE) -
                )                           -
          DATA  (                           -
                NAME( FINANCE.DATASET1.V1.DATA ) -
                KEYS (5 0 )                 -
                RECORDSIZE( 80 80)          -
                CONTROLINTERVALSIZE( 8192 ) -
                )                           -
          INDEX (                           -
                NAME( FINANCE.DATASET1.V1.INDEX ) -
                CONTROLINTERVALSIZE( 4096 ) -
                IMBED                       -
                REPLICATE                   -
                )
/*
//*******************************************
//SORT     EXEC PGM=SORT,COND=(0,NE)
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SORTOUT  DD DSN=&&LOAD,SPACE=(6144,(100,100)),
//            DISP=(,PASS),UNIT=SYSDA,
//            DCB=(LRECL=80,RECFM=FB,BLKSIZE=3120)
//SORTWK01    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK02    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK03    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTIN   DD *
00001 .SMPFILE1.V1 SET A
00002 .SMPFILE1.V1 SET A
00003 .SMPFILE1.V1 SET A
00004 .SMPFILE1.V1 SET A
00005 .SMPFILE1.V1 SET A
00006 .SMPFILE1.V1 SET A
00007 .SMPFILE1.V1 SET A
00008 .SMPFILE1.V1 SET A
00009 .SMPFILE1.V1 SET A
00010 .SMPFILE1.V1 SET A
/*
//SYSIN    DD *
 SORT FIELDS=(1,10,CH,A)
/*
//************************
//REPRO    EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//SYS01    DD DSN=&&LOAD,DISP=(OLD,DELETE)
//APDRVP1  DD DISP=SHR,DSN=FINANCE.DATASET1.V1
//SYSIN    DD *
   REPRO INFILE (SYS01) -
         OUTFILE (APDRVP1)
/*
//
//AEADE2S1 JOB (NONE,A4101),'A.EADE',MSGCLASS=H,
//        MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*********************************************************
//* JOBCARD                                               *
//*********************************************************
//MYLIB JCLLIB ORDER=(AEADE.MASTER.JCL)
//*********************************************************
//DEFINE   EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//AMSDUMP  DD SYSOUT=A
//SYSIN    DD *
  DELETE FINANCE.DATASET2.V1 PURGE CLUSTER
  SET MAXCC=0
  DEFINE CLUSTER (                             -
                NAME( FINANCE.DATASET2.V1) -
                CYL(2 1)                       -
                VOLUME(SYSDA)                  -
                CONTROLINTERVALSIZE( 8192 )    -
                BUFFERSPACE ( 11468 )       -
                SHAREOPTIONS( 2 3 )         -
                LOG(NONE) -
                )                           -
          DATA  (                           -
                NAME( FINANCE.DATASET2.V1.DATA ) -
                KEYS (5 0 )                 -
                RECORDSIZE( 80 80)          -
                CONTROLINTERVALSIZE( 8192 ) -
                )                           -
          INDEX (                           -
                NAME( FINANCE.DATASET2.V1.INDEX ) -
                CONTROLINTERVALSIZE( 4096 ) -
                IMBED                       -
                REPLICATE                   -
                )
/*
//*******************************************
//SORT     EXEC PGM=SORT,COND=(0,NE)
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SORTOUT  DD DSN=&&LOAD,SPACE=(6144,(100,100)),
//            DISP=(,PASS),UNIT=SYSDA,
//            DCB=(LRECL=80,RECFM=FB,BLKSIZE=3120)
//SORTWK01    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK02    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK03    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTIN   DD *
00001 .SMPFILE2.V1 SET A
00002 .SMPFILE2.V1 SET A
00003 .SMPFILE2.V1 SET A
00004 .SMPFILE2.V1 SET A
00005 .SMPFILE2.V1 SET A
00006 .SMPFILE2.V1 SET A
00007 .SMPFILE2.V1 SET A
00008 .SMPFILE2.V1 SET A
00009 .SMPFILE2.V1 SET A
00010 .SMPFILE2.V1 SET A
/*
//SYSIN    DD *
 SORT FIELDS=(1,10,CH,A)
/*
//************************
//REPRO    EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//SYS01    DD DSN=&&LOAD,DISP=(OLD,DELETE)
//APDRVP1  DD DISP=SHR,DSN=FINANCE.DATASET2.V1
//SYSIN    DD *
   REPRO INFILE (SYS01) -
         OUTFILE (APDRVP1)
/*
//
//AEADE3S1 JOB (NONE,A4101),'A.EADE',MSGCLASS=H,
//        MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*********************************************************
//* JOBCARD                                               *
//*********************************************************
//MYLIB JCLLIB ORDER=(AEADE.MASTER.JCL)
//*********************************************************
//DEFINE   EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//AMSDUMP  DD SYSOUT=A
//SYSIN    DD *
  DELETE FINANCE.DATASET3.V1 PURGE CLUSTER
  SET MAXCC=0
  DEFINE CLUSTER (                             -
                NAME( FINANCE.DATASET3.V1) -
                CYL(2 1)                       -
                VOLUME(SYSDA)                  -
                CONTROLINTERVALSIZE( 8192 )    -
                BUFFERSPACE ( 11468 )       -
                SHAREOPTIONS( 2 3 )         -
                LOG(NONE) -
                )                           -
          DATA  (                           -
                NAME( FINANCE.DATASET3.V1.DATA ) -
                KEYS (5 0 )                 -
                RECORDSIZE( 80 80)          -
                CONTROLINTERVALSIZE( 8192 ) -
                )                           -
          INDEX (                           -
                NAME( FINANCE.DATASET3.V1.INDEX ) -
                CONTROLINTERVALSIZE( 4096 ) -
                IMBED                       -
                REPLICATE                   -
                )
/*
//*******************************************
//SORT     EXEC PGM=SORT,COND=(0,NE)
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SORTOUT  DD DSN=&&LOAD,SPACE=(6144,(100,100)),
//            DISP=(,PASS),UNIT=SYSDA,
//            DCB=(LRECL=80,RECFM=FB,BLKSIZE=3120)
//SORTWK01    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK02    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK03    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTIN   DD *
00001 .SMPFILE3.V1 SET A
00002 .SMPFILE3.V1 SET A
00003 .SMPFILE3.V1 SET A
00004 .SMPFILE3.V1 SET A
00005 .SMPFILE3.V1 SET A
00006 .SMPFILE3.V1 SET A
00007 .SMPFILE3.V1 SET A
00008 .SMPFILE3.V1 SET A
00009 .SMPFILE3.V1 SET A
00010 .SMPFILE3.V1 SET A
/*
//SYSIN    DD *
 SORT FIELDS=(1,10,CH,A)
/*
//************************
//REPRO    EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//SYS01    DD DSN=&&LOAD,DISP=(OLD,DELETE)
//APDRVP1  DD DISP=SHR,DSN=FINANCE.DATASET3.V1
//SYSIN    DD *
   REPRO INFILE (SYS01) -
         OUTFILE (APDRVP1)
/*
//
//AEADE1S2 JOB (NONE,A4101),'A.EADE',MSGCLASS=H,
//        MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*********************************************************
//* JOBCARD                                               *
//*********************************************************
//MYLIB JCLLIB ORDER=(AEADE.MASTER.JCL)
//*********************************************************
//DEFINE   EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//AMSDUMP  DD SYSOUT=A
//SYSIN    DD *
  DELETE FINANCE.DATASET1.V2 PURGE CLUSTER
  SET MAXCC=0
  DEFINE CLUSTER (                             -
                NAME( FINANCE.DATASET1.V2) -
                CYL(2 1)                       -
                VOLUME(SYSDA)                  -
                CONTROLINTERVALSIZE( 8192 )    -
                BUFFERSPACE ( 11468 )       -
                SHAREOPTIONS( 2 3 )         -
                LOG(NONE) -
                )                           -
          DATA  (                           -
                NAME( FINANCE.DATASET1.V2.DATA ) -
                KEYS (5 0 )                 -
                RECORDSIZE( 80 80)          -
                CONTROLINTERVALSIZE( 8192 ) -
                )                           -
          INDEX (                           -
                NAME( FINANCE.DATASET1.V2.INDEX ) -
                CONTROLINTERVALSIZE( 4096 ) -
                IMBED                       -
                REPLICATE                   -
                )
/*
//*******************************************
//SORT     EXEC PGM=SORT,COND=(0,NE)
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SORTOUT  DD DSN=&&LOAD,SPACE=(6144,(100,100)),
//            DISP=(,PASS),UNIT=SYSDA,
//            DCB=(LRECL=80,RECFM=FB,BLKSIZE=3120)
//SORTWK01    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK02    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK03    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTIN   DD *
00001 .SMPFILE1.V2 SET A
00002 .SMPFILE1.V2 SET A
00003 .SMPFILE1.V2 SET A
00004 .SMPFILE1.V2 SET A
00005 .SMPFILE1.V2 SET A
00006 .SMPFILE1.V2 SET A
00007 .SMPFILE1.V2 SET A
00008 .SMPFILE1.V2 SET A
00009 .SMPFILE1.V2 SET A
00010 .SMPFILE1.V2 SET A
/*
//SYSIN    DD *
 SORT FIELDS=(1,10,CH,A)
/*
//************************
//REPRO    EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//SYS01    DD DSN=&&LOAD,DISP=(OLD,DELETE)
//APDRVP1  DD DISP=SHR,DSN=FINANCE.DATASET1.V2
//SYSIN    DD *
   REPRO INFILE (SYS01) -
         OUTFILE (APDRVP1)
/*
//
//AEADE2S2 JOB (NONE,A4101),'A.EADE',MSGCLASS=H,
//        MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*********************************************************
//* JOBCARD                                               *
//*********************************************************
//MYLIB JCLLIB ORDER=(AEADE.MASTER.JCL)
//*********************************************************
//DEFINE   EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//AMSDUMP  DD SYSOUT=A
//SYSIN    DD *
  DELETE FINANCE.DATASET2.V2 PURGE CLUSTER
  SET MAXCC=0
  DEFINE CLUSTER (                             -
                NAME( FINANCE.DATASET2.V2) -
                CYL(2 1)                       -
                VOLUME(SYSDA)                  -
                CONTROLINTERVALSIZE( 8192 )    -
                BUFFERSPACE ( 11468 )       -
                SHAREOPTIONS( 2 3 )         -
                LOG(NONE) -
                )                           -
          DATA  (                           -
                NAME( FINANCE.DATASET2.V2.DATA ) -
                KEYS (5 0 )                 -
                RECORDSIZE( 80 80)          -
                CONTROLINTERVALSIZE( 8192 ) -
                )                           -
          INDEX (                           -
                NAME( FINANCE.DATASET2.V2.INDEX ) -
                CONTROLINTERVALSIZE( 4096 ) -
                IMBED                       -
                REPLICATE                   -
                )
/*
//*******************************************
//SORT     EXEC PGM=SORT,COND=(0,NE)
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SORTOUT  DD DSN=&&LOAD,SPACE=(6144,(100,100)),
//            DISP=(,PASS),UNIT=SYSDA,
//            DCB=(LRECL=80,RECFM=FB,BLKSIZE=3120)
//SORTWK01    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK02    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK03    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTIN   DD *
00001 .SMPFILE2.V2 SET A
00002 .SMPFILE2.V2 SET A
00003 .SMPFILE2.V2 SET A
00004 .SMPFILE2.V2 SET A
00005 .SMPFILE2.V2 SET A
00006 .SMPFILE2.V2 SET A
00007 .SMPFILE2.V2 SET A
00008 .SMPFILE2.V2 SET A
00009 .SMPFILE2.V2 SET A
00010 .SMPFILE2.V2 SET A
/*
//SYSIN    DD *
 SORT FIELDS=(1,10,CH,A)
/*
//************************
//REPRO    EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//SYS01    DD DSN=&&LOAD,DISP=(OLD,DELETE)
//APDRVP1  DD DISP=SHR,DSN=FINANCE.DATASET2.V2
//SYSIN    DD *
   REPRO INFILE (SYS01) -
         OUTFILE (APDRVP1)
/*
//
//AEADE3S2 JOB (NONE,A4101),'A.EADE',MSGCLASS=H,
//        MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*********************************************************
//* JOBCARD                                               *
//*********************************************************
//MYLIB JCLLIB ORDER=(AEADE.MASTER.JCL)
//*********************************************************
//DEFINE   EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//AMSDUMP  DD SYSOUT=A
//SYSIN    DD *
  DELETE FINANCE.DATASET3.V2 PURGE CLUSTER
  SET MAXCC=0
  DEFINE CLUSTER (                             -
                NAME( FINANCE.DATASET3.V2) -
                CYL(2 1)                       -
                VOLUME(SYSDA)                  -
                CONTROLINTERVALSIZE( 8192 )    -
                BUFFERSPACE ( 11468 )       -
                SHAREOPTIONS( 2 3 )         -
                LOG(NONE) -
                )                           -
          DATA  (                           -
                NAME( FINANCE.DATASET3.V2.DATA ) -
                KEYS (5 0 )                 -
                RECORDSIZE( 80 80)          -
                CONTROLINTERVALSIZE( 8192 ) -
                )                           -
          INDEX (                           -
                NAME( FINANCE.DATASET3.V2.INDEX ) -
                CONTROLINTERVALSIZE( 4096 ) -
                IMBED                       -
                REPLICATE                   -
                )
/*
//*******************************************
//SORT     EXEC PGM=SORT,COND=(0,NE)
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SORTOUT  DD DSN=&&LOAD,SPACE=(6144,(100,100)),
//            DISP=(,PASS),UNIT=SYSDA,
//            DCB=(LRECL=80,RECFM=FB,BLKSIZE=3120)
//SORTWK01    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK02    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTWK03    DD SPACE=(6144,(100,100)),UNIT=SYSDA
//SORTIN   DD *
00001 .SMPFILE3.V2 SET A
00002 .SMPFILE3.V2 SET A
00003 .SMPFILE3.V2 SET A
00004 .SMPFILE3.V2 SET A
00005 .SMPFILE3.V2 SET A
00006 .SMPFILE3.V2 SET A
00007 .SMPFILE3.V2 SET A
00008 .SMPFILE3.V2 SET A
00009 .SMPFILE3.V2 SET A
00010 .SMPFILE3.V2 SET A
/*
//SYSIN    DD *
 SORT FIELDS=(1,10,CH,A)
/*
//************************
//REPRO    EXEC PGM=IDCAMS,COND=(0,NE)
//SYSPRINT DD SYSOUT=A
//SYS01    DD DSN=&&LOAD,DISP=(OLD,DELETE)
//APDRVP1  DD DISP=SHR,DSN=FINANCE.DATASET3.V2
//SYSIN    DD *
   REPRO INFILE (SYS01) -
         OUTFILE (APDRVP1)
/*

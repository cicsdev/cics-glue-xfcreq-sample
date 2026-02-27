# cics-glue-xfcreq-sample
Sample CICS file control EXEC interface API exit XFCREQ

This sample exit has been created to demonstrate how a CICS filename passed to CICS by an application program can be redirected to a different filename at the XFCREQ exit point.

The exit uses fields in the GWA (Global Work Area) to indicate which files should be changed and how. This allows multiple tasks to be consistent in the which files should be used at any one time.

A PDF called 'Documentation.pdf' has been included in this repository.  It contains greater details of how this is achieved and the use case which led to the exit creation. 

In addition to the assembler exit which is called SMPFCREQ, there is a sample COBOL program called EXITMAIN which has been written to show how:
- to enable the exit with a GWA
- initialise the GWA and start the exit
- disable and stop the exit
- show status of a key field in the GWA
- update the key field in the GWA

OVERVIEW OF THE CONTENT OF THIS REPOSITORY
- /doc/documentation.pdf - detailed overview of the XFCREQ sample
- /etc/resource/csd - contains sample DFHCSDUP definitions for a AOR/FOR configuration
- /etc/resource/file definitions / sample JCL to create and load the sample VSAM files
- /etc/resource/plt - sample PLTPI defintion
- /etc/resource/sit - INITPARM definition required if EXITMAIN to used at PLTPI time
- /src/assembler - Sample XFCREQ program and associated DSECT definitions
- /src/Cobol - Sample EXITMAIN program and associated copybook definitions

For more details on use case, solution and workings of this sample please see the documentation.pdf
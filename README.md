# cics-glue-xfcreq-sample
Sample CICS file control EXEC interface API exit XFCREQ

This sample exit has been created to demonstrate how a CICS filename passed to CICS by an application program can be redirected to a different filename at the XFCREQ global user exit (GLUE) point. The exit uses fields in the Global Work Area (GWA) to indicate which files should be changed and how. This allows multiple tasks to be consistent in the which files should be used at any one time. Further details on the design of the exit are included in the [documentation.pdf](doc/documentation.pdf).

In addition to the assembler exit [SMPFCREQ](src/Assembler/SMPFCREQ.asm), there is a sample COBOL program called [EXITMAIN](src/Cobol/EXITMAIN.cbl) which has been written to demonstrate:
- Enabling the exit with a GWA
- Initialising the GWA and starting the exit
- Disabling and stopping the exit
- Show status of a key field in the GWA
- Update the key field in the GWA

## Contents of the repository
- [/doc/documentation.pdf](doc/documentation.pdf) - Detailed overview of the XFCREQ sample
- [/etc/resources/csd](etc/resources/csd) - Sample DFHCSDUP definitions for an AOR/FOR configuration
- [/etc/resources/files](etc/resources/files) Sample JCL to create and load the sample VSAM files
- [/etc/resources/plt](etc/resources/plt) - Sample PLTPI defintion
- [/etc/resources/sit](etc/resources/sit) - SIT INITPARM definition required if EXITMAIN to be used at PLTPI time
- [/src/Assembler](src/Assembler) - Sample XFCREQ program and associated DSECTs
- [/src/Cobol](src/Cobol) - Sample EXITMAIN program and associated copybooks 

For more details on use case, solution and workings of this sample please see the [documentation.pdf](/doc/documentation.pdf)
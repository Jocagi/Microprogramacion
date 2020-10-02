@ECHO OFF
cls
TITLE ASSEMBLY
ECHO ======= TASM =======
TASM Ej3.asm
ECHO ======= TLINK =======
TLINK Ej3
ECHO ====== PROGRAM ======
TIMEOUT 1 >nul
Ej3
PAUSE

@ECHO OFF
cls
TITLE ASSEMBLY
ECHO ======= TASM =======
ECHO.
TASM LAB5.asm
ECHO.
ECHO ======= TLINK =======
ECHO.
TLINK LAB5
ECHO.
ECHO ====== PROGRAM ======
ECHO.
TIMEOUT 1 >nul
LAB5
ECHO.
ECHO.
PAUSE
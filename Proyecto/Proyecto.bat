@ECHO OFF
cls
TITLE ASSEMBLY
ECHO ======= TASM =======
ECHO.
TASM UUID.asm
ECHO.
ECHO ======= TLINK =======
ECHO.
TLINK UUID
ECHO.
ECHO ====== PROGRAM ======
ECHO.
TIMEOUT 1 >nul
UUID
ECHO.
ECHO.
PAUSE
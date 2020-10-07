@ECHO OFF
cls
TITLE ASSEMBLY
ECHO ======= TASM =======
ECHO.
TASM Ejemplo.asm
ECHO.
ECHO ======= TLINK =======
ECHO.
TLINK Ejemplo
ECHO.
ECHO ====== PROGRAM ======
ECHO.
TIMEOUT 1 >nul
Ejemplo
ECHO.
ECHO.
PAUSE

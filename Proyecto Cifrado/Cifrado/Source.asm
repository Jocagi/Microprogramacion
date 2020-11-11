.386
.MODEL flat,stdcall 
;Options
option casemap:none 
;Includes
INCLUDE \masm32\include\kernel32.inc  
INCLUDE \masm32\include\masm32.inc
INCLUDELIB \masm32\lib\kernel32.lib   
INCLUDELIB \masm32\lib\masm32.lib
.DATA 
	saludo DB "Hola Mundo!!!", 0
.CODE
PROGRAM:
	INVOKE StdOut, ADDR saludo 
	;Finalizar
	INVOKE ExitProcess, 0
END PROGRAM
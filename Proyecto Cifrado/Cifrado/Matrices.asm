.386
.MODEL flat, stdcall
option casemap:none 

INCLUDE \masm32\include\kernel32.inc  
INCLUDE \masm32\include\masm32.inc
INCLUDELIB \masm32\lib\kernel32.lib   
INCLUDELIB \masm32\lib\masm32.lib

.CODE
SaludoPROC PROC saludo :DWORD
	INVOKE StdOut, saludo
RET 
SaludoPROC ENDP

END
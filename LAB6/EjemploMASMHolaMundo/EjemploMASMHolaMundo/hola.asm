.386 ; 486 586
.MODEL flat, stdcall ; convención de paso de parámetros
;Options
option casemap :none ; convención para mapear caracteres utilizada por Windows.inc

;includes 
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc

.DATA ; variables que están inicializadas no ?
	saludo DB "Hola mundo",0
	cadena1 DB "Ingrese su nombre ",0
	num DB 3
.DATA? ; variables sin inicializar
	nombre DB 50 dup(?)
.CONST ; valores que no van a cambiar

.CODE
programa:
; no es necesario inicializar el programa
	; Imprimir
	INVOKE StdOut, ADDR saludo ; mandar a imprimir variable, ADDR es el equivalente al offset
	
	ADD num, 30h
	INVOKE StdOut, ADDR num
	
	MOV EAX, 250
	print str$(EAX),13d,10d
	print chr$("Hola Mundo!!!")
	print chr$(13,10)

	INVOKE StdOut, ADDR cadena1
	;Leer
	INVOKE StdIn, ADDR nombre,10 ; 10 máximo a leer
	INVOKE StdOut, ADDR nombre

	;Finalizar
	INVOKE ExitProcess, 0

END programa

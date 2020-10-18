.386 ; 486 586
.MODEL flat,stdcall ; convencion de paso de parametros

;Options
option casemap:none ; convencion para mapear caracteres utilizada por Windows.inc

;Includes
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc

.DATA ; variables sin inicializaar
	saludo DB "Hola Mundo!!!", 0
	cadena1 DB "Ingrese sub nombre ", 0
	num DB 8
.DATA? ; variables sin inicializar
	nombre DB 50 dup(?)
.CONST ; valores que no cambian

.CODE
PROGRAM:
; No es necesario inkicializar el programa
	INVOKE StdOut, ADDR saludo ; mandar a imprimir variable

	ADD num, 30h
	INVOKE StdOut, ADDR num

	MOV EAX, 250
	print str$(EAX),13d,10d
	print chr$("Hola Mundo!!!")
	print chr$(13, 10)

	;Leer
	INVOKE StdOut, ADDR cadena1
	INVOKE StdIn, ADDR nombre, 10 ; 10 maximo a leer
	INVOKE StdOut, ADDR nombre

	;Finalizar
	INVOKE ExitProcess, 0
END PROGRAM

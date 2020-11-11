ImprimeNumero MACRO numero 
	add numero,30h
	invoke StdOut, ADDR numero
ENDM

; Calcula la posición real en la matriz
Mapeo MACRO I, J, Filas, Columnas, Tamano
	MOV AL, I
	MOV BL, Filas
	mul BL				; Resultado está en AL
	MOV BL, Tamano
	MUL BL				; Primera parte de la fórmula
	; Columnas
	MOV CL, AL				; guardar temporalmente el resultado de las filas
	MOV AL, J
	MOV BL, Tamano
	MUL BL
	; sumar
	ADD AL, CL				; Resultado en AL
ENDM

.386 ; 486 586
.MODEL flat, stdcall ; convención de paso de parámetros

option casemap:none ; convención para mapear caracteres utilizada por Windows.inc

;includes 
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc

.DATA
	MensajeFilas DB "Ingrese cantidad de filas de la matriz: ",0
	MensajeColumnas DB "Ingrese cantidad de columnas de la matriz: ",0
	MensajeDimensionesMatriz DB "La cantidad de posiciones es: ",0

	; contadores
	Filas DB 1,0 ; Cantidad de Filas
	Columnas DB 1,0 ; Cantidad de columnas
	I DB 0,0; contador de posicion/índice
	J DB 0,0 ; contador de posicion/índice
	TamanoMatriz DB 0,0
	posicion DB 0,0
	
.CODE
programa:
llenarMatriz PROC Near
	INVOKE StdOut, ADDR MensajeFilas
	INVOKE StdIn, ADDR Filas, 10d

	INVOKE StdOut, ADDR MensajeColumnas
	INVOKE StdIn, ADDR Columnas, 10d

	; Transformar al número real
	SUB Filas,30h
	SUB Columnas,30h

	; Calcular tamano Matriz
	MOV AL, Filas
	MOV BL, Columnas
	MUL BL					; Multiplicar filas por columnas, y resultado está en AL
	MOV TamanoMatriz, AL
	INVOKE StdOut, ADDR MensajeDimensionesMatriz
	ImprimeNumero TamanoMatriz
	
	;1. Inicializar valores /PReparar antes del ciclo
	print chr$(13,10)      ; imprime salto de línea
	MOV I, 0
	;2. Ciclo Recorre Filas
	CicloFilas:
		MOV J, 0
		print chr$(13,10) 
	;3. Ciclo Recorre Columnas
	;	3.1 Obtener posición o elemento en X posición
	CicloColumnas:
		Mapeo I, J, Filas, Columnas, 1     ; El resultado queda en AL [fila, columna]
		MOV posicion, AL
		ImprimeNumero posicion
		; Asignar la posición a un índice
		; EDI = posicion
		; ESI = Posicion
		;[EDI] o [ESI] = asignar valores, obtener los valores
		;Lógica de ciclos
		INC J 
		MOV CL, J
		CMP CL, Columnas
		JL CicloColumnas
		; Else
		INC I ; llegó al final de las columnas, y tiene que cambiar de fila
		MOV CL, I
		CMP CL, Filas
		JL CicloFilas


llenarMatriz ENDP
; Finalizar programa
INVOKE ExitProcess, 0

END programa
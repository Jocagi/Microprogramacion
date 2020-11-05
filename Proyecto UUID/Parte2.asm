.model small
.data
	contador db 0;
	cadena1 db 13,10, 'Introducir la a cadena evaluar: $'
	cadena2 db 13,10, 'La Cadena es correcta$'
	cadena3 db 13,10, 'La Cadena es incorrecta$'
	cadena4 db 13,10, 'La Cadena ingresada es:$'
	cadena db 37 dup ('$')
.stack
.code
program:

main:
	;Inicializacion del programa
	MOV AX, @DATA				;Obtenemos la direccion del inicio al segmento de datos
	MOV DS, AX 					;Inicializa el segmento de datos

	
	;Imprimir primer variable
	MOV AH, 09h
	LEA DX, cadena1
	INT 21h

	XOR DX, DX 					;Limpiar registros
	XOR AX, AX 					;Limpiar registros
    MOV CX, 0d                
	MOV SI,0h 
	
	
LeerCadena:
	; Inicializar el indice con la cadena
	LEA DI, cadena
	; realizar llamadas
	CALL LlenarCadena


;Procedimientos
capturarCaracter PROC NEAR
	XOR AX, AX
	INC CX
	MOV AH, 01h						; obtener caracter de consola
	INT 21h 						; Ejecuta la interrupcion
	RET
capturarCaracter ENDP
	   
LlenarCadena PROC NEAR   
Leer:
	CMP CX, 36d							; Comparar si fue enter
	JE PrepararEvaluacion
	CALL CapturarCaracter
	MOV [DI], AL
	INC DI
	JMP Leer
LlenarCadena ENDP
	
ImprimirCadena PROC NEAR
	XOR DX, DX
	;Imprime salto de linea
	MOV AH, 02h 						; imprime caracter
	MOV DL, 0AH
	INT 21h
	;Imprime cadena
	XOR DX, DX 							; limpiar registro
	MOV AH, 09h
	MOV DX, offset cadena
	INT 21h
	RET
ImprimirCadena ENDP

PrepararEvaluacion:
	MOV CX, 0d
	MOV SI,0h 
	XOR DX, DX 					;Limpiar registros
	XOR AX, AX 					;Limpiar registros
	MOV AH, 09h
	LEA DX, cadena4
	INT 21h

	XOR DX, DX 					;Limpiar registros
	XOR AX, AX 					;Limpiar registros
	CAll ImprimirCadena
	MOV DL, 0Ah												
	MOV AH, 02h
	INT 21h
	XOR DX, DX 					;Limpiar registros
	XOR AX, AX 					;Limpiar registros
	MOV DI, 0d
	JMP EvaluarCadena
	

EvaluarCadena:

	MOV AL, cadena[DI]
	INC DI
	INC CX
	CMP CX,09d
	JE Guion 
	CMP CX,14d
	JE Guion
	CMP CX, 15d
	JE EvaluarNUm1
	CMP CX,19d
	JE Guion
	CMP CX,20d
	JE SegundoGrupo
	CMP CX,24d
	JE Guion
	CMP CX,37d
	JL NumeroInicio
	JMP Aceptar

NumeroInicio:	
	CMP AL, "0"
	JAE NumeroFInal
	JMP Error

NumeroFInal:
	CMP AL, "9"
	JBE EvaluarCadena
	JMP LetraInicio

LetraInicio:
	CMP AL, "A"
	JAE LetrFinal
	JMP Error
	
LetrFinal:
	CMP AL, "F"
	JBE EvaluarCadena
	JMP Error

Guion:
	CMP AL, "-"
	JE EvaluarCadena
	JMP Error
SegundoGrupo:
	CMP AL, "A"
	JE EvaluarCadena
	CMP AL, "B"
	JE EvaluarCadena
	CMP AL, "8"
	JE EvaluarCadena
	CMP AL, "9"
	JE EvaluarCadena
	JMP Error
EvaluarNUm1:
	CMP AL, "1"
	JE EvaluarCadena
	JMP Error
Error:
	MOV AH, 09h
	LEA DX, cadena3
	INT 21h
	JMP Final

Aceptar:
	MOV AH, 09h
	LEA DX, cadena2
	INT 21h
	JMP Final
Final:
	;fin programa
	MOV AH, 4CH
	INT 21H
	
END
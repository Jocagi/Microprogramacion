.model small				;Declaracion del modelo
.data 						;Inicia segmento de datos	
	numA DB 4h
	numB DB 2h
	numC DB 1h
.stack
.code 
main:
		;Inicializacion del programa
		MOV AX, @DATA		;Obtener direccion de inicio de segmento de datos
		MOV DS, AX			;Inicializacion del segmento de datos
		
		XOR AX, AX			;Limpiar registro AX
		
		;SUMA
		MOV AL, numA
		ADD AL, numC
		ADD AL, 30h			;Offset para el valor del ASCII correspondiente
		
		;Imprimir
		MOV DL, AL
		MOV AH, 02h
		INT 21h
		;Imprime espacio en blanco
		MOV DL, 0Ah
		INT 21h
		
		;RESTA
		MOV AL, numA
		SUB AL, numB
		ADD AL, 30h

		;Imprimir
		MOV DL, AL
		INT 21h

		MOV DL, 0Ah
		INT 21h
		
		;A + B + 2C
		MOV AL, numA
		ADD AL, numB
		ADD AL, numC
		ADD AL, numC
		ADD AL, 30h

		;Imprimir
		MOV DL, AL
		INT 21h
		
		MOV DL, 0Ah
		INT 21h

		;A - B + C
		MOV AL, numA
		SUB AL, numB
		ADD AL, numC
		ADD AL, 30h

		;Imprimir
		MOV DL, AL
		INT 21h
		
		;Finalizacion del programa
		MOV AH, 4Ch
		INT 21h
End main
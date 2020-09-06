.model small					;Modelo-tamanio del programa
.data 							;Inicia declaracion de variables
	Nombre DB 'Jose Giron $'	;Variable de tipo cadena
	Carnet DB '1064718$'
.stack							;Segmento de pila
.code							;Segmento de codigo

programa:						;Etiqueta que indica inico de programa
		;INICIALIZAR EL PROGRAMA
		MOV AX, @DATA			;Asigna al registro AX, la direccion de inicio
		MOV DS, AX
		
		;Imprimir cadena en pantalla
		MOV DX, offset Nombre
		MOV AH, 09h
		INT 21h
		
		MOV DX, offset Carnet
		MOV AH, 09h
		INT 21h
		
		;Limpiar registro
		MOV DX, 0h
		
		;Imprimir nombre, letra por letra
		MOV DL, 20h ;(espacio)
		MOV AH, 02h
		INT 21h
		
		MOV DL, 4Ah ;J
		MOV AH, 02h
		INT 21h
		
		MOV DL, 2Dh ;-
		MOV AH, 02h
		INT 21h
		
		MOV DL, 6Fh ;o
		MOV AH, 02h
		INT 21h
		
		MOV DL, 2Dh ;-
		MOV AH, 02h
		INT 21h

		MOV DL, 73h ;s
		MOV AH, 02h
		INT 21h
		
		MOV DL, 2Dh ;-
		MOV AH, 02h
		INT 21h
		
		MOV DL, 65h ;e
		MOV AH, 02h
		INT 21h
		
		;FINALIZAR EL PROGRAMA
		MOV AH, 4Ch				;Interrupcion de finalizar proceso
		INT 21h					;Llamada a ejecutar la interrupcion anterior
END programa					;Fin de programa
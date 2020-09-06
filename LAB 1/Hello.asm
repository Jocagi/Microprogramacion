.model small					;Modelo-tamanio del programa
.data 							;Inicia declaracion de variables
	HELLO DB 'HELLO WORLD!$'	;Variable de tipo cadena
.stack							;Segmento de pila
.code							;Segmento de codigo

programa:						;Etiqueta que indica inico de programa
		;INICIALIZAR EL PROGRAMA
		MOV AX, @DATA			;Asigna al registro AX, la direccion de inicio
		MOV DS, AX
		
		;Imprimir cadena en pantalla
		MOV DX, offset HELLO
		MOV AH, 09h
		INT 21h
		
		;Limpiar registro
		XOR DX, DX
		
		;FINALIZAR EL PROGRAMA
		MOV AH, 4Ch				;Interrupcion de finalizar proceso
		INT 21h					;Llamada a ejecutar la interrupcion anterior
END programa					;Fin de programa
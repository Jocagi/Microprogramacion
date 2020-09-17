.model small			; Modelo para ejecutables
.code					; Inicia el segmento de código
.stack					; [Agregado] Segmento de pila
programa:				; Etiqueta para el inicio del programa
		Mov AX,@DATA	; Se obtiene la dirección de inicio del segmento de datos
		Mov DS,AX		; Se asigna al registro data segment la dirección de inicio del segmento de datos
		Mov AX,0000h	; Se inicializa el acumulador
		Mov BX,0000h	; Se inicializa el registro BX
		Mov AL,15h		; Se asigna el valor a la parte baja del registro AX
		Mov BL,15h		; Se asigna el valor a la parte baja del registro BX
		Add AL,BL		; Se suman los dos registros
		Add AL,30h		; [Agregado] Al resultado se le hace un offset para que muestre la letra Z
		Mov DL,AL		; El resultado se asigna al registro DL para imprimirlo en pantalla
		Mov AH,02		; Se asigna el valor para impresión de caracteres en pantalla a la parte alta del acumulador
		Int 21h			; Se invoca a la interrupción del DOS 21h
		Mov AH,4CH		; Se asigna el código para finalización de programa
		int 21h			; Si invoca a la interrupción del DOS 21h para finalizar

End programa
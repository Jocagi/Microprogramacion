.model small
.data
	cadena1 DB 'hola$'
	cadena2 DB 'test$'
	resEsIgual DB 'Las cadenas son iguales$'
	resNoEsIgual DB 'Las cadenas son diferentes$'
.stack
.code
programa:
		
	;	INICIO PROGRAMA
	mov ax, @DATA	
	mov ds, ax
	
	;	Inicializar apuntadores
	; Registros para recorrer cadenas de caracteres SI, DI
	lea si, cadena1		;Inicializando SI, en la primera posicion de cadena1
	lea di, cadena2		;Inicializando DI, en la primera posicion de cadena2
	;mov bl, [si]		;BL, tiene la letra 'H' asignada
	
	call CompararCadenas
	
	Final:
	;	FINALIZACION DEL PROGRAMA
	mov ah, 4Ch
	int 21h
	
	;	Recorrido de las cadenas
	CompararCadenas PROC NEAR
	Comparar:
		xor bx, bx
		xor cx, cx
		; Asignar a registros valores de cada posicion
		mov bl, [si]	;Almacena posicion actual en BL cadena1
		mov cl, [di]	;Almacena posicion actual en CL cadena2
		cmp bl, [di]
		jnz NoSonIguales
		; Incrementar SI y DI
		inc si
		inc di
		; Comparar si la cadena ha terminado
		cmp cadena1[SI], 24h
		je SonIguales
		jmp Comparar
		
	SonIguales:
		xor dx, dx
		mov dx, offset resEsIgual
		mov ah, 09h
		int 21h	
		jmp Fin
		
	NoSonIguales:
		xor dx, dx
		mov dx, offset resNoEsIgual
		mov ah, 09h
		int 21h
	Fin:
	RET
	CompararCadenas ENDP

End programa
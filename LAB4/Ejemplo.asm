.model small
.data
	num1 db ?
	num2 db ?
	contador db 1 dup (0)
.stack
.code
programa:
		
	;	INICIO PROGRAMA
	mov ax, @DATA	
	mov ds, ax		
	
	;Leer num1
	mov ah, 02		;Para cambiar de linea
	mov dl, 0AH
	int 21h
		
	mov ah, 01h		;Leer caracter desde el teclado
	int 21h			;Leer segundo caracter
		
	sub al, 30h		;resto 30h para obtener numero real
	mov num1, al	;se guarda en variable num2
	
	;Leer num2
	mov ah, 02		;Para cambiar de linea
	mov dl, 0AH
	int 21h
		
	mov ah, 01h		;Leer caracter desde el teclado
	int 21h			;Leer segundo caracter
		
	sub al, 30h		;resto 30h para obtener numero real
	mov num2, al	;se guarda en variable num2
	
	mov ah, 02		;Para cambiar de linea
	mov dl, 0AH
	int 21h
			
	; Preparar lo que necesito para multiplicar
	; Asignar contador
	xor cx, cx
	mov cl, num1	;Veces en las que se repetira
	sub cl, 1h		;Se cuenta el valor inical de num2 como la primera iteracion
	
	mov bl, num2	;Asignar valor inicial, total
	
	;Multiplicacion
	Multiplicar:
		add bl, num2	; Sumar num2, num1 veces
		loop multiplicar
		
	;Imprimir
	Evaluar:
		cmp bl, 09h				; Vefificar si el numero es de 1 digito o no
		jle ImprimirUnDigito	;Es un digito
		jmp SepararNumero
		
		ImprimirUnDigito:
		mov ah, 02h				; Parametro de interrupcion para imprimir un caracter
		mov dl, contador		; imprimir decenas
		add dl, 30h				; Representacion ASCII
		int 21h
		
		mov dl, bl				; Asignando digito a imprimir (unidad)
		add dl, 30h				; Representacion ASCII
		int 21h
		jmp Final
		
		SepararNumero:
		sub bl, 0AH				; Quitarle un decena
		inc contador			; Contar cuantas decenas quitamos
		cmp bl, 09h
		jle ImprimirUnDigito
		jmp SepararNumero
		
		
	Final:
	;	FINALIZACION DEL PROGRAMA
	mov ah, 4Ch
	int 21h

End programa
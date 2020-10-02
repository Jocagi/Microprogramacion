; Escribir un programa en lenguaje ensamblador que lea dos números desde el teclado, 
; haga su multiplicación haciendo sumas sucesivas, utilizando saltos.

.model small
.data
	;Variables
	num1 db ?
	num2 db ?
	contador1 db 1 dup (0)
	contador2 db 1 dup (0)
	contador3 db 1 dup (0)
	;Strings
	sInstruccion1 db 'Ingrese num1: $'
	sInstruccion2 db 'Ingrese num2: $'
	sResultado	  db 'Resultado: $'
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

	MOV DX, OFFSET sInstruccion1	;Imprimir Instruccion
	MOV AH, 09H	
	INT 21H	
	
	mov ah, 01h		;Leer primer caracter desde el teclado
	int 21h			
		
	sub al, 30h		;resto 30h para obtener numero real
	mov bl, 0Ah
	mul bl			;multiplicar por 10(bl) para las decenas
	mov num1, al	;se guarda en variable num1
	
	mov ah, 01h		;Leer segundo caracter
	int 21h			
		
	sub al, 30h		;resto 30h para obtener numero real
	add num1, al	;se guarda en variable num1
	
	;Leer num2
	mov ah, 02		;Para cambiar de linea
	mov dl, 0AH
	int 21h
		
	MOV DX, OFFSET sInstruccion2	;Imprimir Instruccion
	MOV AH, 09H	
	INT 21H	
	
	mov ah, 01h		;Leer primer caracter desde el teclado
	int 21h			
		
	sub al, 30h		;resto 30h para obtener numero real
	mov bl, 0Ah
	mul bl			;multiplicar por 10(bl) para las decenas
	mov num2, al	;se guarda en variable num2
	
	mov ah, 01h		;Leer segundo caracter
	int 21h			
		
	sub al, 30h		;resto 30h para obtener numero real
	add num2, al	;se guarda en variable num2
			
	; Multiplicacion
	; Asignar contador
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	mov cl, num1
	mov dx, cx	 ;Veces en las que se repetira el ciclo
	
	xor cx, cx
	mov cl, num2 ;Valor que se sumara repetidamente
	
	;Multiplicacion
	Multiplicar:
		cmp dx, 00h		; Evaluar si contador es cero
		jle Imprimir
		add bx, cx		; Sumar num2, num1 veces
		sub dx, 01h		; Disminuir contador
		jmp Multiplicar	; Repetir
		
		
	;Imprimir Resultado
	Imprimir:
	mov ah, 02		;Para cambiar de linea
	mov dl, 0AH
	int 21h
		
	MOV DX, OFFSET sResultado	;Imprimir Instruccion
	MOV AH, 09H	
	INT 21H	
	
	Evaluar:
		cmp bx, 09d				; Vefificar si el numero es de 1 digito o no
		jle UnDigitoProd		;Es un digito
		cmp bx, 99d
		jle DosDigitosProd		;Son dos digitos
		cmp bx, 999d
		jle TresDigitosProd		;Son tres digitos
		jmp CuatroDigitos		;Son cuatro digitos
		
		UnDigito:
		mov ah, 02h				; Parametro de interrupcion para imprimir un caracter
		mov dl, contador1		; imprimir decenas
		add dl, 30h				; Representacion ASCII
		int 21h
		UnDigitoProd:
		mov dx, bx				; Asignando digito a imprimir (unidad)
		add dx, 30h				; Representacion ASCII
		mov ah, 02h	
		int 21h
		jmp Final
		
		DosDigitos:
		mov ah, 02h				; Parametro de interrupcion para imprimir un caracter
		mov dl, contador2		; imprimir centenas
		add dl, 30h				; Representacion ASCII
		int 21h
		DosDigitosProd:
		cmp bx, 09d
		jle UnDigito			; Saltar si es menor a un digito
		sub bx, 10d				; Quitarle un decena
		inc contador1			; Contar cuantas decenas quitamos
		jmp DosDigitosProd
		
		TresDigitos:
		mov ah, 02h				; Parametro de interrupcion para imprimir un caracter
		mov dl, contador3		; imprimir centenas
		add dl, 30h				; Representacion ASCII
		int 21h
		TresDigitosProd:
		cmp bx, 99d
		jle DosDigitos			; Saltar si tiene dos digitos
		sub bx, 100d			; Quitarle un centena
		inc contador2			; Contar cuantas decenas quitamos
		jmp TresDigitosProd
		
		CuatroDigitos:
		sub bx, 1000d				; Quitarle mil unidades
		inc contador3			; Contar cuantas decenas quitamos
		cmp bx, 999d
		jle TresDigitos
		jmp CuatroDigitos
			
	Final:
	
	;Salto de linea
	mov ah, 02
	mov dl, 0AH
	int 21h
	
	;	FINALIZACION DEL PROGRAMA
	mov ah, 4Ch
	int 21h

End programa
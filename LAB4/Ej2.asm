;Escribir un programa en lenguaje ensamblador que lea dos números desde el teclado y realice
;su división por medio de restas sucesivas, utilizando ciclos.

.model small
.data
	;Variables
	num1 db ?
	num2 db ?
	resultado dw 0
	residuo dw 0
	contador1 db 1 dup (0)
	contador2 db 1 dup (0)
	contador3 db 1 dup (0)
	;Strings
	sInstruccion1 db 'Ingrese num1: $'
	sInstruccion2 db 'Ingrese num2: $'
	sResultado1	  db 'Resultado: $'
	sResultado2	  db 'Residuo: $'
	sError		  db 'Error: Division por cero... $'
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
			
	; Division
	; Asignar contador
	xor cx, cx
	xor dx, dx
	xor bx, bx
	xor ax, ax
	
	mov cl, num1
	mov dx, cx	 ;Valor Numerador
	
	xor cx, cx
	mov cl, num1 ;Veces que se repite el ciclo
	mov al, num2
	
	mov residuo, cx ;Default
	
	;Division
	Division:
	sub dx, ax		;Quitarle un num2 a num1
	cmp dx, 00h
	jl ExitDiv
	add bx, 01h		;Aumentar cociente
	mov residuo, dx ;Guardar residuo
	loop Division
	ExitDiv:
	
	;Imprimir Resultado
	Imprimir:
	mov ah, 02		;Para cambiar de linea
	mov dl, 0AH
	int 21h
	
	;Evaluar error
	cmp num2, 00h
	je ErrorDivCero ;Division por cero
			
	MOV DX, OFFSET sResultado1	;Imprimir Instruccion
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
		jmp LResiduo
		
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
			
		ErrorDivCero:
		mov ah, 02		
		mov dl, 0AH
		int 21h
		
		MOV DX, OFFSET sError	
		MOV AH, 09H	
		INT 21H
		jmp Final
			
		LResiduo:
		;Evaluar valor de residuo
		cmp residuo, 00h ;Ver si no se ha impreso antes
		je Final
		
		;Imprimir en pantalla info
		mov ah, 02		
		mov dl, 0AH
		int 21h
		
		xor bx, bx
		mov bx, residuo  ;Guardar para imprimir
		mov residuo, 00h ;Limpiar valor
		
		MOV DX, OFFSET sResultado2	
		MOV AH, 09H	
		INT 21H
		
		jmp Evaluar
	
	Final:
	
	;Salto de linea
	mov ah, 02
	mov dl, 0AH
	int 21h
	
	;	FINALIZACION DEL PROGRAMA
	mov ah, 4Ch
	int 21h

End programa
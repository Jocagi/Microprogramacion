;Escribir un programa en lenguaje ensamblador que ingresando un número de dos dígitos
;imprima todos sus factores utilizando ciclos. 

.model small
.data
	;Variables
	num1 db ?
	contador1 db 1 dup (0)
	;Strings
	sInstruccion1 db 'Ingrese un numero: $'
	sResultado	  db 'Factores: $'
	sComa		  db ','
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
	
	;Imprimir Resultado
	mov ah, 02		;Para cambiar de linea
	mov dl, 0AH
	int 21h
		
	MOV DX, OFFSET sResultado	;Imprimir Instruccion
	MOV AH, 09H	
	INT 21H	
	
	; Factorizacion
	; Asignar contador
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	;Veces en las que se repetira el ciclo
	mov cl, num1
	jmp FACTOR
	
	;Multiplicacion
	LOOP_FACTOR:
		
		;Imprimir coma
		COMA:
		mov dl, 2Ch
		mov ah, 02h
		int 21h
		
		;Calcular siguiente factor
		FACTOR:
		;limpiar
		xor ax, ax
		xor bx, bx
		mov contador1, 0h
		
		mov al, num1
		mov dx, cx 		;Asignar valor actual
		div dl			;num / contador
		cmp ah, 00h 	;Se evalua si hay residuo
		jne No_Imprimir ;Si hay residuo, no es factor
		Imprimir:
		mov bx, cx		;Se imprime el valor actual del contador
		
			cmp bx, 09h				; Vefificar si el numero es de 1 digito o no
			jle UnDigitoProd		;Es un digito
			jmp DosDigitosProd		;Son dos digitos
			
			UnDigito:
			xor dx, dx
			mov ah, 02h				; Parametro de interrupcion para imprimir un caracter
			mov dl, contador1		; imprimir decenas
			add dl, 30h				; Representacion ASCII
			int 21h
			UnDigitoProd:
			mov dx, bx				; Asignando digito a imprimir (unidad)
			add dx, 30h				; Representacion ASCII
			mov ah, 02h	
			int 21h
			jmp Fin_Imprimir
			DosDigitosProd:
			cmp bx, 09d
			jle UnDigito			; Saltar si es menor a un digito
			sub bx, 10d				; Quitarle un decena
			inc contador1			; Contar cuantas decenas quitamos
			jmp DosDigitosProd
			
		No_Imprimir:
		loop FACTOR
		
		Fin_Imprimir:
	loop LOOP_FACTOR
		
	Final:
	;Salto de linea
	mov ah, 02
	mov dl, 0AH
	int 21h
	
	;	FINALIZACION DEL PROGRAMA
	mov ah, 4Ch
	int 21h

End programa
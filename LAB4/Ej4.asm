;Escribir un programa en lenguaje ensamblador que convierta un número de 2 dígitos a su
;equivalente en binario utilizando saltos. 

.model small
.data
	;Variables
	num1 db ?
	;Strings
	sInstruccion1 db 'Ingrese un numero: $'
	sResultado	  db 'Binario: $'
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
	
	; Binario
	; Asignar Valores
	xor cx, cx
	xor dx, dx
	xor bx, bx
	
	;Valor del numero
	mov bl, num1
	;Define veces en las que se repete el ciclo
	mov cl, 1000000b ;1000000b
	
	;Obtener numero binario
	Binario:
	
	cmp bl, cl ;Comprobar si el bit a evaluar existe
	jge UNO	   ;(Si es mas grande, si esta presente el bit)
	jmp CERO
	
		UNO:
		;Imprimir uno
		mov dl, 31h
		mov ah, 02h
		int 21h
		
		sub bl, cl ;Eliminar bit evaluado
		jmp Next
		
		CERO:
		;Imprimir cero
		mov dl, 30h
		mov ah, 02h
		int 21h
		
	Next:
	shr cl, 1	;Desplazamiento de bits
	cmp cl, 00h
	jne Binario
		
	Final:
	;Salto de linea
	mov ah, 02
	mov dl, 0AH
	int 21h
	
	;	FINALIZACION DEL PROGRAMA
	mov ah, 4Ch
	int 21h

End programa
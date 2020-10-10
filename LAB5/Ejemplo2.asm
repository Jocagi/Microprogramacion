.model small
.data
	cadena DB 100 DUP (24h)
	cadena1 DB ?
.code
.stack
Program:		
	;	Iniciar programa
	mov ax, @DATA	
	mov ds, ax
	
	;	Logica general
	lecturaDeCadena:
		; Realizar llamadas
		call llenarCadena
		call imprimirCadena
		jmp Final
	
	;	Definicion de procedimientos
	capturarCaracter PROC NEAR
		xor ax, ax
		mov ah, 01h			;Obtener caracter de consola
		int 21h				;Ejecutar
	RET
	capturarCaracter ENDP
	
	llenarCadena PROC NEAR
	; Inicializar el indice con la cadena
	lea di, cadena
	Leer:
		cmp al, 0Dh			;Comparar si fue ENTER
		je TerminarLectura
		call capturarCaracter
		mov [di], al
		inc di
		jmp Leer
	TerminarLectura:
		;mov bl, 24h
		;mov [di], bl
	RET
	llenarCadena ENDP
	
	imprimirCadena PROC NEAR
		xor dx, dx
		mov ah, 02h				;Imprimir caracter
		mov dl, 0Ah
		int 21h
		xor dx, dx
		mov ah, 09h				;Imprimir cadena
		mov dx, offset cadena
		int 21h
	RET
	imprimirCadena ENDP
	
	Final:
	;	Finaliza el programa
	mov ah, 4Ch
	int 21h
End Program

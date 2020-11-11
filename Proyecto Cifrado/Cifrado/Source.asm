.386
.MODEL flat,stdcall 
;Options
option casemap:none 
;Includes
INCLUDE \masm32\include\kernel32.inc  
INCLUDE \masm32\include\masm32.inc
INCLUDELIB \masm32\lib\kernel32.lib   
INCLUDELIB \masm32\lib\masm32.lib
.DATA 
;Strings
	sValorMatriz DB 10,13,10,13,"Los valores en la matriz son: ",10,13,0
	sErrorValor DB 10,13,"Error. Entrada Invalida.",10,13,0
	sSalto DB 10,13,0
	sEspacio DB " ",0
	;Data
	sInput DB 10 DUP(0)
	sResultado DB 10 DUP(0)
	buffer DB 0
	intValue DW 0
	value DB 0,0
	saludo DB "Hola Mundo!!!", 0
	;Operacioens de matriz
	valueABC DB "ZABCDEFGHIJKLMNOPQRSTUVWXY",0
	MatrizABC DB 677 DUP(0)
	filas DW 26
	columnas DW 26
	actualValue DB 255
	i DW 0
	j DW 0
.CODE
PROGRAM:
	INVOKE StdOut, ADDR saludo 
	CALL LlenarMatriz
	CALL ImprimirMatriz
	;Finalizar
	INVOKE ExitProcess, 0

;----------------------Procedimientos----------------------
;Limpia todos los registros
Limpiar PROC NEAR 
        XOR EAX, EAX
		XOR EBX, EBX
		XOR ECX, ECX
		XOR EDX, EDX
RET 
Limpiar ENDP

;Imprime los valores de la matriz
ImprimirMatriz PROC NEAR 
	INVOKE StdOut, ADDR sValorMatriz
	LEA EDI, MatrizABC
	InicioImprimir:
	INVOKE StdOut, ADDR sSalto
	CALL Limpiar
	MOV i, AX
	MOV j, AX
		;Evaluar cada una de las filas
		InicioImprimirFila:
			;Comprobar si se ha llegado al final de la matriz
			CALL Limpiar
			MOV BX, filas
			CMP i, BX
			JE FinImprimirFila
			;Evaluar cada una de las columnas
			InicioImprimirColumnas:
				;Comprobar si se ha llegado al final de la fila
				CALL Limpiar
				MOV BX, columnas
				CMP j, BX
				JE FinImprimirColumnas
				;Imprimir valor				
				LEA ESI, value
				MOV AL, [EDI]
				MOV [ESI], AL 
				INVOKE StdOut, ADDR value
				INVOKE StdOut, ADDR sEspacio
				;Moverse a siguiente columna
				INC EDI
				INC j
				JMP InicioImprimirColumnas
			FinImprimirColumnas:
			;Moverse a siguiente fila
			INC i
			MOV CX, 0
			MOV j, CX
			INVOKE StdOut, ADDR sSalto
			JMP InicioImprimirFila
		FinImprimirFila:
	FinImprimir:
RET 
ImprimirMatriz ENDP

;Llena la matriz con valores del abecedario
LlenarMatriz PROC NEAR
	LEA EDI, MatrizABC
	InicioLlenado:
		;Evaluar cada una de las filas
		InicioLlenarFila:
			;Comprobar si se ha llegado al final de la matriz
			CALL Limpiar
			MOV BX, filas
			CMP i, BX
			JE FinLlenarFila
			;Recibir valores del usuario
			CALL ShiftABC
			LEA ESI, valueABC
			;Evaluar cada una de las columnas
			InicioLlenarColumnas:
				;Comprobar si se ha llegado al final de la fila
				CALL Limpiar
				MOV BX, columnas
				CMP j, BX
				JE FinLlenarColumnas
				;Agregar siguiente valor
				MOV AL, [ESI]
				MOV [EDI], AL
				;Moverse a siguiente columna
				INC EDI
				INC ESI
				INC j
				JMP InicioLlenarColumnas
			FinLlenarColumnas:
			;Moverse a siguiente fila
			INC i
			MOV CX, 0
			MOV j, CX
			JMP InicioLlenarFila
		FinLlenarFila:
	FinLlenado:
RET 
LlenarMatriz ENDP

; Corre todos los caracteres de un string a la izquierda e inserta la primera letra al final
ShiftABC PROC NEAR
	CALL Limpiar
	LEA ESI, valueABC
	MOV DL, [ESI]	; Valor a agregar al final
	Mover:
	XOR AX, AX
	XOR BX, BX
	MOV BL, [ESI+1]	; Almacenar valor siguiente
	MOV [ESI], BL	; Colocar valor siguiente en posicion actual
	MOV BL, 00h
	MOV AL, [ESI]
	INC ESI
	CMP AL, BL		; Comprobar si se ha llegado al final de la cadena
	JNE Mover
	FinMover:
	MOV [ESI-1], DL	; Asignar ultimo valor
RET
ShiftABC ENDP

;Se genera el siguiente valor de la matriz
SiguienteValor PROC NEAR 
	INC actualValue
RET 
SiguienteValor ENDP

LimpiarsResultado PROC NEAR
    CALL Limpiar
    MOV EBX, 0
    LEA ESI, sResultado
    InicioLimpiarString:
        MOV [ESI], BL
        INC ESI
        CMP [ESI], BL
        JNE InicioLimpiarString
    FinLimpiarString:
RET
LimpiarsResultado ENDP

IntToString PROC NEAR ;Convierte el valor de la variable resultado en String
		CALL LimpiarsResultado
		CALL Limpiar
		;Leer input
		lea esi, sResultado	
		mov BX, intValue

		;Comparar valores
		;cmp bx, 09d				; Verificar si el numero es de 1 digito o no
		;jle UnDigitoProd		; Es un digito
		cmp bx, 99d				; Vefificar si el numero es de 2 digitos
		jle DosDigitosProd		; Son dos digitos
		cmp bx, 999d			; Vefificar si el numero es de 3 digitos
		jle TresDigitosProd		; Son dos digitos
		jmp CuatroDigitosProd	; Son tres digitos
		
		UnDigito:
		mov [esi], cl			; Mover cantidad de decenas
        MOV al, 30h
        ADD [esi], eax          ; Valor ASCII
		inc esi					; Mover posicion en cadena
		UnDigitoProd:
		mov [esi], bl			; Asignar valor del ultimo digito
        MOV al, 30h
        ADD [esi], eax          ; Valor ASCII
		jmp FinIntString
		
		DosDigitos:
		mov [esi], cl			; Mover cantidad de centenas
        MOV al, 30h
        ADD [esi], eax          ; Valor ASCII
		inc esi					; Mover posicion en cadena
		xor cl, cl				; Limpiar contador
		DosDigitosProd:
		cmp BX, 09d
		jbe UnDigito			; Saltar si le queda solo un digito
		sub BX, 10d				; Quitarle un decena
		inc cl					; Contar cuantas decenas quitamos
		jmp DosDigitosProd		; Reiniciar ciclo
		
		TresDigitos:
		mov [esi], cl			; Mover cantidad de centenas
        MOV al, 30h
        ADD [esi], eax          ; Valor ASCII
		inc esi					; Mover posicion en cadena
		xor cl, cl				; Limpiar contador
		TresDigitosProd:
		cmp BX, 99d
		jbe DosDigitos			; Saltar si tiene dos digitos
		sub BX, 100d			; Quitarle un centena
		inc cl					; Contar cuantas decenas quitamos
		jmp TresDigitosProd		; Reiniciar ciclo

		CuatroDigitosProd:
		cmp BX, 999d
		jbe TresDigitos			; Saltar si tiene dos digitos
		sub BX, 1000d			; Quitarle un millar
		inc cl					; Contar cuantos millares quitamos
		jmp CuatroDigitosProd	; Reiniciar ciclo
		
		FinIntString:
	RET
IntToString ENDP

END PROGRAM
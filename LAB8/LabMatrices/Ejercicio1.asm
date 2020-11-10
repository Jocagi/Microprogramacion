;Multiplicacion
Multiplicar MACRO n1, n2, producto
    CALL Limpiar
    MOV AX, n1
    MUL n2
    MOV producto, AX
ENDM

;Programa
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
	sValorFila DB 10,13,"Ingrese cantidad de filas: ",0
	sValorColumna DB 10,13,"Ingrese cantidad de columnas: ",0
	sTamanioMatriz DB 10,13,"La matriz tiene un tamaño de: ",0
	sValorMatriz DB 10,13,"Los valores en la matriz son: ",10,13,0
	sError DB 10,13,"Error. Tamaño de matriz demasiado grande.",10,13,0
	sErrorValor DB 10,13,"Error. Entrada Invalida.",10,13,0
	sSalto DB 10,13,0
	sEspacio DB " ",0
	;Data
	matriz DB 9802 DUP(0)
	sInput DB 10 DUP(0)
	sResultado DB 10 DUP(0)
	filas DW 0
	columnas DW 0
	buffer DB 0
	intValue DW 0
	actualValue DB 255
	posicion DB 0
	value DB 0
	i DW 0
	j DW 0
.CODE
PROGRAM:
	Inicio:
		CALL LeerDatos
		CALL LlenarMatriz
		CALL ImprimirMatriz
		JMP Fin
		ErrorTamanio:
			INVOKE StdOut, ADDR sError
	Fin:
	;Finalizar
	INVOKE ExitProcess, 0

ImprimirMatriz PROC NEAR ;Imprime los valores de la matriz
	INVOKE StdOut, ADDR sValorMatriz
	LEA EDI, matriz
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
				MOV AL, [EDI]
				MOV intValue, AX
				CALL IntToString
				INVOKE StdOut, ADDR sResultado
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

LlenarMatriz PROC NEAR ;Llena la matriz con valores
	LEA ESI, matriz
	InicioLlenado:
		;Evaluar cada una de las filas
		InicioLlenarFila:
			;Comprobar si se ha llegado al final de la matriz
			CALL Limpiar
			MOV BX, filas
			CMP i, BX
			JE FinLlenarFila
			;Evaluar cada una de las columnas
			InicioLlenarColumnas:
				;Comprobar si se ha llegado al final de la fila
				CALL Limpiar
				MOV BX, columnas
				CMP j, BX
				JE FinLlenarColumnas
				;Agregar siguiente valor
				CALL SiguienteValor
				MOV AL, actualValue
				MOV [ESI], AL
				;Moverse a siguiente columna
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

SiguienteValor PROC NEAR ;Se genera el siguiente valor de la matriz
	INC actualValue
RET 
SiguienteValor ENDP

Limpiar PROC NEAR ;Limpia todos los registros
        XOR EAX, EAX
		XOR EBX, EBX
		XOR ECX, ECX
		XOR EDX, EDX
RET 
Limpiar ENDP

LeerDatos PROC NEAR ;Lee cantidad de filas y de columnas
    ;Ingresar filas
	INVOKE StdOut, ADDR sValorFila
	INVOKE StdIn, ADDR sInput, 10  
	CALL StringToInt
	CALL Limpiar
	MOV BX, intValue
	MOV filas, BX
	;Ingresar columnas
	INVOKE StdOut, ADDR sValorColumna
	INVOKE StdIn, ADDR sInput, 10  
	CALL StringToInt
	CALL Limpiar
	MOV BX, intValue
	MOV columnas, BX
	;Imprimir tamaño de matriz
	Multiplicar filas, columnas, intValue
	CALL IntToString
	INVOKE StdOut, ADDR sTamanioMatriz
	INVOKE StdOut, ADDR sResultado
	;Validar tamaño
	CMP intValue, 100d
	JA ErrorTamanio
RET 
LeerDatos ENDP

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

StringToInt PROC NEAR ;Convierte el valor de la cadena input, en un entero (Maximo 2 digitos)
		InicioLeer:
		    CALL Limpiar

		    MOV intValue, 0
		    MOV buffer, 0
		    MOV BL, 0Ah			
		
            LEA ESI, sInput

		    ;Digito 1
		    ;Validar Fin de cadena
            MOV AL, [ESI]
		    CMP AL, 00h		
		    JE FinLeer
		    ;	Validar valor incorrecto
		    SUB AL, 30h			;Obtener valor real
		    MOV DL, AL
		    CMP DL, 09h			;Validar si es mayor a 9
		    JG ErrorLeer
		    CMP DL, 0h			;Validar si es menor a 0
		    JL ErrorLeer
		    XOR AH, AH
	        MOV buffer, AL		;Guardar valor		
		
		    ;	Digito 2
		    INC ESI			    ;Mover posicion en la cadena
		    ;	Validar Fn de cadena
		    MOV CL, [ESI]		;Guardar valor
            MOV AL, [ESI]		;Guardar valor
		    SUB CL, 30h			;Obtener valor real
		    CMP AL, 00h			;Validar Fin de cadena
		    je FinLeer
		    ;	Validar valor incorrecto
		    MOV DL, CL
		    CMP DL, 09h			;Validar si es mayor a 9
		    JG ErrorLeer
		    CMP DL, 00h			;Validar si es menor a 0
		    JL ErrorLeer
		    ;	Agregar digito
		    XOR AX, AX
		    MOV AL, buffer
		    MUL BX				;Multiplicar valor anterior de buffer por 10
		    MOV buffer, AL
		    ADD buffer, CL		;Sumar al valor anterior		
		
		    ;Terminar
		    jmp FinLeer

		ErrorLeer:
			INVOKE StdOut, ADDR sErrorValor
			JMP Inicio	        ;Volver al inicio
		
		FinLeer:
		    XOR AX, AX 
		    MOV AL, buffer
		    MOV intValue, AX    ;Guardar valor
RET
StringToInt ENDP

END PROGRAM
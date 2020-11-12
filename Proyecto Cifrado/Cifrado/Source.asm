.386
.MODEL flat,stdcall 
;Options
option casemap:none 
;Includes
INCLUDE External.inc
INCLUDE \masm32\include\kernel32.inc  
INCLUDE \masm32\include\masm32.inc
INCLUDELIB \masm32\lib\kernel32.lib   
INCLUDELIB \masm32\lib\masm32.lib
.DATA 
	;Strings
	sMensaje DB 10,13,"Ingrese el mensaje: ",0
	sClave DB 10,13,"Ingrese la clave: ",0
	sValorMatriz DB 10,13,10,13,"Los valores en la matriz son: ",10,13,0
	sErrorValor DB 10,13,"Error. Entrada Invalida.",10,13,0
	sSalto DB 10,13,0
	sEspacio DB " ",0
	;Data
	;Datos de Cifrado
	mensaje DB 100 DUP(0)
	clave DB 100 DUP(0)
	messageLength DB 0
	;Datos de operaciones
	sInput DB 100 DUP(0)
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
PROGRAM PROC NEAR
	
	ImprimirTexto saludo
	INVOKE SaludoPROC, ADDR saludo
	INVOKE StdOut, ADDR sMensaje
	INVOKE StdIn, ADDR mensaje, 99
	INVOKE StdOut, ADDR sClave
	INVOKE StdIn, ADDR clave, 99
	CALL LongitudMensaje
	CALL CompletarClaveMensaje
	INVOKE StdOut, ADDR sSalto
	INVOKE StdOut, ADDR clave
	CALL LlenarMatriz
	CALL ImprimirMatriz
	
	;Finalizar
	INVOKE ExitProcess, 0

PROGRAM ENDP

;----------------------Procedimientos----------------------
;Limpia todos los registros
Limpiar PROC NEAR 
        XOR EAX, EAX
		XOR EBX, EBX
		XOR ECX, ECX
		XOR EDX, EDX
RET 
Limpiar ENDP

;Si la clave es menor que el mensaje, se repite la clave hasta completar la longitud del mensaje
CompletarClaveRepetir PROC NEAR
	CALL Limpiar
	LEA ESI, clave
	LEA EDI, clave
	MOV CL, messageLength
	InicioCompletarClave:
		XOR BX, BX
		XOR AX, AX
		MOV AL, 00h
		CMP CL, AL		;Comprobar si se ha llegado al final
		JE FinMensaje
		MOV BL, [ESI]
		MOV AL, 0Ah
		CMP BL, AL		;Ignorar saltos de linea
		JE Llenar
		MOV AL, 00h
		CMP BL, AL		;Comprobar si la clave se ha quedado sin chars
		JNE SiguientePos
		Llenar:
		;Se comienza a repetir los valores de la clave
		MOV AL, [EDI]
		MOV [ESI], AL
		INC EDI
		MOV AL, 00h
		MOV BL, [EDI]	;Validar si es necesario repetir la clave otra vez
		CMP AL, BL
		JNE SiguientePos
		ReiniciarClave:
			LEA EDI, clave
		SiguientePos:
		DEC CL
		INC ESI
		JMP InicioCompletarClave
	FinMensaje:
RET
CompletarClaveRepetir ENDP

;Si la clave es menor que el mensaje, se repite la clave hasta completar la longitud del mensaje
CompletarClaveMensaje PROC NEAR
	CALL Limpiar
	LEA ESI, clave
	LEA EDI, mensaje
	MOV CL, messageLength
	InicioCompletarConMensaje:
		XOR BX, BX
		XOR AX, AX
		MOV AL, 00h
		CMP CL, AL		;Comprobar si se ha llegado al final
		JE FinCompletarMensaje
		MOV BL, [ESI]
		MOV AL, 0Ah
		CMP BL, AL		;Ignorar saltos de linea
		JE LlenarConMensaje
		MOV AL, 00h
		CMP BL, AL		;Comprobar si la clave se ha quedado sin chars
		JNE SiguienteChar
		LlenarConMensaje:
		;Se comienza a repetir los valores de la clave
		MOV AL, [EDI]
		MOV [ESI], AL
		INC EDI
		SiguienteChar:
		DEC CL
		INC ESI
		JMP InicioCompletarConMensaje
	FinCompletarMensaje:
RET
CompletarClaveMensaje ENDP

;Calcula la longitud del mensaje y lo guarda en (messageLength)
LongitudMensaje PROC NEAR
	LEA ESI, mensaje
	CALL Limpiar
	MOV messageLength, AL	;Limpiar variable
	SiguienteChar:
	INC messageLength
	INC ESI
	MOV BL, 00h
	MOV AL, [ESI] 
	CMP AL, BL
	JNE SiguienteChar
RET
LongitudMensaje ENDP

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

;Corre todos los caracteres de un string a la izquierda e inserta la primera letra al final
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

;Se limpia el array de resultado
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

;Convierte el valor de la variable resultado en String
IntToString PROC NEAR
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
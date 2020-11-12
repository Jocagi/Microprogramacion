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
	sMensaje DB 10,13,"Ingrese el mensaje: ",0
	sMensajeCifrado DB 10,13,"El mensaje cifrado es: ",0
	sClave DB 10,13,"Ingrese la clave: ",0
	sValorClave DB 10,13,"La clave a utilizar es: ",0
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
	sResultado DB 100 DUP(0)
	buffer DB 0
	intValue DW 0
	value DB 0,0
	saludo DB "Hola Mundo!!!", 0
	;Operaciones de matriz
	valueABC DB "ZABCDEFGHIJKLMNOPQRSTUVWXY",0
	MatrizABC DB 677 DUP(0)
	filas DW 26
	columnas DW 26
	i DB 0
	j DB 0
	;Operaciones de cifrado
	posicion DB 0
	charMensaje DB "P"
	charClave DB "J"
	actualValue DB 255, 0
.CODE
PROGRAM PROC NEAR
	
	INVOKE StdOut, ADDR saludo
	CALL Cifrar

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
	MOV i, AL
	MOV j, AL
		;Evaluar cada una de las filas
		InicioImprimirFila:
			;Comprobar si se ha llegado al final de la matriz
			CALL Limpiar
			MOV BX, filas
			CMP i, BL
			JE FinImprimirFila
			;Evaluar cada una de las columnas
			InicioImprimirColumnas:
				;Comprobar si se ha llegado al final de la fila
				CALL Limpiar
				MOV BX, columnas
				CMP j, BL
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
			MOV j, CL
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
			CMP i, BL
			JE FinLlenarFila
			;Recibir valores del usuario
			CALL ShiftABC
			LEA ESI, valueABC
			;Evaluar cada una de las columnas
			InicioLlenarColumnas:
				;Comprobar si se ha llegado al final de la fila
				CALL Limpiar
				MOV BX, columnas
				CMP j, BL
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
			MOV j, CL
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

;Buscar valor de fila para el cifrado
DefinirFila PROC NEAR
	XOR AX, AX
	MOV AL, charClave
	SUB AL, 40h
	DEC AL
	MOV i, AL
RET
DefinirFila ENDP

;Buscar valor de columna para el cifrado
DefinirColumna PROC NEAR
	XOR AX, AX
	MOV AL, charMensaje
	SUB AL, 40h
	DEC AL
	MOV j, AL
RET
DefinirColumna ENDP

;Buscar un valor [i,j] en la matriz
BuscarValor PROC NEAR
	CALL Limpiar
	LEA EDI, MatrizABC
	MOV AL, 26d			;Longitud de una fila
	MOV BL, i			;Valor de posicion de la fila
	MUL BL				;Posicionar en espacio de memoria correspondiente
	MOV CL, j			;Valor de posicion de la columna
	ADD AX, CX			;Posicionar en espacio de memoria correspondiente
	MOV DX, AX
	ADD EDI, EDX
	MOV AH, [EDI]
	MOV actualValue, AH
RET
BuscarValor ENDP

;Procedimiento para el cifrado
Cifrar PROC NEAR
	;Solicitar Informacion
	INVOKE StdOut, ADDR sMensaje
	INVOKE StdIn, ADDR mensaje, 99
	INVOKE StdOut, ADDR sClave
	INVOKE StdIn, ADDR clave, 99
	;Si la calve es mas pequeña que el mensaje, completarla
	CALL LongitudMensaje
	CALL CompletarClaveRepetir
	;Mostrar clave
	INVOKE StdOut, ADDR sValorClave
	INVOKE StdOut, ADDR clave
	;Crear matriz de cifrado
	CALL LlenarMatriz
	;Cifrar
	INVOKE StdOut, ADDR sMensajeCifrado
	CALL LimpiarsResultado
	MOV DL, 00h
	MOV posicion, DL		;Iniciar desde posicion cero
	InicioCifrado:
		;Columna de matriz
		CALL Limpiar
		LEA ESI, mensaje
		MOV DL, posicion
		MOV AL, [ESI+EDX]	;Acceder a valor actual en mensaje
		MOV charMensaje, AL
		CALL DefinirColumna
		;Fila de matriz
		CALL Limpiar
		LEA ESI, clave
		MOV DL, posicion
		MOV AL, [ESI+EDX]	;Acceder a valor actual en mensaje
		MOV charClave, AL
		CALL DefinirFila
		;Valor cifrado
		CALL BuscarValor
		INVOKE StdOut, ADDR actualValue
		;Siguiente valor
		MOV DL, posicion
		INC DL
		MOV posicion, DL
		MOV AL, messageLength
		CMP DL, AL
		JNE InicioCifrado
	FinCifrado:
RET
Cifrar ENDP

END PROGRAM
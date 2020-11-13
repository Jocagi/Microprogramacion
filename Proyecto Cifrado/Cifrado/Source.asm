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
	sTituloCifrado DB 10,13,10,13,"Cifrado:",10,13,0
	sTituloDescifrado DB 10,13,10,13,"Descifrado:",10,13,0
	sMensaje DB 10,13,"Ingrese el mensaje: ",0
	sMensajeCifrado DB 10,13,10,13,"El mensaje cifrado es: ",0
	sMensajeDescifrado DB 10,13,10,13,"El mensaje cifrado es: ",0
	sClave DB 10,13,"Ingrese la clave: ",0
	sValorClave DB 10,13,10,13,"La clave a utilizar es: ",0
	sValorMatriz DB 10,13,10,13,"Los valores en la matriz son: ",10,13,0
	sErrorValor DB 10,13,"Error. Entrada Invalida.",10,13,0
	sTipoCifrado DB 10,13,10,13,"Elija el tipo de cifrado:",10,13,0
	sCifradoOpcion1 DB 10,13,"1) Original (Repetir clave)",0
	sCifradoOpcion2 DB 10,13,"2) Variante (Toma mensaje)",0
	sElegir DB 10,13,10,13,"Opcion: ",0
	sSalto DB 10,13,0
	sEspacio DB " ",0
	;Data
	;Datos de Cifrado
	opcion DB 100 DUP(0)
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
	mensaje DB 500 DUP(0)
	clave DB 1000 DUP(0)
	messageLength DB 0
	passwordLength DB 0
	posicion DB 0
	charMensaje DB "P",0
	charClave DB "J",0
	actualValue DB 255, 0
.CODE
PROGRAM PROC NEAR
	
	INVOKE StdOut, ADDR saludo
	;Crear matriz de cifrado
	CALL LlenarMatriz
	;Operaciones
	CALL Cifrar
	CALL Descifrar

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
	SiguienteCharMSG:
	INC messageLength
	INC ESI
	MOV BL, 00h
	MOV AL, [ESI] 
	CMP AL, BL
	JNE SiguienteCharMSG
RET
LongitudMensaje ENDP

;Calcula la longitud del mensaje y lo guarda en (messageLength)
LongitudClave PROC NEAR
	LEA ESI, clave
	CALL Limpiar
	MOV passwordLength, AL	;Limpiar variable
	SiguienteCharClave:
	INC passwordLength
	INC ESI
	MOV BL, 00h
	MOV AL, [ESI] 
	CMP AL, BL
	JNE SiguienteCharClave
RET
LongitudClave ENDP

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

;Buscar valor de fila para el cifrado
DefinirFilaCifrado PROC NEAR
	XOR AX, AX
	MOV AL, charClave
	SUB AL, 40h
	DEC AL
	MOV i, AL
RET
DefinirFilaCifrado ENDP

;Buscar valor de columna para el cifrado
DefinirColumnaCifrado PROC NEAR
	XOR AX, AX
	MOV AL, charMensaje
	SUB AL, 40h
	DEC AL
	MOV j, AL
RET
DefinirColumnaCifrado ENDP

;Buscar valor de fila para el cifrado
DefinirFilaDescifrado PROC NEAR
	MOV AL, 00h
	MOV i, AL
RET
DefinirFilaDescifrado ENDP

;Buscar valor de columna para el cifrado
DefinirColumnaDescifrado PROC NEAR
	CALL Limpiar
	;Operacion
	;(("Z" - charClave) + (charCifrado - "A") + 1) % 26
	
	;("Z" - charClave) -> X
	MOV AL, "Z"
	MOV AH, charClave
	SUB AL, AH

	;(charCifrado - "A") -> Y
	MOV BL, charMensaje
	MOV BH, "A"
	SUB BL, BH

	;X + Y + 1 -> Z
	XOR AH, AH
	ADD AL, BL
	INC AL

	;Z % 26
	MOV BL, 26d
	DIV BL

	MOV j, AH
RET
DefinirColumnaDescifrado ENDP

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

;Reinicia la variable mensaje
LimpiarMensaje PROC NEAR
    CALL Limpiar
    MOV EBX, 0
    LEA ESI, mensaje
    InicioLimpiarMensaje:
        MOV [ESI], BL
        INC ESI
        CMP [ESI], BL
        JNE InicioLimpiarMensaje
    FinLimpiarMensaje:
RET
LimpiarMensaje ENDP

;Reinicia la variable clave
LimpiarClave PROC NEAR
    CALL Limpiar
    MOV EBX, 0
    LEA ESI, clave
    InicioLimpiarClave:
        MOV [ESI], BL
        INC ESI
        CMP [ESI], BL
        JNE InicioLimpiarClave
    FinLimpiarClave:
RET
LimpiarClave ENDP

;Limpia todas la variables para cifrado
LimpiarCifrado PROC NEAR
	CALL LimpiarClave
	CALL LimpiarMensaje
RET
LimpiarCifrado ENDP

;Procedimiento para el cifrado
Cifrar PROC NEAR
	CALL LimpiarCifrado
	;Presentacion
	INVOKE StdOut, ADDR sTituloCifrado
	;Solicitar Informacion
	INVOKE StdOut, ADDR sMensaje
	INVOKE StdIn, ADDR mensaje, 450
	INVOKE StdOut, ADDR sClave
	INVOKE StdIn, ADDR clave, 450
	;Elegir tipo de cifrado
	ElegirCifrado:
	INVOKE StdOut, ADDR sTipoCifrado
	INVOKE StdOut, ADDR sCifradoOpcion1
	INVOKE StdOut, ADDR sCifradoOpcion2
	INVOKE StdOut, ADDR sElegir
	INVOKE StdIn, ADDR opcion, 99
	;Comprobar opcion elegida
	MOV AL, opcion
	MOV BL, "1"
	CMP AL, BL
	JE Cifrado1
	MOV BL, "2"
	CMP AL, BL
	JE Cifrado2
	JMP ErrorOpcion
	Cifrado1:
		;Si la calve es mas pequeña que el mensaje, completarla
		CALL LongitudMensaje
		CALL CompletarClaveRepetir
		JMP ContinuacionCifrado
	Cifrado2:
		;Si la calve es mas pequeña que el mensaje, completarla
		CALL LongitudMensaje
		CALL CompletarClaveMensaje
		JMP ContinuacionCifrado
	ErrorOpcion:
		INVOKE StdOut, ADDR sErrorValor
		JMP ElegirCifrado
	ContinuacionCifrado:
	;Mostrar clave
	INVOKE StdOut, ADDR sValorClave
	INVOKE StdOut, ADDR clave
	;Cifrar
	INVOKE StdOut, ADDR sMensajeCifrado
	MOV DL, 00h
	MOV posicion, DL		;Iniciar desde posicion cero
	InicioCifrado:
		;Columna de matriz
		CALL Limpiar
		LEA ESI, mensaje
		MOV DL, posicion
		MOV AL, [ESI+EDX]	;Acceder a valor actual en mensaje
		MOV charMensaje, AL
		MOV BL, "A"
		CMP AL, BL			;Comparar si el simbolo se sale del rango (Menor a A)
		JB	CharInvalido
		MOV BL, "Z"
		CMP AL, BL			;Comparar si el simbolo se sale del rango (Mayor a Z)
		JA	CharInvalido
		CALL DefinirColumnaCifrado
		;Fila de matriz
		CALL Limpiar
		LEA ESI, clave
		MOV DL, posicion
		MOV AL, [ESI+EDX]	;Acceder a valor actual en mensaje
		MOV charClave, AL
		MOV BL, "A"
		CMP AL, BL			;Comparar si el simbolo se sale del rango (Menor a A)
		JB	CharInvalido
		MOV BL, "Z"
		CMP AL, BL			;Comparar si el simbolo se sale del rango (Mayor a Z)
		JA	CharInvalido
		CALL DefinirFilaCifrado
		;Valor cifrado
		CALL BuscarValor
		INVOKE StdOut, ADDR actualValue
		SiguientePosMSG:
		;Siguiente valor
		MOV DL, posicion
		INC DL
		MOV posicion, DL
		MOV AL, messageLength
		CMP DL, AL
		JNE InicioCifrado
		JMP FinCifrado
		;Si se introduce un ASCII diferente a una letra
		CharInvalido:
		INVOKE StdOut, ADDR charMensaje
		JMP SiguientePosMSG
	FinCifrado:
RET
Cifrar ENDP

;Procedimiento para el cifrado
Descifrar PROC NEAR
	CALL LimpiarCifrado
	;Presentacion
	INVOKE StdOut, ADDR sTituloDescifrado
	;Solicitar Informacion
	INVOKE StdOut, ADDR sMensaje
	INVOKE StdIn, ADDR mensaje, 450
	INVOKE StdOut, ADDR sClave
	INVOKE StdIn, ADDR clave, 450
	;Elegir tipo de cifrado
	ElegirDescifrado:
	INVOKE StdOut, ADDR sTipoCifrado
	INVOKE StdOut, ADDR sCifradoOpcion1
	INVOKE StdOut, ADDR sCifradoOpcion2
	INVOKE StdOut, ADDR sElegir
	INVOKE StdIn, ADDR opcion, 99
	;Comprobar opcion elegida
	MOV AL, opcion
	MOV BL, "1"
	CMP AL, BL
	JE Descifrado1
	MOV BL, "2"
	CMP AL, BL
	JE Descifrado2
	JMP ErrorOpcion1
	Descifrado1:
		;Si la clave es mas pequeña que el mensaje, completarla
		CALL LongitudMensaje
		CALL CompletarClaveRepetir
		CALL LongitudClave
		JMP ContinuacionDescifrado
	Descifrado2:
		;Si la calve es mas pequeña que el mensaje, completarla
		;(Esto se va a hacer mientras el mensaje se comienza a descifrar)
		CALL LongitudClave
		JMP ContinuacionDescifrado
	ErrorOpcion1:
		INVOKE StdOut, ADDR sErrorValor
		JMP ElegirDescifrado
	ContinuacionDescifrado:
	;Cifrar
	INVOKE StdOut, ADDR sMensajeDescifrado
	MOV DL, 00h
	MOV posicion, DL		;Iniciar desde posicion cero
	InicioDescifrado:
		;Columna de matriz
		CALL Limpiar
		LEA ESI, mensaje
		MOV DL, posicion
		MOV AL, [ESI+EDX]	;Acceder a valor actual en mensaje
		MOV charMensaje, AL
		MOV BL, "A"
		CMP AL, BL			;Comparar si el simbolo se sale del rango (Menor a A)
		JB	CharInvalidoDescifrado
		MOV BL, "Z"
		CMP AL, BL			;Comparar si el simbolo se sale del rango (Mayor a Z)
		JA	CharInvalidoDescifrado
		;Fila de matriz
		CALL Limpiar
		LEA ESI, clave
		MOV DL, posicion
		MOV AL, [ESI+EDX]	;Acceder a valor actual en mensaje
		MOV charClave, AL
		MOV BL, "A"
		CMP AL, BL			;Comparar si el simbolo se sale del rango (Menor a A)
		JB	CharInvalidoDescifrado
		MOV BL, "Z"
		CMP AL, BL			;Comparar si el simbolo se sale del rango (Mayor a Z)
		JA	CharInvalidoDescifrado
		;Definir fila y columna
		CALL DefinirFilaDescifrado
		CALL DefinirColumnaDescifrado
		;Valor cifrado
		CALL BuscarValor
		INVOKE StdOut, ADDR actualValue
		;Agregar valor descifrado al final de la clave
		CALL Limpiar
		MOV AL, passwordLength
		MOV BL, posicion
		ADD AL, BL
		MOV CL, actualValue
		MOV [ESI+EAX], CL
		SiguientePosMSGDescifrado:
		;Siguiente valor
		MOV DL, posicion
		INC DL
		MOV posicion, DL
		MOV AL, messageLength
		CMP DL, AL
		JNE InicioDescifrado
		JMP FinDescifrado
		;Si se introduce un ASCII diferente a una letra
		CharInvalidoDescifrado:
		INVOKE StdOut, ADDR charMensaje
		JMP SiguientePosMSGDescifrado
	FinDescifrado:
RET
Descifrar ENDP

END PROGRAM
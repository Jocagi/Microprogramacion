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
	sTitulo DB 10,13,10,13,"Menu Principal:",0
	sPrincipalOpcion1 DB 10,13,"1) Cifrado",0
	sPrincipalOpcion2 DB 10,13,"2) Descifrado",0
	sPrincipalOpcion3 DB 10,13,"3) Estadistica",0
	sPrincipalOpcion4 DB 10,13,"4) Salir",0
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
	charMensaje DB 0,0
	charClave DB 0,0
	actualValue DB 255, 0
	;Probabilidades
	five_instruction db "Ingrese el criptograma: ",0
	crypto_five	db 500 dup('$')
	count	db 0,0
	numbers	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	letters	db 41h,42h,43h,44h,45h,46h,47h,48h,49h,4Ah,4Bh,4Ch,4Dh,4Eh,4Fh,50h,51h,52h,53h,54h,55h,56h,57h,58h,59h,5Ah
	auxiliar		dd 0
	new_line        db 0Ah,0
	white_space       db 20h,0
	point_char db 2Eh,0
	units	db 0,0
	tens db 0,0
	hundreds db 0,0
	quotient db 0,0
	remainder db 0,0
	new_letter_print db 0,0
	message_five_part1 db "La letra ",0
	message_five_part2 db "tiene una probabilidad de ",0
	message_five_part3 db "por lo que ",0
	message_five_good db "se cree que puede ser la letra ",0
	message_five_bad db "no se a podido determinar que letra puede ser",0
	possible_text db "La palabra puede ser: ", 0
	main_tittle db "Menu Principal",0
	instruction1 db "1. Cifrar mensaje",0
	instruction2 db "2. Descifrar mensaje",0
	instruction3 db "3. Calculo de probabilidades",0
	instruction4 db "4. Salir del programa",0
	instruction5 db "Que desea hacer?: ",0
	option_input db 0,0
	invalid_main_option db " La opcion seleccionada es invalida",0

.CODE
PROGRAM PROC NEAR
	;Crear matriz de cifrado
	CALL LlenarMatriz

		; Main app loop
	main_loop:

		; Print menu
		invoke StdOut, addr main_tittle
		invoke StdOut, addr new_line
		invoke StdOut, addr instruction1
		invoke StdOut, addr new_line
		invoke StdOut, addr instruction2
		invoke StdOut, addr new_line
		invoke StdOut, addr instruction3
		invoke StdOut, addr new_line
		invoke StdOut, addr instruction4
		invoke StdOut, addr new_line
		invoke StdIn, addr option_input, 10
		invoke StdOut, addr new_line

		; Clean registers
		xor bx, bx
		mov bl, option_input

		; Check what to do
		cmp bl, 31h
		je option_1
		cmp bl, 32h
		je option_2
		cmp bl, 33h
		je option_3
		cmp bl, 39h
		je option_9
		cmp bl, 34h
		je exit_program
		
		; Invalid option
		invoke StdOut, addr invalid_main_option
		invoke StdOut, addr new_line
		invoke StdOut, addr new_line
		jmp main_loop

		; Option 1
		option_1:
			CALL Limpiar
			call Cifrar
			invoke StdOut, addr new_line
			invoke StdOut, addr new_line
			jmp main_loop

		; Option 1
		option_2:
			CALL Limpiar
			call Descifrar
			invoke StdOut, addr new_line
			invoke StdOut, addr new_line
			jmp main_loop

		; Option 3
		option_3:
			CALL Limpiar
			call init_probability
			invoke StdOut, addr new_line
			invoke StdOut, addr new_line
			jmp main_loop

		; Option 1
		option_9:
			CALL Limpiar
			call ImprimirMatriz
			invoke StdOut, addr new_line
			invoke StdOut, addr new_line
			jmp main_loop


		; Finish the program
		exit_program:
			invoke ExitProcess, 0

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

; Get the probabilities
init_probability proc near

		; Print instructions
		invoke StdOut, addr five_instruction
		invoke StdIn, addr crypto_five,499

		; Prepare data
		lea esi, crypto_five
		mov count,00h

		; Iterate through the string
		loop_string:

			; Init numbers data
			lea edi,numbers
			xor ebx,ebx
			xor ax,ax
			mov bl,[esi]

			; Check if finish
			cmp bl,al
			je finish_five

			; Check if letter is in range
			cmp bl,41h
			jl skip_letter
			cmp bl,5Ah
			jg skip_letter

			; Get the index of the array and add one
			sub bl,41h
			add edi,ebx
			mov eax,[edi]
			inc eax
			mov [edi],eax
			mov bl,[edi]
			inc count

			; Skip the letter
			skip_letter:
				inc esi
				jmp loop_string

		; Check if string was empty
		finish_five:
			mov bl,count
			cmp bl,00h
			je finish_five_proc
			call get_values
			call posibble_decrypt
			call reset_numbers

		; Finish the procedure
		finish_five_proc:
			ret

	init_probability endp

; Print the posibble message
posibble_decrypt proc near

		; Init reader
		invoke StdOut, addr new_line
		invoke StdOut, addr possible_text
		lea esi, crypto_five

		; Iterate through the string
		loop_string2:

			; Init numbers data
			lea edi,numbers
			xor ebx,ebx
			xor ax,ax
			xor cx, cx
			mov bl,[esi]

			; Check if finish
			cmp bl,al
			je finish_possible

			; Get the index of the array and the number
			sub bl,41h
			add edi,ebx
			mov ecx,[edi]

			; Calculate probability
			mov al,cl
			mov cl,64h
			mul cl
			mov cl,count
			div cl
			mov cl,al
			mov quotient,al
			mov remainder,ah
			call print_posibble_new_letter

			; Do it again
			inc esi
			jmp loop_string2

		; Finish procedure
		finish_possible:
			ret

	posibble_decrypt endp

; Get the values of the probability
get_values proc near

		lea esi,letters
		lea edi,numbers
		xor ax, ax
		xor bx, bx
		xor cx, cx

		; Loop the array
		values_loop:

			; Init variables
			xor ebx,ebx
			mov bl,[edi]
			mov cl,00h

			; Check if the letter is 0
			cmp bl,cl
			je dont_print_letter

			; Check if finish of array
			mov bl,[esi]
			cmp bl,41h
			jl finish_get_values

			; Print the letter
			invoke StdOut, addr message_five_part1
			mov edx,edi
			lea edi,auxiliar
			mov [edi],ebx
			mov edi,edx
			invoke StdOut, addr auxiliar
			invoke StdOut, addr white_space

			; Reset data
			xor bx,bx
			xor ax,ax
			xor cx, cx
			mov bl,[edi]

			; Calculate probability
			mov al,bl
			mov bl,64h
			mul bl
			mov bl,count
			div bl
			mov bl,al
			mov quotient,al
			mov remainder,ah

			; Print the result
			invoke StdOut, addr message_five_part2
			call print_probability

			; Print percentage sing
			mov bl,25h
			mov edx,edi
			lea edi,auxiliar
			mov [edi],ebx
			mov edi,edx
			invoke StdOut, addr auxiliar
			invoke StdOut, addr white_space

			; Reset data
			xor bx,bx
			xor ax,ax
			xor cx, cx
			mov bl,[edi]

			; Print the new letter
			invoke StdOut, addr message_five_part3
			call new_letter
			invoke StdOut, addr new_line

			; Dont print the letter and continue
			dont_print_letter:
				inc esi
				inc edi
				jmp values_loop

		; Finish the procedure
		finish_get_values:
			ret

	get_values endp

; Print the probability
print_probability proc near

		; Init data
		mov tens,00h

		; Check if number has tens
		cmp bl,09h
		jle print_number

		; Get the tens
		get_tens:

			cmp bl,0Ah
			jl print_number
			sub bl,0Ah
			inc tens
			jmp get_tens

		; Print the numbers
		print_number:
			add tens, 30h
			invoke StdOut, addr tens
			mov units,bl
			add units, 30h
			invoke StdOut, addr units

		; Print dont
		invoke StdOut, addr point_char

		; Init data for remainder
		mov hundreds, 00h
		mov tens,00h
		mov units,00h
		xor bx, bx
		mov bl, remainder

		; Check if remainder has hundreds
		cmp bl,63h
		jle check_for_tens

		; Get the hundreds
		get_hundreds_remainder:
			cmp bl,64h
			jl check_for_tens
			sub bl,64h
			inc hundreds
			jmp get_hundreds_remainder

		; Check if remainder has tens
		check_for_tens:
			cmp bl,09h
			jle print_remainder

		; Get the tens
		get_tens_remainder:
			cmp bl,0Ah
			jl print_remainder
			sub bl,0Ah
			inc tens
			jmp get_tens_remainder

		; Print the remainder
		print_remainder:

			; Check if units is okey
			mov units,bl
			cmp units, 09h
			jle print_result_remainder
			mov units, 00h

			print_result_remainder:
				add hundreds, 30h
				invoke StdOut, addr hundreds
				add tens, 30h
				invoke StdOut, addr tens
				add units, 30h
				invoke StdOut, addr units

		ret

	print_probability endp

; Print the posibble new letter 
print_posibble_new_letter proc near

		; Init data
		mov al, quotient
		mov bl, remainder

		; Check the quotient
		cmp al,00h
		je cero_print
		cmp al,01h
		je one_print
		cmp al,02h
		je two_print
		cmp al,03h
		je three_print
		cmp al, 04h
		je four_print
		cmp al, 05h
		je five_print
		cmp al, 06h
		je six_print
		cmp al, 07h
		je seven_print
		cmp al, 09h
		jle nine_print
		cmp al, 0Ch
		jle twelve_quotinet
		cmp al, 0Eh
		jle print2_e
		jmp print_unknown

		; Check if j f z or k
		cero_print:
			cmp bl, 0Ah
			jle print2_k
			cmp bl, 28h
			jle print2_z
			cmp bl, 32h
			jle print2_f
			cmp bl, 42h
			jle print2_j
			jmp print2_g

		; Check for y b h v or g
		one_print:
			cmp bl, 00h
			jle print2_g
			cmp bl, 01h
			jle print2_v
			cmp bl, 02h
			jle print2_h
			cmp bl, 05h
			jle print2_b
			cmp bl, 06h
			jle print2_y
			jmp print2_q

		; Check for m p or q
		two_print:
			cmp bl, 00h
			jle print2_q
			cmp bl, 14h
			jle print2_p
			cmp bl, 46h
			jle print2_m
			jmp print2_c

		; Check for t or c
		three_print:
			cmp bl, 3Ch
			jle print2_c
			cmp bl, 50h
			jle print2_t
			jmp print2_u

		; Check for u
		four_print:
			cmp bl, 50h
			jle print2_u
			jmp print2_d

		; Check for d l or i
		five_print:
			cmp bl, 1Eh
			jle print2_d
			cmp bl, 28h
			jle print2_l
			cmp bl, 32h
			jle print2_i
			jmp print2_r

		; Check for n or f
		six_print:
			cmp bl, 14h
			jle print2_r
			cmp bl, 3Ch
			jle print2_n
			jmp print2_s

		; Check for s
		seven_print:
			cmp bl, 07h
			jle print2_s
			jmp print2_o

		; Check for o
		nine_print:
			cmp al, 09h
			jl print2_o
			cmp bl, 5Ah
			jle print2_o
			jmp print2_a

		; Check for a
		twelve_quotinet:
			cmp al, 0Ch
			jl print2_a
			cmp bl, 14h
			jle print2_a
			jmp print2_e

		; Print the specific letter
		print2_a:
			mov new_letter_print, 41h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_b:
			mov new_letter_print, 42h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_c:
			mov new_letter_print, 43h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_d:
			mov new_letter_print, 44h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_e:
			mov new_letter_print, 45h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_f:
			mov new_letter_print, 46h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_g:
			mov new_letter_print, 47h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_h:
			mov new_letter_print, 48h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_i:
			mov new_letter_print, 49h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_j:
			mov new_letter_print, 4Ah
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_k:
			mov new_letter_print, 4Bh
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_l:
			mov new_letter_print, 4Ch
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_m:
			mov new_letter_print, 4Dh
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_n:
			mov new_letter_print, 4Eh
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_o:
			mov new_letter_print, 4Fh
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_p:
			mov new_letter_print, 50h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_q:
			mov new_letter_print, 51h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_r:
			mov new_letter_print, 52h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_s:
			mov new_letter_print, 53h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_t:
			mov new_letter_print, 54h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_u:
			mov new_letter_print, 55h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_v:
			mov new_letter_print, 56h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_w:
			mov new_letter_print, 57h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_x:
			mov new_letter_print, 58h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_y:
			mov new_letter_print, 59h
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		print2_z:
			mov new_letter_print, 5Ah
			invoke StdOut, addr new_letter_print
			jmp finish_print_new_letter

		; No probability match with letter
		print_unknown:
			mov new_letter_print, 3Fh
			invoke StdOut, addr new_letter_print

		; Finish the procedure
		finish_print_new_letter:
			ret

	print_posibble_new_letter endp

; Print the new letter
new_letter proc near

		; Init data
		mov al, quotient
		mov bl, remainder

		; Check the quotient
		cmp al,00h
		je cero_quotient
		cmp al,01h
		je one_quotient
		cmp al,02h
		je two_quotient
		cmp al,03h
		je three_quotient
		cmp al, 04h
		je four_quotient
		cmp al, 05h
		je five_quotient
		cmp al, 06h
		je six_quotient
		cmp al, 07h
		je seven_quotient
		cmp al, 09h
		jle nine_quotient
		cmp al, 0Ch
		jle twelve_quotinet
		cmp al, 0Eh
		jle print_e
		jmp print_none

		; Check if j f z or k
		cero_quotient:
			cmp bl, 0Ah
			jle print_k
			cmp bl, 28h
			jle print_z
			cmp bl, 32h
			jle print_f
			cmp bl, 42h
			jle print_j
			jmp print_g

		; Check for y b h v or g
		one_quotient:
			cmp bl, 00h
			jle print_g
			cmp bl, 01h
			jle print_v
			cmp bl, 02h
			jle print_h
			cmp bl, 05h
			jle print_b
			cmp bl, 06h
			jle print_y
			jmp print_q

		; Check for m p or q
		two_quotient:
			cmp bl, 00h
			jle print_q
			cmp bl, 14h
			jle print_p
			cmp bl, 46h
			jle print_m
			jmp print_c

		; Check for t or c
		three_quotient:
			cmp bl, 3Ch
			jle print_c
			cmp bl, 50h
			jle print_t
			jmp print_u

		; Check for u
		four_quotient:
			cmp bl, 50h
			jle print_u
			jmp print_d

		; Check for d l or i
		five_quotient:
			cmp bl, 1Eh
			jle print_d
			cmp bl, 28h
			jle print_l
			cmp bl, 32h
			jle print_i
			jmp print_r

		; Check for n or f
		six_quotient:
			cmp bl, 14h
			jle print_r
			cmp bl, 3Ch
			jle print_n
			jmp print_s

		; Check for s
		seven_quotient:
			cmp bl, 46h
			jle print_s
			jmp print_o

		; Check for o
		nine_quotient:
			cmp al, 09h
			jl print_o
			cmp bl, 5Ah
			jle print_o
			jmp print_a

		; Check for a
		twelve_quotinet:
			cmp al, 0Ch
			jl print_a
			cmp bl, 14h
			jle print_a
			jmp print_e

		; Print the specific letter
		print_a:
			mov new_letter_print, 41h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_b:
			mov new_letter_print, 42h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_c:
			mov new_letter_print, 43h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_d:
			mov new_letter_print, 44h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_e:
			mov new_letter_print, 45h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_f:
			mov new_letter_print, 46h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_g:
			mov new_letter_print, 47h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_h:
			mov new_letter_print, 48h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_i:
			mov new_letter_print, 49h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_j:
			mov new_letter_print, 4Ah
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_k:
			mov new_letter_print, 4Bh
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_l:
			mov new_letter_print, 4Ch
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_m:
			mov new_letter_print, 4Dh
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_n:
			mov new_letter_print, 4Eh
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_o:
			mov new_letter_print, 4Fh
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_p:
			mov new_letter_print, 50h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_q:
			mov new_letter_print, 51h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_r:
			mov new_letter_print, 52h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_s:
			mov new_letter_print, 53h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_t:
			mov new_letter_print, 54h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_u:
			mov new_letter_print, 55h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_v:
			mov new_letter_print, 56h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_w:
			mov new_letter_print, 57h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_x:
			mov new_letter_print, 58h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_y:
			mov new_letter_print, 59h
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		print_z:
			mov new_letter_print, 5Ah
			invoke StdOut, addr message_five_good
			invoke StdOut, addr new_letter_print
			jmp finish_new_letter

		; No probability match with letter
		print_none:
			invoke StdOut, addr message_five_bad

		; Finish the procedure
		finish_new_letter:
			ret

	new_letter endp

; Reset the numbers array to 0
reset_numbers proc near

		lea edi,numbers
		mov cl,00h
		mov bl,00h

		reset_loop:
			cmp cl,19h
			jg finish_reset
			mov [edi],bl
			inc cl
			inc edi
			jmp reset_loop

		finish_reset:
			ret

	reset_numbers endp

END PROGRAM
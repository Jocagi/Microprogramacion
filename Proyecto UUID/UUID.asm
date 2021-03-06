.model small					;Modelo small
.data
	; Generador de UUID
		;Variables para el numero aleatorio
		timespan DD	0				;Valor en milisegundos (Maximo 2 palabras)
		num1 DD 0					;Factor en multiplicacion
		num2 DD 0					;Factor en multiplicacion
		numS DD 0					;Sumando
		; Valores de la fecha
		TotalDays DW 0
		year DW 0
		month DB 0
		day DB 0
		hour DB 0
		minutes DB 0
		seconds DB 0
		miliseconds DW 0
		; Valores para numeros random
		seed DD 0
		random DB 0						;Valor aleatorio generado: Xn+1 = (aXn + c) mod m
		module DD 16384d				;Valor por el que se trunca el numero 
		; Valores para UUID
		UUIDCounter DW 1d				;Cantidad de UUID's a generar
		CharCounter DW 0d				;Recorrido en ciclo
		UUID DB 36 DUP ('0'), '$'		;Valor del UUID incluyendo guiones
	; Validador de UUID		
		contadorEvaluar db 0;
		cadenaTMP db 37 dup ('$')
	; General
		menuOpcion DB 0
	; Strings
		sMensajePrincipal 	DB 	0Ah,0Ah, 'Bienvenido a UUID Generator$'
		sPreguntaOpcion 	DB 	0Ah,0Ah, 'Elija una opcion: $'
		sOpcion1		 	DB 	0Ah,0Ah, '1. Generar un UUID$'
		sOpcion2		 	DB 		0Ah, '2. Generar varios UUIDs$'
		sOpcion3		 	DB 		0Ah, '3. Validar un UUID$'		
		sOpcion4		 	DB 		0Ah, '4. Salir$'		
		sInstruccionVarios	DB 	0Ah,0Ah, 'Introduzca la cantidad de UUIDs a generar: $'
		sErrorValor			DB 		0Ah, 'Error, valor no valido$'
		sMensaje1 db 13,10,13,10, 'Introducir la a cadena a evaluar: $'
		sMensaje2 db 13,10,13,10, 'La Cadena es correcta$'
		sMensaje3 db 13,10,13,10, 'La Cadena es incorrecta$'
		sMensaje4 db 13,10,13,10, 'La Cadena ingresada es:$'
.stack		
.386			
.code
Program:		

	Inicio:
	;	Inicio Programa
	mov ax, @DATA	
	mov ds, ax
	
	call Menu
	
	Final:
	;	Finalizacion del Programa
	mov ah, 4Ch
	int 21h

	; PROCEDIMIENTOS
	Menu PROC NEAR
		InicioMenu:
		;Imprimir cadenas
		call Limpiar
		mov ah, 09h				
		mov dx, offset sMensajePrincipal
		int 21h
		mov dx, offset sOpcion1
		int 21h
		mov dx, offset sOpcion2
		int 21h
		mov dx, offset sOpcion3
		int 21h
		mov dx, offset sOpcion4
		int 21h
		mov dx, offset sPreguntaOpcion
		int 21h
		
		;Leer valor
		xor ax, ax
		mov ah, 01h		
		int 21h			

		;Comparar opcion
		sub al, 30h		;Valor real
		cmp al, 01h		
		je Opcion1
		cmp al, 02h		
		je Opcion2
		cmp al, 03h		
		je Opcion3
		cmp al, 04h		
		je Opcion4
		
		ErrorOpcion:
			xor dx, dx
			mov ah, 09h				
			mov dx, offset sErrorValor
			int 21h
			jmp InicioMenu
		Opcion1:
			mov bl, 01h
			mov UUIDCounter, bx
			call GetManyUUID
			jmp InicioMenu
		Opcion2:
			call ContadorUUID
			call GetManyUUID
			jmp InicioMenu
		Opcion3:
			call ValidarUUID
			jmp InicioMenu
		Opcion4:
	RET
	Menu ENDP

	; Leer del teclado un numero y guardarlo en el contador
	ContadorUUID PROC NEAR
	InicioLeer:
		;Imprimir instrucciones
		mov dx, offset sInstruccionVarios
		mov ah, 09h
		int 21h
		
		call Limpiar
		
		mov UUIDCounter, 0h
		
		NuevoDigito:
		call Limpiar
		mov bl, 10d				;Para numeros de base 10
		mov ax, UUIDCounter
		mul bx					;Multiplicar valor anterior por 10
		mov UUIDCounter, ax
		;Leer 
		call Limpiar
		mov ah, 01h				;Interrupcion para leer
		int 21h
		;Validar Enter
		cmp al, 0Dh		
		je TeclaEnter
		;	Validar valor incorrecto
		xor ah,ah
		sub al, 30h				;Obtener valor real
		cmp al, 9h				;Validar si es mayor a 9
		jg ErrorNumero
		cmp al, 0h				;Validar si es menor a 0
		jl ErrorNumero
		add UUIDCounter, ax		;Guardar valor		
		jmp NuevoDigito
		TeclaEnter:
		call Limpiar
		mov bl, 10d				;Para numeros de base 10
		mov ax, UUIDCounter
		div bx					;Dividir valor anterior por 10
		mov UUIDCounter,ax		;Se conserva el cociente 
		jmp FinLeer
		
		ErrorNumero:
		xor dx, dx
		mov dx, offset sErrorValor
		mov ah, 09h
		int 21h
		FinLeer:		
	RET
	ContadorUUID ENDP

	; Obtener varios UUID's e imprimirlos en pantalla
	GetManyUUID PROC NEAR
		;Imprimir Salto de Linea
		xor dx, dx
		mov ah, 02h				
		mov dl, 0Ah
		int 21h
	InicioGetManyUUID:
		call Limpiar
		mov bx, UUIDCounter 
		cmp bx, 0d
		jbe FinGetManyUUID
		;Obtener UUID
		call GetUUID
		;Imprimir Salto de Linea
		xor dx, dx
		mov ah, 02h				
		mov dl, 0Ah
		int 21h
		;Imprimir cadena
		mov ah, 09h			
		mov dx, offset UUID
		int 21h
		;Decrementar contador
		xor bx, bx
		mov bx, UUIDCounter 
		dec bx
		mov UUIDCounter, bx
		;Esperar a que el usuario presione una tecla
		xor ax, ax
		mov ah, 01h			
		int 21h			
		;Repetir ciclo
		jmp InicioGetManyUUID
	FinGetManyUUID:
	RET
	GetManyUUID ENDP

	; Obtiene un UUID por medio de numeros aleatorios y se guarda en un string 
	; Ej: 82DC1366-6B6B-196A-9AE7-A84DE82DDA34
	; Condiciones:
	; [Contando desde 0] 
	; Las posiciones 8, 13, 18, 23 son guiones '-'
	; [Condicion 1] La posicion 14 deberá iniciar siempre con “1”
	; [Condicion 2] La posicion 19 deberá iniciar con un número aleatorio entre 8,9,A,B en hexadecimal.
	GetUUID PROC NEAR
		call Limpiar
		call GetSeed			;Generar primera semilla para numeros aleatorio
		mov dx, 0d
		mov CharCounter, dx			;Iniciar ciclo
		lea si, UUID			;Inicializando puntero
		
		NuevoNumero:
		mov dx, CharCounter			;Mover CharCounter a registro DL
		cmp CharCounter, 36d		;Comprobar si ha terminado el ciclo
		jge FinUUID
		
		; Comprobar condiciones especiales
		cmp dl, 8d		; Validar para guiones
		je Guiones
		cmp dl, 13d		; Validar para guiones
		je Guiones
		cmp dl, 18d		; Validar para guiones
		je Guiones
		cmp dl, 23d		; Validar para guiones
		je Guiones
		cmp dl, 8d		; Validar para guiones
		je Guiones
		cmp dl, 14d		; Validar Condicion 1
		je NumeroUno
		cmp dl, 19d		; Validar Condicion 2
		je NumeroEspecial
		
		NumeroNormal:
			call GetRandomNumber	;Obtener un numero entre 0-F
			call Limpiar
			mov bl, random
			jmp GuardarPosicion
		Guiones:
			mov bl, '-'
			jmp GuardarPosicion
		NumeroUno:
			mov bl, '1'
			jmp GuardarPosicion
		NumeroEspecial:
			call GetRandomNumber	;Obtener un numero aleatorio
			call Limpiar
			mov bl, 4d				; Obtener numero entre 8,9,A,B
			mov al, random			; Guardar el random actual en AX
			div bx 					; AX/BX -> cociente:AX, residuo:DX
			
			cmp dl, 00h		; Validar para valor 0
			je Numero8
			cmp dl, 01h		; Validar para valor 1
			je Numero9
			cmp dl, 02h		; Validar para valor 2
			je NumeroA
			cmp dl, 03h		; Validar para valor 3
			je NumeroB
			Numero8:
			mov bl, '8'
			jmp GuardarPosicion
			Numero9:
			mov bl, '9'
			jmp GuardarPosicion
			NumeroA:
			mov bl, 'A'
			jmp GuardarPosicion
			NumeroB:
			mov bl, 'B'
			jmp GuardarPosicion
			
		GuardarPosicion:
		mov [si], bl
		inc si
		inc CharCounter
		jmp NuevoNumero
	FinUUID:
	RET
	GetUUID ENDP

	;Obtener numero aleatorio
	GetRandomNumber PROC NEAR
		; Xn+1 = (aXn + c) mod m
		; a = 25173, c = 13849 		
		call Limpiar
		mov edx, seed
		mov eax, 25173d
		mov ecx, 13849d
		mul edx			;aXn
		add eax, ecx	;aXn + c		;EAX * 32bit = EDX EAX
		xor edx, edx
		mov ebx, module
		div ebx			; mod m
		shr eax,1		; Desechar el bit menos significativo
		mov seed, eax	; El numero se convierte en la nueva semilla
		xor bx, bx
		xor ax, ax
		mov bl, 16d		; Obtener numero entre [0-9][A-F]
		mov ax, dx		; Guardar el random actual en AX
		xor dx, dx
		div bx 			; AX/BX -> cociente:AX, residuo:DX
		
		cmp dl, 0Ah		; Validar para simbolo A
		je ValorA
		cmp dl, 0Bh		; Validar para simbolo B
		je ValorB
		cmp dl, 0Ch		; Validar para simbolo C
		je ValorC
		cmp dl, 0Dh		; Validar para simbolo D
		je ValorD
		cmp dl, 0Eh		; Validar para simbolo E
		je ValorE
		cmp dl, 0Fh		; Validar para simbolo F
		je ValorF
		
		Numero:
		add dl, 30h
		jmp GuardarRandom
		ValorA:
		mov dl, 'A'
		jmp GuardarRandom
		ValorB:
		mov dl, 'B'
		jmp GuardarRandom
		ValorC:
		mov dl, 'C'
		jmp GuardarRandom
		ValorD:
		mov dl, 'D'
		jmp GuardarRandom
		ValorE:
		mov dl, 'E'
		jmp GuardarRandom
		ValorF:
		mov dl, 'F'
		jmp GuardarRandom
		
		GuardarRandom:
		mov random, dl
	RET
	GetRandomNumber ENDP

	;Crea la primera semilla para la generacion de numeros aleatorios
	GetSeed PROC NEAR
		call GetTimeStamp
		call Limpiar
		mov eax, timespan		;Fijar timespan como primera semilla
		; First seed
		mov seed, eax
	RET
	GetSeed ENDP

	; Obtener milisegundos desde 1970
	GetTimeStamp PROC NEAR
		call Limpiar
		; Interrupcion para obtener la fecha
		; AL = día de la semana (Dom=0, Lun=1,….Sab=6), CX = año, DH = mes, DL = día
		mov ah, 2Ah
		int 21h
		; Guardar valor del año
		mov year, cx
		; Guardar valor del mes
		mov month, dh
		; Guardar valor del dia
		mov day, dl
		
		;Obtener dias por cada año
		call Limpiar
		mov ax, year
		mov bx, 1970d
		sub ax, bx			;Diferencia entre año actual y 1970
		mov cx, 365d
		mul cx				;365 dias en un año
		add TotalDays, ax	;Se suma a la cantidad de dias totales
		;Obtener dias por cada mes
		call Limpiar
		mov al, month
		mov bx, 30d
		mul bx				;30 dias en un mes
		add TotalDays, ax	;Se suma a la cantidad de dias totales
		;Sumar dias
		xor eax, eax
		mov al, day
		add TotalDays, ax	;Se suma a la cantidad de dias totales
		;Obtener milisegundos por dia
			;Milisegundos en un dia -> 86,400,000
			;Tamaño maximo de una palabra -> 65k
			;Los milisegundos por dia se diviven en multiples operaciones 86,400,000
		xor eax, eax
		mov ax, TotalDays
		mov num1, eax		;Primer valor de multiplicacion
		xor eax, eax
		mov eax, 86400000d	;Segundo valor [milisegundos]
		mov num2, eax
		call Multiplicacion	;Realiza multiplicacion y se suma a timespan
	
		; Interrupcion para obtener la hora
		; CH = hora, CL = minutos, DH = segundos y DL = centésimos de segundo.
		call Limpiar
		mov ah, 2Ch
		int 21h
		; Guardar valor de la hora
		mov hour, ch
		; Guardar valor de los minutos
		mov minutes, cl
		; Guardar valor de los segundos
		mov seconds, dh
		; Guardar valor de los milisegundos
		xor eax, eax
		mov al, 10
		mul dl		;Multiplicar centesimos de segundo por 10 para obtener milisegundos
		mov miliseconds, ax
		
		;Obtener milisegundos en cada hora
			;Milisegundos en una hora -> 3,600,000
		xor eax, eax
		mov al, hour
		mov num1, eax		;Primer valor de multiplicacion
		xor ax, ax
		mov eax, 3600000d	;Segundo valor [milisegundos]
		mov num2, eax
		call Multiplicacion	;Realiza multiplicacion y se suma a timespan
		;Obtener milisegundos en cada minuto
			;Milisegundos en cada minuto -> 60,000
		xor ax, ax
		mov al, minutes
		mov num1, eax		;Primer valor de multiplicacion
		xor eax, eax
		mov ax, 60000d		;Segundo factor [milisegundos]
		mov num2, eax
		call Multiplicacion	;Realiza multiplicacion y se suma a timespan
		;Obtener milisegundos en cada segundo
			;Milisegundos en cada segundo -> 1,000
		xor eax, eax
		mov al, seconds
		mov num1, eax		;Primer valor de multiplicacion
		xor eax, eax
		mov ax, 1000d		;Segundo valor [milisegundos]
		mov num2, eax
		call Multiplicacion	;Realiza multiplicacion y se suma a timespan
		;Sumar milisegundos
		xor eax, eax
		mov ax, miliseconds
		mov numS, eax
		call SumarTimeSpan
	RET
	GetTimeStamp ENDP

	; Multiplica dos numeros dados, y se suma a la variable timespan
	; Parametros: num1, num2 (numero)
	Multiplicacion PROC NEAR
		inc num1				;Para no ser afectado por el loop
		LoopMulti:
		call Limpiar
		dec num1				;Reducir contador en uno
		cmp num1, ecx			;Comprobar si se termina el ciclo (CX = 0)
		jbe FinMulti
		mov eax, num2
		mov numS, eax
		call SumarTimeSpan		;Sumar valores
		jmp LoopMulti			;Repetir
		FinMulti:
	RET
	Multiplicacion ENDP
	
	; Parametros: timespan, numS
	; El resultado se guarda en timespan
	SumarTimeSpan PROC NEAR
		InicioSuma:
			call Limpiar			;AX -> 0
			mov edx, numS			;Sumando
			add timespan, edx		;Operacion
		FinSuma:
	RET
	SumarTimeSpan ENDP
	
	Limpiar PROC NEAR
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
	RET
	Limpiar ENDP
	
	ValidarUUID PROC NEAR	
	;Imprimir primer variable
		MOV AH, 09h
		LEA DX, sMensaje1
		INT 21h

		XOR DX, DX 					;Limpiar registros
		XOR AX, AX 					;Limpiar registros
		MOV CX, 0d                
		MOV SI,0h 
				
	LeerCadena:
		; Inicializar el indice con la cadenaTMP
		LEA DI, cadenaTMP
		; realizar llamadas
		CALL LlenarCadena

	;Procedimientos
	capturarCaracter PROC NEAR
		XOR AX, AX
		INC CX
		MOV AH, 01h						; obtener caracter de consola
		INT 21h 						; Ejecuta la interrupcion
		RET
	capturarCaracter ENDP
		   
	LlenarCadena PROC NEAR   
	LeerTeclado:
		CMP CX, 36d							; Comparar si fue enter
		JE PrepararEvaluacion
		CALL CapturarCaracter
		MOV [DI], AL
		INC DI
		JMP LeerTeclado
	LlenarCadena ENDP
		
	ImprimirCadena PROC NEAR
		XOR DX, DX
		;Imprime salto de linea
		MOV AH, 02h 						; imprime caracter
		MOV DL, 0AH
		INT 21h
		;Imprime cadenaTMP
		XOR DX, DX 							; limpiar registro
		MOV AH, 09h
		MOV DX, offset cadenaTMP
		INT 21h
		RET
	ImprimirCadena ENDP

	PrepararEvaluacion:
		MOV CX, 0d
		MOV SI,0h 
		XOR DX, DX 					;Limpiar registros
		XOR AX, AX 					;Limpiar registros
		MOV AH, 09h
		LEA DX, sMensaje4
		INT 21h

		XOR DX, DX 					;Limpiar registros
		XOR AX, AX 					;Limpiar registros
		CAll ImprimirCadena
		MOV DL, 0Ah												
		MOV AH, 02h
		INT 21h
		XOR DX, DX 					;Limpiar registros
		XOR AX, AX 					;Limpiar registros
		MOV DI, 0d
		JMP EvaluarCadena
		
	EvaluarCadena:
		MOV AL, cadenaTMP[DI]
		INC DI
		INC CX
		CMP CX,09d
		JE ValidarGuion 
		CMP CX,14d
		JE ValidarGuion
		CMP CX, 15d
		JE EvaluarNUm1
		CMP CX,19d
		JE ValidarGuion
		CMP CX,20d
		JE SegundoGrupo
		CMP CX,24d
		JE ValidarGuion
		CMP CX,37d
		JL NumeroInicio
		JMP Aceptar
	NumeroInicio:	
		CMP AL, "0"
		JAE NumeroFInal
		JMP ErrorValor
	NumeroFInal:
		CMP AL, "9"
		JBE EvaluarCadena
		JMP LetraInicio
	LetraInicio:
		CMP AL, "A"
		JAE LetrFinal
		JMP ErrorValor
	LetrFinal:
		CMP AL, "F"
		JBE EvaluarCadena
		JMP ErrorValor
	ValidarGuion:
		CMP AL, "-"
		JE EvaluarCadena
		JMP ErrorValor
	SegundoGrupo:
		CMP AL, "A"
		JE EvaluarCadena
		CMP AL, "B"
		JE EvaluarCadena
		CMP AL, "8"
		JE EvaluarCadena
		CMP AL, "9"
		JE EvaluarCadena
		JMP ErrorValor
	EvaluarNUm1:
		CMP AL, "1"
		JE EvaluarCadena
		JMP ErrorValor
	ErrorValor:
		MOV AH, 09h
		LEA DX, sMensaje3
		INT 21h
		JMP FinalEvaluar
	Aceptar:
		MOV AH, 09h
		LEA DX, sMensaje2
		INT 21h
		JMP FinalEvaluar
	FinalEvaluar:
	RET
	ValidarUUID ENDP
	
End Program
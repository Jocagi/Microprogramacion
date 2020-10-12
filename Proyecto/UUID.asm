.model small					;Modelo small
.data
	;Variables para el numero aleatorio
	timespan DB 4 DUP (0), '$'	;Valor en milisegundos (Maximo 2 palabras)
	num1 DW 0					;Factor en multiplicacion
	num2 DW 0					;Factor en multiplicacion
	numS DW 0					;Sumando
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
	seed DB 0
	random DB 0						;Valor aleatorio generado: Xn+1 = (aXn + c) mod m
	module DW 32768d				;Valor por el que se trunca el numero 
	; Valores para UUID
	UUIDCounter DB 1d				;Cantidad de UUID's a generar
	CharCounter DW 0d				;Recorrido en ciclo
	UUID DB 36 DUP ('0'), '$'		;Valor del UUID incluyendo guiones
.stack					
.code
Program:		

	Inicio:
	;	Inicio Programa
	mov ax, @DATA	
	mov ds, ax
	
	call GetManyUUID
	
	Final:
	;	Finalizacion del Programa
	mov ah, 4Ch
	int 21h

	; Obtener varios UUID's e imprimirlos en pantalla
	GetManyUUID PROC NEAR
	InicioGetManyUUID:
		call Limpiar
		mov bl, UUIDCounter 
		cmp bl, 0d
		jbe FinGetManyUUID
		;Obtener UUID
		call GetUUID
		;Imprimir cadena
		mov ah, 09h			
		mov dx, offset UUID
		int 21h
		;Imprimir Salto de Linea
		xor dx, dx
		mov ah, 02h				
		mov dl, 0Ah
		int 21h
		;Decrementar contador
		xor bx, bx
		mov bl, UUIDCounter 
		dec bl
		mov UUIDCounter, bl
		jmp InicioGetManyUUID
	FinGetManyUUID:
	RET
	GetManyUUID ENDP

	; Obtiene un UUID por medio de numeros aleatorios y se guarda en un string 
	; Ej: 82dc1366-6b6b-496a-bae7-a84de82dda34
	; Condiciones:
	; [Contando desde 0] 
	; Las posiciones 8, 13, 18, 23 son guiones '-'
	; [Condicion 1] La posicion 14 deberá iniciar siempre con “1”
	; [Condicion 2] La posicion 19 deberá iniciar con un número aleatorio entre 8,9,A,B en hexadecimal.
	GetUUID PROC NEAR
		call Limpiar
		call GetSeed			;Generar primera semilla para numeroa aleatorio
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
		mov dl, seed
		mov ax, 25173d
		mov cx, 9d
		mul dx			;aXn
		add ax, cx		;aXn + c		
		xor dx, dx
		mov bx, module
		div bx			; mod m
		mov seed, dl	; El numero se convierte en la nueva semilla
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
		lea si, timespan
		mov ax, [si]		;Truncar solo a la primera posicion del tiempo
		; First seed
		mov seed, al
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
		mov day, cl
		
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
		xor ax, ax
		mov al, day
		add TotalDays, ax	;Se suma a la cantidad de dias totales
		;Obtener milisegundos por dia
			;Milisegundos en un dia -> 86,400,000
			;Tamaño maximo de una palabra -> 65k
			;Los milisegundos por dia se diviven en multiples operaciones 86,400,000 = 8640*10000
		xor ax, ax
		mov ax, TotalDays
		mov num1, ax		;Primer valor de multiplicacion
		xor ax, ax
		mov ax, 8640d		;Primer factor [milisegundos]
		mov num2, ax
		call Multiplicacion	;Realiza multiplicacion y se suma a timespan
		xor ax, ax
		mov ax, 10000d		;Segundo factor [milisegundos]
		mov num2, ax
		call Multiplicacion	;Realiza multiplicacion y se suma a timespan
		
		call Limpiar
		; Interrupcion para obtener la hora
		; CH = hora, CL = minutos, DH = segundos y DL = centésimos de segundo.
		mov ah, 2Ch
		int 21h
		; Guardar valor de la hora
		mov hour, ch
		; Guardar valor de los minutos
		mov minutes, cl
		; Guardar valor de los segundos
		mov seconds, dh
		; Guardar valor de los milisegundos
		xor ax, ax
		mov al, 10
		mul dl		;Multiplicar centesimos de segundo por 10 para obtener milisegundos
		mov miliseconds, ax
		
		;Obtener milisegundos en cada hora
			;Milisegundos en una hora -> 3,600,000 = 3600*1000
		xor ax, ax
		mov al, hour
		mov num1, ax		;Primer valor de multiplicacion
		xor ax, ax
		mov ax, 3600d		;Primer factor [milisegundos]
		mov num2, ax
		call Multiplicacion	;Realiza multiplicacion y se suma a timespan
		xor ax, ax
		mov ax, 1000d		;Segundo factor [milisegundos]
		mov num2, ax
		call Multiplicacion	;Realiza multiplicacion y se suma a timespan
		;Obtener milisegundos en cada minuto
			;Milisegundos en cada minuto -> 60,000
		xor ax, ax
		mov al, minutes
		mov num1, ax		;Primer valor de multiplicacion
		xor ax, ax
		mov ax, 60000d		;Segundo factor [milisegundos]
		mov num2, ax
		call Multiplicacion	;Realiza multiplicacion y se suma a timespan
		;Obtener milisegundos en cada segundo
			;Milisegundos en cada segundo -> 1,000
		xor ax, ax
		mov al, seconds
		mov num1, ax		;Primer valor de multiplicacion
		xor ax, ax
		mov ax, 1000d		;Segundo factor [milisegundos]
		mov num2, ax
		call Multiplicacion	;Realiza multiplicacion y se suma a timespan
		;Sumar milisegundos
		xor ax, ax
		mov ax, miliseconds
		mov numS, ax
		call SumarTimeSpan
	RET
	GetTimeStamp ENDP

	; Multiplica dos numeros dados, y se suma a la variable timespan
	; Parametros: num1, num2 (numero)
	Multiplicacion PROC NEAR
		inc num1				;Para no ser afectado por el loop
		LoopMulti:
		xor cx, cx
		xor ax, ax
		dec num1				;Reducir contador en uno
		mov cl, 0
		cmp num1, cx			;Comprobar si se termina el ciclo
		jbe FinMulti
		mov ax, num2
		mov numS, ax
		call SumarTimeSpan		;Sumar valores
		jmp LoopMulti			;Repetir
		FinMulti:
	RET
	Multiplicacion ENDP
	
	; Suma dos cadenas dadas, donde cada char representa un valor en base 10 (0 - 9)
	; Se asume que ambos tienen la misma longitud
	; Parametros: timespan, numS
	; El resultado se guarda en timespan
	SumarTimeSpan PROC NEAR
		;Inicializar apuntadores
		lea si, timespan			;Inicializando SI, en la primera posicion del timespan
		InicioSuma:
			xor bx, bx
			xor ax, ax
			mov al, 0				;Valor de comparacion
			mov bx, numS			;Mover valor del sumando a registro
			;Guardar valores en variable
			Guardar:
			dec bx					;Decrementar posicion actual
			cmp bx, ax				;Comparar si se ha terminado el proceso (Negativo)
			jl  FinSuma
			;Posicion 1
			xor cx, cx
			mov cl, [si]
			inc cl					;Incrementar el valor apuntado actual
			mov [si], cl
			cmp [si], al			;Comparar si ha ocurrido un overflow
			jne Guardar				;Si no ha ocurrido, repetir proceso				
			;Posicion 2
			xor cx, cx
			mov cl, [si+1]
			inc cl					
			mov [si+1], cl			;Incrementar el valor de la siguiente posicion (acarreo)
			cmp [si+1], al			;Comparar si ha ocurrido otro overflow
			jne Guardar				;Si no ha ocurrido, regresar al inicio
			;Posicion 3
			xor cx, cx
			mov cl, [si+2]
			inc cl					
			mov [si+2], cl			;Incrementar el valor de la siguiente posicion (acarreo)
			cmp [si+2], al			;Comparar si ha ocurrido otro overflow
			jne Guardar				;Si no ha ocurrido, regresar al inicio
			;Posicion 4
			xor cx, cx
			mov cl, [si+3]
			inc cl	
			mov [si+3], cl			;Incrementar el valor de la siguiente posicion (acarreo)
			jmp Guardar				;Regresar al inicio
		FinSuma:
	RET
	SumarTimeSpan ENDP
	
	Limpiar PROC NEAR
		xor ax, ax
		xor bx, bx
		xor cx, cx
		xor dx, dx
	RET
	Limpiar ENDP

End Program
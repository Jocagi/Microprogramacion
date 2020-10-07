;Crear un programa, utilizando procedimientos y cadenas realice el cálculo 
;del factorial de un número, el número mayor que puede ser ingresado es 128!.

.model small
.data
	;Variables para multiplicar
	num1 DB 300 DUP ('$')		
	num2 DB 300 DUP ('$')				
	;Variables de conteo
	buffer DW 0					;Buffer de lectura
	actualF DB 0			 	;Indice Factorial
	actualM DB 0 				;Indice Multiplicacion
	;Variables de usuario
	input DB ?					;Numero definido por el usuario
	;Utilidades
	carry DB 0					;Valor de acarreo en una operacion
	counter DW 0				;Variable para contar posiciones en la suma
	;Strings
	sBienvenida DB 0Ah, 'Calcular Factorial$'
	sLimitacion DB 0Ah, 'Ingrese un numero y presione ENTER$'
	sInstruccion DB 0Ah, 'Ingrese un numero: $'
	sResultado DB 0Ah, 'Resultado: $'
	sErrorVal DB 0Ah, 'Error: El valor de debe ser menor a 128...$'
	sErrorChar DB 0Ah, 'Error: Solo se permiten numeros...$'
.stack
.code
programa:		

	;	Inicio Programa
	mov ax, @DATA	
	mov ds, ax
	
	;Instrucciones
	mov dx, offset sBienvenida
	mov ah, 09h
	int 21h
	mov dx, offset sLimitacion
	int 21h
	
	;Leer y calcular
	call Leer
	call Factorial
	call TraducirCadena
	
	;Respuesta
	xor dx, dx
	mov dx, offset sResultado
	mov ah, 09h
	int 21h
	mov dx, offset num1
	int 21h

	Final:
	;	Finalizacion del Programa
	mov ah, 4Ch
	int 21h

	; Leer valor introducido del teclado
	Leer PROC NEAR	
		InicioLeer:
		;Imprimir instrucciones
		mov dx, offset sInstruccion
		mov ah, 09h
		int 21h
		
		xor ax, ax
		xor bx, bx
		xor dx, dx
		
		mov actualF, 0
		mov buffer, 0
		mov bl, 10d			
		
		;Digito 1
		mov ah, 01h			;Interrupcion para leer
		int 21h
		;Validar Enter
		cmp al, 0Dh		
		je FinLeer
		;	Validar valor incorrecto
		sub al, 30h			;Obtener valor real
		mov dl, al
		cmp dl, 9h			;Validar si es mayor a 9
		jg ErrorLeer
		cmp dl, 0h			;Validar si es menor a 0
		jl ErrorLeer
		xor ah, ah
		mov buffer, ax		;Guardar valor		
		
		;	Digito 2
		mov ah, 01h			;Interrupcion para leer
		int 21h
		;	Validar si se presiono Enter
		mov cl, al			;Guardar valor ingresado
		sub cl, 30h			;Obtener valor real ingresado
		cmp al, 0Dh			;Validar Enter
		je FinLeer
		;	Validar valor incorrecto
		mov dl, cl
		cmp dl, 9h			;Validar si es mayor a 9
		jg ErrorLeer
		cmp dl, 0h			;Validar si es menor a 0
		jl ErrorLeer
		;	Agregar digito
		xor ax, ax
		mov ax, buffer
		mul bx				;Multiplicar por 10
		mov buffer, ax
		add buffer, cx		;Sumar al valor anterior		
		
		;	Digito 3
		mov ah, 01h			;Interrupcion para leer
		int 21h
		;	Validar si se presiono Enter
		mov cl, al			;Guardar valor ingresado
		sub cl, 30h			;Obtener valor real ingresado
		cmp al, 0Dh			;Validar Enter
		je FinLeer
		;	Validar valor incorrecto
		mov dl, cl
		cmp dl, 9h			;Validar si es mayor a 9
		jg ErrorLeer
		cmp dl, 0h			;Validar si es menor a 0
		jl ErrorLeer
		;	Agregar digito
		xor ax, ax
		mov ax, buffer
		mul bx				;Multiplicar por 10
		mov buffer, ax
		add buffer, cx		;Sumar al valor anterior		
		
		;Terminar
		jmp FinLeer
		ErrorLeer:
		xor dx, dx
		mov dx, offset sErrorChar
		mov ah, 09h
		int 21h
		jmp InicioLeer	;Volver al inicio
		
		ErrorNumero:
		xor dx, dx
		mov dx, offset sErrorVal
		mov ah, 09h
		int 21h
		jmp InicioLeer	;Volver al inicio
		
		FinLeer:
		
		;Validar valor muy grande
		cmp buffer, 128
		ja ErrorNumero	;Saltar si es mayor a 128
		
		;Guardar valor
		xor ax, ax
		mov ax, buffer
		mov actualF, al
	RET
	Leer ENDP

	; Calcular el valor del factorial
	Factorial PROC NEAR
		call IntToString	;Mover primer valor a num1
		LoopFact:
		xor dl, dl
		dec actualF			;Reducir contador en uno
		cmp actualF, 0		;Comprobar si se termina el ciclo
		jbe FinFact
		mov dl, actualF		;Nuevo valor a multiplicar
		mov actualM, dl
		call Multiplicacion	;Multiplica valores
		jmp LoopFact		;Repetir
		FinFact:
		mov actualF, 0		;Reiniciar contador
	RET
	Factorial ENDP
	
	; Multiplica dos cadenas dadas, donde cada char representa un valor en base 10 (0 - 9)
	; Parametros: num1 (numero), actualM(veces que se repite)
	Multiplicacion PROC NEAR
		call CopyString		;Copiar num1 a num2
		LoopMulti:
		dec actualM			;Reducir contador en uno
		cmp actualM, 0		;Comprobar si se termina el ciclo
		jbe FinMulti
		call Suma			;Sumar valores
		jmp LoopMulti		;Repetir
		FinMulti:
		mov actualM, 0		;Reiniciar contador
	RET
	Multiplicacion ENDP
	
	; Suma dos cadenas dadas, donde cada char representa un valor en base 10 (0 - 9)
	; Se asume que ambos tienen la misma longitud
	; Parametros: num1, num2
	; El resultado se guarda en num1
	Suma PROC NEAR
		;Inicializar apuntadores
		lea si, num1		;Inicializando SI, en la primera posicion de num1
		lea di, num2		;Inicializando DI, en la primera posicion de num2
		RecorrerHastaFinal:
			mov al, [si]
			cmp al, 24h				;Validar si se ha leido el '$'
			je IniciarSumar			;Sumar si ya no hay digitos			
			inc si
			inc di
			inc counter
			jmp RecorrerHastaFinal ;Regresar a inicio si aun quedan digitos
		IniciarSumar:
			dec si	;Primer valor a la derecha
			dec di	;Primer valor a la derecha
			dec counter
		Sumar:
			;Limpiar registros
			xor ax, ax
			xor bx, bx
			xor cx, cx
			; Asignar a registros valores de cada posicion
			mov bl, [si]	;Almacena posicion actual en BL num1
			mov cl, [di]	;Almacena posicion actual en CL num2
			; Sumar valores de la posicion actual
			add bl, cl
			; Sumar valor de acarreo
			add bl, carry
			mov carry, 0
			; Asignar sobrante al acarreo
			cmp bl, 10d		;Comprobar si es mayor a 10
			jl NoAcarreo
			mov carry, 1	;Llevar acarreo
			sub bl, 10d		
			NoAcarreo:
			; Asignar resultado de suma a posicion en num1
			mov [si], bl
			; Decrementar SI y DI
			dec si
			dec di
			dec counter
			; Comparar si la cadena ha terminado
			cmp counter, 0
			jge Sumar				;Regresar a inicio si aun quedan digitos
		FinSuma:
		call NumInicio
		mov counter, 0
	RET
	Suma ENDP
	
	; Agregar un numero al inicio de una cadena
	; Parametros: Leftcarry (numero), num1 (cadena)
	NumInicio PROC NEAR
		cmp carry, 0		;Validar si es cero
		je FinNumI			;No hacer nada si verdadero
		call RShiftString	;Hacer espacio para insertar
		call ShiftNum2		;Hacer que Num2 sea del mismo tamanio
		xor bx, bx			;Limpiar registro
		mov bl, carry		;Leer valor a insertar
		lea si, num1		;Leer cadena
		mov [si], bl		;Insertar valor en primera posicion de cadena
		FinNumI:
		mov carry, 0		;Limpiar variable
	RET
	NumInicio ENDP
	
	; Corre todos los caracteres de un string a la derecha e inserta un $ al inicio
	; Parametros: num1 (cadena)
	RShiftString PROC NEAR
		xor cx, cx			;Limpiar registros
		lea si, num1		;Inicializando SI, en la primera posicion de num1
		mov cl, 2Bh			;Valor a agregar al inicio
		Mover:
		xor ax, ax
		xor bx, bx
		mov bl, [si]	; Almacenar valor actual en BL num1
		mov [si], cl	; Asignar valor del desplazamiento
		mov cl, bl		; Asignar valor del siguiente desplazamiento
		inc si			; Incrementar puntero
		mov al, [si]	; Comparar si la cadena ha terminado
		cmp al, 24h		;24h -> '$'
		jne Mover		;Regresar a inicio si aun quedan digitos
		FinMover:
		mov [si], cl	; Asignar ultimo valor del desplazamiento
	RET
	RShiftString ENDP
	
	; Corre todos los caracteres de un string a la derecha e inserta un 0 al inicio
	; Parametros: num2 (cadena)
	ShiftNum2 PROC NEAR
		xor cx, cx			;Limpiar registros
		lea si, num2		;Inicializando SI, en la primera posicion de num1
		mov cl, 0h			;Valor a agregar al inicio
		MoverNum2:
		xor ax, ax
		xor bx, bx
		mov bl, [si]	; Almacenar valor actual en BL num1
		mov [si], cl	; Asignar valor del desplazamiento
		mov cl, bl		; Asignar valor del siguiente desplazamiento
		inc si			; Incrementar puntero
		mov al, [si]	; Comparar si la cadena ha terminado
		cmp al, 24h		;24h -> '$'
		jne MoverNum2		;Regresar a inicio si aun quedan digitos
		mov [si], cl	; Asignar ultimo valor del desplazamiento
	RET
	ShiftNum2 ENDP
	
	; Traslada el valor de una variable a otra (String)
	; Parametros: num1 (origen), numA (destino)
	CopyString PROC NEAR
		xor dx, dx
		xor ax, ax
		;Inicializar apuntadores
		lea si, num1	
		lea di, num2	
		Copiar:
		;Copiar un caracter
		xor dl, dl
		mov dl, [si]
		mov [di], dl
		;Moverse al siguinete puntero
		inc si			
		inc di
		;Comprobar si ha terminado
		mov al, [si]	
		cmp al, 24h		; Comparar si la cadena ha terminado
		jne Copiar		; Regresar al inicio si aun quedan digitos
	RET
	CopyString ENDP
	
	; Reemplaza todos lo valores de una cadena a $
	; Parametros: num1 (cadena a limpiar)
	ClearString PROC NEAR
		lea si, num1	
		Clear:
		xor ax, ax
		mov bl, '$'
		mov [si], bl	; Cambiar valor
		inc si			; Incrementar puntero
		mov al, [si]	; Comparar si la cadena ha terminado
		cmp al, 24h		;24h -> '$'
		jne Clear	;Regresar a inicio si aun quedan digitos
	RET
	ClearString ENDP

	; Convertir el valor del factorial en num1
	;Parametros: actualF(origen), num1(destino)
	IntToString PROC NEAR
		xor ax, ax
		xor bx, bx
		xor cx, cx
		xor dx, dx
		
		;Leer input
		lea si, num1	
		mov bl, actualF

		;Comparar valores
		cmp bx, 09d				; Vefificar si el numero es de 1 digito o no
		jle UnDigitoProd		; Es un digito
		cmp bx, 99d				; Vefificar si el numero es de 2 o 3 digitos
		jle DosDigitosProd		; Son dos digitos
		jmp TresDigitosProd		; Son tres digitos
		
		UnDigito:
		mov [si], cl			; Mover cantidad de decenas
		inc si					; Mover posicion en cadena
		UnDigitoProd:
		mov [si], bl			; Asignar valor del ultimo digito
		jmp FinIntString
		
		DosDigitos:
		mov [si], cl			; Mover cantidad de centenas
		inc si					; Mover posicion en cadena
		xor cl, cl				; Limpiar contador
		DosDigitosProd:
		cmp bl, 09d
		jbe UnDigito			; Saltar si le queda solo un digito
		sub bl, 10d				; Quitarle un decena
		inc cl					; Contar cuantas decenas quitamos
		jmp DosDigitosProd		; Reiniciar ciclo
		
		TresDigitosProd:
		cmp bl, 99d
		jbe DosDigitos			; Saltar si tiene dos digitos
		sub bl, 100d			; Quitarle un centena
		inc cl					; Contar cuantas decenas quitamos
		jmp TresDigitosProd		; Reiniciar ciclo
		
		FinIntString:
	RET
	IntToString ENDP
	
	; Convierte el valor del resultado de multiplicacion (num1) a una cadena con los
	; valores ascii correctos para la respuesta 
	TraducirCadena PROC NEAR
		lea si, num1	
		Traducir:
		xor ax, ax
		xor bx, bx
		mov bl, [si]	; Almacenar valor actual en BL num1
		add bl, 30h		; Valor ascii
		mov [si], bl	; Cambiar valor
		inc si			; Incrementar puntero
		mov al, [si]	; Comparar si la cadena ha terminado
		cmp al, 24h		;24h -> '$'
		jne Traducir		;Regresar a inicio si aun quedan digitos
	RET
	TraducirCadena ENDP

End programa
; Imprimir texto
ImprimirTexto MACRO texto
	INVOKE StdOut, ADDR texto
ENDM

ImprimirResultado MACRO
    CALL IntToString
	INVOKE StdOut, ADDR sResultado
ENDM

; Leer texto
LeerNumero MACRO valor
    CALL LimpiarString2
	INVOKE StdIn, ADDR sInput, 10
    CALL StringToInt
    CALL Limpiar
    MOV DL, intValue
    MOV valor, DL
ENDM

LeerTexto MACRO valor
	INVOKE StdIn, ADDR valor, 99
ENDM

;Suma
Sumar MACRO n1, n2, total
    CALL Limpiar
    MOV BL, n1
    ADD BL, n2
    MOV total, BL
ENDM

;Resta
Restar MACRO n1, n2, total
    CALL Limpiar
    MOV BL, n1
    SUB BL, n2
    MOV total, BL
ENDM

;Multiplicacion
Multiplicar MACRO n1, n2, producto
    CALL Limpiar
    MOV AL, n1
    MUL n2
    MOV producto, AL
ENDM

;Division
Dividir MACRO n1, n2, cociente, residuo
    CALL Limpiar
    MOV AL, n1
    MOV BL, n2
    DIV BL
    MOV cociente, AL
    MOV residuo,  AH
ENDM

;Ejercicio Cuadrado
EjercicioCuadrado MACRO
            ImprimirTexto sInstruccionLado
            LeerNumero num1
            ;Area
            Multiplicar num1, num1, resultado
            ImprimirTexto sResultadoArea
            ImprimirResultado
            ;Perimetro
            Sumar num1, num1, resultado
            Sumar resultado, num1, resultado
            Sumar resultado, num1, resultado
            ImprimirTexto sResultadoPerimetro
            ImprimirResultado
            JMP Ejercicio1
ENDM

;Ejercicio Rectangulo
EjercicioRectangulo MACRO
            ImprimirTexto sInstruccionLado1
            LeerNumero num1
            ImprimirTexto sInstruccionAltura
            LeerNumero num2
            ;Area
            Multiplicar num1, num2, resultado
            ImprimirTexto sResultadoArea
            ImprimirResultado
            ;Perimetro
            Sumar num1, num1, resultado
            Sumar resultado, num2, resultado
            Sumar resultado, num2, resultado
            ImprimirTexto sResultadoPerimetro
            ImprimirResultado
            JMP Ejercicio1
ENDM

;Ejercicio Triangulo
EjercicioTriangulo MACRO
            ImprimirTexto sInstruccionLado1
            LeerNumero num1
            ImprimirTexto sInstruccionLado2
            LeerNumero num2
            ImprimirTexto sInstruccionLado3
            LeerNumero num3
            ImprimirTexto sInstruccionAltura
            LeerNumero num4
            ;Area
            Multiplicar num1, num4, resultado
            MOV BL, 2h
            MOV factor, BL
            Dividir resultado, factor, resultado, residuo
            ImprimirTexto sResultadoArea
            ImprimirResultado
            ;Perimetro
            Sumar num1, num2, resultado
            Sumar resultado, num3, resultado
            ImprimirTexto sResultadoPerimetro
            ImprimirResultado
            JMP Ejercicio1
ENDM

;Ejercicio Expresiones Matematicas
;1. 2 * b + 3 * (a-c)
EjercicioAlgebra1 MACRO
            ImprimirTexto sInstruccionA
            LeerNumero numA
            ImprimirTexto sInstruccionB
            LeerNumero numB
            ImprimirTexto sInstruccionC
            LeerNumero numC
            ;a-c
            Restar numA, numC, tmp1
            ;3 * (a-c)
            XOR BX, BX
            MOV BL, 03h
            MOV value, BL
            Multiplicar value, tmp1, tmp2
            ;2 * b
            XOR BX, BX
            MOV BL, 02h
            MOV value, BL
            Multiplicar value, numB, tmp3
            ;(2 * b) + (3 * (a-c))
            Sumar tmp2, tmp3, resultado
            ;Resultado
            ImprimirTexto sResultadoAlgebra
            ImprimirResultado
            JMP Ejercicio2
ENDM

;Ejercicio Expresiones Matematicas
;2. a/b
EjercicioAlgebra2 MACRO
            ImprimirTexto sInstruccionA
            LeerNumero numA
            ImprimirTexto sInstruccionB
            LeerNumero numB
            ;a/b
            Dividir numA, numB, resultado, residuo
            ;Resultado
            ImprimirTexto sResultadoAlgebra
            ImprimirResultado
            JMP Ejercicio2
ENDM

;Ejercicio Expresiones Matematicas
;3. a * b /c
EjercicioAlgebra3 MACRO
            ImprimirTexto sInstruccionA
            LeerNumero numA
            ImprimirTexto sInstruccionB
            LeerNumero numB
            ImprimirTexto sInstruccionC
            LeerNumero numC
            ;a*b
            Multiplicar numA, numB, tmp1
            ;a*b / c
            Dividir tmp1, numC, resultado, residuo
            ;Resultado
            ImprimirTexto sResultadoAlgebra
            ImprimirResultado
            JMP Ejercicio2
ENDM

;Ejercicio Expresiones Matematicas
;4. a * (b/c)
EjercicioAlgebra4 MACRO
            ImprimirTexto sInstruccionA
            LeerNumero numA
            ImprimirTexto sInstruccionB
            LeerNumero numB
            ImprimirTexto sInstruccionC
            LeerNumero numC
            ;(b/c)
            Dividir numB, numC, tmp1, residuo
            ;a* (b/c)
            Multiplicar numA, tmp1, resultado
            ;Resultado
            ImprimirTexto sResultadoAlgebra
            ImprimirResultado
            JMP Ejercicio2
ENDM

;Programa
.386                                   
.MODEL flat, stdcall                  
                                      
OPTION casemap :none                  

INCLUDE \masm32\include\kernel32.inc  
INCLUDE \masm32\include\masm32.inc
INCLUDELIB \masm32\lib\kernel32.lib   
INCLUDELIB \masm32\lib\masm32.lib

.DATA                   
    ;Strings
    sError DB 10,13,10,13,"Opcion invalida",0
        ;Principal
    sElegirOpcion DB 10,13,"Elija una opcion: ",0
    sBienvenida DB 10,13,10,13,"Bienvenido! ",10,13,"(Escriba solo numeros enteros positivos de un solo digito)",10,13,0
    sOpcionP1 DB 10,13,"1. Ej1 - Area y Perimetro",0
    sOpcionP2 DB 10,13,"2. Ej2 - Expresiones Matematicas",0
    sOpcionP3 DB 10,13,"3. Ej3 - Cadenas",0
    sOpcionP4 DB 10,13,"4. Salir",10,13,0
        ;Ejercicio 1
    sMensajeEj1 DB 10,13,10,13,"Ejercicio 1: ",10,13,0
    sOpcion1Ej1 DB 10,13,"1. Cuadrado",0
    sOpcion2Ej1 DB 10,13,"2. Rectangulo",0
    sOpcion3Ej1 DB 10,13,"3. Triangulo",0
    sOpcion4Ej1 DB 10,13,"4. Regresar",10,13,0
            ;Informacion Ejercicio 1
    sInstruccionLado DB 10,13,"Ingrese longitud de un lado: ",0
    sInstruccionLado1 DB 10,13,"Ingrese longitud de la base: ",0
    sInstruccionLado2 DB 10,13,"Ingrese longitud del segundo lado: ",0
    sInstruccionLado3 DB 10,13,"Ingrese longitud del tercer lado: ",0
    sInstruccionBase DB 10,13,"Ingrese longitud de la base: ",0
    sInstruccionAltura DB 10,13,"Ingrese longitud de la altura: ",0      
           ;Resultado Ejercicio 1
    sResultadoArea DB 10,13,"El area de la figura es: ",0
    sResultadoPerimetro DB 10,13,"El perimetro de la figura es: ",0
    ;Ejercicio 2
    sMensajeEj2 DB 10,13,10,13,"Ejercicio 2: ",10,13,0
    sOpcion1Ej2 DB 10,13,"1. 2*b+3*(a-c)",0
    sOpcion2Ej2 DB 10,13,"2. a/b",0
    sOpcion3Ej2 DB 10,13,"3. a*b/c",0
    sOpcion4Ej2 DB 10,13,"4. a*(b/c)",0
    sOpcion5Ej2 DB 10,13,"5. Regresar",10,13,0
            ;Informacion Ejercicio 2
    sInstruccionA DB 10,13,"Ingrese numero 'a': ",0
    sInstruccionB DB 10,13,"Ingrese numero 'b': ",0
    sInstruccionC DB 10,13,"Ingrese numero 'c': ",0
            ;Resultado Ejercicio 2
    sResultadoAlgebra DB 10,13,"El resultado de la operacion es: ",0
    ;Ejercicio 3
    sInstruccionC1 DB 10,13,"Ingrese la cadena principal: ",0
    sInstruccionC2 DB 10,13,"Ingrese la cadena a buscar: ",0
    sResultadoCadena DB 10,13,"La cantidad de ocurrencias es: ",0

    ;Data
    opcion DB 0
    num1 DB 0
    num2 DB 0
    num3 DB 0
    num4 DB 0
    numA DB 0
    numB DB 0
    numC DB 0
    tmp1 DB 0
    tmp2 DB 0
    tmp3 DB 0
    tmpPos DD 0
    factor DB 2
    value DB 0
    residuo DB 0
    resultado DB 0
    sResultado DB 5 DUP(0)
    sInput DB 5 DUP(0)
    intValue DB 0
    buffer DB 0
    cadena1 DB 100 DUP(0)
    cadena2 DB 100 DUP(0)

.CODE                                
program:
       
      Inicio:
      ;Menu Princiapl
      ImprimirTexto sBienvenida
      ImprimirTexto sOpcionP1
      ImprimirTexto sOpcionP2
      ImprimirTexto sOpcionP3
      ImprimirTexto sOpcionP4
      ImprimirTexto sElegirOpcion

      LeerNumero opcion

      ;Evaluar opcion
      XOR BX, BX
      MOV BL, 1
      CMP opcion, BL
      JE Ejercicio1
      MOV BL, 2
      CMP opcion, BL
      JE Ejercicio2
      MOV BL, 3
      CMP opcion, BL
      JE Ejercicio3
      MOV BL, 4
      CMP opcion, BL
      JE Salir
      JNE Error

      JMP Inicio

      ;Ejercicios
      Ejercicio1:
            ;Menu Ejercicio 1
          ImprimirTexto sMensajeEj1
          ImprimirTexto sOpcion1Ej1
          ImprimirTexto sOpcion2Ej1
          ImprimirTexto sOpcion3Ej1
          ImprimirTexto sOpcion4Ej1
          ImprimirTexto sElegirOpcion

          LeerNumero opcion

          ;Evaluar opcion
          XOR BX, BX
          MOV BL, 1
          CMP opcion, BL
          JE Cuadrado
          MOV BL, 2
          CMP opcion, BL
          JE Rectangulo
          MOV BL, 3
          CMP opcion, BL
          JE Triangulo
          MOV BL, 4
          CMP opcion, BL
          JE RegresarEj1
          JNE Error

          JMP Inicio

          Cuadrado:
            ImprimirTexto sOpcion1Ej1
            EjercicioCuadrado
          Rectangulo:
            ImprimirTexto sOpcion2Ej1
            EjercicioRectangulo
          Triangulo:
            ImprimirTexto sOpcion3Ej1
            EjercicioTriangulo
          RegresarEj1:
            JMP Inicio
      Ejercicio2:
            ;Menu Ejercicio 2
          ImprimirTexto sMensajeEj2
          ImprimirTexto sOpcion1Ej2
          ImprimirTexto sOpcion2Ej2
          ImprimirTexto sOpcion3Ej2
          ImprimirTexto sOpcion4Ej2
          ImprimirTexto sOpcion5Ej2
          ImprimirTexto sElegirOpcion

          LeerNumero opcion

          ;Evaluar opcion
          XOR BX, BX
          MOV BL, 1
          CMP opcion, BL
          JE Algebra1
          MOV BL, 2
          CMP opcion, BL
          JE Algebra2
          MOV BL, 3
          CMP opcion, BL
          JE Algebra3
          MOV BL, 4
          CMP opcion, BL
          JE Algebra4
          MOV BL, 5
          CMP opcion, BL
          JE RegresarEj2
          JNE Error

          JMP Inicio

          Algebra1:
            ImprimirTexto sOpcion1Ej2
            EjercicioAlgebra1
          Algebra2:
            ImprimirTexto sOpcion2Ej2
            EjercicioAlgebra2
          Algebra3:
            ImprimirTexto sOpcion3Ej2
            EjercicioAlgebra3
          Algebra4:
            ImprimirTexto sOpcion4Ej2
            EjercicioAlgebra4
          RegresarEj2:
            JMP Inicio
      Ejercicio3:
        CALL ContarSubString
        JMP Inicio
      Error:
        ImprimirTexto sError
        JMP Inicio
      Salir:
        INVOKE ExitProcess, 0			


;Procedimientos
ContarSubString PROC NEAR
            ;Leer datos
            ImprimirTexto sInstruccionC1
            LeerTexto cadena1
            ImprimirTexto sInstruccionC2
            LeerTexto cadena2
            ;Inicializar contador
            CALL Limpiar
            MOV EBX, 00h
            MOV resultado, BL
            MOV tmpPos, EBX
            ;Utilizar EDI y ESI para recorrer cadenas
            ;Utilizar punteros
            LEA EDI, cadena1
            LEA ESI, cadena2

            InicioCadena:
                MOV BL, 00h
                MOV AL, [EDI]
                CMP AL, BL           ;Comparar fin de cadena
                JE FinalizarRecorrido
                MOV BL, [ESI]
                MOV AL, [EDI]
                CMP AL, BL           ;Comparar si el char es igual
                JE InicioCadena2
                INC EDI
                JMP InicioCadena

            InicioCadena2:
                CALL Limpiar 
                ;La posicion actual de las cadenas se toman en cero    
            CharIgual:
                MOV BL, 00h
                MOV AL, [ESI+ECX]
                CMP AL, BL           ;Comparar fin de cadena
                JE Cadena2Encontrado
                MOV BL, [ESI+ECX]
                MOV AL, [EDI+ECX]
                CMP AL, BL           ;Comparar si el char es igual
                JNE Cadena2NoEncontrado
                INC ECX
                JMP CharIgual
            Cadena2Encontrado:
                INC resultado
            Cadena2NoEncontrado:
                CALL Limpiar
                INC EDI                 ;Mover a la siguiente posicion de la cadena 
                JMP InicioCadena
            FinalizarRecorrido:
            ;Resultado
            ImprimirTexto sResultadoCadena
            ImprimirResultado
RET
ContarSubString ENDP

Limpiar PROC NEAR ;Limpia todos los registros
        XOR EAX, EAX
		XOR EBX, EBX
		XOR ECX, ECX
		XOR EDX, EDX
RET 
Limpiar ENDP

LimpiarString1 PROC NEAR
    CALL Limpiar
    MOV EBX, 0
    LEA ESI, sResultado
    InicioLimpiarString1:
        MOV [ESI], BL
        INC ESI
        CMP [ESI], BL
        JNE InicioLimpiarString1
    FinLimpiarString1:
RET
LimpiarString1 ENDP

LimpiarString2 PROC NEAR
    CALL Limpiar
    MOV EBX, 0
    LEA ESI, sInput
    InicioLimpiarString2:
        MOV [ESI], BL
        INC ESI
        CMP [ESI], BL
        JNE InicioLimpiarString2
    FinLimpiarString2:
RET
LimpiarString2 ENDP

IntToString PROC NEAR ;Convierte el valor de la variable resultado en String
		CALL Limpiar
        CALL LimpiarString1
		;Leer input
		lea esi, sResultado	
		mov bl, resultado

		;Comparar valores
		cmp bx, 09d				; Vefificar si el numero es de 1 digito o no
		jle UnDigitoProd		; Es un digito
		cmp bx, 99d				; Vefificar si el numero es de 2 o 3 digitos
		jle DosDigitosProd		; Son dos digitos
		jmp TresDigitosProd		; Son tres digitos
		
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

	
StringToInt PROC NEAR	        ;Convierte el valor de la cadena input, en un entero (Maximo 2 digitos)
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
		    ImprimirTexto sError
		    JMP Inicio	        ;Volver al inicio
		
		FinLeer:
		    XOR AX, AX 
		    MOV AL, buffer
		    MOV intValue, AL    ;Guardar valor
RET
StringToInt ENDP

END program
; Imprimir texto
ImprimirTexto MACRO texto
	INVOKE StdOut, ADDR texto
ENDM

;Suma
Sumar MACRO n1, n2, total
    XOR BX, BX
    MOV BL, n1
    ADD BL, n2
    ADD BL, 30h
    MOV total, BL
ENDM

;Multiplicacion
Multiplicar MACRO n1, n2, producto
    XOR AX, AX
    MOV AL, n1
    MUL n2
    ADD AL, 30h
    MOV producto, AL
ENDM

.386                                   
.MODEL flat, stdcall                  
                                      
OPTION casemap :none                  

INCLUDE \masm32\include\kernel32.inc  
INCLUDE \masm32\include\masm32.inc
INCLUDELIB \masm32\lib\kernel32.lib   
INCLUDELIB \masm32\lib\masm32.lib

.DATA                                 
    hola DB "Hola!!!", 0      
    num1 DB 3,0
    num2 DB 2,0
    total DB 0,0
    producto DB 0,0
    cadena1 DW 100 DUP ("$")
    cadena2 DW 100 DUP ("$")
    instruccion1 DB 10,"Ingrese la subcadena a evaluar",0
    instruccion2 DB 10,"Ingrese la cadena principal",0
    cantidad DB 0,0

.CODE                                
programa:
       
      ;Macros
      ImprimirTexto hola	
      
      Sumar num1, num2, total
      ImprimirTexto total

      Multiplicar num1, num2, producto
      ImprimirTexto producto

      ;Cadenas
      INVOKE StdOut, ADDR instruccion1
      INVOKE StdIn, ADDR cadena1, 99

      INVOKE StdOut, ADDR instruccion2
      INVOKE StdIn, ADDR cadena2, 99

      EvaluarCadena PROC NEAR
            ;Utilizar EDI y ESI para recorrer cadenas
            ;Utilizar punteros
            LEA EDI, cadena1
            LEA ESI, cadena2

            inicio:
                MOV BL, [ESI]
                CMP [EDI], BL
                JE ActualIgual
                MOV BL, 24h
                CMP [EDI], BL
                JE FinalizarRecorrido1
                INC EDI
                JMP inicio

            ActualIgual:
            FinalizarRecorrido1:
      RET
      EvaluarCadena ENDP

      INVOKE ExitProcess, 0			
END programa
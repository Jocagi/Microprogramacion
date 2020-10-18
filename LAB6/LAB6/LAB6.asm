.386                                 
.model flat, stdcall                 
                                     
option casemap :none                  

include \masm32\include\kernel32.inc  
include \masm32\include\masm32.inc   
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data                                
    message db "Hello World!",10,0
    instruccion1 db 10, "Ingrese su nombre: ", 0
    instruccion2 db 10, "Ingrese su carnet: ", 0
    instruccion3 db 10, "Ingrese su carrera: ", 0
    message1 db 10, "Hola ", 0
    message2 db " su carnet es ", 0
    message3 db 10, "Bienvenido a la carrera de ", 0
    salto db 10
.data?
    data db ?
    nombre  db 10   dup (?)
    carnet  db 10   dup (?)
    carrera db 100  dup (?)

.code                                 
    main:
        ;Hello World
        invoke StdOut, addr message
      
      	;Leer nombre
        invoke StdOut, addr instruccion1
	    invoke StdIn, addr nombre, 10

        ;Leer carnet
        invoke StdOut, addr instruccion2
	    invoke StdIn, addr carnet, 10 

        ;Leer carrera
        invoke StdOut, addr instruccion3
	    invoke StdIn, addr carrera, 10 
	    
        ;Imprimir mensaje personalizado
        invoke StdOut, addr message1
        invoke StdOut, addr nombre
        invoke StdOut, addr message2
        invoke StdOut, addr carnet
        invoke StdOut, addr message3
        invoke StdOut, addr carrera
        invoke StdOut, addr salto

      invoke ExitProcess, 0			
    end main
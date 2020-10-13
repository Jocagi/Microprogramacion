.386                                  ; this gets use to use 386 instruction set 
.model flat, stdcall                  ; this specifies the memory model of the program, flat is for windows
                                      ; stdcall means our parameters are pushed from left to right
option casemap :none                  ; this means our labels will be case sensitive

include \masm32\include\kernel32.inc  ; for ExitProcess
include \masm32\include\masm32.inc    ; for StdOut 
includelib \masm32\lib\kernel32.lib   ; the libraries for above 
includelib \masm32\lib\masm32.lib

.data                                 ; all initialized data must follow the .data directive
    message db "Hello World!", 0      ; define byte named 'message' to be the string 'Hello World!'
                                      ; followed by the NULL character

.code                                 ; all code must follow the .code directive
    main:								
      invoke StdOut, addr message		
      invoke ExitProcess, 0			
    end main
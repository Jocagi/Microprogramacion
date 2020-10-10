.model small			;Modelo small
.data
	Timespan DD 0		;Valor en milisegundos desde el inicio de la semana
	random DB 0			;Valor aleatorio generado
.stack					
.386					;Ensamblar en 32 bits
.code
programa:		
	Inicio:
	;	Inicio Programa
	mov ax, @DATA	
	mov ds, ax
	
	Final:
	;	Finalizacion del Programa
	mov ah, 4Ch
	int 21h

	; Obtener milisegundos desde el inicio de la semana
	GetTimeSpan PROC NEAR
		; Interrupcion para obtener la fecha
		; AL = día de la semana (Dom=0, Lun=1,….Sab=6), CX = año, DH = mes, DL = día
		mov ah, 2Ah
		int 21h
		; Limpiar ah, pero dejar intacto AL(dia)
		xor ah, ah
		; Limpiar DX
		xor dx, dx
		mov EDX, 5265C00h	;Milisegundos en un dia
		mul EDX				;EAX * EDX (dias * mil/dia)
		mov timespan, EAX
		; Interrupcion para obtener la hora
		; CH = hora, CL = minutos, DH = segundos y DL = centésimos de segundo.
		mov ah, 2Ch
		int 21h
	RET
	GetTimeSpan ENDP

End programa
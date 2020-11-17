.386
.model flat,stdcall

option casemap:none

INCLUDE \masm32\include\kernel32.inc  
INCLUDE \masm32\include\masm32.inc
INCLUDELIB \masm32\lib\kernel32.lib   
INCLUDELIB \masm32\lib\masm32.lib

.data
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
	instruction2 db "2. Cifrar mensaje con variante",0
	instruction3 db "3. Descifrar mensaje",0
	instruction4 db "4. Descifrar mensaje con variante",0
	instruction5 db "5. Calculo de probabilidades",0
	instruction6 db "6. Salir del programa",0
	instruction7 db "Que desea hacer?: ",0
	_option db 0,0
	invalid_main_option db "La opcion seleccionada es invalida",0

.const

.code
program:

	; Main app loop
	main_loop:

		; Print menu
		invoke StdOut, addr main_tittle
		invoke StdOut, addr instruction1
		invoke StdOut, addr instruction2
		invoke StdOut, addr instruction3
		invoke StdOut, addr instruction4
		invoke StdOut, addr instruction5
		invoke StdOut, addr instruction6
		invoke StdOut, addr instruction7
		invoke StdIn, addr _option, 10
		invoke StdOut, addr new_line

		; Clean registers
		xor bx, bx
		mov bl, _option

		; Check what to do
		cmp bl, 31h
		je option_1
		cmp bl, 32h
		je option_2
		cmp bl, 33h
		je option_3
		cmp bl, 34h
		je option_4
		cmp bl, 35h
		je option_5
		cmp bl, 36h
		je exit_program
		
		; Invalid option
		invoke StdOut, addr invalid_main_option
		invoke StdOut, addr new_line
		jmp main_loop

		; Option 1
		option_1:
			xor ax, ax
			xor bx, bx
			xor cx, cx
			call init_one
			invoke StdOut, addr new_line
			jmp main_loop

		; Option 1
		option_2:
			xor ax, ax
			xor bx, bx
			xor cx, cx
			call init_two
			invoke StdOut, addr new_line
			jmp main_loop

		; Option 1
		option_3:
			xor ax, ax
			xor bx, bx
			xor cx, cx
			call init_three
			invoke StdOut, addr new_line
			jmp main_loop

		; Option 1
		option_4:
			xor ax, ax
			xor bx, bx
			xor cx, cx
			call init_four
			invoke StdOut, addr new_line
			jmp main_loop

		; Option 1
		option_5:
			xor ax, ax
			xor bx, bx
			xor cx, cx
			call init_five
			invoke StdOut, addr new_line
			jmp main_loop

	; Finish the program
	exit_program:
		invoke ExitProcess, 0

	; Firts problem
	init_one proc near

		ret

	init_one endp

	; Second problem
	init_two proc near

		ret

	init_two endp

	; Three problem
	init_three proc near

		ret

	init_three endp

	; Four problem
	init_four proc near

		ret

	init_four endp

	; Get the probabilities
	init_five proc near

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

	init_five endp

	; Print the posibble message
	posibble_decrypt proc near

		; Init reader
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
		mov tens,00h
		mov units,00h
		xor bx, bx
		mov bl, remainder

		; Check if remainder has tens
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
			add tens, 30h
			invoke StdOut, addr tens
			mov units,bl
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
			cmp cl,1Ah
			jg finish_reset
			mov [edi],bl
			inc cl
			inc edi
			jmp reset_loop

		finish_reset:
			ret

	reset_numbers endp

end program
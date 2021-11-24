data segment
	ball_x dw 0030h				; initial x coordinate of the ball
	ball_y dw 0010h 			; initial y coordinate of the ball
	ball_width dw 0009h			; width of the ball
	curr_time db 00h 			; auxillary variable to maintan time
data ends

stack segment
stack ends

code segment
	assume cs:code, ds:data, ss:stack
	main proc far
		mov ax, data 		; load ds with data segment address
		mov ds, ax

		mov ah, 00h 		; set video mode
		mov al, 0dh 		; to 320*200 16 color mode
		int 10h

		mov ah, 0bh 		; set background color
		mov bh, 00h
		mov bl, 0ch 		; to light red
		int 10h

	updatetime:
		mov ah, 2ch 		; get system time
		int 21h

		cmp curr_time, dl 			; if time is not passed, (in 1/100 sec)
		je updatetime 				; wait till it is
		mov curr_time, dl
		add ball_x, 03h 			; updata the position of the ball
		add ball_y, 03h
		call drawball 				; and update the frame
		jmp updatetime				; continue forever

		mov ah, 4ch
		int 21h
	main endp

	include src/io.asm

	drawball proc near 				; procedure to draw the ball
		mov cx, ball_x			; initial position coordinates of the ball(top-left corner)
		mov dx, ball_y

	back:
		xor ax, ax				; clear ax and bx registers
		xor bx, bx

		; pixel drawen at x -> cx, y -> dx coordinates
		mov ah, 0ch 			; draw the pixel... ah -> function code
		mov al, 0fh 			; al -> color of the pixel(white)
		mov bh, 00h 			; bh -> page number
		int 10h 				; call the interupt

		mov ax, cx 				; check if number of pixels in current row
		sub ax, ball_x 			; are greater than ball_width
		cmp ax, ball_width
		jge nxt_row 			; if yes, stop and draw the next row
		inc cx					; else draw next pixel of the current row
		jmp back
	nxt_row:
		mov ax, dx				; check if number of rows greater then ball_width
		sub ax, ball_y
		cmp ax, ball_width
		jge done				; if yes, we are done drawing the ball, return
		inc dx					; else draw the next row
		mov cx, ball_x
		jmp back
	done:
		ret
	drawball endp

code ends
end 

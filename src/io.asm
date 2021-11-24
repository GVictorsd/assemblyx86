
_PRINT_INT proc far ;(int num in stack)
        
        push bx                 ; callee save registers
        push bp                 ; save previous frame pointer
        mov bp, sp              ; and setup a new frame


        mov dx, [bp+8]           ; argument (considering bp, cs, ip, save register(bx))

        __BACK_INT:
        mov ax, dx
        mov bl, 10
        div bl
        mov dl, ah              ; move reminder to dx
        mov dh, 0               ; (size extend)
        add dx, 48              ; convert to ascii
        mov bl, al              ; save the quotient to bl reg for further use

        push ax                 ; caller save registers
        push cx
        push dx                 ; arguments
        call far ptr _PRINT_CHAR
        add sp, 2                ; get back the saved registers
        pop cx
        pop ax

        
        cmp bl, 0               ; if previous quotient == 0
        jz __DONE               ; return
        mov dl, bl              ; else
        mov dh, 0               ; loop again 
        jmp __BACK_INT

        __DONE:
            mov sp, bp              ; delete the current frame
            pop bp                  ; set the previous frame back
            pop bx                  ; get back the callee save registers
            ret
       
_PRINT_INT endp


_PRINT_STRING proc far              ; assuming address in dx(using lea)
    
    push bp                     ; save the previous frame pointer
    mov bp, sp                  ; set up a new frame
    
    mov dx, [bp+6]              ; get arguments(considering bp, cs, ip on stack)
    mov ah, 09h                 ; DOS interrupt
    int 21h

    mov sp, bp                  ; delete the current frame pointer
    pop bp                      ; set the previous frame
    ret
_PRINT_STRING endp


_PRINT_CHAR proc far
    push bp
    mov bp, sp
    
    mov dx, [bp+6]  ; get arguments from stack (account for cs,ip,bp on stack)
    mov ah, 02h     ; and print
    int 21h

    mov sp, bp              ; delete the current frame
    pop bp                  ; set the previous frame
    ret                     ; and return
_PRINT_CHAR endp




; EXAMPLE USAGE
; start:
;        mov ax, data
;        mov ds, ax

;        push ax                          ; caller save registers
;        push cx
;        push dx
;        mov ax, 32                       ; arguments for the procedure
;        push ax                          ; push to the stack
;        call far ptr _PRINT_INT          ; call the procedure
;        add sp, 2                        ; delete the argumnets
;        pop dx                           ; and get back the saved registers
;        pop cx
;        pop ax
;        mov ah, 4ch                      ; terminate the program
;        int 21h

;     INCLUDE src\io.asm                  ; include the library file
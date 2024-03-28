.model small
.stack 100h

.data
 oneChar dw ?
 array dw 10000 DUP (?) ; array for numbers from input
 endOfLine dw 'k' , 0
 count DW 0
.code

main:
  lea si, array 
  mov di,0
  read_next:
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset oneChar   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    mov bx, oneChar ; copy oneChar to bx
    ; adding numbers from input to array
    mov [si], bx ; copy bx to array
    inc si ; add +1 to si
    inc count
    cmp bx, 206Bh
    ; printing 'a' for example if 'k'=206Bh is printed
    je calculate_mod
    jne ifNoEndOfLine
    calculate_mod:
      jmp bubbleSort
      bubbleSort:
    mov cx, word ptr count
    ;dec cx  ; count-1
outerLoop:
    ;push cx

    lea si, array
innerLoop:
    mov ax, [si]
    cmp ax, [si+2]
    jl nextStep
    xchg [si+2], ax
    mov [si], ax
nextStep:
    add si, 2
    dec cx
    cmp cx, 0
    jne innerLoop
    ;loop innerLoop
    ;pop cx
    xor cx,cx
    mov cx, word ptr count
      jmp print_out
;output
print_out:
lea si, array 
mov bl,[si]

    mov ah, 02h
    mov dl, bl
    int 21h
    dec cx
    inc si
    cmp cx,0
    jne print_out
    xor cx,cx
    je read_next
    ifNoEndOfLine:
    or ax,ax
    jnz read_next
; ;output
; print_out:
; lea si, array 
; mov bl,[si]
; mov cx, word ptr count
;     mov ah, 02h
;     mov dl, bl
;     int 21h
;     dec cx
;     cmp cx,0
;     jne print_out
;     je read_next

;     bubbleSort:
;     mov cx, word ptr count
;     ;dec cx  ; count-1
; outerLoop:
;     push cx
;     lea si, array
; innerLoop:
;     mov ax, [si]
;     cmp ax, [si+2]
;     jl nextStep
;     xchg [si+2], ax
;     mov [si], ax
; nextStep:
;     add si, 2
;     loop innerLoop
;     pop cx
;     ret
    ;loop outerLoop

;     mov ax, 7FFFh
;     add ax, 0FFFh

;     xor dx,dx       ; DX - 32-bit hi-word
;     mov ax, 7FFFh   ; AX - 32-bit lo-word
;     add ax, 7FFFh   ; add 16bit signed value
;     adc dx, 0       ; note that OF=0! 

;     mov dx, 0FFh
;     mov ax, 0h
;     mov bx, 1500
;     div bx  ; DX:AX / 1500, result in ax

;     test ax,ax
;     jns oi1
;     mov cx,ax
;     mov ah, 02h
;     mov dl,'-'
;     int 21h
;     mov ax,cx
;     neg ax
;     ; кіл-ть цифр в сх
;     oi1:
;     xor cx,cx
;     mov bx,10
;     oi2:
;     xor dx,dx
;     div bx
;     push dx
;     inc cx
;     test ax,ax
;     jnz oi2
;     mov ah, 02h
;     oi3:
;     pop dx
;     cmp dl,9
;     jbe oi4
;     add dl,7
;     oi4:
;     add dl,'0'
;     int 21h
;     ;зациклення на к-ть цифр
;     loop oi3
;     ret
end main

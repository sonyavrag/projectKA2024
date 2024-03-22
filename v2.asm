.model small
.stack 100h

.data
 oneChar db ?
.code

main:
  read_next:
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset oneChar   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    ; do something with [oneChar]
    or ax,ax
    jnz read_next

    test ax,ax
    jns oi1
    mov cx,ax
    mov ah, 02h
    mov dl,'-'
    int 21h
    mov ax,cx
    neg ax
    ; кіл-ть цифр в сх
    oi1:
    xor cx,cx
    mov bx,10
    oi2:
    xor dx,dx
    div bx
    push dx
    inc cx
    test ax,ax
    jnz oi2
    mov ah, 02h
    oi3:
    pop dx
    cmp dl,9
    jbe oi4
    add dl,7
    oi4:
    add dl,'0'
    int 21h
    ;зациклення на к-ть цифр
    loop oi3
    ret
end main

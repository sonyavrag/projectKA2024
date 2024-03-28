.386
.model small
.stack 100h

.data
 oneChar db ?
 array dw 10000 DUP (?) ; array for numbers from input
 endOfLine db 13, 10, 0 ; symbol, that means that end of one line has come
 count DW 0 ; counter
 temp db 1000 DUP (?) ; array for symbols from input(побайтово)
 number dw 0 
 base dw 10 ; base for decimal number, 355 = 3*10^2 + 5*10^1 + 5*10^0
 sum dw 0 ; contains sum of 3*10^2 + 5*10^1 + 5*10^0 = 355
 arrayIndex dw 0 ; for index of array
 countForArrayEl db 0 ; counter for elements of array
 median dw ? ; variable for median
.code

main:
  lea si, array ;loads the array address into the si
  mov [arrayIndex], si
  mov di,0
         read_next:
            mov ah, 3Fh
            mov bx, 0h  ; stdin handle
            mov cx, 1   ; 1 byte to read
            mov dl, offset oneChar   ; read to ds:dx 
            int 21h   ;  ax = number of bytes read
; converts symbols to numbers
    mov bl, oneChar ; copy oneChar to bl
    cmp bl, 13
    je print_out
    cmp bl ,' ' ; check if bl = ' '
    je calculate ; if ' ' jump to calculate
    jne savenum ; if input is number jump to savenum
            savenum:
            mov si, [arrayIndex] ;loads the temp address into the si
            inc count ; +1 count
            mov [si], bl ; copy bl to temp
            inc si ; +1 si, next element of temp
            jmp read_next
    ; converts symbols to numbers, checks if symbol from input = 0-9 , if so number becomes 0-9
    calculate:

    jmp bubble_sort
    bubble_sort:

    mov cx, word ptr count ;count to cx
outerLoop:
    lea si, array ;loads the array address into the si
innerLoop:
    mov ax, [si] ; copy current element of array to ax
    cmp ax, [si+2] ; compare current element of array to next one
    jl nextStep ; if current element is less then next one, jump to nextStep
    xchg [si+2], ax ; exchange current number with next one
    mov [si], ax ; copy current element on next element position
nextStep:
    add si, 2 ; to go to next element of array
    dec cx ; -1 to count
    cmp cx, 0 ; checks if there are more elements of array
    jne innerLoop ; if there are more elements of array jump to nextStep
    xor cx,cx ;cx = 0
    mov cx, word ptr count;count to cx

    lea si, temp ;loads the address of first element of temp into the si
    mov ax, [si]
    cmp al, 30h ; checks if symbol from input = '0'
    je saveZero ; if symbol from input = '0' jump to saveZero
    jne afterZero ; if symbol from input != '0' jump to afterZero
    saveZero:
    mov number, 0 ; number = 0
    afterZero:
    cmp al, 31h 
    je saveOne
    jne afterOne
    saveOne:
    mov number,1
    afterOne:
    cmp al, 32h
    je saveTwo
    jne afterTwo
    saveTwo:
    mov number,2
    afterTwo:
    cmp al, 33h
    je saveThree
    jne afterThree
    saveThree:
    mov number, 3
    afterThree:
    cmp al, 34h
    je saveFour
    jne afterFour
    saveFour:
    mov number, 4
    afterFour:
    cmp al, 35h
    je saveFive
    jne afterFive
    saveFive:
    mov number, 5
    afterFive:
    cmp al, 36h
    je saveSix
    jne afterSix
    saveSix:
    mov number, 6
    afterSix:
    cmp al, 37h
    je saveSeven
    jne afterSeven
    saveSeven:
    mov number, 7
    afterSeven:
    cmp al, 38h
    je saveEight
    jne afterEight
    saveEight:
    mov number, 8
    afterEight:
    cmp al, 39h
    je saveNine
    jne afterNine
    saveNine:
    mov number, 9
    afterNine:
    ; multiply number by its base in power of its largest byte
    mov di,count ; count to di
    dec di ; -1 to di
    mov ax, [base] ; base(=10) to ax
    mul di ; ax * di
    mul [number] ; ax * number
    mov [number], ax ; copy the lowest byte (from the result of multiplication) from ax to number
    mov ax, [number] ; copy from number to ax, used to get value from number
    add sum, ax ; ax + sum
    inc si ; +1 to si
    dec count ; -1 to count
    cmp count, 0 ; checks if there are more elements of array
    je saveToArray ; if so , jump to saveToArray
    jne calculate ; if no , repeat
    ; saves sum to array
    saveToArray:
        lea si, [arrayIndex] ; saves current array index to si
        mov ax,sum ; copy sum to ax
        mov [bp] , ax ; sum to bp
        inc si ; +1 to si
        mov [arrayIndex], si ; next element of array to arrayIndex
        inc countForArrayEl ; +1 tocountForArrayEl
        jmp read_next ; jump to read_next

        ;     lea si, array ;loads the array address into the si
; innerLoop:
;     mov ax, [si] ; copy current element of array to ax
;     cmp ax, [si+2] ; compare current element of array to next one
;     jl nextStep ; if current element is less then next one, jump to nextStep
;     xchg [si+2], ax ; exchange current number with next one
;     mov [si], ax ; copy current element on next element position
; nextStep:
;     add si, 2 ; to go to next element of array
;     dec cx ; -1 to count
;     cmp cx, 0 ; checks if there are more elements of array
;     jne innerLoop ; if there are more elements of array jump to nextStep
;     ;loop innerLoop
;     ;pop cx
;     xor cx,cx ;cx = 0
;     mov cx, word ptr count;count to cx
;       jmp print_out ; jump to print out
;output
        print_out:
        lea si, array ;loads the array address into the si
        mov bl,[si] ; copy current element of array to bl
        mov ah, 02h
        mov dl, bl ; bl to dl
        int 21h
        dec cx ; -1 to count
        inc si ; +1 to si
        cmp cx,0 ; checks if there are more elements of array
        jne print_out ; if there are more elements of array repeat the cycle
    xor cx,cx ;cx = 0
    je read_next ; repeat the input
    ifNoEndOfLine:
    or ax,ax ; checks if ax=0
    jnz read_next ; if ax=0 repeat the input

    call calculate_median
    calculate_median:
    call bubble_sort
    mov ax, count ; copy count of elements in array to ax

        test al, 1 ; операція конʼюнкції, if result is 0 then number is even , if 1 then uneven
        jnz uneven_num ; if uneven jump to uneven_num
        shr ax, 1 ; бітовий зсув праворуч на один біт(ділення на 2 з відокремненням цілої частини)
        mov bx, ax ; ax to bx
        dec bx ; -1 to bx
        mov ax, array[bx] ; save first middle number
        add ax, array[bx+1] ; first middle number + second middle number
        shr ax, 1 ; бітовий зсув праворуч на один біт(ділення на 2 з відокремненням цілої частини)
        jmp save_median
        uneven_num:
            mov bx, ax ; ax to bx
            mov ax, array[bx]; save middle number
            jmp save_median
        save_median:
            mov median, ax ; save middle number in median
        ret


;     mov bx, oneChar ; copy oneChar to bx
;     ; adding numbers from input to array
;     mov [si], bx ; copy bx to array
;     inc si ; add +1 to si
;     inc count ; add +1 to counter
;     cmp bx, 206Bh ; 206Bh = k , checks if 'k' was typed
;     ; printing 'a' for example if 'k'=206Bh is printed
;     je calculate_mod ; if k was typed, jump to mod calculations
;     jne ifNoEndOfLine ; if k wasn't typed , jump to ifNoEndOfLine and repeat the cycle
;     calculate_mod: ; mod calculations and bubble sort
;       jmp bubbleSort
;       bubbleSort:
;     mov cx, word ptr count ;count to cx
;     ;dec cx  ; count-1
; outerLoop:
;     ;push cx
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

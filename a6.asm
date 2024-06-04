.model small
.stack 100h
.data
    printA db 'Please enter umber between 1 - 99 and then press / : $'
    printB db 'The factors are : $'
    userInput db 1
    printNum db ?
    counter db 0
    num db ?
    temp db ?
.code
outputNumbers Proc
    push bp
    push ax ; ax holds the value to print
    push bx
    push cx
    cmp ax,0
    je printOnly0 ; if to print only a character that is 0
    OUTPUTT:
    mov dx, 0
    MOV Bx, 10
    L1:
    mov dx, 0
    CMP Ax, 0 ; iterates till ax isn't 0
    JE DISP
    DIV Bx
    MOV cx, dx ; pushes reminder in stack
    PUSH CX
    inc counter
    MOV AH, 0
    JMP L1

    DISP:
    CMP counter, 0
    JE return
    POP DX ; pops values, adds 030h and prints on screen 1 by 1 with no spaces in them
    ADD DX, 48
    MOV AH, 02H
    INT 21H
    dec counter
    JMP DISP

    jmp return
    printOnly0:
    mov ah,02
    mov dx,0
    add dx,030h
    int 21h


    return:
    pop cx
    pop bx
    pop ax
    pop bp
    ret
outputNumbers endp
printNumber proc
    push bp
    mov dl,printNum
    add dl,'0'
    mov ah,2
    int 21h
    mov dl,','
    mov ah,2
    int 21h
    pop bp
    ret
printNumber endp
InputNumber proc
    push bp
    mov dx,offset printA
    mov ah,9
    int 21h
    mov ah,1
    int 21h
    sub al,30h
    mov userInput,al
    mov ah,1
    int 21h
    cmp al,02fh
    je INP
    sub al,30h
    mov bl,al
    mov al,userInput
    mov bh,10
    mul bh
    add bl,al
    mov userInput,bl
    INP:
    mov dl,10
    mov ah,2
    int 21h
    pop bp
    ret
InputNumber endp
makefactors proc
    push bp
    mov dx, offset printB
    mov ah,9
    int 21h
    ;inc userInput
    mov   temp, 1
    ; all not in use till
    checkFactors:
    mov ah, 0
    mov al,userInput
    mov bl, temp
    div bl
    cmp ah, 0
    jne notFactor
    mov al,temp
    mov printNum,al
    mov ah,0
    mov al,temp
    call outputNumbers
    mov dl,','
    mov ah,2
    int 21h
    notFactor:
    inc temp
    mov al,userInput
    cmp al, temp
    je endLoop
    jmp checkFactors
    endLoop:
    mov ah,0
    mov al,userInput
    call outputNumbers
    pop bp
    ret
makefactors endp

main proc
    mov ax,@data
    mov ds,ax
    call InputNumber
    call makefactors
    ;call printfactors
    mov ah,4ch
    int 21h
main endp
end main



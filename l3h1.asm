bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 4
    b dw 20
    c dd 45
    d dq 55

; our code starts here
segment code use32 class=code
    start:
        ; (b+b)+(c-a)+d   - signed
        mov AX, [b]
        add AX, [b]
        cwde
        mov EBX, EAX    ;EBX = b+b
        
        mov AL, [a]
        cbw
        cwde
        mov ECX, [c]
        sub ECX, EAX    ;ECX = c-a
        
        add EBX, ECX
        mov EAX, EBX
        cdq             ;EDX:EAX = (b+b)+(c-a)
        
        mov EBX, [d]
        mov ECX, [d+4]  ;EBX:ECX = d
        
        add EAX, EBX    ;EDX:EAX = (b+b)+(c-a)+d
        add EDX, ECX
        

        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

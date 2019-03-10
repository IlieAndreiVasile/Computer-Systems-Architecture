bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 44
    b db 3
    c db 2
    e dd 36
    x dq 55

; our code starts here
segment code use32 class=code
    start:
        ;   a*b -(100-c)/(b*b)+ e + x   - signed
        ;   a-word; b,c-byte; e-doubleword; x-qword
        
        mov al, [b]
        imul byte [b]    
        mov bx, ax      ;BX = (b*b)
        
        mov al, 100
        sub al, byte [c]   
        cbw
        cwd             ;DX:AX = 100-c
              
        idiv bx         ;AX = (100-c)/(b*b)

        ; convert and save in cx:bx
        cwd
        mov cx, dx
        mov bx, ax
        
        
        mov al, [b]
        cbw   
        imul word [a]   ;DX:AX = a*b
        
        sub ax, bx      ;DX:AX = a*b - (100-c)/(b*b)
        sbb dx, cx      
        
        add ax, word [e]    ;DX:AX = a*b-(100-c)/(b*b) + e
        adc dx, word [e+2]  
        
        ;move dword dx:ax in eax
        push dx
        push ax
        pop eax
        
        
        cdq ; convert to quadword
        add eax, dword [x]      ;EDX:EAX = a*b-(100-c)/(b*b)+e + x
        adc edx, dword [x+4]  
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

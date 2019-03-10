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
        ;d-a+c+c-b+a     - signed
        
        mov ebx, dword [d]      ;ecx:ebx = d
        mov ecx, dword [d+4]
        
        ;convert 'a' from byte to quad
        mov al, [a]
        cbw
        cwde
        cdq
        
        sub ebx, eax    ;ECX:EBX = d-a
        sbb ecx, edx
        
        ;convert 'c' to quad
        mov eax, [c]
        cdq
        
        add ebx, eax    ;ECX:EBX = d-a + c
        adc ecx, edx
        
        
        add ebx, eax    ;ECX:EBX = d-a+c + c
        adc ecx, edx
        
        ;convert 'b' to quad
        mov ax, [b]
        cwde
        cdq
        
        sub ebx, eax    ;ECX:EBX = d-a+c+c - b
        sbb ecx, edx
        
        ;convert 'a' from byte to quad
        mov al, [a]
        cbw
        cwde
        cdq
        
        add ebx, eax    ;ECX:EBX = d-a+c+c-b + a
        adc ecx, edx 
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

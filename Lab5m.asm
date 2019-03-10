bits 32

global start

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class = data
    
    s1 db 1,2,3,4,5,6
    s2 db 5,6,7,8,9,10
    l equ $-s1
    d times l db 0

segment code use32 class=code

; Two byte strings S1 and S2 of the same length are given. Obtain the string D 
; where each element is the sum of the corresponding elements from S1 and S2 
start:
    mov ecx, l
    mov esi, 0
    jecxz sfarsit
    repeta:
        mov al, [s1+esi]
        add al, byte [s2+esi]       
        
        mov [d+esi], al
        inc esi
    loop repeta    
    
    sfarsit:
    push dword 0
    call [exit]
    
;read numbers until 0 is given and print the minimum

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit             ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

extern scanf, printf                           
import scanf msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    n dd 0 
    min1 dd 0FFFFh ;the result will be stored here
    
    read db '%d', 0 
    print db "Min: %d", 0
    
; our code starts here
segment code use32 class=code   
start:
    read_until_zero:
        
        ;Read a number
        push dword n
        push dword read
        call [scanf]
        add esp, 4 * 2
        
        ;If its 0 then we stop the reading.
        cmp dword [n], 0
        je sfarsit
        
        ;Check if we found a new minimum, then jump to minFound
        mov eax, [n]
        cmp eax, [min1]
        jl minFound
        jmp read_until_zero
        
        minFound:
            mov eax, [n]
            mov dword [min1], eax
            jmp read_until_zero

    sfarsit: 
    push dword [min1]
    push dword print
    call [printf]
    add esp, 4 * 2
    
    push dword 0
    call [exit]
    
    
    
    
    
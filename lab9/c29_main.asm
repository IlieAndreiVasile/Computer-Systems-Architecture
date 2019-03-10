bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, gets, printf              
import exit msvcrt.dll    
import printf msvcrt.dll
import gets msvcrt.dll
                          
;%include "c29_reverseWords.asm"
extern reverseWords

segment data use32 public data
    s resb 35  
    writeFormat db "%s ", 0

    
segment code use32 class=code
start:
    ;We read the entire line!
    ;gets(s)
    push dword s
    call [gets]
    add esp, 4    
    
    ;Call another module.
    ;Address of the resulted string will be in eax.
    push dword s
    call reverseWords

    ;print the result
    push dword eax
    push dword writeFormat
    call [printf]
    add esp, 4*2
    
    push    dword 0      ; push the parameter for exit onto the stack
    call    [exit]       ; call exit to terminate the program

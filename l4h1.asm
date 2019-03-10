bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0111011101010111b
    b dw 1001101110111110b
    c dd 0  
    
; our code starts here
segment code use32 class=code
    start:
        ;Given the words A and B, compute the doubleword C as follows:
        ;the bits 0-4 of C are the same as the bits 11-15 of A
        ;the bits 5-11 of C have the value 1
        ;the bits 12-15 of C are the same as the bits 8-11 of B
        ;the bits 16-31 of C are the same as the bits of A
        
        
        mov  bx, 0 ; we compute the result in bx

        mov  ax, [a] ; we isolate bits 11-15 of A
        and  ax, 1111100000000000b
        mov  cl, 11
        ror  ax, cl ; we rotate 11 positions to the right
        or   bx, ax ; we put the bits into bx
        
        or   bx, 0000111111100000b ; we force the value of bits 5-11 of the result to the value 1
        
		mov  ax, [b] ; we isolate bits 8-11 of B
		and  ax, 0000111100000000b
		mov  cl, 4
		rol  ax, cl ; we rotate 4 positions to the left
		or   bx, ax ; we put the bits into bx
		mov  ax, bx

		mov  dx, [a]
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

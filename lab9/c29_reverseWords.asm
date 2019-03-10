bits 32 ; assembling for the 32 bits architecture


; our data is declared here (the variables needed by our program)
segment data use32 public data
    
    c1 resq 1   ;this keeps the address where last word ended
    c2 dd 0     ;Parses each word
    over db 0   ;When it becomes 1 we stop the main loop
    
    rez db 35

; our code starts here
segment code use32 public code
global reverseWords

reverseWords:
    ;eax is the address of the input string 's'
    mov eax, [esp+4]
    mov [c1], eax   ;c1 is initialised with the address of 's'
    
    mov esi, eax
    mov edi, rez
    ;We iterate each character
    repeta1:
        ;Load in AL each character of the string
        lodsb
        
        ;0 denotes the end of the string 's'
        cmp al, 0
        je stopIt
        
        ;We encountered an empty space, we parse in reverse until address pointed by c1 is reached
        cmp al, 32     
        je emptySpace
        jmp repeta1
        
        ;It is a character
        stopIt:
            mov byte [over], 1
            jmp emptySpace
            
        ;Empty space means we ended a word and must reverse it
        ;Called also if end of line is reached, then after the label finishes we go to 'sfarsit'
        emptySpace:
            mov dword [c2], esi
            dec dword [c2]
            
            ;Loop backwards each word
            repeta2:
            dec dword [c2]
            mov eax, [c2]
            mov al, [eax]   ;Move to AL the current character
            
            stosb   ;Store in rez the current character
            
            ;Check if we are at address 'c1'. If yes, then stop the loop.
            mov eax, [c2]    
            cmp eax, [c1]
            jne repeta2
            
            mov byte [edi], 32
            inc edi
            
            mov dword [c1], esi ;move c1 to the beggining of the next word
            
            cmp byte [over], 1
            je sfarsit
            
            jmp repeta1
    
    ;End of module
    sfarsit:
    dec edi
    mov byte [edi], 0
    mov eax, rez    ;Return parameter
    ret 4
    
    
    
; A file name (defined in data segment) is given. Create a file with the given name, then read words from the 
; keyboard until character '$' is read from the keyboard. Write only the words that contain at least one digit 
; to file.

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit             ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

extern fopen, scanf, fprintf, printf, fclose
import fclose msvcrt.dll
import printf msvcrt.dll                      
import fopen msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    
    cuvant resb 20
    fileName db 'text.txt', 0
    
    fileDescriptor dd -1    ;-1 because 0 represents error in opening a file
    
    citire db "%s", 0   ;string format 
    inputFormat db 'w', 0  
    writeFormat db "%s", 10, 0 
    
; our code starts here
segment code use32 class=code


start:
    push dword inputFormat
    push dword fileName
    call [fopen]  
    add esp, 4*2
    
    ;If error go to end
    ;If an error occurs, EAX will be set to 0
    cmp eax, 0
    je sfarsit
    mov [fileDescriptor], eax 
    
    repeta:
        ;we read a word from keyboard and store it in 'cuvant'
        ;scanf("%s", cuvant)
        push dword cuvant
        push dword citire
        call [scanf]
        add esp, 4*2
        
        ;Is cuvant = '$' Then Stop
        mov al, [cuvant]   
        cmp al, 36
        je sfarsit
        
        ;Iterate the word and check each character
        mov esi, cuvant
        repeta1:
        lodsb   ; al <- cuvant[i] 
        
        ;if its 0, end of string, we read another word
        cmp al, 0
        je repeta
        
        ;Begin the process of checking if it's a digit
        ;ASCII works with unsigned decimals so we use 'above' and 'below'
        cmp al, 48
        jae f1
        jmp repeta1
        
        f1:
            cmp al, 58
            jb f2
            jmp repeta1
            
        ; It's a digit! Write to file
        f2:
            ;fprintf(file_descriptor, format, variables)   - file descriptor as first parameter
            push dword cuvant
            push dword writeFormat
            push dword [fileDescriptor]
            call [fprintf]
            add esp, 4*3
            
            jmp repeta
    
    sfarsit:
    ;We must close the file.
    push dword [fileDescriptor]
    call [fclose]
    add esp, 4*1
    
    push dword 0      ; push the parameter for exit onto the stack
    call [exit]       ; call exit to terminate the program

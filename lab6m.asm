; A string of words is given. Build two strings of bytes, s1 and s2, in the following way: for each word,
; if the number of bits 1 from the high byte of the word is larger than the number of bits 1 from its low byte, then s1 will contain the high byte and s2 will contain the low byte of the word
; if the number of bits 1 from the high byte of the word is equal to the number of bits 1 from its low byte, then s1 will contain the number of bits 1 from the low byte and s2 will contain 0
; otherwise, s1 will contain the low byte and s2 will contain the high byte of the word.start:

bits 32

global start

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class = data
    
    s dw 65535,2
    l equ ($-s)/2
    
    s1 resb l
    s2 resb l
    
    ;these keep the number of ones from each byte
    one1 db 0
    one2 db 0
    
    ;e times l db 10

segment code use32 class=code


start:
    mov ecx, l
    mov esi, s
    mov edi, 0
    
    jecxz sfarsit
    repeta:
        ;========================= LOW BYTE PART =========================
        ;Little Endian Warning!
        
        lodsb   ; al = esi+0 low part , esi = s, inc(esi)
        ;mov al, [s+esi*2+1]
        mov ah, 0
        
        countOnes:
            cmp al, 0
            je low_part

            mov ah, 0
            mov dl, 2
            div byte dl ;ax/dl = al, ax%dl=ah
        
            ;Is the rest '1'?
            cmp ah, 1
            je f
            jne countOnes
        
        ; we found a byte of 1
        f:
           add byte [one2], 1
           jmp countOnes
        
        ; ===================== HIGH BYTE PART ======================
        low_part:
        lodsb   ; al = esi+1, inc(esi)
        ;mov al, [s+esi*2]
        mov ah, 0
        
        countOnes2:
           cmp al, 0
           je compare_results
           
           mov ah, 0
           mov dl, 2
           div byte dl ;ax/dl = al, ax%dl=ah
        
            ;Is it a '1'?
            cmp ah, 1
            je f2
            jne countOnes2
        
          ; we found a byte of 1
        f2:
        
           add byte [one1], 1
           jmp countOnes2
    
    
    ; loop repeta 
    sfarsit:
        jecxz sfarsit1    
        
    compare_results:
            ; Compare the ones from high part and low part.
            ; one1-ones in high part
            ; one2-ones in low part
            dec esi
            dec esi
            mov dl, [one1]
            cmp  dl,  byte [one2]
            jg opt1
            je opt2
            jl opt3
            
            opt1:
                ; partea low
                ; high part in s1
                mov al, [esi+1]
                mov [s1+edi], al
                
                ;low part in s2
                mov al, [esi]
                mov [s2+edi], al
                jmp inc_source
            
            opt2:
                mov al, [one1]
                mov [s1+edi], al
                mov [s2+edi], byte 0
                jmp inc_source
            
            opt3:
                ;high part in s2
                mov al, [esi+1]
                mov [s2+edi], al
                
                ;low part in s1
                mov al, [esi]
                mov [s1+edi], al
                
                jmp inc_source
        
        inc_source:
            mov al, 0
            mov [one1], al
            mov [one2], al
            inc edi
            inc esi
            inc esi
            
            dec ecx
            jecxz sfarsit1
            
        jmp repeta           
  
    sfarsit1:
    push dword 0
    call [exit]
    
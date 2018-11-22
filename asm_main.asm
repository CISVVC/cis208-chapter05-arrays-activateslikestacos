;
; file: asm_main.asm
; author: Christopher Cox
; Desc: This program has a simple subprogram that takes three arguments,
;   a scalar, the array's address, and the size of the array. The
;    function then proceeds to multiply the array by that scalar.
;    Gotta love pointer arithmatic!

%define     ARRAY_SIZE      20
%define     CALL_OFFSET     36


%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
    
    myArray:    dd  1,2,3,4,5,6,7,8,9,10,\
                    11,12,13,14,15,16,17,18,19,20
    
    scalar:     dd  2

; uninitialized data is put in the .bss segment
;
segment .bss

;
; code is put in the .text segment
;
segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
; *********** Start  Assignment Code *******************

    b1:

        ; Load all my arguments onto the stack
        mov     eax, [scalar]
        push    eax

        mov     eax, myArray
        push    eax

        mov     eax, ARRAY_SIZE
        push    eax

        call    SCALE_ARRAY

        ; "pop" the items off the stack

        add     esp, 12
         
; *********** End Assignment Code **********************

        popa
        mov     eax, 0       ; return back to the C program
        leave                     
        ret

; My function for scaling the array
SCALE_ARRAY:

        pusha

            ; arraySize: [esp + 36] is the array size
            ; arrayAddr: [esp + 40] is the array address
            ; scalar:    [esp + 44] is the array scalar

            ; Loop over the array and multiply the scalar
            ; ebx will be our loop counter
            mov     ebx, 0

            WHILE: ; (counter<arraySize)
                cmp     ebx, [esp + 36]
                je      WHILE_END

                ; Generate the offset
                mov     ecx, ebx
                imul    ecx, 4

                ; Offset the address
                add     ecx, [esp + 40]
               
                ; Multiply by scalar at address
                mov     eax, [ecx]
                imul    eax, [esp + 44]
                mov     ecx, eax

                ; Move the new data into ecx
                call    print_int
                call    print_nl
                
                ; Add 1 to ebx for loop count
                add     ebx, 1

                jmp     WHILE

            WHILE_END:

        popa

    ret

section .data
    sensor db 0x03 ; Mock input: 0x03
    motor db 0
    alarm db 0

section .text
    global _start

_start:
    ; Simulate sensor read
    mov al, [sensor]

    ; Decision logic
    cmp al, 3
    je high_level
    cmp al, 2
    je moderate_level
    jmp low_level

high_level:
    mov byte [alarm], 1
    jmp exit

moderate_level:
    mov byte [motor], 0
    jmp exit

low_level:
    mov byte [motor], 1
    jmp exit

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

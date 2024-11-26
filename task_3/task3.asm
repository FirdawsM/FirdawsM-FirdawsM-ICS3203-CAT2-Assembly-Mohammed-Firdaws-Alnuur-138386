section .data
    prompt db "Enter a number to compute factorial: ", 0
    result db "Factorial: ", 0

section .bss
    num resb 4

section .text
    global _start

_start:
    ; Input a number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 32
    int 0x80

    ; Mock input of 5 for simplicity
    mov dword [num], 5

    ; Call factorial subroutine
    mov eax, [num]
    push eax
    call factorial
    add esp, 4

    ; Print result (mock single-digit result)
    add eax, 48
    mov [result + 10], al
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 12
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

factorial:
    ; Compute factorial using recursion
    cmp eax, 1
    jle factorial_end
    push eax
    dec eax
    call factorial
    pop ebx
    mul ebx
factorial_end:
    ret

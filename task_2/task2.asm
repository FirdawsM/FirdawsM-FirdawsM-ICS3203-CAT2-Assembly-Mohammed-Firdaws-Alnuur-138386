section .data
    prompt db "Enter 5 numbers separated by spaces: ", 0
    result db "Reversed array: ", 0
    space db " ", 0

section .bss
    array resd 5

section .text
    global _start

_start:
    ; Prompt user
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 32
    int 0x80

    ; Read input (mocking array initialization for simplicity)
    mov dword [array], 1
    mov dword [array + 4], 2
    mov dword [array + 8], 3
    mov dword [array + 12], 4
    mov dword [array + 16], 5

    ; Reverse the array
    mov ecx, 0
    mov edx, 4
reverse:
    cmp ecx, edx
    jge reversed
    ; Swap array[ecx] and array[edx]
    mov eax, [array + ecx * 4]
    mov ebx, [array + edx * 4]
    mov [array + ecx * 4], ebx
    mov [array + edx * 4], eax
    inc ecx
    dec edx
    jmp reverse

reversed:
    ; Output reversed array
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 17
    int 0x80
    xor ecx, ecx
output_loop:
    cmp ecx, 5
    jge done
    mov eax, [array + ecx * 4]
    ; Output each number (mock printing single-digit numbers)
    add eax, 48
    mov [space], al
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80
    inc ecx
    jmp output_loop

done:
    mov eax, 1
    xor ebx, ebx
    int 0x80

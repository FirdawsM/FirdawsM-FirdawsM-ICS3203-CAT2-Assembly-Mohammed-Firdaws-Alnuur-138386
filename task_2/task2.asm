section .data
    prompt db "Enter 5 numbers separated by spaces: ", 0  ; Prompt message to ask for input
    result db "Reversed array: ", 0                       ; Message to show before printing the reversed array
    space db " ", 0                                       ; Space character to separate numbers when printing

section .bss
    array resd 5                 ; Reserve space for 5 integers (array of 5 elements)

section .text
    global _start                 ; Define entry point of the program

_start:
    ; Prompt the user to enter numbers
    mov eax, 4                    ; sys_write system call (write to stdout)
    mov ebx, 1                    ; file descriptor 1 (stdout)
    mov ecx, prompt               ; address of prompt message
    mov edx, 32                   ; length of prompt message (including null terminator)
    int 0x80                      ; make the system call to write the prompt to stdout

    ; Read input (mocking array initialization for simplicity)
    ; In a real case, you would read the user input here, but we are directly initializing the array
    mov dword [array], 1          ; Set array[0] = 1
    mov dword [array + 4], 2      ; Set array[1] = 2
    mov dword [array + 8], 3      ; Set array[2] = 3
    mov dword [array + 12], 4     ; Set array[3] = 4
    mov dword [array + 16], 5     ; Set array[4] = 5

    ; Reverse the array
    mov ecx, 0                    ; ecx = 0 (start index)
    mov edx, 4                    ; edx = 4 (end index, array length - 1)
reverse:
    cmp ecx, edx                  ; compare ecx (start index) with edx (end index)
    jge reversed                  ; if ecx >= edx, jump to reversed (done)
    ; Swap array[ecx] and array[edx]
    mov eax, [array + ecx * 4]    ; load array[ecx] into eax
    mov ebx, [array + edx * 4]    ; load array[edx] into ebx
    mov [array + ecx * 4], ebx    ; store value of ebx into array[ecx]
    mov [array + edx * 4], eax    ; store value of eax into array[edx]
    inc ecx                       ; increment ecx (move towards the center of the array)
    dec edx                       ; decrement edx (move towards the center of the array)
    jmp reverse                   ; repeat the process (go back to reversing)

reversed:
    ; Output the reversed array
    mov eax, 4                    ; sys_write system call (write to stdout)
    mov ebx, 1                    ; file descriptor 1 (stdout)
    mov ecx, result               ; address of result message
    mov edx, 17                   ; length of result message (excluding null terminator)
    int 0x80                      ; make the system call to write the result message to stdout

    xor ecx, ecx                  ; clear ecx (used as array index for output)
output_loop:
    cmp ecx, 5                    ; check if we have printed 5 numbers
    jge done                       ; if ecx >= 5, exit the loop
    mov eax, [array + ecx * 4]    ; load array[ecx] into eax
    ; Convert the number to ASCII (assuming single-digit numbers here)
    add eax, 48                   ; convert the integer to ASCII by adding '0' (48 in decimal)
    mov [space], al               ; store the ASCII character in space (buffer for output)
    mov eax, 4                    ; sys_write system call (write to stdout)
    mov ebx, 1                    ; file descriptor 1 (stdout)
    mov ecx, space                ; address of space buffer
    mov edx, 1                    ; length of output (1 character)
    int 0x80                      ; make the system call to write the ASCII character to stdout
    inc ecx                        ; increment ecx to print the next element in the array
    jmp output_loop               ; repeat the loop to print all numbers

done:
    ; Exit the program
    mov eax, 1                    ; sys_exit system call
    xor ebx, ebx                  ; return code 0 (exit successfully)
    int 0x80                      ; make the system call to exit the program

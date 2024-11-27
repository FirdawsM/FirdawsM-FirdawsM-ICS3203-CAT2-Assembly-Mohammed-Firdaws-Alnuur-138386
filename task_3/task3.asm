section .data
    prompt db "Enter a number to compute factorial: ", 0  ; Prompt message to ask for input
    result db "Factorial: ", 0                             ; Message to display before the factorial result

section .bss
    num resb 4                    ; Reserve space for 4 bytes (enough for a number input)

section .text
    global _start                 ; Define entry point of the program

_start:
    ; Input a number from the user
    mov eax, 4                    ; sys_write system call (write to stdout)
    mov ebx, 1                    ; file descriptor 1 (stdout)
    mov ecx, prompt               ; address of prompt message
    mov edx, 32                   ; length of prompt message (including null terminator)
    int 0x80                      ; make the system call to display the prompt

    ; Mock input of 5 for simplicity (simulating user input)
    mov dword [num], 5            ; set the number to 5

    ; Call factorial subroutine
    mov eax, [num]                ; move the value of num into eax (argument for factorial)
    push eax                       ; push the number onto the stack (used for recursion)
    call factorial                ; call the factorial subroutine
    add esp, 4                     ; clean up the stack (remove the argument)

    ; Print the result (mock single-digit result)
    add eax, 48                    ; convert the factorial result to ASCII (assuming single-digit result)
    mov [result + 10], al          ; store the result in the `result` message buffer
    mov eax, 4                     ; sys_write system call (write to stdout)
    mov ebx, 1                     ; file descriptor 1 (stdout)
    mov ecx, result                ; address of result message
    mov edx, 12                    ; length of result message (including the result digit)
    int 0x80                       ; make the system call to print the result

    ; Exit the program
    mov eax, 1                     ; sys_exit system call
    xor ebx, ebx                   ; return code 0 (successful exit)
    int 0x80                       ; make the system call to exit the program

factorial:
    ; Compute factorial using recursion
    cmp eax, 1                     ; compare eax with 1 (base case)
    jle factorial_end              ; if eax <= 1, jump to factorial_end (base case)
    push eax                       ; save the current value of eax (argument for recursion)
    dec eax                        ; decrement eax (n-1 for factorial of n)
    call factorial                 ; recursive call to factorial
    pop ebx                        ; restore the previous value of eax into ebx
    mul ebx                        ; multiply eax (current result) by ebx (previous argument)
factorial_end:
    ret                            ; return from the factorial subroutine

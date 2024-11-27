
section .data
    prompt db "Enter a number: ", 0         ; Message to prompt the user for input
    positive_msg db "The number is POSITIVE.", 0  ; Message for positive number
    negative_msg db "The number is NEGATIVE.", 0  ; Message for negative number
    zero_msg db "The number is ZERO.", 0        ; Message for zero

section .bss
    user_input resb 10             ; Reserve 10 bytes for user input buffer

section .text
    global _start                 ; Define entry point of the program

_start:
    ; Prompt user for input
    mov rax, 1                    ; sys_write system call
    mov rdi, 1                    ; file descriptor 1 (stdout)
    mov rsi, prompt               ; address of prompt message
    mov rdx, 15                   ; length of prompt message (including null terminator)
    syscall                       ; make the system call to write the prompt to stdout

    ; Read user input
    mov rax, 0                    ; sys_read system call
    mov rdi, 0                    ; file descriptor 0 (stdin)
    mov rsi, user_input           ; buffer to store user input
    mov rdx, 10                   ; maximum input length (10 characters)
    syscall                       ; make the system call to read input

    ; Convert input to integer (ASCII to integer conversion)
    mov rsi, user_input           ; address of user input string
    call atoi                     ; call atoi function to convert ASCII input to integer
    mov rbx, rax                  ; store the result in rbx

    ; Classify the number (positive, negative, or zero)
    cmp rbx, 0                    ; compare the number with zero
    jl negative                   ; if less than 0, jump to negative label
    je zero                       ; if equal to 0, jump to zero label
    jmp positive                  ; if greater than 0, jump to positive label

negative:
    ; Print "NEGATIVE" message
    mov rax, 1                    ; sys_write system call
    mov rdi, 1                    ; file descriptor 1 (stdout)
    mov rsi, negative_msg         ; address of negative_msg
    mov rdx, 23                   ; length of negative_msg (excluding null terminator)
    syscall                       ; make the system call to write the negative message to stdout
    jmp exit                      ; jump to exit label

zero:
    ; Print "ZERO" message
    mov rax, 1                    ; sys_write system call
    mov rdi, 1                    ; file descriptor 1 (stdout)
    mov rsi, zero_msg             ; address of zero_msg
    mov rdx, 18                   ; length of zero_msg (excluding null terminator)
    syscall                       ; make the system call to write the zero message to stdout
    jmp exit                      ; jump to exit label

positive:
    ; Print "POSITIVE" message
    mov rax, 1                    ; sys_write system call
    mov rdi, 1                    ; file descriptor 1 (stdout)
    mov rsi, positive_msg         ; address of positive_msg
    mov rdx, 21                   ; length of positive_msg (excluding null terminator)
    syscall                       ; make the system call to write the positive message to stdout

exit:
    ; Exit program
    mov rax, 60                   ; sys_exit system call
    xor rdi, rdi                  ; set return code 0 (successful exit)
    syscall                       ; make the system call to exit the program

; Subroutine to convert ASCII to integer (atoi)
atoi:
    xor rax, rax                  ; clear rax (used for result)
    xor rcx, rcx                  ; clear rcx (used for sign flag)
atoi_loop:
    movzx rdx, byte [rsi]         ; load the byte from the input string
    cmp rdx, '-'                  ; check if the byte is the negative sign
    je atoi_set_sign              ; if negative sign, jump to atoi_set_sign
    cmp rdx, 10                   ; check if the byte is a newline (end of input)
    je atoi_done                  ; if newline, end conversion
    sub rdx, '0'                  ; convert ASCII character to integer (subtract '0' to get the digit)
    imul rax, rax, 10             ; multiply result by 10 (shift left by one decimal place)
    add rax, rdx                  ; add the current digit to result
    inc rsi                       ; move to the next character in the input string
    jmp atoi_loop                 ; continue loop

atoi_set_sign:
    inc rsi                       ; skip the negative sign
    mov rcx, 1                    ; set the sign flag to 1 (indicating negative number)
    jmp atoi_loop                 ; continue conversion loop

atoi_done:
    test rcx, rcx                 ; check if sign flag is set
    jz atoi_return                ; if not set, skip negating the result
    neg rax                       ; negate the result if negative
atoi_return:
    ret                           ; return from the atoi function

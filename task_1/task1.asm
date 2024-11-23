section .data
    prompt db "Enter a number: ", 0
    positive_msg db "The number is POSITIVE.", 0
    negative_msg db "The number is NEGATIVE.", 0
    zero_msg db "The number is ZERO.", 0

section .bss
    user_input resb 10

section .text
    global _start

_start:
    ; Prompt user for input
    mov rax, 1                 ; sys_write
    mov rdi, 1                 ; stdout
    mov rsi, prompt            ; address of prompt
    mov rdx, 15                ; length of prompt
    syscall

    ; Read user input
    mov rax, 0                 ; sys_read
    mov rdi, 0                 ; stdin
    mov rsi, user_input        ; buffer to store input
    mov rdx, 10                ; maximum input length
    syscall

    ; Convert input to integer
    mov rsi, user_input        ; address of user input
    call atoi                  ; convert ASCII to integer
    mov rbx, rax               ; store result in rbx

    ; Classify the number
    cmp rbx, 0
    jl negative                ; jump if less than 0
    je zero                    ; jump if equal to 0
    jmp positive               ; unconditional jump for positive

negative:
    ; Print "NEGATIVE"
    mov rax, 1                 ; sys_write
    mov rdi, 1                 ; stdout
    mov rsi, negative_msg      ; address of negative_msg
    mov rdx, 23                ; length of negative_msg
    syscall
    jmp exit                   ; jump to exit

zero:
    ; Print "ZERO"
    mov rax, 1                 ; sys_write
    mov rdi, 1                 ; stdout
    mov rsi, zero_msg          ; address of zero_msg
    mov rdx, 18                ; length of zero_msg
    syscall
    jmp exit                   ; jump to exit

positive:
    ; Print "POSITIVE"
    mov rax, 1                 ; sys_write
    mov rdi, 1                 ; stdout
    mov rsi, positive_msg      ; address of positive_msg
    mov rdx, 21                ; length of positive_msg
    syscall

exit:
    ; Exit program
    mov rax, 60                ; sys_exit
    xor rdi, rdi               ; return code 0
    syscall

; Subroutine to convert ASCII to integer
atoi:
    xor rax, rax               ; clear rax (result)
    xor rcx, rcx               ; clear rcx (sign)
atoi_loop:
    movzx rdx, byte [rsi]      ; load byte from string
    cmp rdx, '-'               ; check for negative sign
    je atoi_set_sign
    cmp rdx, 10                ; check for newline
    je atoi_done
    sub rdx, '0'               ; convert ASCII to digit
    imul rax, rax, 10          ; multiply result by 10
    add rax, rdx               ; add digit to result
    inc rsi                    ; move to next character
    jmp atoi_loop

atoi_set_sign:
    inc rsi                    ; skip sign
    mov rcx, 1                 ; set sign flag
    jmp atoi_loop

atoi_done:
    test rcx, rcx              ; check if sign flag is set
    jz atoi_return
    neg rax                    ; negate result if negative
atoi_return:
    ret

section .data
    prompt db "Enter a number: ", 0
    prompt_len equ $-prompt
    result_msg db "Factorial: ", 0
    result_msg_len equ $-result_msg
    buffer resb 20           ; Buffer to store the ASCII representation of the result

section .bss
    num resb 1               ; Buffer to store input number
    factorial resq 1         ; Space to store the result (64-bit)

section .text
    global _start

_start:
    ; Prompt the user for input
    mov rax, 1               ; sys_write
    mov rdi, 1               ; File descriptor: stdout
    mov rsi, prompt          ; Address of prompt
    mov rdx, prompt_len      ; Length of prompt
    syscall                  ; System call

    ; Read input from the user
    mov rax, 0               ; sys_read
    mov rdi, 0               ; File descriptor: stdin
    mov rsi, num             ; Address to store input
    mov rdx, 1               ; Read 1 byte (single digit)
    syscall                  ; System call

    ; Convert ASCII to integer
    movzx rax, byte [num]    ; Load input into RAX
    sub rax, '0'             ; Convert ASCII to integer
    mov rbx, rax             ; Save the number in RBX

    ; Call the factorial subroutine
    push rbx                 ; Push the number onto the stack
    call factorial_calc      ; Call the subroutine
    add rsp, 8               ; Clean up the stack

    ; Print the result message
    mov rax, 1               ; sys_write
    mov rdi, 1               ; File descriptor: stdout
    mov rsi, result_msg      ; Address of message
    mov rdx, result_msg_len  ; Length of message
    syscall                  ; System call

    ; Print the factorial result
    mov rsi, buffer          ; Address of buffer
    mov rdi, [factorial]     ; Load the result into RDI
    call int_to_ascii        ; Convert the result to ASCII string
    mov rax, 1               ; sys_write
    mov rdi, 1               ; File descriptor: stdout
    mov rdx, 20              ; Maximum bytes to write
    syscall                  ; Write to stdout

    ; Exit the program
    mov rax, 60              ; sys_exit
    xor rdi, rdi             ; Exit code 0
    syscall                  ; System call

factorial_calc:
    ; Calculate factorial of the number in RBX
    mov rax, 1               ; Initialize result in RAX
    cmp rbx, 0               ; Check if input is 0
    je .done                 ; If 0, result is 1

.loop:
    mul rbx                  ; Multiply RAX by RBX
    dec rbx                  ; Decrement RBX
    jnz .loop                ; Repeat until RBX = 0

.done:
    mov [factorial], rax     ; Store the result in memory
    ret                      ; Return to caller

int_to_ascii:
    ; Convert integer (RDI) to ASCII string in buffer (RSI)
    xor rcx, rcx             ; Clear RCX (digit counter)
    mov rbx, 10              ; Base 10 for conversion
    xor rdx, rdx             ; Clear RDX (remainder)

.convert_loop:
    div rbx                  ; Divide RDI by 10, quotient in RDI, remainder in RDX
    add dl, '0'              ; Convert remainder to ASCII
    mov [rsi + rcx], dl      ; Store character in buffer
    inc rcx                  ; Increment counter
    test rdi, rdi            ; Check if quotient is 0
    jnz .convert_loop        ; Repeat if quotient is not 0

    ; Reverse the string in buffer
    mov rax, rcx             ; Get the number of digits
    dec rax                  ; Decrement to last digit index
.reverse_loop:
    mov dl, [rsi + rax]      ; Load character from buffer
    mov [rsi + rcx - 1], dl  ; Place it in the reverse position
    dec rax                  ; Move to previous digit
    dec rcx                  ; Move the pointer for reverse index
    jns .reverse_loop        ; Repeat if still within bounds
    ret                      ; Return to caller

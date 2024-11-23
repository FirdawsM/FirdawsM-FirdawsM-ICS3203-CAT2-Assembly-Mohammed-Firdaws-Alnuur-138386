section .data
    prompt db "Enter 5 integers separated by spaces: ", 0
    prompt_len equ $-prompt
    msg db "Reversed array: ", 0Ah
    msg_len equ $-msg

section .bss
    array resb 10         ; Reserve more space for input (10 bytes)
    array resb 5       ; Array to store 5 parsed integers    
    temp resb 1           ; Temporary variable for swapping

section .text
    global _start

_start:
    ; Prompt the user for input
    mov rax, 1            ; sys_write (64-bit)
    mov rdi, 1            ; File descriptor: stdout
    mov rsi, prompt       ; Address of prompt
    mov rdx, prompt_len   ; Length of the prompt
    syscall               ; Make system call

    ; Read input from the user
    mov rax, 0            ; sys_read (64-bit)
    mov rdi, 0            ; File descriptor: stdin
    mov rsi, array        ; Address to store input
    mov rdx, 10            ; Max number of integers (bytes)
    syscall               ; Make system call

    ; Set up pointers
    lea rsi, [array]      ; Start of the array
    lea rdi, [array + 4]  ; End of the array (offset by 4 for 5 bytes)

reverse_loop:
    cmp rsi, rdi          ; Check if pointers have crossed
    jge reverse_done      ; Exit loop if complete

    ; Swap elements at RSI and RDI
    mov al, [rsi]         ; Load value at RSI into AL
    mov [temp], al        ; Save AL into temp
    mov al, [rdi]         ; Load value at RDI into AL
    mov [rsi], al         ; Store AL at RSI
    mov al, [temp]        ; Load temp back into AL
    mov [rdi], al         ; Store AL at RDI

    ; Move pointers
    inc rsi               ; Move forward
    dec rdi               ; Move backward
    jmp reverse_loop      ; Repeat

reverse_done:
    ; Print the reversed array
    mov rax, 1            ; sys_write (64-bit)
    mov rdi, 1            ; File descriptor: stdout
    mov rsi, msg          ; Address of message
    mov rdx, msg_len      ; Length of message
    syscall               ; Make system call

    ; Output each element
    lea rsi, [array]      ; Reset pointer to start of array
    mov rcx, 5            ; Loop counter

print_loop:
    movzx rax, byte [rsi] ; Load current byte and zero-extend to RAX
    add al, '0'           ; Convert number to ASCII
    mov [temp], al        ; Store in temp for syscall
    mov rax, 1            ; sys_write (64-bit)
    mov rdi, 1            ; File descriptor: stdout
    lea rsi, [temp]       ; Address of ASCII character
    mov rdx, 1            ; Write one byte
    syscall               ; Make system call

    inc rsi               ; Move to next element
    loop print_loop       ; Continue loop

    ; Exit the program
    mov rax, 60           ; sys_exit (64-bit)
    xor rdi, rdi          ; Exit code 0
    syscall               ; Make system call

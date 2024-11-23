section .data
    msg_sensor db "Sensor value: ", 0
    msg_motor_on db "Motor ON", 0
    msg_motor_off db "Motor OFF", 0
    msg_alarm_on db "Alarm ON", 0
    msg_alarm_off db "Alarm OFF", 0
    msg_newline db 0Ah, 0

section .bss
    sensor_value resb 1     ; 1 byte to store the sensor value
    motor_control resb 1    ; 1 byte to store motor state (0: off, 1: on)
    alarm_status resb 1     ; 1 byte to store alarm state (0: off, 1: on)

section .text
    global _start

_start:
    ; Initialize motor and alarm to OFF
    mov byte [motor_control], 0     ; Motor OFF
    mov byte [alarm_status], 0      ; Alarm OFF

    ; Simulate sensor value (for example, 0x05)
    mov byte [sensor_value], 0x05   ; Set sensor value (simulating water level)

    ; Print the sensor value
    mov eax, 4            ; sys_write
    mov ebx, 1            ; File descriptor: stdout
    mov ecx, msg_sensor   ; Message: "Sensor value: "
    mov edx, 14           ; Length of the message
    int 0x80              ; System call

    ; Print the sensor value (as hexadecimal for clarity)
    mov al, [sensor_value]   ; Load sensor value into AL
    call print_hex           ; Call subroutine to print the value in hex

    ; Check sensor value and decide actions

    mov al, [sensor_value]   ; Load sensor value again
    cmp al, 0x03             ; Compare sensor value to 0x03 (moderate level)
    jl motor_on              ; If less, turn motor ON

    cmp al, 0x06             ; Compare sensor value to 0x06 (high level)
    jge alarm_on             ; If greater or equal, trigger alarm

motor_on:
    ; Turn on motor
    mov byte [motor_control], 1    ; Set motor control to ON (1)
    mov eax, 4                    ; sys_write
    mov ebx, 1                    ; File descriptor: stdout
    mov ecx, msg_motor_on         ; Message: "Motor ON"
    mov edx, 9                     ; Length of the message
    int 0x80                       ; System call
    jmp exit_program

alarm_on:
    ; Trigger alarm
    mov byte [alarm_status], 1    ; Set alarm status to ON (1)
    mov eax, 4                    ; sys_write
    mov ebx, 1                    ; File descriptor: stdout
    mov ecx, msg_alarm_on         ; Message: "Alarm ON"
    mov edx, 9                     ; Length of the message
    int 0x80                       ; System call
    jmp exit_program

exit_program:
    ; Exit the program
    mov eax, 1                    ; sys_exit
    xor ebx, ebx                  ; Exit code 0
    int 0x80                       ; System call

print_hex:
    ; Print AL as hexadecimal
    ; Convert AL to hex and print
    mov bl, al            ; Copy AL to BL
    shr bl, 4             ; Shift to get the high nibble
    and bl, 0x0F          ; Mask to get the low nibble
    call print_digit      ; Print high nibble
    mov bl, al            ; Copy AL again
    and bl, 0x0F          ; Mask to get the low nibble
    call print_digit      ; Print low nibble
    ret

print_digit:
    add bl, '0'           ; Convert digit to ASCII
    cmp bl, '9'           ; Check if the digit is a letter
    jg print_letter       ; If greater than '9', it's a letter (A-F)
    mov dl, bl            ; Store digit to DL
    mov eax, 4            ; sys_write
    mov ebx, 1            ; File descriptor: stdout
    mov ecx, esp          ; Address of the digit
    mov edx, 1            ; Length of the message
    int 0x80              ; System call
    ret

print_letter:
    add bl, 7             ; Convert to letter (A-F)
    mov dl, bl            ; Store letter to DL
    mov eax, 4            ; sys_write
    mov ebx, 1            ; File descriptor: stdout
    mov ecx, esp          ; Address of the letter
    mov edx, 1            ; Length of the message
    int 0x80              ; System call
    ret

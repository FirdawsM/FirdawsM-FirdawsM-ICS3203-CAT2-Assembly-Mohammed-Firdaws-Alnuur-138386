section .data
    sensor db 0x03  ; Mock input: 0x03 (simulating the sensor value)
    motor db 0      ; Motor status (0 for OFF, 1 for ON)
    alarm db 0      ; Alarm status (0 for OFF, 1 for ON)

section .text
    global _start   ; Define the entry point of the program

_start:
    ; Simulate sensor read
    mov al, [sensor]    ; Load the value of the sensor into the AL register

    ; Decision logic based on sensor value
    cmp al, 3           ; Compare the sensor value (AL) with 3
    je high_level       ; If equal to 3, jump to the high_level label
    cmp al, 2           ; Compare the sensor value (AL) with 2
    je moderate_level   ; If equal to 2, jump to the moderate_level label
    jmp low_level       ; If the value is neither 3 nor 2, jump to low_level

high_level:
    mov byte [alarm], 1 ; Set alarm to 1 (ON) when the sensor is at a high level
    jmp exit            ; Jump to the exit point

moderate_level:
    mov byte [motor], 0 ; Set motor to 0 (OFF) when the sensor is at a moderate level
    jmp exit            ; Jump to the exit point

low_level:
    mov byte [motor], 1 ; Set motor to 1 (ON) when the sensor is at a low level
    jmp exit            ; Jump to the exit point

exit:
    mov eax, 1          ; sys_exit system call (exit the program)
    xor ebx, ebx        ; Return code 0 (indicating successful termination)
    int 0x80            ; Trigger the system call to exit the program

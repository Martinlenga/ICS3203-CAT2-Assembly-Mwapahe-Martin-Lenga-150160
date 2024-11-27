section .data
    message_motor_on db "Motor is ON", 0   ; Message to indicate motor is on
    message_motor_off db "Motor is OFF", 0  ; Message to indicate motor is off
    message_alarm_on db "Alarm is ON", 0    ; Message to indicate alarm is on
    message_alarm_off db "Alarm is OFF", 0  ; Message to indicate alarm is off
    newline db 0x0A   ; Newline character for formatting

section .bss
    sensor_value resb 1      ; 1 byte for storing sensor value

section .text
    global _start

_start:
    ; Simulate reading the sensor value from a memory location
    ; For this example, set a sample sensor value
    mov byte [sensor_value], 80  ; Simulate high water level (80)

    ; Load the sensor value into a register (e.g., eax)
    mov al, [sensor_value]

    ; Perform actions based on sensor value
    cmp al, 75                ; Compare sensor value with 75
    jge high_water_level      ; If sensor value >= 75, go to high_water_level

    cmp al, 30                ; Compare sensor value with 30
    jge moderate_water_level  ; If sensor value >= 30 and < 75, go to moderate_water_level

    ; If the sensor value is below 30, it's considered low water level
    ; Action: Turn the motor on and turn the alarm off
    call motor_on
    call alarm_off
    jmp end_program

high_water_level:
    ; If the sensor value is high, trigger the alarm
    call motor_off
    call alarm_on
    jmp end_program

moderate_water_level:
    ; If the sensor value is moderate, stop the motor
    call motor_off
    call alarm_off
    jmp end_program

motor_on:
    ; Print "Motor is ON"
    mov eax, 4                ; syscall number for sys_write
    mov ebx, 1                ; file descriptor (1 = stdout)
    lea ecx, [message_motor_on]  ; load address of message
    mov edx, 13               ; length of message "Motor is ON"
    int 0x80                  ; syscall to write to stdout
    ret

motor_off:
    ; Print "Motor is OFF"
    mov eax, 4                ; syscall number for sys_write
    mov ebx, 1                ; file descriptor (1 = stdout)
    lea ecx, [message_motor_off] ; load address of message
    mov edx, 14               ; length of message "Motor is OFF"
    int 0x80                  ; syscall to write to stdout
    ret

alarm_on:
    ; Print "Alarm is ON"
    mov eax, 4                ; syscall number for sys_write
    mov ebx, 1                ; file descriptor (1 = stdout)
    lea ecx, [message_alarm_on] ; load address of message
    mov edx, 12               ; length of message "Alarm is ON"
    int 0x80                  ; syscall to write to stdout
    ret

alarm_off:
    ; Print "Alarm is OFF"
    mov eax, 4                ; syscall number for sys_write
    mov ebx, 1                ; file descriptor (1 = stdout)
    lea ecx, [message_alarm_off] ; load address of message
    mov edx, 13               ; length of message "Alarm is OFF"
    int 0x80                  ; syscall to write to stdout
    ret

end_program:
    ; Exit the program
    mov eax, 1                ; syscall number for sys_exit
    xor ebx, ebx              ; exit status 0
    int 0x80                  ; make the syscall to exit

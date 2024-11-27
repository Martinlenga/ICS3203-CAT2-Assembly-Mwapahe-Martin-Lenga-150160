section .data
    message db 'The factorial of 6 is: ', 0  ; Message to display
    newline db 0x0A  ; Newline character for formatting

section .bss
    buffer resb 16  ; Buffer to store the result as a string

section .text
    global _start

_start:
    ; Print the message "The factorial of 6 is: "
    mov eax, 4                ; syscall number for sys_write
    mov ebx, 1                ; file descriptor (1 = stdout)
    lea ecx, [message]        ; load address of message
    mov edx, 23               ; length of the message string
    int 0x80                  ; syscall to write to stdout

    ; Calculate the factorial of 6 (6! = 720)
    mov ecx, 6                ; Use ecx to store the number (6)
    call factorial

    ; The result is now in eax
    ; Convert the result to a string
    lea edi, [buffer + 15]    ; Point to the end of the buffer
    mov byte [edi], 0x0A      ; Newline character at the end of the string

    ; Convert eax to string and store it in buffer
    call convert

    ; Write the result to the console
    mov eax, 4                ; syscall number for sys_write
    mov ebx, 1                ; file descriptor (1 = stdout)
    lea ecx, [edi]            ; pointer to the string
    lea edx, [buffer + 16]    ; buffer length (16 bytes)
    sub edx, ecx              ; calculate the length by subtracting addresses
    int 0x80                  ; syscall to write the string

    ; Exit the program
    mov eax, 1                ; syscall number for sys_exit
    xor ebx, ebx              ; exit status 0
    int 0x80                  ; exit

; Factorial function (using a loop instead of recursion)
factorial:
    mov eax, 1                ; Initialize eax to 1 (starting value for multiplication)
    factorial_loop:
        imul eax, ecx         ; eax = eax * ecx (multiply with current value of ecx)
        dec ecx               ; Decrement ecx (move to the next number)
        jnz factorial_loop    ; If ecx is not zero, repeat the loop
    ret

; Convert eax to a string (ASCII digits)
convert:
    dec edi                   ; Move buffer pointer backwards
    xor edx, edx              ; Clear edx for division
    mov ecx, 10               ; Base 10 for division
    div ecx                   ; Divide eax by 10, result in eax, remainder in edx
    add dl, '0'               ; Convert remainder to ASCII character
    mov [edi], dl             ; Store ASCII character in buffer
    test eax, eax             ; Check if eax is zero
    jnz convert               ; If eax is not zero, continue converting
    ret

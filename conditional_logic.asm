section .data
    prompt db "Enter a number: ", 0
    positive_msg db "The number is POSITIVE.", 0
    negative_msg db "The number is NEGATIVE.", 0
    zero_msg db "The number is ZERO.", 0
    newline db 10, 0  ; Newline character with null terminator

section .bss
    input resb 10     ; Reserve space for user input

section .text
    global _start

_start:
    ; Prompt user for input
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, prompt     ; message to display
    mov edx, 16         ; length of the message
    int 0x80            ; call kernel

    ; Read user input
    mov eax, 3          ; syscall: read
    mov ebx, 0          ; file descriptor: stdin
    mov ecx, input      ; buffer to store input
    mov edx, 10         ; buffer size
    int 0x80            ; call kernel

    ; Remove the newline character from input
    mov esi, input      ; address of input buffer
remove_newline:
    movzx ecx, byte [esi]   ; load byte from input
    cmp ecx, 10             ; check for newline (ASCII 10)
    je end_remove_newline   ; if newline, terminate loop
    cmp ecx, 0              ; check for null terminator
    je end_remove_newline   ; if null, terminate loop
    inc esi                 ; move to next character
    jmp remove_newline      ; continue checking
end_remove_newline:
    mov byte [esi], 0       ; replace newline or null with null terminator

    ; Convert input to integer
    mov esi, input          ; address of input buffer
    xor eax, eax            ; clear EAX (number accumulator)
    xor ebx, ebx            ; clear EBX (negative flag)
convert_loop:
    movzx ecx, byte [esi]   ; load byte from input
    cmp ecx, 0              ; check for null terminator
    je classify_number      ; if null, jump to classify_number
    sub ecx, '0'            ; convert ASCII to integer
    imul eax, eax, 10       ; multiply accumulator by 10
    add eax, ecx            ; add digit to accumulator
    inc esi                 ; move to next character
    jmp convert_loop        ; unconditional jump to continue

classify_number:
    ; Check if the number is positive, negative, or zero
    cmp eax, 0
    je is_zero              ; conditional jump if EAX == 0
    jg is_positive          ; conditional jump if EAX > 0
    jmp is_negative         ; unconditional jump if EAX < 0

is_positive:
    ; Print "The number is POSITIVE."
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, positive_msg   ; message to display
    mov edx, 22             ; length of the message
    int 0x80                ; call kernel

    ; Print newline
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, newline        ; newline to display
    mov edx, 1              ; length of the newline
    int 0x80                ; call kernel

    jmp exit_program        ; unconditional jump to exit

is_negative:
    ; Print "The number is NEGATIVE."
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, negative_msg   ; message to display
    mov edx, 22             ; length of the message
    int 0x80                ; call kernel

    ; Print newline
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, newline        ; newline to display
    mov edx, 1              ; length of the newline
    int 0x80                ; call kernel

    jmp exit_program        ; unconditional jump to exit

is_zero:
    ; Print "The number is ZERO."
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, zero_msg       ; message to display
    mov edx, 18             ; length of the message
    int 0x80                ; call kernel

    ; Print newline
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, newline        ; newline to display
    mov edx, 1              ; length of the newline
    int 0x80                ; call kernel

exit_program:
    ; Exit the program
    mov eax, 1              ; syscall: exit
    xor ebx, ebx            ; status code 0
    int 0x80                ; call kernel

; Why Jump Instructions Were Chosen:
;1. Conditional Jumps- The conditional jumps (je, jg) are necessary for branching the program based on the comparison between the input number and zero. This allows the program to respond to different cases (positive, negative, or zero) without excessive use of if-else structures.
;2. Unconditional Jumps - The unconditional jmp is used to exit the program or skip unnecessary code after a message is displayed. It ensures smooth program flow without unnecessary checks.

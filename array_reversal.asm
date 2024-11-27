section .data
    prompt db "Enter 5 integers (space-separated): ", 0
    reversed_msg db "The reversed array is: ", 0
    newline db 10, 0   ; newline character

section .bss
    input resb 20       ; Reserve 20 bytes for input (adjust based on expected size)
    arr resd 5          ; Reserve space for 5 integers (each integer is 4 bytes)

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, prompt     ; message to display
    mov edx, 35         ; length of the message
    int 0x80            ; call kernel

    ; Read user input (array of integers)
    mov eax, 3          ; syscall: read
    mov ebx, 0          ; file descriptor: stdin
    mov ecx, input      ; buffer to store input
    mov edx, 20         ; buffer size
    int 0x80            ; call kernel

    ; Convert input to integers and store in the array
    mov esi, input      ; pointer to input buffer
    mov edi, arr        ; pointer to the array
    mov ecx, 5          ; we need to handle 5 numbers
convert_loop:
    xor ebx, ebx        ; clear ebx (used for number)
    mov edx, 0          ; clear edx (used for digit)
    ; Convert the characters to integers
convert_digit:
    mov al, byte [esi]  ; load the byte (character)
    cmp al, 20          ; check if it's a space (ASCII 20)
    je convert_next     ; if space, process the next number
    sub al, '0'         ; convert ASCII to integer
    imul ebx, ebx, 10   ; multiply current number by 10
    add ebx, eax        ; add the digit to the number
    inc esi             ; move to the next byte
    jmp convert_digit

convert_next:
    mov [edi], ebx      ; store the current number in the array
    inc edi             ; move to the next array element
    inc esi             ; skip the space
    loop convert_loop   ; repeat for 5 numbers

    ; Reverse the array (in-place)
    mov ecx, 2          ; we need to swap 2 pairs (for 5 elements)
    mov edi, arr        ; pointer to the start of the array
    mov esi, arr + 16   ; pointer to the end of the array

reverse_loop:
    mov eax, [edi]      ; load the first element
    mov ebx, [esi]      ; load the last element
    mov [edi], ebx      ; store the last element at the start
    mov [esi], eax      ; store the first element at the end
    add edi, 4          ; move to the next element
    sub esi, 4          ; move to the previous element
    loop reverse_loop   ; repeat for the other swaps

    ; Print reversed message
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, reversed_msg  ; message to display
    mov edx, 21         ; length of the message
    int 0x80            ; call kernel

    ; Output the reversed array
    mov ecx, 5          ; we need to print 5 numbers
    mov edi, arr        ; pointer to the array
print_loop:
    mov eax, [edi]      ; load the current integer
    call int_to_str     ; convert integer to string for printing
    ; Print the integer as a string
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; file descriptor: stdout
    mov edx, 4          ; length of the string
    int 0x80            ; call kernel
    add edi, 4          ; move to the next integer
    loop print_loop     ; repeat for all integers

    ; Exit program
    mov eax, 1          ; syscall: exit
    xor ebx, ebx        ; status code 0
    int 0x80            ; call kernel

int_to_str:  ; Convert integer to string
    push eax
    xor edx, edx        ; clear EDX
    mov ebx, 10         ; divisor for base 10
reverse_digits:
    div ebx             ; divide EAX by 10
    add dl, '0'         ; convert remainder to ASCII
    dec esp             ; move stack pointer to store the digit
    mov [esp], dl       ; store the character
    test eax, eax       ; check if EAX is 0
    jnz reverse_digits  ; if not zero, continue
    pop eax
    ret

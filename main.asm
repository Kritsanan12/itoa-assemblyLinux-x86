section .data
    newline db 0xa
section .bss
    ItoaBuffer resb 12
section .text
    global _start
_start:
    push 12345
    call itoa
    
    push ItoaBuffer
    call Print

EndProcess:
    mov eax , 1
    int 0x80

itoa: ; +8 is num 
    push ebp
    mov ebp , esp
    sub esp , 16

    mov DWORD [ebp-8] , 0 ;i
    mov DWORD [ebp-12] , 0 ;isNegative
    mov esi , ItoaBuffer

    mov eax , [ebp+8]
    cmp eax , 0 
    jne itoa.notzero

    mov eax , [ebp-8]
    mov byte [esi+eax] , '0'
    inc DWORD [ebp-8]
    mov eax, [ebp-8]
    mov byte [esi+eax] , 0
    jmp return

itoa.notzero:
    mov eax , [ebp+8] ;eax = num
    cmp eax , 0
    jg itoa.loop
    inc DWORD [ebp-12] ; isNegative = 1
    neg DWORD [ebp+8] ; num = -num
   
    mov esi , ItoaBuffer
itoa.loop:
    mov eax, [ebp+8] ;eax = num
    cmp eax , 0
    je itoa.loop.end

    mov ecx , 10 ; %10
    xor edx , edx ; clear edx
    div ecx ; eax = num / 10
    add dl , '0' ; convert to char
    mov edi , [ebp-8] ; i
    mov [esi+edi] , dl ; buffer[i] = num % 10
    inc DWORD [ebp-8] ; i++
    mov [ebp+8] , eax ; num = num / 10
    jmp itoa.loop
itoa.loop.end:
    mov esi , ItoaBuffer
    mov eax, [ebp-8]
    mov byte [esi+eax] , 0 ; buffer[i] = 0
    mov eax, [ebp-12] ; check if isNegative
    cmp eax, 0
    je itoa.reverse
    mov eax, [ebp-8] ; i
    mov byte [esi+eax], '-' ; prepend '-'
    inc DWORD [ebp-8] ; i++
itoa.reverse:
    mov ecx, 0 ; j = 0 
    mov eax, [ebp-8] ; i
    dec eax ; k = i-1
itoa.reverse.loop:
    cmp ecx ,eax 
    jge return
    movzx ebx, byte [esi + ecx] 
    movzx edx, byte [esi + eax]
    mov [esi + ecx], dl 
    mov [esi + eax], bl
    inc ecx
    dec eax
    jmp itoa.reverse.loop
return:
    add esp , 16
    pop ebp
    ret
Print:
    push ebp
    mov ebp , esp
    sub esp , 16

    mov eax , 4
    mov ebx , 1
    mov ecx , [ebp+8]
    mov edx , 12
    int 0x80

    mov eax , 4
    mov ebx , 1
    mov ecx , newline
    mov edx , 1
    int 0x80

    add esp , 16
    pop ebp
    ret


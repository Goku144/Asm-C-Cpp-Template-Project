global asm_hello

section .rodata
msg db "Hello from NASM", 10
msg_len equ $ - msg

section .text
asm_hello:
  mov rax, 1
  mov rdi, 1
  lea rsi, [rel msg]
  mov rdx, msg_len
  syscall
  ret
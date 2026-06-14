;PrintStr.inc

%macro print_str_macro 2
  ; Linux x86-64 syscall: write(stdout, msg, msg_len)
print_str:
  ; rdi = str pointer
  ; rsi = length
  mov rdx, rsi    ; length
  mov rsi, rdi    ; string address
  mov rax, 1      ; write syscall
  mov rdi, 1      ; stdout
  syscall
%endmacro
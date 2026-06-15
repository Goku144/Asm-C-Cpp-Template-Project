; Export this symbol so C++ can call it as:
; extern "C" void print_str(void);
%include "PrintStr.inc"

global print_str

section .rodata

section .text
  print_str_macro rdi, rsi
  ; Return to the C++ caller.
  ret

section .note.GNU-stack noalloc noexec nowrite progbits
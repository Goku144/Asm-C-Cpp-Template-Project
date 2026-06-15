// The assembly function is exported from asm/src/Hello.asm.
// extern "C" keeps the symbol name simple so the linker can find asm_hello.
#include "App.hpp"

int main(void)
{
  // Call the NASM example. It writes a message directly with the Linux syscall ABI.
  char str[] = "Hello World!\n";
  print_str(str, sizeof(str) / sizeof(char));

  return 0;
}
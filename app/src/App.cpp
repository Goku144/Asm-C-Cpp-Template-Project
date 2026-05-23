// The assembly function is exported from asm/src/Hello.asm.
// extern "C" keeps the symbol name simple so the linker can find asm_hello.
extern "C" void asm_hello(void);


int main(void)
{
  // Call the NASM example. It writes a message directly with the Linux syscall ABI.
  asm_hello();

  return 0;
}

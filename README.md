# ASM C++ Template Project

A small Linux template for mixing C++ and NASM assembly in one project.

The example starts in `project/src/app/App.cpp`, calls the assembly function
`print_str`, and the NASM file `project/src/asm/PrintStr.asm` prints:

```text
Hello World!
```

## Project Layout

```text
Makefile              Build rules
project/src/app/      C++ application sources
project/src/asm/      NASM assembly sources
project/class/        Optional shared-library C++ sources
interface/src/app/    C++ headers
interface/src/asm/    NASM include files
interface/class/      Optional shared-library headers
target/bin/app/       C++ object output
target/bin/asm/       Assembly object output
target/lib/           Built shared libraries
target/build/prog     Linked executable
.vscode/              Tracked VS Code project settings
```

## Requirements

- `make`
- `g++`
- `nasm`
- `sudo` for installing the built program
- `gdb`
- VS Code with the C/C++ extension for debugging

## Build

```bash
make
```

The executable is linked at:

```text
target/build/prog
```

The default `make` target also installs it to `/usr/local/bin/prog`.

## Run

```bash
./target/build/prog
```

After installation, it can also be run as:

```bash
prog
```

## Clean

```bash
make clean
```

## License

MIT License, copyright (c) 2026 Orion.

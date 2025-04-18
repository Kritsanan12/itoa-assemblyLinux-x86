# itoa-assemblyLinux-x86
#How to Compile
 ```
nasm -f elf -g -F dwarf main.asm
 ```
 ``` 
 ld -m elf_i386 main.o -o main
```

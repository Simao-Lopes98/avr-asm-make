.section .text  ; Tells the assembler “this is code.”

.global __start ; Makes __start visible to the linker as the program's 
                ; entry point (tells the linker to use this as the 
                ; reset vector).

__start:
    RJMP main   ; Jump to your main code   

main:
    RJMP main   ; Infinite loop to keep the MCU alive
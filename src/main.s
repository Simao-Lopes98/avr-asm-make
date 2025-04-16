.section .text  ; Tells the assembler “this is code.”

.global __start ; Makes __start visible to the linker as the program's 
                ; entry point (tells the linker to use this as the 
                ; reset vector).

.equ PORTB, 0x05
.equ DDRB,  0x04

__start:
    RJMP main   ; Jump to your main code   

delay:
    DEC R16
    BREQ delay

; Register setup routine
setup:
    SBI DDRB, 5 ; Set the bit 5 of DDRB register (GPIO 13 set to OUTPUT)

; Loop routine
loop:
    SBI PORTB, 5 ; Set the bit 5 of PORTB register (GPIO 13 set to HIGH)

    ; delay
    LDI R16, 0xFF
    RJMP delay

    CBI PORTB, 5 ; Clear the bit 5 of PORTB register (GPIO 13 set to HIGH)

    ; Add delay

    RJMP loop   ; Infinite loop to keep the MCU alive

; Main routine
main:
    RJMP setup
    RJMP loop
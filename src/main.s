.section .text  ; Tells the assembler “this is code.”

.list
.org 0x0000
RJMP main        ; Jump to main
.org 0x0016
RJMP toggle_led     ; Timer1 Compare Match A ISR

.equ PORTB, 0x05
.equ DDRB,  0x04
.equ TCCR1A, 0x80
.equ TCCR1B, 0x81
.equ TCNT1L, 0x84
.equ TCNT1H, 0x85
.equ OCR1AL, 0x88
.equ OCR1AH, 0x89
.equ TIMSK1, 0x6F
.equ SPH, 0x3E
.equ SPL, 0x3D

; Timer setup
timer_setup:
    ; Clear TCCR1A
    LDI R16, 0x00       
    STS TCCR1A, R16
    
    ; Clear TCCR1B
    LDI R16, 0x00   
    STS TCCR1B, R16

    ; Clear TCNT1L
    LDI R16, 0x00   
    STS TCNT1L, R16

    ; Clear TCNT1H
    LDI R16, 0x00   
    STS TCNT1H, R16
    
    ; Set Prescaler (1024) and CTC mode
    LDI R16, 0x0D
    STS TCCR1B, R16

    ; Value to compare: 15624 -> 0x3D08
    ; Set the low word of the compare register OCR1AL
    LDI R16, 0x08
    STS OCR1AL, R16
    
    ; Set the high word of the compare register OCR1AH
    LDI R16, 0x3D
    STS OCR1AH, R16 
    
    ; Set the bit 2 of TIMSK1 - Compare Interrupt Enable
    LDI R16, 0x02    
    STS TIMSK1, R16
    RET

toggle_led:
    ;IN R16, PORTB

    ; Cannot load 0x20 into EOR. Need to bitshit right than left
    ;LDI R17, 2

    ; Right - Bitshift 4 times ->
    ;LSR R16
    ;LSR R16
    ;LSR R16
    ;LSR R16

    ; Toggle R16
    ;EOR R16, R17   ; Exclusive OR (XOR)

    ; Left - Bitshift 4 times <-
    ;LSL R16
    ;LSL R16
    ;LSL R16
    ;LSL R16

    ; Load PORTB
    ;OUT PORTB, R16

    ; DBG Instruction
    SBI PORTB, 5

    RETI            ; Return from interrupt

; Loop routine
loop: 
    NOP
    RJMP loop   ; Infinite loop to keep the MCU alive

; Main routine
main:
    CLI        ; Clear Global Interrupt Flag
    ; Set Stack Pointer
    LDI R16, 0x08
    OUT SPH, R16
    LDI R16, 0xFF
    OUT SPL, R16
    
    SBI DDRB, 5 ; Set the bit 5 of DDRB register (GPIO 13 set to OUTPUT)
    RCALL timer_setup
    SEI         ; Set Global Interrupt Flag
    CBI PORTB, 5
    RJMP loop
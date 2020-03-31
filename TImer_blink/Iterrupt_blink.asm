
_interrupt:

;Iterrupt_blink.c,5 :: 		void interrupt() {
;Iterrupt_blink.c,6 :: 		Num ++;           // Interrupt causes Num to be incremented by 1
	INCF       _Num+0, 1
;Iterrupt_blink.c,7 :: 		if(Num == 18) {
	MOVF       _Num+0, 0
	XORLW      18
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt0
;Iterrupt_blink.c,8 :: 		LED = ~LED;       // Toggle LED every sec
	MOVLW
	XORWF      RC0_bit+0, 1
;Iterrupt_blink.c,9 :: 		Num = 0;
	CLRF       _Num+0
;Iterrupt_blink.c,10 :: 		}
L_interrupt0:
;Iterrupt_blink.c,11 :: 		TMR0 = 39;        // TMR0 returns to its initial value
	MOVLW      39
	MOVWF      TMR0+0
;Iterrupt_blink.c,12 :: 		INTCON.T0IF = 0;  // Bit T0IF is cleared so that the interrupt could reoccur
	BCF        INTCON+0, 2
;Iterrupt_blink.c,13 :: 		}
L_end_interrupt:
L__interrupt6:
	RETFIE     %s
; end of _interrupt

_main:

;Iterrupt_blink.c,14 :: 		void main() {
;Iterrupt_blink.c,15 :: 		CM1CON0 = 0x07;    // Disable Comparators
	MOVLW      7
	MOVWF      CM1CON0+0
;Iterrupt_blink.c,17 :: 		TRISC = 0x00;     // PORTC O/P
	CLRF       TRISC+0
;Iterrupt_blink.c,18 :: 		LED = 0;
	BCF        RC0_bit+0, BitPos(RC0_bit+0)
;Iterrupt_blink.c,19 :: 		Num = 0;
	CLRF       _Num+0
;Iterrupt_blink.c,20 :: 		OPTION_REG = 0x07; // Prescaler (1:256) is assigned to the timer TMR0       p
	MOVLW      7
	MOVWF      OPTION_REG+0
;Iterrupt_blink.c,21 :: 		TMR0 = 39;          // Timer T0 counts from 39 to 255
	MOVLW      39
	MOVWF      TMR0+0
;Iterrupt_blink.c,22 :: 		INTCON = 0xA0;     // Enable interrupt TMR0 and Global Interrupts
	MOVLW      160
	MOVWF      INTCON+0
;Iterrupt_blink.c,24 :: 		Sound_Init(&PORTE, 1);
	MOVLW      PORTE+0
	MOVWF      FARG_Sound_Init_snd_port+0
	MOVLW      hi_addr(PORTE+0)
	MOVWF      FARG_Sound_Init_snd_port+1
	MOVLW      1
	MOVWF      FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;Iterrupt_blink.c,26 :: 		do {
L_main1:
;Iterrupt_blink.c,27 :: 		if (Button(&PORTB, 5, 100, 1)) {               // Detect logical zero
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      hi_addr(PORTB+0)
	MOVWF      FARG_Button_port+1
	MOVLW      5
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main4
;Iterrupt_blink.c,28 :: 		Sound_Play(1318, 50);
	MOVLW      38
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      5
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      50
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;Iterrupt_blink.c,30 :: 		}
L_main4:
;Iterrupt_blink.c,31 :: 		} while(1);  // infinite loop
	GOTO       L_main1
;Iterrupt_blink.c,32 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

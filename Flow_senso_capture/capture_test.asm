
_interrupt:

;capture_test.c,14 :: 		void interrupt()
;capture_test.c,16 :: 		if(TMR1IF_bit==1)
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt0
;capture_test.c,18 :: 		tmrOverflowA++;
	INFSNZ      _tmrOverflowA+0, 1 
	INCF        _tmrOverflowA+1, 1 
;capture_test.c,19 :: 		LED =~LED;
	BTG         RB7_bit+0, BitPos(RB7_bit+0) 
;capture_test.c,20 :: 		TMR1IF_bit=0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;capture_test.c,21 :: 		}
L_interrupt0:
;capture_test.c,22 :: 		Atmrcount1 = CCPR1L;
	MOVF        CCPR1L+0, 0 
	MOVWF       _Atmrcount1+0 
	MOVLW       0
	MOVWF       _Atmrcount1+1 
;capture_test.c,23 :: 		Atmrcount2 = CCPR1H;
	MOVF        CCPR1H+0, 0 
	MOVWF       _Atmrcount2+0 
	MOVLW       0
	MOVWF       _Atmrcount2+1 
;capture_test.c,24 :: 		timerCountA =  (65536*(tmrOverflowA)) + (Atmrcount2*256) +  Atmrcount1 +1000;
	MOVF        _tmrOverflowA+1, 0 
	MOVWF       _timerCountA+3 
	MOVF        _tmrOverflowA+0, 0 
	MOVWF       _timerCountA+2 
	CLRF        _timerCountA+0 
	CLRF        _timerCountA+1 
	MOVF        _Atmrcount2+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	ADDWF       _timerCountA+0, 1 
	MOVF        R1, 0 
	ADDWFC      _timerCountA+1, 1 
	MOVLW       0
	ADDWFC      _timerCountA+2, 1 
	ADDWFC      _timerCountA+3, 1 
	MOVF        _Atmrcount1+0, 0 
	ADDWF       _timerCountA+0, 1 
	MOVF        _Atmrcount1+1, 0 
	ADDWFC      _timerCountA+1, 1 
	MOVLW       0
	ADDWFC      _timerCountA+2, 1 
	ADDWFC      _timerCountA+3, 1 
	MOVLW       232
	ADDWF       _timerCountA+0, 1 
	MOVLW       3
	ADDWFC      _timerCountA+1, 1 
	MOVLW       0
	ADDWFC      _timerCountA+2, 1 
	ADDWFC      _timerCountA+3, 1 
;capture_test.c,26 :: 		if(CCP1IF_bit==1){
	BTFSS       CCP1IF_bit+0, BitPos(CCP1IF_bit+0) 
	GOTO        L_interrupt1
;capture_test.c,27 :: 		RotCountA++;
	MOVLW       1
	ADDWF       _RotCountA+0, 1 
	MOVLW       0
	ADDWFC      _RotCountA+1, 1 
	ADDWFC      _RotCountA+2, 1 
	ADDWFC      _RotCountA+3, 1 
;capture_test.c,28 :: 		LEDccp =~LEDccp;
	BTG         RB6_bit+0, BitPos(RB6_bit+0) 
;capture_test.c,30 :: 		freqA = (2000000.0 / timerCountA) ;
	MOVF        _timerCountA+0, 0 
	MOVWF       R0 
	MOVF        _timerCountA+1, 0 
	MOVWF       R1 
	MOVF        _timerCountA+2, 0 
	MOVWF       R2 
	MOVF        _timerCountA+3, 0 
	MOVWF       R3 
	CALL        _longword2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       36
	MOVWF       R1 
	MOVLW       116
	MOVWF       R2 
	MOVLW       147
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       _freqA+0 
	MOVF        R1, 0 
	MOVWF       _freqA+1 
;capture_test.c,31 :: 		TMR1L=0;
	CLRF        TMR1L+0 
;capture_test.c,32 :: 		TMR1H=0;
	CLRF        TMR1H+0 
;capture_test.c,33 :: 		tmrOverflowA=0;
	CLRF        _tmrOverflowA+0 
	CLRF        _tmrOverflowA+1 
;capture_test.c,34 :: 		CCP1IF_bit=0;
	BCF         CCP1IF_bit+0, BitPos(CCP1IF_bit+0) 
;capture_test.c,35 :: 		TMR1IF_bit=0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;capture_test.c,36 :: 		}
L_interrupt1:
;capture_test.c,37 :: 		}
L_end_interrupt:
L__interrupt10:
	RETFIE      1
; end of _interrupt

_SensorA:

;capture_test.c,39 :: 		void SensorA(){
;capture_test.c,40 :: 		volumeAH = RotCountA/600;
	MOVLW       88
	MOVWF       R4 
	MOVLW       2
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _RotCountA+0, 0 
	MOVWF       R0 
	MOVF        _RotCountA+1, 0 
	MOVWF       R1 
	MOVF        _RotCountA+2, 0 
	MOVWF       R2 
	MOVF        _RotCountA+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__SensorA+4 
	MOVF        R1, 0 
	MOVWF       FLOC__SensorA+5 
	MOVF        R2, 0 
	MOVWF       FLOC__SensorA+6 
	MOVF        R3, 0 
	MOVWF       FLOC__SensorA+7 
	MOVF        FLOC__SensorA+4, 0 
	MOVWF       _volumeAH+0 
	MOVF        FLOC__SensorA+5, 0 
	MOVWF       _volumeAH+1 
;capture_test.c,41 :: 		volumeAL = (RotCountA%600)/60;
	MOVLW       88
	MOVWF       R4 
	MOVLW       2
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	MOVF        _RotCountA+0, 0 
	MOVWF       R0 
	MOVF        _RotCountA+1, 0 
	MOVWF       R1 
	MOVF        _RotCountA+2, 0 
	MOVWF       R2 
	MOVF        _RotCountA+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__SensorA+0 
	MOVF        R1, 0 
	MOVWF       FLOC__SensorA+1 
	MOVF        R2, 0 
	MOVWF       FLOC__SensorA+2 
	MOVF        R3, 0 
	MOVWF       FLOC__SensorA+3 
	MOVF        FLOC__SensorA+0, 0 
	MOVWF       _volumeAL+0 
	MOVF        FLOC__SensorA+1, 0 
	MOVWF       _volumeAL+1 
;capture_test.c,43 :: 		volumeA[0]= volumeAH/1000 +'0';
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        FLOC__SensorA+4, 0 
	MOVWF       R0 
	MOVF        FLOC__SensorA+5, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _volumeA+0 
;capture_test.c,44 :: 		volumeA[1]= (volumeAH%1000)/100 + '0';
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        FLOC__SensorA+4, 0 
	MOVWF       R0 
	MOVF        FLOC__SensorA+5, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _volumeA+1 
;capture_test.c,45 :: 		volumeA[2]= (volumeAH%100)/10 + '0';
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__SensorA+4, 0 
	MOVWF       R0 
	MOVF        FLOC__SensorA+5, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _volumeA+2 
;capture_test.c,46 :: 		volumeA[3]= volumeAH%10 + '0';
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__SensorA+4, 0 
	MOVWF       R0 
	MOVF        FLOC__SensorA+5, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _volumeA+3 
;capture_test.c,47 :: 		volumeA[4]= '.';
	MOVLW       46
	MOVWF       _volumeA+4 
;capture_test.c,48 :: 		volumeA[5]= volumeAL + '0';
	MOVLW       48
	ADDWF       FLOC__SensorA+0, 0 
	MOVWF       _volumeA+5 
;capture_test.c,50 :: 		AsensorRate = freqA/10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _freqA+0, 0 
	MOVWF       R0 
	MOVF        _freqA+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _AsensorRate+0 
	MOVF        R1, 0 
	MOVWF       _AsensorRate+1 
;capture_test.c,51 :: 		}
L_end_SensorA:
	RETURN      0
; end of _SensorA

_main:

;capture_test.c,53 :: 		void main() {
;capture_test.c,57 :: 		ANSELB =0x00;
	CLRF        ANSELB+0 
;capture_test.c,58 :: 		ANSELC =0x00;
	CLRF        ANSELC+0 
;capture_test.c,60 :: 		LED = 0;
	BCF         RB7_bit+0, BitPos(RB7_bit+0) 
;capture_test.c,61 :: 		LEDccp=0;
	BCF         RB6_bit+0, BitPos(RB6_bit+0) 
;capture_test.c,63 :: 		volumeAL=0;
	CLRF        _volumeAL+0 
	CLRF        _volumeAL+1 
;capture_test.c,64 :: 		volumeAH=0;
	CLRF        _volumeAH+0 
	CLRF        _volumeAH+1 
;capture_test.c,65 :: 		RotCountA=0;
	CLRF        _RotCountA+0 
	CLRF        _RotCountA+1 
	CLRF        _RotCountA+2 
	CLRF        _RotCountA+3 
;capture_test.c,66 :: 		freqA=0;
	CLRF        _freqA+0 
	CLRF        _freqA+1 
;capture_test.c,68 :: 		ADCON1 =0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;capture_test.c,69 :: 		TRISB3_bit =0;
	BCF         TRISB3_bit+0, BitPos(TRISB3_bit+0) 
;capture_test.c,70 :: 		TRISB4_bit =0;
	BCF         TRISB4_bit+0, BitPos(TRISB4_bit+0) 
;capture_test.c,71 :: 		TRISB6_bit =0;
	BCF         TRISB6_bit+0, BitPos(TRISB6_bit+0) 
;capture_test.c,72 :: 		TRISB7_bit =0;
	BCF         TRISB7_bit+0, BitPos(TRISB7_bit+0) 
;capture_test.c,73 :: 		TRISC2_bit = 1;
	BSF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;capture_test.c,74 :: 		LATB.B4  =1;
	BSF         LATB+0, 4 
;capture_test.c,75 :: 		LATB.B3 =0;
	BCF         LATB+0, 3 
;capture_test.c,77 :: 		CCP1CON = 0x05;
	MOVLW       5
	MOVWF       CCP1CON+0 
;capture_test.c,78 :: 		TMR1ON_bit=1;
	BSF         TMR1ON_bit+0, BitPos(TMR1ON_bit+0) 
;capture_test.c,79 :: 		GIE_bit=1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;capture_test.c,80 :: 		PEIE_bit = 1;
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;capture_test.c,81 :: 		CCP1IE_bit=1;
	BSF         CCP1IE_bit+0, BitPos(CCP1IE_bit+0) 
;capture_test.c,82 :: 		CCP1IF_bit=0;
	BCF         CCP1IF_bit+0, BitPos(CCP1IF_bit+0) 
;capture_test.c,83 :: 		TMR1IE_bit=1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;capture_test.c,88 :: 		while(1){
L_main2:
;capture_test.c,90 :: 		if(PORTC.RC2 ==1)  //button input
	BTFSS       PORTC+0, 2 
	GOTO        L_main4
;capture_test.c,92 :: 		Delay_ms(50);     //deboncing handling
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	NOP
	NOP
;capture_test.c,93 :: 		if(PORTC.RC2 ==1)
	BTFSS       PORTC+0, 2 
	GOTO        L_main6
;capture_test.c,95 :: 		LATB.B4 =0;
	BCF         LATB+0, 4 
;capture_test.c,96 :: 		CCP1IF_bit=1;
	BSF         CCP1IF_bit+0, BitPos(CCP1IF_bit+0) 
;capture_test.c,97 :: 		}
L_main6:
;capture_test.c,99 :: 		}
	GOTO        L_main7
L_main4:
;capture_test.c,103 :: 		LATB.B4 =1;
	BSF         LATB+0, 4 
;capture_test.c,104 :: 		if(RotCountA>=10){
	MOVLW       0
	SUBWF       _RotCountA+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main13
	MOVLW       0
	SUBWF       _RotCountA+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main13
	MOVLW       0
	SUBWF       _RotCountA+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main13
	MOVLW       10
	SUBWF       _RotCountA+0, 0 
L__main13:
	BTFSS       STATUS+0, 0 
	GOTO        L_main8
;capture_test.c,105 :: 		LATB.B3 =1;
	BSF         LATB+0, 3 
;capture_test.c,106 :: 		}
L_main8:
;capture_test.c,107 :: 		}
L_main7:
;capture_test.c,109 :: 		}
	GOTO        L_main2
;capture_test.c,110 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

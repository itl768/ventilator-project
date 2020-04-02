
_shiftdata595:

;ventilator.c,61 :: 		void shiftdata595(int _shiftdata[])  //shift register
;ventilator.c,65 :: 		i=8;
	MOVLW      8
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
;ventilator.c,66 :: 		while (i>0)                  //loop to send 8bit data
L_shiftdata5950:
	MOVF       R4+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__shiftdata595113
	MOVF       R4+0, 0
	SUBLW      0
L__shiftdata595113:
	BTFSC      STATUS+0, 0
	GOTO       L_shiftdata5951
;ventilator.c,68 :: 		SHIFT_DATA=_shiftdata[i-1]; //  send array value
	MOVLW      1
	SUBWF      R4+0, 0
	MOVWF      R2+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      R4+1, 0
	MOVWF      R2+1
	MOVF       R2+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDWF      FARG_shiftdata595__shiftdata+0, 0
	MOVWF      FSR
	BTFSC      INDF+0, 0
	GOTO       L__shiftdata595114
	BCF        PORTB+0, 0
	GOTO       L__shiftdata595115
L__shiftdata595114:
	BSF        PORTB+0, 0
L__shiftdata595115:
;ventilator.c,69 :: 		SHIFT_CLOCK = 1;
	BSF        PORTB+0, 2
;ventilator.c,70 :: 		Delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;ventilator.c,71 :: 		SHIFT_CLOCK = 0;
	BCF        PORTB+0, 2
;ventilator.c,72 :: 		i--;
	MOVLW      1
	SUBWF      R4+0, 1
	BTFSS      STATUS+0, 0
	DECF       R4+1, 1
;ventilator.c,73 :: 		}
	GOTO       L_shiftdata5950
L_shiftdata5951:
;ventilator.c,74 :: 		}
L_end_shiftdata595:
	RETURN
; end of _shiftdata595

_latch595:

;ventilator.c,76 :: 		void latch595()              //latch pin controll
;ventilator.c,78 :: 		SHIFT_LATCH = 1;
	BSF        PORTB+0, 1
;ventilator.c,79 :: 		Delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;ventilator.c,80 :: 		SHIFT_LATCH = 0;
	BCF        PORTB+0, 1
;ventilator.c,81 :: 		}
L_end_latch595:
	RETURN
; end of _latch595

_switches:

;ventilator.c,85 :: 		void switches(){
;ventilator.c,87 :: 		if (Button(&PORTB, 6, 1, 0)) {               // Detect logical zero
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      6
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches2
;ventilator.c,88 :: 		oldbpmup = 1;                              // Update flag
	BSF        _oldbpmup+0, BitPos(_oldbpmup+0)
;ventilator.c,89 :: 		}
L_switches2:
;ventilator.c,90 :: 		if (oldbpmup && Button(&PORTB, 6, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldbpmup+0, BitPos(_oldbpmup+0)
	GOTO       L_switches5
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      6
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches5
L__switches111:
;ventilator.c,91 :: 		oldbpmup = 0;                            // Update flag
	BCF        _oldbpmup+0, BitPos(_oldbpmup+0)
;ventilator.c,92 :: 		bpmv++;                                //increment bpm level
	INCF       _bpmv+0, 1
	BTFSC      STATUS+0, 2
	INCF       _bpmv+1, 1
;ventilator.c,94 :: 		if(bpmv>16){                     //limit bpm value
	MOVF       _bpmv+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__switches118
	MOVF       _bpmv+0, 0
	SUBLW      16
L__switches118:
	BTFSC      STATUS+0, 0
	GOTO       L_switches6
;ventilator.c,95 :: 		bpmv=16;
	MOVLW      16
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,96 :: 		}
L_switches6:
;ventilator.c,97 :: 		if(bpmv<12){
	MOVLW      0
	SUBWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches119
	MOVLW      12
	SUBWF      _bpmv+0, 0
L__switches119:
	BTFSC      STATUS+0, 0
	GOTO       L_switches7
;ventilator.c,98 :: 		bpmv=12;
	MOVLW      12
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,99 :: 		}
L_switches7:
;ventilator.c,102 :: 		}
L_switches5:
;ventilator.c,104 :: 		if (Button(&PORTB, 7, 1, 0)) {               // Detect logical zero
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      7
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches8
;ventilator.c,105 :: 		oldbpmdown = 1;                              // Update flag
	BSF        _oldbpmdown+0, BitPos(_oldbpmdown+0)
;ventilator.c,106 :: 		}
L_switches8:
;ventilator.c,107 :: 		if (oldbpmdown && Button(&PORTB, 7, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldbpmdown+0, BitPos(_oldbpmdown+0)
	GOTO       L_switches11
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      7
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches11
L__switches110:
;ventilator.c,108 :: 		oldbpmdown = 0;                           // Update flag
	BCF        _oldbpmdown+0, BitPos(_oldbpmdown+0)
;ventilator.c,111 :: 		bpmv--;                                      //decrement bpm value
	MOVLW      1
	SUBWF      _bpmv+0, 1
	BTFSS      STATUS+0, 0
	DECF       _bpmv+1, 1
;ventilator.c,112 :: 		if(bpmv>16){                                 //limit bpm value
	MOVF       _bpmv+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__switches120
	MOVF       _bpmv+0, 0
	SUBLW      16
L__switches120:
	BTFSC      STATUS+0, 0
	GOTO       L_switches12
;ventilator.c,113 :: 		bpmv=16;
	MOVLW      16
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,114 :: 		}
L_switches12:
;ventilator.c,115 :: 		if(bpmv<12){
	MOVLW      0
	SUBWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches121
	MOVLW      12
	SUBWF      _bpmv+0, 0
L__switches121:
	BTFSC      STATUS+0, 0
	GOTO       L_switches13
;ventilator.c,116 :: 		bpmv=12;
	MOVLW      12
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,117 :: 		}
L_switches13:
;ventilator.c,120 :: 		}
L_switches11:
;ventilator.c,125 :: 		if (Button(&PORTB, 4, 1, 0)) {               // Detect logical zero
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      4
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches14
;ventilator.c,126 :: 		oldvolup = 1;                              // Update flag
	BSF        _oldvolup+0, BitPos(_oldvolup+0)
;ventilator.c,127 :: 		}
L_switches14:
;ventilator.c,128 :: 		if (oldvolup && Button(&PORTB, 4, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldvolup+0, BitPos(_oldvolup+0)
	GOTO       L_switches17
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      4
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches17
L__switches109:
;ventilator.c,129 :: 		oldvolup = 0;                    // Update flag
	BCF        _oldvolup+0, BitPos(_oldvolup+0)
;ventilator.c,131 :: 		vol=vol+50;              //increment volume level by 50
	MOVLW      50
	ADDWF      _vol+0, 0
	MOVWF      R1+0
	MOVF       _vol+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R1+1
	MOVF       R1+0, 0
	MOVWF      _vol+0
	MOVF       R1+1, 0
	MOVWF      _vol+1
;ventilator.c,132 :: 		if(vol>550){                                         //limit volume level
	MOVF       R1+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches122
	MOVF       R1+0, 0
	SUBLW      38
L__switches122:
	BTFSC      STATUS+0, 0
	GOTO       L_switches18
;ventilator.c,133 :: 		vol=550;
	MOVLW      38
	MOVWF      _vol+0
	MOVLW      2
	MOVWF      _vol+1
;ventilator.c,134 :: 		}
L_switches18:
;ventilator.c,135 :: 		if(vol<450){
	MOVLW      1
	SUBWF      _vol+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches123
	MOVLW      194
	SUBWF      _vol+0, 0
L__switches123:
	BTFSC      STATUS+0, 0
	GOTO       L_switches19
;ventilator.c,136 :: 		vol=450;
	MOVLW      194
	MOVWF      _vol+0
	MOVLW      1
	MOVWF      _vol+1
;ventilator.c,137 :: 		}
L_switches19:
;ventilator.c,139 :: 		}
L_switches17:
;ventilator.c,141 :: 		if (Button(&PORTB, 5, 1, 0)) {               // Detect logical zero
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      5
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches20
;ventilator.c,142 :: 		oldvoldown = 1;                              // Update flag
	BSF        _oldvoldown+0, BitPos(_oldvoldown+0)
;ventilator.c,143 :: 		}
L_switches20:
;ventilator.c,144 :: 		if (oldvoldown && Button(&PORTB, 5, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldvoldown+0, BitPos(_oldvoldown+0)
	GOTO       L_switches23
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      5
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches23
L__switches108:
;ventilator.c,145 :: 		oldvoldown = 0;                                   // Update flag
	BCF        _oldvoldown+0, BitPos(_oldvoldown+0)
;ventilator.c,147 :: 		vol=vol-50;                                         //decrement volume level
	MOVLW      50
	SUBWF      _vol+0, 0
	MOVWF      R1+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _vol+1, 0
	MOVWF      R1+1
	MOVF       R1+0, 0
	MOVWF      _vol+0
	MOVF       R1+1, 0
	MOVWF      _vol+1
;ventilator.c,148 :: 		if(vol>550){                                         //limit volume level
	MOVF       R1+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches124
	MOVF       R1+0, 0
	SUBLW      38
L__switches124:
	BTFSC      STATUS+0, 0
	GOTO       L_switches24
;ventilator.c,149 :: 		vol=550;
	MOVLW      38
	MOVWF      _vol+0
	MOVLW      2
	MOVWF      _vol+1
;ventilator.c,150 :: 		}
L_switches24:
;ventilator.c,151 :: 		if(vol<450){
	MOVLW      1
	SUBWF      _vol+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches125
	MOVLW      194
	SUBWF      _vol+0, 0
L__switches125:
	BTFSC      STATUS+0, 0
	GOTO       L_switches25
;ventilator.c,152 :: 		vol=450;
	MOVLW      194
	MOVWF      _vol+0
	MOVLW      1
	MOVWF      _vol+1
;ventilator.c,153 :: 		}
L_switches25:
;ventilator.c,156 :: 		}
L_switches23:
;ventilator.c,159 :: 		if ( !startstatus  && Button(&PORTC, 6, 1, 0)) {               // Detect logical zero
	MOVF       _startstatus+0, 0
	IORWF      _startstatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_switches28
	MOVLW      PORTC+0
	MOVWF      FARG_Button_port+0
	MOVLW      6
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches28
L__switches107:
;ventilator.c,162 :: 		startstatus = 1;                              // Update flag
	MOVLW      1
	MOVWF      _startstatus+0
	MOVLW      0
	MOVWF      _startstatus+1
;ventilator.c,163 :: 		}
L_switches28:
;ventilator.c,164 :: 		if (startstatus && Button(&PORTC, 7, 1, 0)) {   // Detect logical zero
	MOVF       _startstatus+0, 0
	IORWF      _startstatus+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches31
	MOVLW      PORTC+0
	MOVWF      FARG_Button_port+0
	MOVLW      7
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches31
L__switches106:
;ventilator.c,167 :: 		startstatus = 0;               // Update flag
	CLRF       _startstatus+0
	CLRF       _startstatus+1
;ventilator.c,168 :: 		}
L_switches31:
;ventilator.c,172 :: 		switch (vol){                       //led value for each volume level
	GOTO       L_switches32
;ventilator.c,173 :: 		case 450:
L_switches34:
;ventilator.c,174 :: 		led[5]=1;
	MOVLW      1
	MOVWF      _led+10
	MOVLW      0
	MOVWF      _led+11
;ventilator.c,175 :: 		led[6]=0;
	CLRF       _led+12
	CLRF       _led+13
;ventilator.c,176 :: 		led[7]=0;
	CLRF       _led+14
	CLRF       _led+15
;ventilator.c,178 :: 		break;
	GOTO       L_switches33
;ventilator.c,179 :: 		case 500:
L_switches35:
;ventilator.c,180 :: 		led[5]=0;
	CLRF       _led+10
	CLRF       _led+11
;ventilator.c,181 :: 		led[6]=1;
	MOVLW      1
	MOVWF      _led+12
	MOVLW      0
	MOVWF      _led+13
;ventilator.c,182 :: 		led[7]=0;
	CLRF       _led+14
	CLRF       _led+15
;ventilator.c,184 :: 		break;
	GOTO       L_switches33
;ventilator.c,185 :: 		case 550:
L_switches36:
;ventilator.c,186 :: 		led[5]=0;
	CLRF       _led+10
	CLRF       _led+11
;ventilator.c,187 :: 		led[6]=0;
	CLRF       _led+12
	CLRF       _led+13
;ventilator.c,188 :: 		led[7]=1;
	MOVLW      1
	MOVWF      _led+14
	MOVLW      0
	MOVWF      _led+15
;ventilator.c,190 :: 		break;
	GOTO       L_switches33
;ventilator.c,192 :: 		}
L_switches32:
	MOVF       _vol+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__switches126
	MOVLW      194
	XORWF      _vol+0, 0
L__switches126:
	BTFSC      STATUS+0, 2
	GOTO       L_switches34
	MOVF       _vol+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__switches127
	MOVLW      244
	XORWF      _vol+0, 0
L__switches127:
	BTFSC      STATUS+0, 2
	GOTO       L_switches35
	MOVF       _vol+1, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches128
	MOVLW      38
	XORWF      _vol+0, 0
L__switches128:
	BTFSC      STATUS+0, 2
	GOTO       L_switches36
L_switches33:
;ventilator.c,194 :: 		switch (bpmv){                           //led value for each bpm value
	GOTO       L_switches37
;ventilator.c,195 :: 		case 12:
L_switches39:
;ventilator.c,196 :: 		led[0]=1;
	MOVLW      1
	MOVWF      _led+0
	MOVLW      0
	MOVWF      _led+1
;ventilator.c,197 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,198 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,199 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,200 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,201 :: 		break;
	GOTO       L_switches38
;ventilator.c,202 :: 		case 13:
L_switches40:
;ventilator.c,203 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,204 :: 		led[1]=1;
	MOVLW      1
	MOVWF      _led+2
	MOVLW      0
	MOVWF      _led+3
;ventilator.c,205 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,206 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,207 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,208 :: 		break;
	GOTO       L_switches38
;ventilator.c,209 :: 		case 14:
L_switches41:
;ventilator.c,210 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,211 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,212 :: 		led[2]=1;
	MOVLW      1
	MOVWF      _led+4
	MOVLW      0
	MOVWF      _led+5
;ventilator.c,213 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,214 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,215 :: 		break;
	GOTO       L_switches38
;ventilator.c,216 :: 		case 15:
L_switches42:
;ventilator.c,217 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,218 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,219 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,220 :: 		led[3]=1;
	MOVLW      1
	MOVWF      _led+6
	MOVLW      0
	MOVWF      _led+7
;ventilator.c,221 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,222 :: 		break;
	GOTO       L_switches38
;ventilator.c,223 :: 		case 16:
L_switches43:
;ventilator.c,224 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,225 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,226 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,227 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,228 :: 		led[4]=1;
	MOVLW      1
	MOVWF      _led+8
	MOVLW      0
	MOVWF      _led+9
;ventilator.c,229 :: 		break;
	GOTO       L_switches38
;ventilator.c,230 :: 		}
L_switches37:
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches129
	MOVLW      12
	XORWF      _bpmv+0, 0
L__switches129:
	BTFSC      STATUS+0, 2
	GOTO       L_switches39
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches130
	MOVLW      13
	XORWF      _bpmv+0, 0
L__switches130:
	BTFSC      STATUS+0, 2
	GOTO       L_switches40
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches131
	MOVLW      14
	XORWF      _bpmv+0, 0
L__switches131:
	BTFSC      STATUS+0, 2
	GOTO       L_switches41
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches132
	MOVLW      15
	XORWF      _bpmv+0, 0
L__switches132:
	BTFSC      STATUS+0, 2
	GOTO       L_switches42
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches133
	MOVLW      16
	XORWF      _bpmv+0, 0
L__switches133:
	BTFSC      STATUS+0, 2
	GOTO       L_switches43
L_switches38:
;ventilator.c,232 :: 		shiftdata595(led);                  //send out led data
	MOVLW      _led+0
	MOVWF      FARG_shiftdata595__shiftdata+0
	CALL       _shiftdata595+0
;ventilator.c,233 :: 		latch595();
	CALL       _latch595+0
;ventilator.c,236 :: 		}
L_end_switches:
	RETURN
; end of _switches

_selftest:

;ventilator.c,239 :: 		void selftest(){
;ventilator.c,249 :: 		testl=1;                                        //test led on
	BSF        PORTD+0, 3
;ventilator.c,250 :: 		Sound_Play(500, 500);                            //selftest ok notify alarm
	MOVLW      244
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      244
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,251 :: 		Sound_Play(1000, 500);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      244
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,259 :: 		}
L_selftest45:
;ventilator.c,260 :: 		}
L_end_selftest:
	RETURN
; end of _selftest

_InitTimer0:

;ventilator.c,274 :: 		void InitTimer0(){
;ventilator.c,275 :: 		OPTION_REG         = 0x84;
	MOVLW      132
	MOVWF      OPTION_REG+0
;ventilator.c,276 :: 		TMR0                 = 100;
	MOVLW      100
	MOVWF      TMR0+0
;ventilator.c,277 :: 		INTCON         = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;ventilator.c,278 :: 		}
L_end_InitTimer0:
	RETURN
; end of _InitTimer0

_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;ventilator.c,280 :: 		void Interrupt(){
;ventilator.c,281 :: 		if (TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_Interrupt48
;ventilator.c,282 :: 		TMR0IF_bit         = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;ventilator.c,283 :: 		TMR0                 = 100;
	MOVLW      100
	MOVWF      TMR0+0
;ventilator.c,285 :: 		millis_count++;
	MOVF       _millis_count+0, 0
	MOVWF      R0+0
	MOVF       _millis_count+1, 0
	MOVWF      R0+1
	MOVF       _millis_count+2, 0
	MOVWF      R0+2
	MOVF       _millis_count+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _millis_count+0
	MOVF       R0+1, 0
	MOVWF      _millis_count+1
	MOVF       R0+2, 0
	MOVWF      _millis_count+2
	MOVF       R0+3, 0
	MOVWF      _millis_count+3
;ventilator.c,287 :: 		}
L_Interrupt48:
;ventilator.c,289 :: 		}
L_end_Interrupt:
L__Interrupt137:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_millis:

;ventilator.c,291 :: 		unsigned long millis()
;ventilator.c,293 :: 		return(millis_count);
	MOVF       _millis_count+0, 0
	MOVWF      R0+0
	MOVF       _millis_count+1, 0
	MOVWF      R0+1
	MOVF       _millis_count+2, 0
	MOVWF      R0+2
	MOVF       _millis_count+3, 0
	MOVWF      R0+3
;ventilator.c,294 :: 		}
L_end_millis:
	RETURN
; end of _millis

_main:

;ventilator.c,302 :: 		void main()
;ventilator.c,305 :: 		ADCON1 = 0x80;
	MOVLW      128
	MOVWF      ADCON1+0
;ventilator.c,307 :: 		TRISA  = 0xFF;              // PORTA is input
	MOVLW      255
	MOVWF      TRISA+0
;ventilator.c,312 :: 		PORTB=0;  // set portB as digital
	CLRF       PORTB+0
;ventilator.c,313 :: 		TRISB=0xf0;  // set portB input/outputs
	MOVLW      240
	MOVWF      TRISB+0
;ventilator.c,314 :: 		OPTION_REG.F7=0;
	BCF        OPTION_REG+0, 7
;ventilator.c,315 :: 		PORTC=0;  // set portC as digital
	CLRF       PORTC+0
;ventilator.c,316 :: 		TRISC=0xff;  // set portC as inputs
	MOVLW      255
	MOVWF      TRISC+0
;ventilator.c,317 :: 		PORTD=0;  // set portD as digital
	CLRF       PORTD+0
;ventilator.c,318 :: 		TRISD=0x00;  // set portD as outputs
	CLRF       TRISD+0
;ventilator.c,319 :: 		InitTimer0();//inica conte timer cada milisegundo
	CALL       _InitTimer0+0
;ventilator.c,322 :: 		Sound_Init(&PORTD, 2);
	MOVLW      PORTD+0
	MOVWF      FARG_Sound_Init_snd_port+0
	MOVLW      2
	MOVWF      FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;ventilator.c,324 :: 		selftest();//do self test
	CALL       _selftest+0
;ventilator.c,325 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main49:
	DECFSZ     R13+0, 1
	GOTO       L_main49
	DECFSZ     R12+0, 1
	GOTO       L_main49
	DECFSZ     R11+0, 1
	GOTO       L_main49
	NOP
	NOP
;ventilator.c,326 :: 		startl=0;
	BCF        PORTD+0, 4
;ventilator.c,327 :: 		testl=0;
	BCF        PORTD+0, 3
;ventilator.c,328 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main50:
	DECFSZ     R13+0, 1
	GOTO       L_main50
	DECFSZ     R12+0, 1
	GOTO       L_main50
	DECFSZ     R11+0, 1
	GOTO       L_main50
	NOP
	NOP
;ventilator.c,330 :: 		time1=millis();
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      _time1+0
	MOVF       R0+1, 0
	MOVWF      _time1+1
	MOVF       R0+2, 0
	MOVWF      _time1+2
	MOVF       R0+3, 0
	MOVWF      _time1+3
;ventilator.c,331 :: 		while(1){
L_main51:
;ventilator.c,333 :: 		switches();
	CALL       _switches+0
;ventilator.c,336 :: 		s2v=1;
	BSF        PORTD+0, 5
;ventilator.c,337 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,338 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main53:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main140
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main140:
	BTFSC      STATUS+0, 0
	GOTO       L_main54
;ventilator.c,340 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,341 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,338 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,342 :: 		}
	GOTO       L_main53
L_main54:
;ventilator.c,343 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main56:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main141
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main141:
	BTFSC      STATUS+0, 0
	GOTO       L_main57
;ventilator.c,346 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,343 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,347 :: 		}
	GOTO       L_main56
L_main57:
;ventilator.c,349 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main59:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main142
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main142:
	BTFSC      STATUS+0, 0
	GOTO       L_main60
;ventilator.c,351 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,352 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,349 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,353 :: 		}
	GOTO       L_main59
L_main60:
;ventilator.c,354 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main62:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main143
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main143:
	BTFSC      STATUS+0, 0
	GOTO       L_main63
;ventilator.c,356 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,357 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,354 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,358 :: 		}
	GOTO       L_main62
L_main63:
;ventilator.c,359 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main65:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main144
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main144:
	BTFSC      STATUS+0, 0
	GOTO       L_main66
;ventilator.c,361 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,362 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,359 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,363 :: 		}
	GOTO       L_main65
L_main66:
;ventilator.c,364 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main68:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main145
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main145:
	BTFSC      STATUS+0, 0
	GOTO       L_main69
;ventilator.c,366 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,367 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,364 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,368 :: 		}
	GOTO       L_main68
L_main69:
;ventilator.c,369 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main71:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main146
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main146:
	BTFSC      STATUS+0, 0
	GOTO       L_main72
;ventilator.c,371 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,372 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,369 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,373 :: 		}
	GOTO       L_main71
L_main72:
;ventilator.c,374 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main74:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main147
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main147:
	BTFSC      STATUS+0, 0
	GOTO       L_main75
;ventilator.c,376 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,377 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,374 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,378 :: 		}
	GOTO       L_main74
L_main75:
;ventilator.c,379 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main77:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main148
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main148:
	BTFSC      STATUS+0, 0
	GOTO       L_main78
;ventilator.c,381 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,382 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,379 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,383 :: 		}
	GOTO       L_main77
L_main78:
;ventilator.c,384 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main80:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main149
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main149:
	BTFSC      STATUS+0, 0
	GOTO       L_main81
;ventilator.c,386 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,387 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,384 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,388 :: 		}
	GOTO       L_main80
L_main81:
;ventilator.c,389 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main83:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main150
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main150:
	BTFSC      STATUS+0, 0
	GOTO       L_main84
;ventilator.c,391 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,392 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,389 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,393 :: 		}
	GOTO       L_main83
L_main84:
;ventilator.c,394 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main86:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main151
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main151:
	BTFSC      STATUS+0, 0
	GOTO       L_main87
;ventilator.c,396 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,397 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,394 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,398 :: 		}
	GOTO       L_main86
L_main87:
;ventilator.c,399 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main89:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main152
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main152:
	BTFSC      STATUS+0, 0
	GOTO       L_main90
;ventilator.c,401 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,402 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,399 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,403 :: 		}
	GOTO       L_main89
L_main90:
;ventilator.c,404 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main92:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main153
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main153:
	BTFSC      STATUS+0, 0
	GOTO       L_main93
;ventilator.c,406 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,407 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,404 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,408 :: 		}
	GOTO       L_main92
L_main93:
;ventilator.c,409 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main95:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main154
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main154:
	BTFSC      STATUS+0, 0
	GOTO       L_main96
;ventilator.c,411 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,412 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,409 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,413 :: 		}
	GOTO       L_main95
L_main96:
;ventilator.c,414 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main98:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main155
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main155:
	BTFSC      STATUS+0, 0
	GOTO       L_main99
;ventilator.c,416 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,417 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,414 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,418 :: 		}
	GOTO       L_main98
L_main99:
;ventilator.c,419 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main101:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main156
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main156:
	BTFSC      STATUS+0, 0
	GOTO       L_main102
;ventilator.c,421 :: 		adc = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc+0
	MOVF       R0+1, 0
	MOVWF      _adc+1
;ventilator.c,422 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,419 :: 		for(i=0;i<count;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,423 :: 		}
	GOTO       L_main101
L_main102:
;ventilator.c,426 :: 		if (millis()-time1>=100)
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVF       _time1+0, 0
	SUBWF      R4+0, 1
	MOVF       _time1+1, 0
	BTFSS      STATUS+0, 0
	INCFSZ     _time1+1, 0
	SUBWF      R4+1, 1
	MOVF       _time1+2, 0
	BTFSS      STATUS+0, 0
	INCFSZ     _time1+2, 0
	SUBWF      R4+2, 1
	MOVF       _time1+3, 0
	BTFSS      STATUS+0, 0
	INCFSZ     _time1+3, 0
	SUBWF      R4+3, 1
	MOVLW      0
	SUBWF      R4+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main157
	MOVLW      0
	SUBWF      R4+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main157
	MOVLW      0
	SUBWF      R4+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main157
	MOVLW      100
	SUBWF      R4+0, 0
L__main157:
	BTFSS      STATUS+0, 0
	GOTO       L_main104
;ventilator.c,428 :: 		testl=1  ;
	BSF        PORTD+0, 3
;ventilator.c,429 :: 		startl=0 ;
	BCF        PORTD+0, 4
;ventilator.c,430 :: 		time1=millis();
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      _time1+0
	MOVF       R0+1, 0
	MOVWF      _time1+1
	MOVF       R0+2, 0
	MOVWF      _time1+2
	MOVF       R0+3, 0
	MOVWF      _time1+3
;ventilator.c,431 :: 		}
	GOTO       L_main105
L_main104:
;ventilator.c,434 :: 		testl=0  ;
	BCF        PORTD+0, 3
;ventilator.c,435 :: 		startl=1 ;
	BSF        PORTD+0, 4
;ventilator.c,436 :: 		time1=millis();
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      _time1+0
	MOVF       R0+1, 0
	MOVWF      _time1+1
	MOVF       R0+2, 0
	MOVWF      _time1+2
	MOVF       R0+3, 0
	MOVWF      _time1+3
;ventilator.c,437 :: 		}
L_main105:
;ventilator.c,438 :: 		}
	GOTO       L_main51
;ventilator.c,439 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

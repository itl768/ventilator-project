
_shiftdata595:

;ventilator.c,39 :: 		void shiftdata595(int _shiftdata[])  //shift register
;ventilator.c,43 :: 		i=8;
	MOVLW      8
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
;ventilator.c,44 :: 		while (i>0)                  //loop to send 8bit data
L_shiftdata5950:
	MOVF       R4+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__shiftdata595119
	MOVF       R4+0, 0
	SUBLW      0
L__shiftdata595119:
	BTFSC      STATUS+0, 0
	GOTO       L_shiftdata5951
;ventilator.c,46 :: 		SHIFT_DATA=_shiftdata[i-1]; //  send array value
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
	GOTO       L__shiftdata595120
	BCF        PORTB+0, 0
	GOTO       L__shiftdata595121
L__shiftdata595120:
	BSF        PORTB+0, 0
L__shiftdata595121:
;ventilator.c,47 :: 		SHIFT_CLOCK = 1;
	BSF        PORTB+0, 2
;ventilator.c,49 :: 		SHIFT_CLOCK = 0;
	BCF        PORTB+0, 2
;ventilator.c,50 :: 		i--;
	MOVF       R2+0, 0
	MOVWF      R4+0
	MOVF       R2+1, 0
	MOVWF      R4+1
;ventilator.c,51 :: 		}
	GOTO       L_shiftdata5950
L_shiftdata5951:
;ventilator.c,52 :: 		}
L_end_shiftdata595:
	RETURN
; end of _shiftdata595

_latch595:

;ventilator.c,54 :: 		void latch595()              //latch pin controll
;ventilator.c,56 :: 		SHIFT_LATCH = 1;
	BSF        PORTB+0, 1
;ventilator.c,58 :: 		SHIFT_LATCH = 0;
	BCF        PORTB+0, 1
;ventilator.c,59 :: 		}
L_end_latch595:
	RETURN
; end of _latch595

_switches:

;ventilator.c,63 :: 		void switches(){
;ventilator.c,65 :: 		if (Button(&PORTB, 6, 100, 0)) {               // Detect logical zero
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      6
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches2
;ventilator.c,66 :: 		oldbpmup = 1;                              // Update flag
	BSF        _oldbpmup+0, BitPos(_oldbpmup+0)
;ventilator.c,67 :: 		}
L_switches2:
;ventilator.c,68 :: 		if (oldbpmup && Button(&PORTB, 6, 100, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldbpmup+0, BitPos(_oldbpmup+0)
	GOTO       L_switches5
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      6
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches5
L__switches117:
;ventilator.c,69 :: 		oldbpmup = 0;                            // Update flag
	BCF        _oldbpmup+0, BitPos(_oldbpmup+0)
;ventilator.c,70 :: 		bpmv++;                                //increment bpm level
	INCF       _bpmv+0, 1
	BTFSC      STATUS+0, 2
	INCF       _bpmv+1, 1
;ventilator.c,71 :: 		Sound_Play(1318, 50);
	MOVLW      38
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      5
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      50
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,72 :: 		if(bpmv>16){                     //limit bpm value
	MOVF       _bpmv+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__switches124
	MOVF       _bpmv+0, 0
	SUBLW      16
L__switches124:
	BTFSC      STATUS+0, 0
	GOTO       L_switches6
;ventilator.c,73 :: 		bpmv=16;
	MOVLW      16
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,74 :: 		}
L_switches6:
;ventilator.c,75 :: 		if(bpmv<12){
	MOVLW      0
	SUBWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches125
	MOVLW      12
	SUBWF      _bpmv+0, 0
L__switches125:
	BTFSC      STATUS+0, 0
	GOTO       L_switches7
;ventilator.c,76 :: 		bpmv=12;
	MOVLW      12
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,77 :: 		}
L_switches7:
;ventilator.c,80 :: 		}
L_switches5:
;ventilator.c,82 :: 		if (Button(&PORTB, 7, 100, 0)) {               // Detect logical zero
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      7
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches8
;ventilator.c,83 :: 		oldbpmdown = 1;                              // Update flag
	BSF        _oldbpmdown+0, BitPos(_oldbpmdown+0)
;ventilator.c,84 :: 		}
L_switches8:
;ventilator.c,85 :: 		if (oldbpmdown && Button(&PORTB, 7, 100, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldbpmdown+0, BitPos(_oldbpmdown+0)
	GOTO       L_switches11
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      7
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches11
L__switches116:
;ventilator.c,86 :: 		oldbpmdown = 0;                           // Update flag
	BCF        _oldbpmdown+0, BitPos(_oldbpmdown+0)
;ventilator.c,87 :: 		Sound_Play(1318, 50);
	MOVLW      38
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      5
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      50
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,89 :: 		bpmv--;                                      //decrement bpm value
	MOVLW      1
	SUBWF      _bpmv+0, 1
	BTFSS      STATUS+0, 0
	DECF       _bpmv+1, 1
;ventilator.c,90 :: 		if(bpmv>16){                                 //limit bpm value
	MOVF       _bpmv+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__switches126
	MOVF       _bpmv+0, 0
	SUBLW      16
L__switches126:
	BTFSC      STATUS+0, 0
	GOTO       L_switches12
;ventilator.c,91 :: 		bpmv=16;
	MOVLW      16
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,92 :: 		}
L_switches12:
;ventilator.c,93 :: 		if(bpmv<12){
	MOVLW      0
	SUBWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches127
	MOVLW      12
	SUBWF      _bpmv+0, 0
L__switches127:
	BTFSC      STATUS+0, 0
	GOTO       L_switches13
;ventilator.c,94 :: 		bpmv=12;
	MOVLW      12
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,95 :: 		}
L_switches13:
;ventilator.c,98 :: 		}
L_switches11:
;ventilator.c,103 :: 		if (Button(&PORTB, 4, 100, 0)) {               // Detect logical zero
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      4
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches14
;ventilator.c,104 :: 		oldvolup = 1;                              // Update flag
	BSF        _oldvolup+0, BitPos(_oldvolup+0)
;ventilator.c,105 :: 		}
L_switches14:
;ventilator.c,106 :: 		if (oldvolup && Button(&PORTB, 4, 100, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldvolup+0, BitPos(_oldvolup+0)
	GOTO       L_switches17
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      4
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches17
L__switches115:
;ventilator.c,107 :: 		oldvolup = 0;                    // Update flag
	BCF        _oldvolup+0, BitPos(_oldvolup+0)
;ventilator.c,108 :: 		Sound_Play(1000, 100);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      100
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,109 :: 		vol=vol+50;              //increment volume level by 50
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
;ventilator.c,110 :: 		if(vol>550){                                         //limit volume level
	MOVF       R1+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches128
	MOVF       R1+0, 0
	SUBLW      38
L__switches128:
	BTFSC      STATUS+0, 0
	GOTO       L_switches18
;ventilator.c,111 :: 		vol=550;
	MOVLW      38
	MOVWF      _vol+0
	MOVLW      2
	MOVWF      _vol+1
;ventilator.c,112 :: 		}
L_switches18:
;ventilator.c,113 :: 		if(vol<450){
	MOVLW      1
	SUBWF      _vol+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches129
	MOVLW      194
	SUBWF      _vol+0, 0
L__switches129:
	BTFSC      STATUS+0, 0
	GOTO       L_switches19
;ventilator.c,114 :: 		vol=450;
	MOVLW      194
	MOVWF      _vol+0
	MOVLW      1
	MOVWF      _vol+1
;ventilator.c,115 :: 		}
L_switches19:
;ventilator.c,117 :: 		}
L_switches17:
;ventilator.c,119 :: 		if (Button(&PORTB, 5, 100, 0)) {               // Detect logical zero
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      5
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches20
;ventilator.c,120 :: 		oldvoldown = 1;                              // Update flag
	BSF        _oldvoldown+0, BitPos(_oldvoldown+0)
;ventilator.c,121 :: 		}
L_switches20:
;ventilator.c,122 :: 		if (oldvoldown && Button(&PORTB, 5, 100, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldvoldown+0, BitPos(_oldvoldown+0)
	GOTO       L_switches23
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      5
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches23
L__switches114:
;ventilator.c,123 :: 		oldvoldown = 0;                                   // Update flag
	BCF        _oldvoldown+0, BitPos(_oldvoldown+0)
;ventilator.c,124 :: 		Sound_Play(1000, 100);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      100
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,125 :: 		vol=vol-50;                                         //decrement volume level
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
;ventilator.c,126 :: 		if(vol>550){                                         //limit volume level
	MOVF       R1+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches130
	MOVF       R1+0, 0
	SUBLW      38
L__switches130:
	BTFSC      STATUS+0, 0
	GOTO       L_switches24
;ventilator.c,127 :: 		vol=550;
	MOVLW      38
	MOVWF      _vol+0
	MOVLW      2
	MOVWF      _vol+1
;ventilator.c,128 :: 		}
L_switches24:
;ventilator.c,129 :: 		if(vol<450){
	MOVLW      1
	SUBWF      _vol+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches131
	MOVLW      194
	SUBWF      _vol+0, 0
L__switches131:
	BTFSC      STATUS+0, 0
	GOTO       L_switches25
;ventilator.c,130 :: 		vol=450;
	MOVLW      194
	MOVWF      _vol+0
	MOVLW      1
	MOVWF      _vol+1
;ventilator.c,131 :: 		}
L_switches25:
;ventilator.c,134 :: 		}
L_switches23:
;ventilator.c,137 :: 		if ( !startstatus  && Button(&PORTC, 6, 100, 0)) {               // Detect logical zero
	MOVF       _startstatus+0, 0
	IORWF      _startstatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_switches28
	MOVLW      PORTC+0
	MOVWF      FARG_Button_port+0
	MOVLW      6
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches28
L__switches113:
;ventilator.c,138 :: 		Sound_Play(1000, 100);                         //play alarm
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      100
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,139 :: 		startl=1;                                      //led indicator
	BSF        PORTD+0, 4
;ventilator.c,140 :: 		startstatus = 1;                              // Update flag
	MOVLW      1
	MOVWF      _startstatus+0
	MOVLW      0
	MOVWF      _startstatus+1
;ventilator.c,141 :: 		}
L_switches28:
;ventilator.c,142 :: 		if (startstatus && Button(&PORTC, 7, 100, 0)) {   // Detect logical zero
	MOVF       _startstatus+0, 0
	IORWF      _startstatus+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches31
	MOVLW      PORTC+0
	MOVWF      FARG_Button_port+0
	MOVLW      7
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches31
L__switches112:
;ventilator.c,143 :: 		Sound_Play(500, 100);                         //play alarm
	MOVLW      244
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      100
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,144 :: 		startl=0;                                    //led indicator
	BCF        PORTD+0, 4
;ventilator.c,145 :: 		startstatus = 0;               // Update flag
	CLRF       _startstatus+0
	CLRF       _startstatus+1
;ventilator.c,146 :: 		}
L_switches31:
;ventilator.c,150 :: 		switch (vol){                       //led value for each volume level
	GOTO       L_switches32
;ventilator.c,151 :: 		case 450:
L_switches34:
;ventilator.c,152 :: 		led[5]=1;
	MOVLW      1
	MOVWF      _led+10
	MOVLW      0
	MOVWF      _led+11
;ventilator.c,153 :: 		led[6]=0;
	CLRF       _led+12
	CLRF       _led+13
;ventilator.c,154 :: 		led[7]=0;
	CLRF       _led+14
	CLRF       _led+15
;ventilator.c,156 :: 		break;
	GOTO       L_switches33
;ventilator.c,157 :: 		case 500:
L_switches35:
;ventilator.c,158 :: 		led[5]=0;
	CLRF       _led+10
	CLRF       _led+11
;ventilator.c,159 :: 		led[6]=1;
	MOVLW      1
	MOVWF      _led+12
	MOVLW      0
	MOVWF      _led+13
;ventilator.c,160 :: 		led[7]=0;
	CLRF       _led+14
	CLRF       _led+15
;ventilator.c,162 :: 		break;
	GOTO       L_switches33
;ventilator.c,163 :: 		case 550:
L_switches36:
;ventilator.c,164 :: 		led[5]=0;
	CLRF       _led+10
	CLRF       _led+11
;ventilator.c,165 :: 		led[6]=0;
	CLRF       _led+12
	CLRF       _led+13
;ventilator.c,166 :: 		led[7]=1;
	MOVLW      1
	MOVWF      _led+14
	MOVLW      0
	MOVWF      _led+15
;ventilator.c,168 :: 		break;
	GOTO       L_switches33
;ventilator.c,170 :: 		}
L_switches32:
	MOVF       _vol+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__switches132
	MOVLW      194
	XORWF      _vol+0, 0
L__switches132:
	BTFSC      STATUS+0, 2
	GOTO       L_switches34
	MOVF       _vol+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__switches133
	MOVLW      244
	XORWF      _vol+0, 0
L__switches133:
	BTFSC      STATUS+0, 2
	GOTO       L_switches35
	MOVF       _vol+1, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches134
	MOVLW      38
	XORWF      _vol+0, 0
L__switches134:
	BTFSC      STATUS+0, 2
	GOTO       L_switches36
L_switches33:
;ventilator.c,172 :: 		switch (bpmv){                           //led value for each bpm value
	GOTO       L_switches37
;ventilator.c,173 :: 		case 12:
L_switches39:
;ventilator.c,174 :: 		led[0]=1;
	MOVLW      1
	MOVWF      _led+0
	MOVLW      0
	MOVWF      _led+1
;ventilator.c,175 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,176 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,177 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,178 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,179 :: 		break;
	GOTO       L_switches38
;ventilator.c,180 :: 		case 13:
L_switches40:
;ventilator.c,181 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,182 :: 		led[1]=1;
	MOVLW      1
	MOVWF      _led+2
	MOVLW      0
	MOVWF      _led+3
;ventilator.c,183 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,184 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,185 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,186 :: 		break;
	GOTO       L_switches38
;ventilator.c,187 :: 		case 14:
L_switches41:
;ventilator.c,188 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,189 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,190 :: 		led[2]=1;
	MOVLW      1
	MOVWF      _led+4
	MOVLW      0
	MOVWF      _led+5
;ventilator.c,191 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,192 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,193 :: 		break;
	GOTO       L_switches38
;ventilator.c,194 :: 		case 15:
L_switches42:
;ventilator.c,195 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,196 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,197 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,198 :: 		led[3]=1;
	MOVLW      1
	MOVWF      _led+6
	MOVLW      0
	MOVWF      _led+7
;ventilator.c,199 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,200 :: 		break;
	GOTO       L_switches38
;ventilator.c,201 :: 		case 16:
L_switches43:
;ventilator.c,202 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,203 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,204 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,205 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,206 :: 		led[4]=1;
	MOVLW      1
	MOVWF      _led+8
	MOVLW      0
	MOVWF      _led+9
;ventilator.c,207 :: 		break;
	GOTO       L_switches38
;ventilator.c,208 :: 		}
L_switches37:
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches135
	MOVLW      12
	XORWF      _bpmv+0, 0
L__switches135:
	BTFSC      STATUS+0, 2
	GOTO       L_switches39
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches136
	MOVLW      13
	XORWF      _bpmv+0, 0
L__switches136:
	BTFSC      STATUS+0, 2
	GOTO       L_switches40
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches137
	MOVLW      14
	XORWF      _bpmv+0, 0
L__switches137:
	BTFSC      STATUS+0, 2
	GOTO       L_switches41
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches138
	MOVLW      15
	XORWF      _bpmv+0, 0
L__switches138:
	BTFSC      STATUS+0, 2
	GOTO       L_switches42
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches139
	MOVLW      16
	XORWF      _bpmv+0, 0
L__switches139:
	BTFSC      STATUS+0, 2
	GOTO       L_switches43
L_switches38:
;ventilator.c,210 :: 		shiftdata595(led);                  //send out led data
	MOVLW      _led+0
	MOVWF      FARG_shiftdata595__shiftdata+0
	CALL       _shiftdata595+0
;ventilator.c,211 :: 		latch595();
	CALL       _latch595+0
;ventilator.c,214 :: 		}
L_end_switches:
	RETURN
; end of _switches

_selftest:

;ventilator.c,217 :: 		void selftest(){
;ventilator.c,227 :: 		testl=1;                                        //test led on
	BSF        PORTD+0, 3
;ventilator.c,228 :: 		Sound_Play(500, 500);                            //selftest ok notify alarm
	MOVLW      244
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      244
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,229 :: 		Sound_Play(1000, 500);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      244
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,237 :: 		}
L_selftest45:
;ventilator.c,238 :: 		}
L_end_selftest:
	RETURN
; end of _selftest

_InitTimer0:

;ventilator.c,252 :: 		void InitTimer0(){
;ventilator.c,253 :: 		OPTION_REG	 = 0x84;
	MOVLW      132
	MOVWF      OPTION_REG+0
;ventilator.c,254 :: 		TMR0		 = 100;
	MOVLW      100
	MOVWF      TMR0+0
;ventilator.c,255 :: 		INTCON	 = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;ventilator.c,256 :: 		}
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

;ventilator.c,258 :: 		void Interrupt(){
;ventilator.c,259 :: 		if (TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_Interrupt48
;ventilator.c,260 :: 		TMR0IF_bit	 = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;ventilator.c,261 :: 		TMR0		 = 100;
	MOVLW      100
	MOVWF      TMR0+0
;ventilator.c,263 :: 		millis_count++;
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
;ventilator.c,265 :: 		}
L_Interrupt48:
;ventilator.c,267 :: 		}
L_end_Interrupt:
L__Interrupt143:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_millis:

;ventilator.c,269 :: 		unsigned long millis()
;ventilator.c,271 :: 		return(millis_count);
	MOVF       _millis_count+0, 0
	MOVWF      R0+0
	MOVF       _millis_count+1, 0
	MOVWF      R0+1
	MOVF       _millis_count+2, 0
	MOVWF      R0+2
	MOVF       _millis_count+3, 0
	MOVWF      R0+3
;ventilator.c,272 :: 		}
L_end_millis:
	RETURN
; end of _millis

_main:

;ventilator.c,280 :: 		void main()
;ventilator.c,282 :: 		PORTB=0;  // set portB as digital
	CLRF       PORTB+0
;ventilator.c,283 :: 		TRISB=0xf0;  // set portB input/outputs
	MOVLW      240
	MOVWF      TRISB+0
;ventilator.c,284 :: 		PORTC=0;  // set portC as digital
	CLRF       PORTC+0
;ventilator.c,285 :: 		TRISC=0xff;  // set portC as inputs
	MOVLW      255
	MOVWF      TRISC+0
;ventilator.c,286 :: 		PORTD=0;  // set portD as digital
	CLRF       PORTD+0
;ventilator.c,287 :: 		TRISD=0x00;  // set portD as outputs
	CLRF       TRISD+0
;ventilator.c,288 :: 		InitTimer0();//inica conte timer cada milisegundo
	CALL       _InitTimer0+0
;ventilator.c,291 :: 		Sound_Init(&PORTD, 2);
	MOVLW      PORTD+0
	MOVWF      FARG_Sound_Init_snd_port+0
	MOVLW      2
	MOVWF      FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;ventilator.c,293 :: 		selftest();//do self test
	CALL       _selftest+0
;ventilator.c,294 :: 		Delay_ms(100);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_main49:
	DECFSZ     R13+0, 1
	GOTO       L_main49
	DECFSZ     R12+0, 1
	GOTO       L_main49
	NOP
;ventilator.c,295 :: 		startl=0;
	BCF        PORTD+0, 4
;ventilator.c,296 :: 		testl=0;
	BCF        PORTD+0, 3
;ventilator.c,297 :: 		Delay_ms(100);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_main50:
	DECFSZ     R13+0, 1
	GOTO       L_main50
	DECFSZ     R12+0, 1
	GOTO       L_main50
	NOP
;ventilator.c,299 :: 		time1=millis();
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      _time1+0
	MOVF       R0+1, 0
	MOVWF      _time1+1
	MOVF       R0+2, 0
	MOVWF      _time1+2
	MOVF       R0+3, 0
	MOVWF      _time1+3
;ventilator.c,300 :: 		while(1){
L_main51:
;ventilator.c,302 :: 		startl=1;
	BSF        PORTD+0, 4
;ventilator.c,303 :: 		testl=1;
	BSF        PORTD+0, 3
;ventilator.c,304 :: 		switches();
	CALL       _switches+0
;ventilator.c,307 :: 		s2v=1;
	BSF        PORTD+0, 5
;ventilator.c,308 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilator.c,309 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main53:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main146
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main146:
	BTFSC      STATUS+0, 0
	GOTO       L_main54
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,311 :: 		}
	GOTO       L_main53
L_main54:
;ventilator.c,312 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main56:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main147
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main147:
	BTFSC      STATUS+0, 0
	GOTO       L_main57
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,314 :: 		}
	GOTO       L_main56
L_main57:
;ventilator.c,315 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main59:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main148
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main148:
	BTFSC      STATUS+0, 0
	GOTO       L_main60
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,317 :: 		}
	GOTO       L_main59
L_main60:
;ventilator.c,318 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main62:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main149
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main149:
	BTFSC      STATUS+0, 0
	GOTO       L_main63
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,320 :: 		}
	GOTO       L_main62
L_main63:
;ventilator.c,321 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main65:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main150
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main150:
	BTFSC      STATUS+0, 0
	GOTO       L_main66
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,323 :: 		}
	GOTO       L_main65
L_main66:
;ventilator.c,324 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main68:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main151
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main151:
	BTFSC      STATUS+0, 0
	GOTO       L_main69
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,326 :: 		}
	GOTO       L_main68
L_main69:
;ventilator.c,327 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main71:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main152
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main152:
	BTFSC      STATUS+0, 0
	GOTO       L_main72
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,329 :: 		}
	GOTO       L_main71
L_main72:
;ventilator.c,330 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main74:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main153
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main153:
	BTFSC      STATUS+0, 0
	GOTO       L_main75
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,332 :: 		}
	GOTO       L_main74
L_main75:
;ventilator.c,333 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main77:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main154
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main154:
	BTFSC      STATUS+0, 0
	GOTO       L_main78
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,335 :: 		}
	GOTO       L_main77
L_main78:
;ventilator.c,336 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main80:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main155
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main155:
	BTFSC      STATUS+0, 0
	GOTO       L_main81
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,338 :: 		}
	GOTO       L_main80
L_main81:
;ventilator.c,339 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main83:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main156
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main156:
	BTFSC      STATUS+0, 0
	GOTO       L_main84
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,341 :: 		} for(i=0;i<count;i++){
	GOTO       L_main83
L_main84:
	CLRF       _i+0
	CLRF       _i+1
L_main86:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main157
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main157:
	BTFSC      STATUS+0, 0
	GOTO       L_main87
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,343 :: 		}
	GOTO       L_main86
L_main87:
;ventilator.c,344 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main89:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main158
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main158:
	BTFSC      STATUS+0, 0
	GOTO       L_main90
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,346 :: 		} for(i=0;i<count;i++){
	GOTO       L_main89
L_main90:
	CLRF       _i+0
	CLRF       _i+1
L_main92:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main159
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main159:
	BTFSC      STATUS+0, 0
	GOTO       L_main93
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,348 :: 		} for(i=0;i<count;i++){
	GOTO       L_main92
L_main93:
	CLRF       _i+0
	CLRF       _i+1
L_main95:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main160
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main160:
	BTFSC      STATUS+0, 0
	GOTO       L_main96
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,350 :: 		}
	GOTO       L_main95
L_main96:
;ventilator.c,351 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main98:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main161
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main161:
	BTFSC      STATUS+0, 0
	GOTO       L_main99
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,353 :: 		}
	GOTO       L_main98
L_main99:
;ventilator.c,354 :: 		for(i=0;i<count;i++){
	CLRF       _i+0
	CLRF       _i+1
L_main101:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main162
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main162:
	BTFSC      STATUS+0, 0
	GOTO       L_main102
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,356 :: 		} for(i=0;i<count;i++){
	GOTO       L_main101
L_main102:
	CLRF       _i+0
	CLRF       _i+1
L_main104:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main163
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main163:
	BTFSC      STATUS+0, 0
	GOTO       L_main105
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,358 :: 		} for(i=0;i<count;i++){
	GOTO       L_main104
L_main105:
	CLRF       _i+0
	CLRF       _i+1
L_main107:
	MOVF       _count+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main164
	MOVF       _count+0, 0
	SUBWF      _i+0, 0
L__main164:
	BTFSC      STATUS+0, 0
	GOTO       L_main108
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;ventilator.c,360 :: 		}
	GOTO       L_main107
L_main108:
;ventilator.c,362 :: 		s2v=0;
	BCF        PORTD+0, 5
;ventilator.c,363 :: 		dcv1=0;
	BCF        PORTD+0, 0
;ventilator.c,367 :: 		if (millis()-time1>100)
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
	MOVF       R4+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main165
	MOVF       R4+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main165
	MOVF       R4+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main165
	MOVF       R4+0, 0
	SUBLW      100
L__main165:
	BTFSC      STATUS+0, 0
	GOTO       L_main110
;ventilator.c,369 :: 		testl=1  ;
	BSF        PORTD+0, 3
;ventilator.c,370 :: 		startl=0 ;
	BCF        PORTD+0, 4
;ventilator.c,371 :: 		time1=millis();
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      _time1+0
	MOVF       R0+1, 0
	MOVWF      _time1+1
	MOVF       R0+2, 0
	MOVWF      _time1+2
	MOVF       R0+3, 0
	MOVWF      _time1+3
;ventilator.c,372 :: 		}
L_main110:
;ventilator.c,373 :: 		if (millis()-time1<=100)
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
	MOVF       R4+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main166
	MOVF       R4+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main166
	MOVF       R4+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main166
	MOVF       R4+0, 0
	SUBLW      100
L__main166:
	BTFSS      STATUS+0, 0
	GOTO       L_main111
;ventilator.c,375 :: 		testl=0  ;
	BCF        PORTD+0, 3
;ventilator.c,376 :: 		startl=1 ;
	BSF        PORTD+0, 4
;ventilator.c,377 :: 		time1=millis();
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      _time1+0
	MOVF       R0+1, 0
	MOVWF      _time1+1
	MOVF       R0+2, 0
	MOVWF      _time1+2
	MOVF       R0+3, 0
	MOVWF      _time1+3
;ventilator.c,378 :: 		}
L_main111:
;ventilator.c,379 :: 		}
	GOTO       L_main51
;ventilator.c,380 :: 		}
L_end_main:
	GOTO       $+0
; end of _main


_shiftdata595:

;ventilator.c,36 :: 		void shiftdata595(int _shiftdata[])  //shift register
;ventilator.c,40 :: 		i=8;
	MOVLW      8
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
;ventilator.c,41 :: 		while (i>0)                  //loop to send 8bit data
L_shiftdata5950:
	MOVF       R4+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__shiftdata59558
	MOVF       R4+0, 0
	SUBLW      0
L__shiftdata59558:
	BTFSC      STATUS+0, 0
	GOTO       L_shiftdata5951
;ventilator.c,43 :: 		SHIFT_DATA=_shiftdata[i-1]; //  send array value
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
	GOTO       L__shiftdata59559
	BCF        PORTB+0, 0
	GOTO       L__shiftdata59560
L__shiftdata59559:
	BSF        PORTB+0, 0
L__shiftdata59560:
;ventilator.c,44 :: 		SHIFT_CLOCK = 1;
	BSF        PORTB+0, 2
;ventilator.c,45 :: 		Delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;ventilator.c,46 :: 		SHIFT_CLOCK = 0;
	BCF        PORTB+0, 2
;ventilator.c,47 :: 		i--;
	MOVLW      1
	SUBWF      R4+0, 1
	BTFSS      STATUS+0, 0
	DECF       R4+1, 1
;ventilator.c,48 :: 		}
	GOTO       L_shiftdata5950
L_shiftdata5951:
;ventilator.c,49 :: 		}
L_end_shiftdata595:
	RETURN
; end of _shiftdata595

_latch595:

;ventilator.c,51 :: 		void latch595()              //latch pin controll
;ventilator.c,53 :: 		SHIFT_LATCH = 1;
	BSF        PORTB+0, 1
;ventilator.c,54 :: 		Delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;ventilator.c,55 :: 		SHIFT_LATCH = 0;
	BCF        PORTB+0, 1
;ventilator.c,56 :: 		}
L_end_latch595:
	RETURN
; end of _latch595

_switches:

;ventilator.c,60 :: 		void switches(){
;ventilator.c,62 :: 		if (Button(&PORTB, 6, 100, 0)) {               // Detect logical zero
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
;ventilator.c,63 :: 		oldbpmup = 1;                              // Update flag
	BSF        _oldbpmup+0, BitPos(_oldbpmup+0)
;ventilator.c,64 :: 		}
L_switches2:
;ventilator.c,65 :: 		if (oldbpmup && Button(&PORTB, 6, 100, 1)) {   // Detect zero-to-one transition
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
L__switches56:
;ventilator.c,66 :: 		oldbpmup = 0;                            // Update flag
	BCF        _oldbpmup+0, BitPos(_oldbpmup+0)
;ventilator.c,67 :: 		bpmv++;                                //increment bpm level
	INCF       _bpmv+0, 1
	BTFSC      STATUS+0, 2
	INCF       _bpmv+1, 1
;ventilator.c,68 :: 		Sound_Play(1318, 50);
	MOVLW      38
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      5
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      50
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,69 :: 		if(bpmv>16){                     //limit bpm value
	MOVF       _bpmv+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__switches63
	MOVF       _bpmv+0, 0
	SUBLW      16
L__switches63:
	BTFSC      STATUS+0, 0
	GOTO       L_switches6
;ventilator.c,70 :: 		bpmv=16;
	MOVLW      16
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,71 :: 		}
L_switches6:
;ventilator.c,72 :: 		if(bpmv<12){
	MOVLW      0
	SUBWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches64
	MOVLW      12
	SUBWF      _bpmv+0, 0
L__switches64:
	BTFSC      STATUS+0, 0
	GOTO       L_switches7
;ventilator.c,73 :: 		bpmv=12;
	MOVLW      12
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,74 :: 		}
L_switches7:
;ventilator.c,77 :: 		}
L_switches5:
;ventilator.c,79 :: 		if (Button(&PORTB, 7, 100, 0)) {               // Detect logical zero
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
;ventilator.c,80 :: 		oldbpmdown = 1;                              // Update flag
	BSF        _oldbpmdown+0, BitPos(_oldbpmdown+0)
;ventilator.c,81 :: 		}
L_switches8:
;ventilator.c,82 :: 		if (oldbpmdown && Button(&PORTB, 7, 100, 1)) {   // Detect zero-to-one transition
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
L__switches55:
;ventilator.c,83 :: 		oldbpmdown = 0;                           // Update flag
	BCF        _oldbpmdown+0, BitPos(_oldbpmdown+0)
;ventilator.c,84 :: 		Sound_Play(1318, 50);
	MOVLW      38
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      5
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      50
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,86 :: 		bpmv--;                                      //decrement bpm value
	MOVLW      1
	SUBWF      _bpmv+0, 1
	BTFSS      STATUS+0, 0
	DECF       _bpmv+1, 1
;ventilator.c,87 :: 		if(bpmv>16){                                 //limit bpm value
	MOVF       _bpmv+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__switches65
	MOVF       _bpmv+0, 0
	SUBLW      16
L__switches65:
	BTFSC      STATUS+0, 0
	GOTO       L_switches12
;ventilator.c,88 :: 		bpmv=16;
	MOVLW      16
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,89 :: 		}
L_switches12:
;ventilator.c,90 :: 		if(bpmv<12){
	MOVLW      0
	SUBWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches66
	MOVLW      12
	SUBWF      _bpmv+0, 0
L__switches66:
	BTFSC      STATUS+0, 0
	GOTO       L_switches13
;ventilator.c,91 :: 		bpmv=12;
	MOVLW      12
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilator.c,92 :: 		}
L_switches13:
;ventilator.c,95 :: 		}
L_switches11:
;ventilator.c,100 :: 		if (Button(&PORTB, 4, 100, 0)) {               // Detect logical zero
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
;ventilator.c,101 :: 		oldvolup = 1;                              // Update flag
	BSF        _oldvolup+0, BitPos(_oldvolup+0)
;ventilator.c,102 :: 		}
L_switches14:
;ventilator.c,103 :: 		if (oldvolup && Button(&PORTB, 4, 100, 1)) {   // Detect zero-to-one transition
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
L__switches54:
;ventilator.c,104 :: 		oldvolup = 0;                    // Update flag
	BCF        _oldvolup+0, BitPos(_oldvolup+0)
;ventilator.c,105 :: 		Sound_Play(1000, 100);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      100
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,106 :: 		vol=vol+50;              //increment volume level by 50
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
;ventilator.c,107 :: 		if(vol>550){                                         //limit volume level
	MOVF       R1+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches67
	MOVF       R1+0, 0
	SUBLW      38
L__switches67:
	BTFSC      STATUS+0, 0
	GOTO       L_switches18
;ventilator.c,108 :: 		vol=550;
	MOVLW      38
	MOVWF      _vol+0
	MOVLW      2
	MOVWF      _vol+1
;ventilator.c,109 :: 		}
L_switches18:
;ventilator.c,110 :: 		if(vol<450){
	MOVLW      1
	SUBWF      _vol+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches68
	MOVLW      194
	SUBWF      _vol+0, 0
L__switches68:
	BTFSC      STATUS+0, 0
	GOTO       L_switches19
;ventilator.c,111 :: 		vol=450;
	MOVLW      194
	MOVWF      _vol+0
	MOVLW      1
	MOVWF      _vol+1
;ventilator.c,112 :: 		}
L_switches19:
;ventilator.c,114 :: 		}
L_switches17:
;ventilator.c,116 :: 		if (Button(&PORTB, 5, 100, 0)) {               // Detect logical zero
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
;ventilator.c,117 :: 		oldvoldown = 1;                              // Update flag
	BSF        _oldvoldown+0, BitPos(_oldvoldown+0)
;ventilator.c,118 :: 		}
L_switches20:
;ventilator.c,119 :: 		if (oldvoldown && Button(&PORTB, 5, 100, 1)) {   // Detect zero-to-one transition
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
L__switches53:
;ventilator.c,120 :: 		oldvoldown = 0;                                   // Update flag
	BCF        _oldvoldown+0, BitPos(_oldvoldown+0)
;ventilator.c,121 :: 		Sound_Play(1000, 100);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      100
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,122 :: 		vol=vol-50;                                         //decrement volume level
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
;ventilator.c,123 :: 		if(vol>550){                                         //limit volume level
	MOVF       R1+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches69
	MOVF       R1+0, 0
	SUBLW      38
L__switches69:
	BTFSC      STATUS+0, 0
	GOTO       L_switches24
;ventilator.c,124 :: 		vol=550;
	MOVLW      38
	MOVWF      _vol+0
	MOVLW      2
	MOVWF      _vol+1
;ventilator.c,125 :: 		}
L_switches24:
;ventilator.c,126 :: 		if(vol<450){
	MOVLW      1
	SUBWF      _vol+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches70
	MOVLW      194
	SUBWF      _vol+0, 0
L__switches70:
	BTFSC      STATUS+0, 0
	GOTO       L_switches25
;ventilator.c,127 :: 		vol=450;
	MOVLW      194
	MOVWF      _vol+0
	MOVLW      1
	MOVWF      _vol+1
;ventilator.c,128 :: 		}
L_switches25:
;ventilator.c,131 :: 		}
L_switches23:
;ventilator.c,134 :: 		if ( !startstatus  && Button(&PORTC, 6, 100, 0)) {               // Detect logical zero
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
L__switches52:
;ventilator.c,135 :: 		Sound_Play(1000, 100);                         //play alarm
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      100
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,136 :: 		startl=1;                                      //led indicator
	BSF        PORTD+0, 4
;ventilator.c,137 :: 		startstatus = 1;                              // Update flag
	MOVLW      1
	MOVWF      _startstatus+0
	MOVLW      0
	MOVWF      _startstatus+1
;ventilator.c,138 :: 		}
L_switches28:
;ventilator.c,139 :: 		if (startstatus && Button(&PORTC, 7, 100, 0)) {   // Detect logical zero
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
L__switches51:
;ventilator.c,140 :: 		Sound_Play(500, 100);                         //play alarm
	MOVLW      244
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      100
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,141 :: 		startl=0;                                    //led indicator
	BCF        PORTD+0, 4
;ventilator.c,142 :: 		startstatus = 0;               // Update flag
	CLRF       _startstatus+0
	CLRF       _startstatus+1
;ventilator.c,143 :: 		}
L_switches31:
;ventilator.c,147 :: 		switch (vol){                       //led value for each volume level
	GOTO       L_switches32
;ventilator.c,148 :: 		case 450:
L_switches34:
;ventilator.c,149 :: 		led[5]=1;
	MOVLW      1
	MOVWF      _led+10
	MOVLW      0
	MOVWF      _led+11
;ventilator.c,150 :: 		led[6]=0;
	CLRF       _led+12
	CLRF       _led+13
;ventilator.c,151 :: 		led[7]=0;
	CLRF       _led+14
	CLRF       _led+15
;ventilator.c,153 :: 		break;
	GOTO       L_switches33
;ventilator.c,154 :: 		case 500:
L_switches35:
;ventilator.c,155 :: 		led[5]=0;
	CLRF       _led+10
	CLRF       _led+11
;ventilator.c,156 :: 		led[6]=1;
	MOVLW      1
	MOVWF      _led+12
	MOVLW      0
	MOVWF      _led+13
;ventilator.c,157 :: 		led[7]=0;
	CLRF       _led+14
	CLRF       _led+15
;ventilator.c,159 :: 		break;
	GOTO       L_switches33
;ventilator.c,160 :: 		case 550:
L_switches36:
;ventilator.c,161 :: 		led[5]=0;
	CLRF       _led+10
	CLRF       _led+11
;ventilator.c,162 :: 		led[6]=0;
	CLRF       _led+12
	CLRF       _led+13
;ventilator.c,163 :: 		led[7]=1;
	MOVLW      1
	MOVWF      _led+14
	MOVLW      0
	MOVWF      _led+15
;ventilator.c,165 :: 		break;
	GOTO       L_switches33
;ventilator.c,167 :: 		}
L_switches32:
	MOVF       _vol+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__switches71
	MOVLW      194
	XORWF      _vol+0, 0
L__switches71:
	BTFSC      STATUS+0, 2
	GOTO       L_switches34
	MOVF       _vol+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__switches72
	MOVLW      244
	XORWF      _vol+0, 0
L__switches72:
	BTFSC      STATUS+0, 2
	GOTO       L_switches35
	MOVF       _vol+1, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches73
	MOVLW      38
	XORWF      _vol+0, 0
L__switches73:
	BTFSC      STATUS+0, 2
	GOTO       L_switches36
L_switches33:
;ventilator.c,169 :: 		switch (bpmv){                           //led value for each bpm value
	GOTO       L_switches37
;ventilator.c,170 :: 		case 12:
L_switches39:
;ventilator.c,171 :: 		led[0]=1;
	MOVLW      1
	MOVWF      _led+0
	MOVLW      0
	MOVWF      _led+1
;ventilator.c,172 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,173 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,174 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,175 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,176 :: 		break;
	GOTO       L_switches38
;ventilator.c,177 :: 		case 13:
L_switches40:
;ventilator.c,178 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,179 :: 		led[1]=1;
	MOVLW      1
	MOVWF      _led+2
	MOVLW      0
	MOVWF      _led+3
;ventilator.c,180 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,181 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,182 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,183 :: 		break;
	GOTO       L_switches38
;ventilator.c,184 :: 		case 14:
L_switches41:
;ventilator.c,185 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,186 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,187 :: 		led[2]=1;
	MOVLW      1
	MOVWF      _led+4
	MOVLW      0
	MOVWF      _led+5
;ventilator.c,188 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,189 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,190 :: 		break;
	GOTO       L_switches38
;ventilator.c,191 :: 		case 15:
L_switches42:
;ventilator.c,192 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,193 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,194 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,195 :: 		led[3]=1;
	MOVLW      1
	MOVWF      _led+6
	MOVLW      0
	MOVWF      _led+7
;ventilator.c,196 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilator.c,197 :: 		break;
	GOTO       L_switches38
;ventilator.c,198 :: 		case 16:
L_switches43:
;ventilator.c,199 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilator.c,200 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilator.c,201 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilator.c,202 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilator.c,203 :: 		led[4]=1;
	MOVLW      1
	MOVWF      _led+8
	MOVLW      0
	MOVWF      _led+9
;ventilator.c,204 :: 		break;
	GOTO       L_switches38
;ventilator.c,205 :: 		}
L_switches37:
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches74
	MOVLW      12
	XORWF      _bpmv+0, 0
L__switches74:
	BTFSC      STATUS+0, 2
	GOTO       L_switches39
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches75
	MOVLW      13
	XORWF      _bpmv+0, 0
L__switches75:
	BTFSC      STATUS+0, 2
	GOTO       L_switches40
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches76
	MOVLW      14
	XORWF      _bpmv+0, 0
L__switches76:
	BTFSC      STATUS+0, 2
	GOTO       L_switches41
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches77
	MOVLW      15
	XORWF      _bpmv+0, 0
L__switches77:
	BTFSC      STATUS+0, 2
	GOTO       L_switches42
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches78
	MOVLW      16
	XORWF      _bpmv+0, 0
L__switches78:
	BTFSC      STATUS+0, 2
	GOTO       L_switches43
L_switches38:
;ventilator.c,207 :: 		shiftdata595(led);                  //send out led data
	MOVLW      _led+0
	MOVWF      FARG_shiftdata595__shiftdata+0
	CALL       _shiftdata595+0
;ventilator.c,208 :: 		latch595();
	CALL       _latch595+0
;ventilator.c,211 :: 		}
L_end_switches:
	RETURN
; end of _switches

_selftest:

;ventilator.c,214 :: 		void selftest(){
;ventilator.c,224 :: 		testl=1;                                        //test led on
	BSF        PORTD+0, 3
;ventilator.c,225 :: 		Sound_Play(500, 500);                            //selftest ok notify alarm
	MOVLW      244
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      244
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,226 :: 		Sound_Play(1000, 500);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      244
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;ventilator.c,234 :: 		}
L_selftest45:
;ventilator.c,235 :: 		}
L_end_selftest:
	RETURN
; end of _selftest

_main:

;ventilator.c,241 :: 		void main()
;ventilator.c,243 :: 		PORTB=0;  // set portB as digital
	CLRF       PORTB+0
;ventilator.c,244 :: 		TRISB=0xf0;  // set portB input/outputs
	MOVLW      240
	MOVWF      TRISB+0
;ventilator.c,245 :: 		PORTC=0;  // set portC as digital
	CLRF       PORTC+0
;ventilator.c,246 :: 		TRISC=0xff;  // set portC as inputs
	MOVLW      255
	MOVWF      TRISC+0
;ventilator.c,247 :: 		PORTD=0;  // set portD as digital
	CLRF       PORTD+0
;ventilator.c,248 :: 		TRISD=0x00;  // set portD as outputs
	CLRF       TRISD+0
;ventilator.c,250 :: 		Sound_Init(&PORTC, 2);
	MOVLW      PORTC+0
	MOVWF      FARG_Sound_Init_snd_port+0
	MOVLW      2
	MOVWF      FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;ventilator.c,252 :: 		selftest();//do self test
	CALL       _selftest+0
;ventilator.c,256 :: 		while(1){
L_main48:
;ventilator.c,258 :: 		switches();
	CALL       _switches+0
;ventilator.c,259 :: 		if(startstatus){
	MOVF       _startstatus+0, 0
	IORWF      _startstatus+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main50
;ventilator.c,267 :: 		}
L_main50:
;ventilator.c,269 :: 		}
	GOTO       L_main48
;ventilator.c,270 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

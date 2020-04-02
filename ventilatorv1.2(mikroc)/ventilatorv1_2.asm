
_shiftdata595:

;ventilatorv1_2.c,74 :: 		void shiftdata595(int _shiftdata[])  //shift register
;ventilatorv1_2.c,78 :: 		i=8;
	MOVLW      8
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
;ventilatorv1_2.c,79 :: 		while (i>0)                  //loop to send 8bit data
L_shiftdata5950:
	MOVF       R4+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__shiftdata59592
	MOVF       R4+0, 0
	SUBLW      0
L__shiftdata59592:
	BTFSC      STATUS+0, 0
	GOTO       L_shiftdata5951
;ventilatorv1_2.c,81 :: 		SHIFT_DATA=_shiftdata[i-1]; //  send array value
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
	GOTO       L__shiftdata59593
	BCF        PORTB+0, 0
	GOTO       L__shiftdata59594
L__shiftdata59593:
	BSF        PORTB+0, 0
L__shiftdata59594:
;ventilatorv1_2.c,82 :: 		SHIFT_CLOCK = 1;
	BSF        PORTB+0, 2
;ventilatorv1_2.c,83 :: 		Delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;ventilatorv1_2.c,84 :: 		SHIFT_CLOCK = 0;
	BCF        PORTB+0, 2
;ventilatorv1_2.c,85 :: 		i--;
	MOVLW      1
	SUBWF      R4+0, 1
	BTFSS      STATUS+0, 0
	DECF       R4+1, 1
;ventilatorv1_2.c,86 :: 		}
	GOTO       L_shiftdata5950
L_shiftdata5951:
;ventilatorv1_2.c,87 :: 		}
L_end_shiftdata595:
	RETURN
; end of _shiftdata595

_latch595:

;ventilatorv1_2.c,89 :: 		void latch595()              //latch pin controll
;ventilatorv1_2.c,91 :: 		SHIFT_LATCH = 1;
	BSF        PORTB+0, 1
;ventilatorv1_2.c,92 :: 		Delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;ventilatorv1_2.c,93 :: 		SHIFT_LATCH = 0;
	BCF        PORTB+0, 1
;ventilatorv1_2.c,94 :: 		}
L_end_latch595:
	RETURN
; end of _latch595

_millis:

;ventilatorv1_2.c,98 :: 		unsigned long millis()
;ventilatorv1_2.c,100 :: 		return(millis_count);
	MOVF       _millis_count+0, 0
	MOVWF      R0+0
	MOVF       _millis_count+1, 0
	MOVWF      R0+1
	MOVF       _millis_count+2, 0
	MOVWF      R0+2
	MOVF       _millis_count+3, 0
	MOVWF      R0+3
;ventilatorv1_2.c,101 :: 		}
L_end_millis:
	RETURN
; end of _millis

_alarm:

;ventilatorv1_2.c,105 :: 		void alarm(int tm){             //alarmfuncion
;ventilatorv1_2.c,106 :: 		int alarm_millis=millis();
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      alarm_alarm_millis_L0+0
	MOVF       R0+1, 0
	MOVWF      alarm_alarm_millis_L0+1
;ventilatorv1_2.c,107 :: 		while(millis()-alarm_millis<=tm){
L_alarm2:
	CALL       _millis+0
	MOVF       alarm_alarm_millis_L0+0, 0
	MOVWF      R8+0
	MOVF       alarm_alarm_millis_L0+1, 0
	MOVWF      R8+1
	MOVLW      0
	BTFSC      R8+1, 7
	MOVLW      255
	MOVWF      R8+2
	MOVWF      R8+3
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVF       R8+0, 0
	SUBWF      R4+0, 1
	MOVF       R8+1, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R8+1, 0
	SUBWF      R4+1, 1
	MOVF       R8+2, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R8+2, 0
	SUBWF      R4+2, 1
	MOVF       R8+3, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R8+3, 0
	SUBWF      R4+3, 1
	MOVLW      0
	BTFSC      FARG_alarm_tm+1, 7
	MOVLW      255
	MOVWF      R0+0
	MOVF       R4+3, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__alarm98
	MOVLW      0
	BTFSC      FARG_alarm_tm+1, 7
	MOVLW      255
	MOVWF      R0+0
	MOVF       R4+2, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__alarm98
	MOVF       R4+1, 0
	SUBWF      FARG_alarm_tm+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__alarm98
	MOVF       R4+0, 0
	SUBWF      FARG_alarm_tm+0, 0
L__alarm98:
	BTFSS      STATUS+0, 0
	GOTO       L_alarm3
;ventilatorv1_2.c,108 :: 		buz=1;
	BSF        PORTD+0, 2
;ventilatorv1_2.c,109 :: 		}
	GOTO       L_alarm2
L_alarm3:
;ventilatorv1_2.c,110 :: 		buz=0;
	BCF        PORTD+0, 2
;ventilatorv1_2.c,111 :: 		}
L_end_alarm:
	RETURN
; end of _alarm

_switches:

;ventilatorv1_2.c,118 :: 		void switches(){
;ventilatorv1_2.c,120 :: 		if (Button(&PORTB, 6, 1, 0)) {               // Detect logical zero
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
	GOTO       L_switches4
;ventilatorv1_2.c,121 :: 		oldbpmup = 1;                              // Update flag
	BSF        _oldbpmup+0, BitPos(_oldbpmup+0)
;ventilatorv1_2.c,122 :: 		}
L_switches4:
;ventilatorv1_2.c,123 :: 		if (oldbpmup && Button(&PORTB, 6, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldbpmup+0, BitPos(_oldbpmup+0)
	GOTO       L_switches7
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
	GOTO       L_switches7
L__switches85:
;ventilatorv1_2.c,124 :: 		oldbpmup = 0;
	BCF        _oldbpmup+0, BitPos(_oldbpmup+0)
;ventilatorv1_2.c,126 :: 		bpmv++;                                //increment bpm level
	INCF       _bpmv+0, 1
	BTFSC      STATUS+0, 2
	INCF       _bpmv+1, 1
;ventilatorv1_2.c,128 :: 		if(bpmv>16){                     //limit bpm value
	MOVF       _bpmv+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__switches100
	MOVF       _bpmv+0, 0
	SUBLW      16
L__switches100:
	BTFSC      STATUS+0, 0
	GOTO       L_switches8
;ventilatorv1_2.c,129 :: 		bpmv=16;
	MOVLW      16
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilatorv1_2.c,130 :: 		}
L_switches8:
;ventilatorv1_2.c,131 :: 		if(bpmv<12){
	MOVLW      0
	SUBWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches101
	MOVLW      12
	SUBWF      _bpmv+0, 0
L__switches101:
	BTFSC      STATUS+0, 0
	GOTO       L_switches9
;ventilatorv1_2.c,132 :: 		bpmv=12;
	MOVLW      12
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilatorv1_2.c,133 :: 		}
L_switches9:
;ventilatorv1_2.c,136 :: 		}
L_switches7:
;ventilatorv1_2.c,138 :: 		if (Button(&PORTB, 7, 1, 0)) {               // Detect logical zero
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
	GOTO       L_switches10
;ventilatorv1_2.c,139 :: 		oldbpmdown = 1;                              // Update flag
	BSF        _oldbpmdown+0, BitPos(_oldbpmdown+0)
;ventilatorv1_2.c,140 :: 		}
L_switches10:
;ventilatorv1_2.c,141 :: 		if (oldbpmdown && Button(&PORTB, 7, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldbpmdown+0, BitPos(_oldbpmdown+0)
	GOTO       L_switches13
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
	GOTO       L_switches13
L__switches84:
;ventilatorv1_2.c,142 :: 		oldbpmdown = 0;                           // Update flag
	BCF        _oldbpmdown+0, BitPos(_oldbpmdown+0)
;ventilatorv1_2.c,144 :: 		bpmv--;                                      //decrement bpm value
	MOVLW      1
	SUBWF      _bpmv+0, 1
	BTFSS      STATUS+0, 0
	DECF       _bpmv+1, 1
;ventilatorv1_2.c,145 :: 		if(bpmv>16){                                 //limit bpm value
	MOVF       _bpmv+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__switches102
	MOVF       _bpmv+0, 0
	SUBLW      16
L__switches102:
	BTFSC      STATUS+0, 0
	GOTO       L_switches14
;ventilatorv1_2.c,146 :: 		bpmv=16;
	MOVLW      16
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilatorv1_2.c,147 :: 		}
L_switches14:
;ventilatorv1_2.c,148 :: 		if(bpmv<12){
	MOVLW      0
	SUBWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches103
	MOVLW      12
	SUBWF      _bpmv+0, 0
L__switches103:
	BTFSC      STATUS+0, 0
	GOTO       L_switches15
;ventilatorv1_2.c,149 :: 		bpmv=12;
	MOVLW      12
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilatorv1_2.c,150 :: 		}
L_switches15:
;ventilatorv1_2.c,153 :: 		}
L_switches13:
;ventilatorv1_2.c,158 :: 		if (Button(&PORTB, 4, 1, 0)) {               // Detect logical zero
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
	GOTO       L_switches16
;ventilatorv1_2.c,159 :: 		oldvolup = 1;                              // Update flag
	BSF        _oldvolup+0, BitPos(_oldvolup+0)
;ventilatorv1_2.c,160 :: 		}
L_switches16:
;ventilatorv1_2.c,161 :: 		if (oldvolup && Button(&PORTB, 4, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldvolup+0, BitPos(_oldvolup+0)
	GOTO       L_switches19
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
	GOTO       L_switches19
L__switches83:
;ventilatorv1_2.c,162 :: 		oldvolup = 0;                    // Update flag
	BCF        _oldvolup+0, BitPos(_oldvolup+0)
;ventilatorv1_2.c,164 :: 		vol=vol+50;              //increment volume level by 50
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
;ventilatorv1_2.c,165 :: 		if(vol>550){                                         //limit volume level
	MOVF       R1+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches104
	MOVF       R1+0, 0
	SUBLW      38
L__switches104:
	BTFSC      STATUS+0, 0
	GOTO       L_switches20
;ventilatorv1_2.c,166 :: 		vol=550;
	MOVLW      38
	MOVWF      _vol+0
	MOVLW      2
	MOVWF      _vol+1
;ventilatorv1_2.c,167 :: 		}
L_switches20:
;ventilatorv1_2.c,168 :: 		if(vol<450){
	MOVLW      1
	SUBWF      _vol+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches105
	MOVLW      194
	SUBWF      _vol+0, 0
L__switches105:
	BTFSC      STATUS+0, 0
	GOTO       L_switches21
;ventilatorv1_2.c,169 :: 		vol=450;
	MOVLW      194
	MOVWF      _vol+0
	MOVLW      1
	MOVWF      _vol+1
;ventilatorv1_2.c,170 :: 		}
L_switches21:
;ventilatorv1_2.c,172 :: 		}
L_switches19:
;ventilatorv1_2.c,174 :: 		if (Button(&PORTB, 5, 1, 0)) {               // Detect logical zero
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
	GOTO       L_switches22
;ventilatorv1_2.c,175 :: 		oldvoldown = 1;                              // Update flag
	BSF        _oldvoldown+0, BitPos(_oldvoldown+0)
;ventilatorv1_2.c,176 :: 		}
L_switches22:
;ventilatorv1_2.c,177 :: 		if (oldvoldown && Button(&PORTB, 5, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldvoldown+0, BitPos(_oldvoldown+0)
	GOTO       L_switches25
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
	GOTO       L_switches25
L__switches82:
;ventilatorv1_2.c,178 :: 		oldvoldown = 0;                                   // Update flag
	BCF        _oldvoldown+0, BitPos(_oldvoldown+0)
;ventilatorv1_2.c,180 :: 		vol=vol-50;                                         //decrement volume level
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
;ventilatorv1_2.c,181 :: 		if(vol>550){                                         //limit volume level
	MOVF       R1+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches106
	MOVF       R1+0, 0
	SUBLW      38
L__switches106:
	BTFSC      STATUS+0, 0
	GOTO       L_switches26
;ventilatorv1_2.c,182 :: 		vol=550;
	MOVLW      38
	MOVWF      _vol+0
	MOVLW      2
	MOVWF      _vol+1
;ventilatorv1_2.c,183 :: 		}
L_switches26:
;ventilatorv1_2.c,184 :: 		if(vol<450){
	MOVLW      1
	SUBWF      _vol+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches107
	MOVLW      194
	SUBWF      _vol+0, 0
L__switches107:
	BTFSC      STATUS+0, 0
	GOTO       L_switches27
;ventilatorv1_2.c,185 :: 		vol=450;
	MOVLW      194
	MOVWF      _vol+0
	MOVLW      1
	MOVWF      _vol+1
;ventilatorv1_2.c,186 :: 		}
L_switches27:
;ventilatorv1_2.c,189 :: 		}
L_switches25:
;ventilatorv1_2.c,192 :: 		if ( !startstatus  && Button(&PORTC, 6, 1, 0)) {               // Detect logical zero
	MOVF       _startstatus+0, 0
	IORWF      _startstatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_switches30
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
	GOTO       L_switches30
L__switches81:
;ventilatorv1_2.c,194 :: 		startl=1;                                      //led indicator
	BSF        PORTD+0, 4
;ventilatorv1_2.c,195 :: 		startstatus = 1;                              // Update flag
	MOVLW      1
	MOVWF      _startstatus+0
	MOVLW      0
	MOVWF      _startstatus+1
;ventilatorv1_2.c,196 :: 		}
L_switches30:
;ventilatorv1_2.c,197 :: 		if (startstatus && Button(&PORTC, 7, 1, 0)) {   // Detect logical zero
	MOVF       _startstatus+0, 0
	IORWF      _startstatus+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches33
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
	GOTO       L_switches33
L__switches80:
;ventilatorv1_2.c,199 :: 		startl=0;                                    //led indicator
	BCF        PORTD+0, 4
;ventilatorv1_2.c,200 :: 		startstatus = 0;               // Update flag
	CLRF       _startstatus+0
	CLRF       _startstatus+1
;ventilatorv1_2.c,201 :: 		}
L_switches33:
;ventilatorv1_2.c,205 :: 		switch (vol){                       //led value for each volume level
	GOTO       L_switches34
;ventilatorv1_2.c,206 :: 		case 450:
L_switches36:
;ventilatorv1_2.c,207 :: 		led[5]=1;
	MOVLW      1
	MOVWF      _led+10
	MOVLW      0
	MOVWF      _led+11
;ventilatorv1_2.c,208 :: 		led[6]=0;
	CLRF       _led+12
	CLRF       _led+13
;ventilatorv1_2.c,209 :: 		led[7]=0;
	CLRF       _led+14
	CLRF       _led+15
;ventilatorv1_2.c,211 :: 		break;
	GOTO       L_switches35
;ventilatorv1_2.c,212 :: 		case 500:
L_switches37:
;ventilatorv1_2.c,213 :: 		led[5]=0;
	CLRF       _led+10
	CLRF       _led+11
;ventilatorv1_2.c,214 :: 		led[6]=1;
	MOVLW      1
	MOVWF      _led+12
	MOVLW      0
	MOVWF      _led+13
;ventilatorv1_2.c,215 :: 		led[7]=0;
	CLRF       _led+14
	CLRF       _led+15
;ventilatorv1_2.c,217 :: 		break;
	GOTO       L_switches35
;ventilatorv1_2.c,218 :: 		case 550:
L_switches38:
;ventilatorv1_2.c,219 :: 		led[5]=0;
	CLRF       _led+10
	CLRF       _led+11
;ventilatorv1_2.c,220 :: 		led[6]=0;
	CLRF       _led+12
	CLRF       _led+13
;ventilatorv1_2.c,221 :: 		led[7]=1;
	MOVLW      1
	MOVWF      _led+14
	MOVLW      0
	MOVWF      _led+15
;ventilatorv1_2.c,223 :: 		break;
	GOTO       L_switches35
;ventilatorv1_2.c,225 :: 		}
L_switches34:
	MOVF       _vol+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__switches108
	MOVLW      194
	XORWF      _vol+0, 0
L__switches108:
	BTFSC      STATUS+0, 2
	GOTO       L_switches36
	MOVF       _vol+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__switches109
	MOVLW      244
	XORWF      _vol+0, 0
L__switches109:
	BTFSC      STATUS+0, 2
	GOTO       L_switches37
	MOVF       _vol+1, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches110
	MOVLW      38
	XORWF      _vol+0, 0
L__switches110:
	BTFSC      STATUS+0, 2
	GOTO       L_switches38
L_switches35:
;ventilatorv1_2.c,227 :: 		switch (bpmv){                           //led value for each bpm value
	GOTO       L_switches39
;ventilatorv1_2.c,228 :: 		case 12:
L_switches41:
;ventilatorv1_2.c,229 :: 		led[0]=1;
	MOVLW      1
	MOVWF      _led+0
	MOVLW      0
	MOVWF      _led+1
;ventilatorv1_2.c,230 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilatorv1_2.c,231 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilatorv1_2.c,232 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilatorv1_2.c,233 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilatorv1_2.c,234 :: 		break;
	GOTO       L_switches40
;ventilatorv1_2.c,235 :: 		case 13:
L_switches42:
;ventilatorv1_2.c,236 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilatorv1_2.c,237 :: 		led[1]=1;
	MOVLW      1
	MOVWF      _led+2
	MOVLW      0
	MOVWF      _led+3
;ventilatorv1_2.c,238 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilatorv1_2.c,239 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilatorv1_2.c,240 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilatorv1_2.c,241 :: 		break;
	GOTO       L_switches40
;ventilatorv1_2.c,242 :: 		case 14:
L_switches43:
;ventilatorv1_2.c,243 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilatorv1_2.c,244 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilatorv1_2.c,245 :: 		led[2]=1;
	MOVLW      1
	MOVWF      _led+4
	MOVLW      0
	MOVWF      _led+5
;ventilatorv1_2.c,246 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilatorv1_2.c,247 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilatorv1_2.c,248 :: 		break;
	GOTO       L_switches40
;ventilatorv1_2.c,249 :: 		case 15:
L_switches44:
;ventilatorv1_2.c,250 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilatorv1_2.c,251 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilatorv1_2.c,252 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilatorv1_2.c,253 :: 		led[3]=1;
	MOVLW      1
	MOVWF      _led+6
	MOVLW      0
	MOVWF      _led+7
;ventilatorv1_2.c,254 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilatorv1_2.c,255 :: 		break;
	GOTO       L_switches40
;ventilatorv1_2.c,256 :: 		case 16:
L_switches45:
;ventilatorv1_2.c,257 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilatorv1_2.c,258 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilatorv1_2.c,259 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilatorv1_2.c,260 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilatorv1_2.c,261 :: 		led[4]=1;
	MOVLW      1
	MOVWF      _led+8
	MOVLW      0
	MOVWF      _led+9
;ventilatorv1_2.c,262 :: 		break;
	GOTO       L_switches40
;ventilatorv1_2.c,263 :: 		}
L_switches39:
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches111
	MOVLW      12
	XORWF      _bpmv+0, 0
L__switches111:
	BTFSC      STATUS+0, 2
	GOTO       L_switches41
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches112
	MOVLW      13
	XORWF      _bpmv+0, 0
L__switches112:
	BTFSC      STATUS+0, 2
	GOTO       L_switches42
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches113
	MOVLW      14
	XORWF      _bpmv+0, 0
L__switches113:
	BTFSC      STATUS+0, 2
	GOTO       L_switches43
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches114
	MOVLW      15
	XORWF      _bpmv+0, 0
L__switches114:
	BTFSC      STATUS+0, 2
	GOTO       L_switches44
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches115
	MOVLW      16
	XORWF      _bpmv+0, 0
L__switches115:
	BTFSC      STATUS+0, 2
	GOTO       L_switches45
L_switches40:
;ventilatorv1_2.c,265 :: 		shiftdata595(led);                  //send out led data
	MOVLW      _led+0
	MOVWF      FARG_shiftdata595__shiftdata+0
	CALL       _shiftdata595+0
;ventilatorv1_2.c,266 :: 		latch595();
	CALL       _latch595+0
;ventilatorv1_2.c,269 :: 		}
L_end_switches:
	RETURN
; end of _switches

_selftest:

;ventilatorv1_2.c,271 :: 		void selftest(int fail){
;ventilatorv1_2.c,272 :: 		if(fail){                                         //if self test ok
	MOVF       FARG_selftest_fail+0, 0
	IORWF      FARG_selftest_fail+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_selftest46
;ventilatorv1_2.c,273 :: 		testl=1;                                        //test led on
	BSF        PORTD+0, 3
;ventilatorv1_2.c,274 :: 		alm_flag=500;
	MOVLW      244
	MOVWF      _alm_flag+0
	MOVLW      1
	MOVWF      _alm_flag+1
;ventilatorv1_2.c,275 :: 		}
	GOTO       L_selftest47
L_selftest46:
;ventilatorv1_2.c,277 :: 		while(1){                                        //programme goes into an infinite loop
L_selftest48:
;ventilatorv1_2.c,278 :: 		testl=0;                                          //test led blinks
	BCF        PORTD+0, 3
;ventilatorv1_2.c,279 :: 		alm_flag=500;                             //test fail alarm
	MOVLW      244
	MOVWF      _alm_flag+0
	MOVLW      1
	MOVWF      _alm_flag+1
;ventilatorv1_2.c,280 :: 		testl=1;
	BSF        PORTD+0, 3
;ventilatorv1_2.c,281 :: 		delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_selftest50:
	DECFSZ     R13+0, 1
	GOTO       L_selftest50
	DECFSZ     R12+0, 1
	GOTO       L_selftest50
	DECFSZ     R11+0, 1
	GOTO       L_selftest50
	NOP
;ventilatorv1_2.c,282 :: 		}
	GOTO       L_selftest48
;ventilatorv1_2.c,283 :: 		}
L_selftest47:
;ventilatorv1_2.c,285 :: 		}
L_end_selftest:
	RETURN
; end of _selftest

_read_sensor_data:

;ventilatorv1_2.c,287 :: 		void read_sensor_data(){     //reading all analog sensor data
;ventilatorv1_2.c,288 :: 		s4=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _s4+0
	MOVF       R0+1, 0
	MOVWF      _s4+1
;ventilatorv1_2.c,290 :: 		s9= ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _s9+0
	MOVF       R0+1, 0
	MOVWF      _s9+1
;ventilatorv1_2.c,292 :: 		s10 =  ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _s10+0
	MOVF       R0+1, 0
	MOVWF      _s10+1
;ventilatorv1_2.c,294 :: 		p1  = ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _p1+0
	MOVF       R0+1, 0
	MOVWF      _p1+1
;ventilatorv1_2.c,296 :: 		p2   = ADC_Read(4);
	MOVLW      4
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _p2+0
	MOVF       R0+1, 0
	MOVWF      _p2+1
;ventilatorv1_2.c,298 :: 		p3 =   ADC_Read(5);
	MOVLW      5
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _p3+0
	MOVF       R0+1, 0
	MOVWF      _p3+1
;ventilatorv1_2.c,300 :: 		p_1  =  ADC_Read(6);
	MOVLW      6
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _p_1+0
	MOVF       R0+1, 0
	MOVWF      _p_1+1
;ventilatorv1_2.c,302 :: 		p_2  =  ADC_Read(7);
	MOVLW      7
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _p_2+0
	MOVF       R0+1, 0
	MOVWF      _p_2+1
;ventilatorv1_2.c,304 :: 		}
L_end_read_sensor_data:
	RETURN
; end of _read_sensor_data

_InitTimer0:

;ventilatorv1_2.c,315 :: 		void InitTimer0(){                //timero initialization
;ventilatorv1_2.c,316 :: 		OPTION_REG         = 0x84;
	MOVLW      132
	MOVWF      OPTION_REG+0
;ventilatorv1_2.c,317 :: 		TMR0                 = 100;
	MOVLW      100
	MOVWF      TMR0+0
;ventilatorv1_2.c,318 :: 		INTCON         = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;ventilatorv1_2.c,319 :: 		}
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

;ventilatorv1_2.c,321 :: 		void Interrupt(){           //interrupt function runs evry 1ms
;ventilatorv1_2.c,322 :: 		if (TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_Interrupt51
;ventilatorv1_2.c,323 :: 		TMR0IF_bit         = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;ventilatorv1_2.c,324 :: 		TMR0                 = 100;
	MOVLW      100
	MOVWF      TMR0+0
;ventilatorv1_2.c,325 :: 		if(count>=50){        //here switches and analog reada will be taken every 50 ms
	MOVLW      0
	SUBWF      _count+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Interrupt121
	MOVLW      0
	SUBWF      _count+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Interrupt121
	MOVLW      0
	SUBWF      _count+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Interrupt121
	MOVLW      50
	SUBWF      _count+0, 0
L__Interrupt121:
	BTFSS      STATUS+0, 0
	GOTO       L_Interrupt52
;ventilatorv1_2.c,327 :: 		switches() ;       //reading switches
	CALL       _switches+0
;ventilatorv1_2.c,328 :: 		read_sensor_data(); //reading sensor data
	CALL       _read_sensor_data+0
;ventilatorv1_2.c,331 :: 		count=0;
	CLRF       _count+0
	CLRF       _count+1
	CLRF       _count+2
	CLRF       _count+3
;ventilatorv1_2.c,333 :: 		}
L_Interrupt52:
;ventilatorv1_2.c,335 :: 		millis_count++;
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
;ventilatorv1_2.c,336 :: 		count++;
	MOVF       _count+0, 0
	MOVWF      R0+0
	MOVF       _count+1, 0
	MOVWF      R0+1
	MOVF       _count+2, 0
	MOVWF      R0+2
	MOVF       _count+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _count+0
	MOVF       R0+1, 0
	MOVWF      _count+1
	MOVF       R0+2, 0
	MOVWF      _count+2
	MOVF       R0+3, 0
	MOVWF      _count+3
;ventilatorv1_2.c,337 :: 		}
L_Interrupt51:
;ventilatorv1_2.c,339 :: 		}
L_end_Interrupt:
L__Interrupt120:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;ventilatorv1_2.c,340 :: 		void main()
;ventilatorv1_2.c,343 :: 		ADCON1 = 0x80;
	MOVLW      128
	MOVWF      ADCON1+0
;ventilatorv1_2.c,344 :: 		TRISA  = 0xFF;// PORTA is input
	MOVLW      255
	MOVWF      TRISA+0
;ventilatorv1_2.c,345 :: 		PORTB=0;  // set portB as digital
	CLRF       PORTB+0
;ventilatorv1_2.c,346 :: 		TRISB=0xf0;  // set portB input/outputs
	MOVLW      240
	MOVWF      TRISB+0
;ventilatorv1_2.c,347 :: 		PORTC=0;  // set portC as digital
	CLRF       PORTC+0
;ventilatorv1_2.c,348 :: 		TRISC=0xff;  // set portC as inputs
	MOVLW      255
	MOVWF      TRISC+0
;ventilatorv1_2.c,349 :: 		PORTD=0x00;  // set portD as digital
	CLRF       PORTD+0
;ventilatorv1_2.c,350 :: 		TRISD=0x00;  // set portD as outputs
	CLRF       TRISD+0
;ventilatorv1_2.c,351 :: 		TRISE  = 0x07; // PORTE as analog input
	MOVLW      7
	MOVWF      TRISE+0
;ventilatorv1_2.c,352 :: 		ADC_Init();
	CALL       _ADC_Init+0
;ventilatorv1_2.c,353 :: 		InitTimer0();//inica conte timer cada milisegundo
	CALL       _InitTimer0+0
;ventilatorv1_2.c,357 :: 		selftest(1);//do self test
	MOVLW      1
	MOVWF      FARG_selftest_fail+0
	MOVLW      0
	MOVWF      FARG_selftest_fail+1
	CALL       _selftest+0
;ventilatorv1_2.c,359 :: 		while(1){
L_main53:
;ventilatorv1_2.c,360 :: 		int tempti=0;
	CLRF       main_tempti_L1+0
	CLRF       main_tempti_L1+1
;ventilatorv1_2.c,361 :: 		if(startstatus)  {
	MOVF       _startstatus+0, 0
	IORWF      _startstatus+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main55
;ventilatorv1_2.c,363 :: 		s2v=1;             //s2v locked
	BSF        PORTD+0, 5
;ventilatorv1_2.c,364 :: 		dcv1=1;             //dcv1 on
	BSF        PORTD+0, 0
;ventilatorv1_2.c,365 :: 		dcv2=1;            //dcv2 on
	BSF        PORTD+0, 1
;ventilatorv1_2.c,366 :: 		delay1=millis();  //flag for delay1
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      _delay1+0
	MOVF       R0+1, 0
	MOVWF      _delay1+1
;ventilatorv1_2.c,367 :: 		while(p1<=200 && startstatus==1){  //dcv1 is on until p1 pressure is good
L_main56:
	MOVF       _p1+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main123
	MOVF       _p1+0, 0
	SUBLW      200
L__main123:
	BTFSS      STATUS+0, 0
	GOTO       L_main57
	MOVLW      0
	XORWF      _startstatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main124
	MOVLW      1
	XORWF      _startstatus+0, 0
L__main124:
	BTFSS      STATUS+0, 2
	GOTO       L_main57
L__main90:
;ventilatorv1_2.c,368 :: 		dcv1=1;
	BSF        PORTD+0, 0
;ventilatorv1_2.c,369 :: 		}
	GOTO       L_main56
L_main57:
;ventilatorv1_2.c,370 :: 		dcv1=0;            //dcv2 on after pressure is ok
	BCF        PORTD+0, 0
;ventilatorv1_2.c,373 :: 		if(s4<200 || s9<200 || s10<200){  //checking flow sensor values
	MOVLW      0
	SUBWF      _s4+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main125
	MOVLW      200
	SUBWF      _s4+0, 0
L__main125:
	BTFSS      STATUS+0, 0
	GOTO       L__main89
	MOVLW      0
	SUBWF      _s9+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main126
	MOVLW      200
	SUBWF      _s9+0, 0
L__main126:
	BTFSS      STATUS+0, 0
	GOTO       L__main89
	MOVLW      0
	SUBWF      _s10+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main127
	MOVLW      200
	SUBWF      _s10+0, 0
L__main127:
	BTFSS      STATUS+0, 0
	GOTO       L__main89
	GOTO       L_main62
L__main89:
;ventilatorv1_2.c,374 :: 		selftest(0);                 //if flow values are not within safe values error is generated
	CLRF       FARG_selftest_fail+0
	CLRF       FARG_selftest_fail+1
	CALL       _selftest+0
;ventilatorv1_2.c,375 :: 		s2v=0;                      //also s2v valve is unlocked
	BCF        PORTD+0, 5
;ventilatorv1_2.c,376 :: 		}
L_main62:
;ventilatorv1_2.c,377 :: 		delay1=millis()-delay1; //calculate time took to generate pressure
	CALL       _millis+0
	MOVF       _delay1+0, 0
	SUBWF      R0+0, 0
	MOVWF      _delay1+0
	MOVF       _delay1+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      R0+1, 0
	MOVWF      _delay1+1
;ventilatorv1_2.c,378 :: 		delay2=millis();              //flag for
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      _delay2+0
	MOVF       R0+1, 0
	MOVWF      _delay2+1
;ventilatorv1_2.c,379 :: 		while(temperature && startstatus==1){          //heating air
L_main63:
	MOVF       _temperature+0, 0
	IORWF      _temperature+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main64
	MOVLW      0
	XORWF      _startstatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main128
	MOVLW      1
	XORWF      _startstatus+0, 0
L__main128:
	BTFSS      STATUS+0, 2
	GOTO       L_main64
L__main88:
;ventilatorv1_2.c,380 :: 		heater=1;
	BSF        PORTD+0, 6
;ventilatorv1_2.c,381 :: 		}
	GOTO       L_main63
L_main64:
;ventilatorv1_2.c,382 :: 		heater=0;                     //turn off heater after temperature is ok
	BCF        PORTD+0, 6
;ventilatorv1_2.c,383 :: 		if(temperature<20){            //if temperature is not within limit error is generated
	MOVLW      0
	SUBWF      _temperature+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main129
	MOVLW      20
	SUBWF      _temperature+0, 0
L__main129:
	BTFSC      STATUS+0, 0
	GOTO       L_main67
;ventilatorv1_2.c,384 :: 		selftest(0);
	CLRF       FARG_selftest_fail+0
	CLRF       FARG_selftest_fail+1
	CALL       _selftest+0
;ventilatorv1_2.c,385 :: 		s2v=0;                        //s2v ulockec
	BCF        PORTD+0, 5
;ventilatorv1_2.c,386 :: 		}
L_main67:
;ventilatorv1_2.c,387 :: 		delay2=millis()-delay2;        //calculating time took for heating
	CALL       _millis+0
	MOVF       _delay2+0, 0
	SUBWF      R0+0, 0
	MOVWF      _delay2+0
	MOVF       _delay2+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      R0+1, 0
	MOVWF      _delay2+1
;ventilatorv1_2.c,388 :: 		delay3=millis();               //flag for delay3
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      _delay3+0
	MOVF       R0+1, 0
	MOVWF      _delay3+1
;ventilatorv1_2.c,389 :: 		tempti=inhtime-(delay1+delay2);    //  calculating left time for inhale
	MOVF       _delay2+0, 0
	ADDWF      _delay1+0, 0
	MOVWF      R0+0
	MOVF       _delay1+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _delay2+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	SUBWF      _inhtime+0, 0
	MOVWF      main_tempti_L1+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _inhtime+1, 0
	MOVWF      main_tempti_L1+1
;ventilatorv1_2.c,391 :: 		while((millis()-delay3<=tempti )&& startstatus==1){    //wait untill inhale finish
L_main68:
	CALL       _millis+0
	MOVF       _delay3+0, 0
	MOVWF      R8+0
	MOVF       _delay3+1, 0
	MOVWF      R8+1
	CLRF       R8+2
	CLRF       R8+3
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVF       R8+0, 0
	SUBWF      R4+0, 1
	MOVF       R8+1, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R8+1, 0
	SUBWF      R4+1, 1
	MOVF       R8+2, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R8+2, 0
	SUBWF      R4+2, 1
	MOVF       R8+3, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R8+3, 0
	SUBWF      R4+3, 1
	MOVLW      0
	BTFSC      main_tempti_L1+1, 7
	MOVLW      255
	MOVWF      R0+0
	MOVF       R4+3, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main130
	MOVLW      0
	BTFSC      main_tempti_L1+1, 7
	MOVLW      255
	MOVWF      R0+0
	MOVF       R4+2, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main130
	MOVF       R4+1, 0
	SUBWF      main_tempti_L1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main130
	MOVF       R4+0, 0
	SUBWF      main_tempti_L1+0, 0
L__main130:
	BTFSS      STATUS+0, 0
	GOTO       L_main69
	MOVLW      0
	XORWF      _startstatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main131
	MOVLW      1
	XORWF      _startstatus+0, 0
L__main131:
	BTFSS      STATUS+0, 2
	GOTO       L_main69
L__main87:
;ventilatorv1_2.c,393 :: 		}
	GOTO       L_main68
L_main69:
;ventilatorv1_2.c,394 :: 		dcv2=0; //   dcv2 off
	BCF        PORTD+0, 1
;ventilatorv1_2.c,395 :: 		tempti=0;
	CLRF       main_tempti_L1+0
	CLRF       main_tempti_L1+1
;ventilatorv1_2.c,396 :: 		delay3=millis()-delay3;// calculating delay 3
	CALL       _millis+0
	MOVF       _delay3+0, 0
	SUBWF      R0+0, 0
	MOVWF      _delay3+0
	MOVF       _delay3+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      R0+1, 0
	MOVWF      _delay3+1
;ventilatorv1_2.c,397 :: 		s2v=0;           //s2v off
	BCF        PORTD+0, 5
;ventilatorv1_2.c,398 :: 		delay4=millis();  //flag for delay 4
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      _delay4+0
	MOVF       R0+1, 0
	MOVWF      _delay4+1
;ventilatorv1_2.c,399 :: 		while((millis()-delay4<exhtime)&& startstatus==1){  //wait until exhail finsh
L_main72:
	CALL       _millis+0
	MOVF       _delay4+0, 0
	MOVWF      R8+0
	MOVF       _delay4+1, 0
	MOVWF      R8+1
	CLRF       R8+2
	CLRF       R8+3
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVF       R8+0, 0
	SUBWF      R4+0, 1
	MOVF       R8+1, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R8+1, 0
	SUBWF      R4+1, 1
	MOVF       R8+2, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R8+2, 0
	SUBWF      R4+2, 1
	MOVF       R8+3, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R8+3, 0
	SUBWF      R4+3, 1
	MOVLW      0
	SUBWF      R4+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVLW      0
	SUBWF      R4+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVF       _exhtime+1, 0
	SUBWF      R4+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVF       _exhtime+0, 0
	SUBWF      R4+0, 0
L__main132:
	BTFSC      STATUS+0, 0
	GOTO       L_main73
	MOVLW      0
	XORWF      _startstatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main133
	MOVLW      1
	XORWF      _startstatus+0, 0
L__main133:
	BTFSS      STATUS+0, 2
	GOTO       L_main73
L__main86:
;ventilatorv1_2.c,400 :: 		if(p3>200){
	MOVF       _p3+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main134
	MOVF       _p3+0, 0
	SUBLW      200
L__main134:
	BTFSC      STATUS+0, 0
	GOTO       L_main76
;ventilatorv1_2.c,402 :: 		}
	GOTO       L_main77
L_main76:
;ventilatorv1_2.c,404 :: 		selftest(0);     //if exhaile pressure not within limits error genrated
	CLRF       FARG_selftest_fail+0
	CLRF       FARG_selftest_fail+1
	CALL       _selftest+0
;ventilatorv1_2.c,405 :: 		s2v=0;//s2v unlocked
	BCF        PORTD+0, 5
;ventilatorv1_2.c,407 :: 		}
L_main77:
;ventilatorv1_2.c,408 :: 		}
	GOTO       L_main72
L_main73:
;ventilatorv1_2.c,410 :: 		delay4=millis()-delay4;  //calculating time took for exhalation
	CALL       _millis+0
	MOVF       _delay4+0, 0
	SUBWF      R0+0, 0
	MOVWF      R4+0
	MOVF       _delay4+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      R0+1, 0
	MOVWF      R4+1
	MOVF       R4+0, 0
	MOVWF      _delay4+0
	MOVF       R4+1, 0
	MOVWF      _delay4+1
;ventilatorv1_2.c,411 :: 		tempti=delay1+delay2+delay3+delay4  ;//calculating total time took for inhale and exhale
	MOVF       _delay2+0, 0
	ADDWF      _delay1+0, 0
	MOVWF      R0+0
	MOVF       _delay1+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _delay2+1, 0
	MOVWF      R0+1
	MOVF       _delay3+0, 0
	ADDWF      R0+0, 1
	MOVF       _delay3+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R4+0, 0
	ADDWF      R0+0, 0
	MOVWF      R3+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R4+1, 0
	MOVWF      R3+1
	MOVF       R3+0, 0
	MOVWF      main_tempti_L1+0
	MOVF       R3+1, 0
	MOVWF      main_tempti_L1+1
;ventilatorv1_2.c,412 :: 		if(tempti>inhtime+exhtime){  //if total time is not within limits error is generated
	MOVF       _exhtime+0, 0
	ADDWF      _inhtime+0, 0
	MOVWF      R1+0
	MOVF       _inhtime+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _exhtime+1, 0
	MOVWF      R1+1
	MOVF       R3+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main135
	MOVF       R3+0, 0
	SUBWF      R1+0, 0
L__main135:
	BTFSC      STATUS+0, 0
	GOTO       L_main78
;ventilatorv1_2.c,413 :: 		selftest(0);
	CLRF       FARG_selftest_fail+0
	CLRF       FARG_selftest_fail+1
	CALL       _selftest+0
;ventilatorv1_2.c,414 :: 		s2v=0;
	BCF        PORTD+0, 5
;ventilatorv1_2.c,415 :: 		}
L_main78:
;ventilatorv1_2.c,417 :: 		}
	GOTO       L_main79
L_main55:
;ventilatorv1_2.c,419 :: 		dcv1=0;
	BCF        PORTD+0, 0
;ventilatorv1_2.c,420 :: 		dcv2=0  ;
	BCF        PORTD+0, 1
;ventilatorv1_2.c,421 :: 		s2v=0;
	BCF        PORTD+0, 5
;ventilatorv1_2.c,422 :: 		heater=0  ;
	BCF        PORTD+0, 6
;ventilatorv1_2.c,424 :: 		}
L_main79:
;ventilatorv1_2.c,426 :: 		}
	GOTO       L_main53
;ventilatorv1_2.c,427 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

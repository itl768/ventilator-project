
_InitTimer0:

;ventilatorv1_2.c,76 :: 		void InitTimer0(){
;ventilatorv1_2.c,77 :: 		OPTION_REG         = 0x84;
	MOVLW      132
	MOVWF      OPTION_REG+0
;ventilatorv1_2.c,78 :: 		TMR0                 = 100;
	MOVLW      100
	MOVWF      TMR0+0
;ventilatorv1_2.c,79 :: 		INTCON         = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;ventilatorv1_2.c,80 :: 		}
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

;ventilatorv1_2.c,82 :: 		void Interrupt(){
;ventilatorv1_2.c,83 :: 		if (TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_Interrupt0
;ventilatorv1_2.c,84 :: 		TMR0IF_bit         = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;ventilatorv1_2.c,85 :: 		TMR0                 = 100;
	MOVLW      100
	MOVWF      TMR0+0
;ventilatorv1_2.c,87 :: 		millis_count++;
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
;ventilatorv1_2.c,89 :: 		}
L_Interrupt0:
;ventilatorv1_2.c,91 :: 		}
L_end_Interrupt:
L__Interrupt70:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_millis:

;ventilatorv1_2.c,93 :: 		unsigned long millis()
;ventilatorv1_2.c,95 :: 		return(millis_count);
	MOVF       _millis_count+0, 0
	MOVWF      R0+0
	MOVF       _millis_count+1, 0
	MOVWF      R0+1
	MOVF       _millis_count+2, 0
	MOVWF      R0+2
	MOVF       _millis_count+3, 0
	MOVWF      R0+3
;ventilatorv1_2.c,96 :: 		}
L_end_millis:
	RETURN
; end of _millis

_alarm:

;ventilatorv1_2.c,99 :: 		void alarm(int tm){
;ventilatorv1_2.c,100 :: 		int alarm_millis=millis();
	CALL       _millis+0
	MOVF       R0+0, 0
	MOVWF      alarm_alarm_millis_L0+0
	MOVF       R0+1, 0
	MOVWF      alarm_alarm_millis_L0+1
;ventilatorv1_2.c,101 :: 		while(millis()-alarm_millis<=tm){
L_alarm1:
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
	GOTO       L__alarm73
	MOVLW      0
	BTFSC      FARG_alarm_tm+1, 7
	MOVLW      255
	MOVWF      R0+0
	MOVF       R4+2, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__alarm73
	MOVF       R4+1, 0
	SUBWF      FARG_alarm_tm+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__alarm73
	MOVF       R4+0, 0
	SUBWF      FARG_alarm_tm+0, 0
L__alarm73:
	BTFSS      STATUS+0, 0
	GOTO       L_alarm2
;ventilatorv1_2.c,102 :: 		buz=1;
	BSF        PORTD+0, 2
;ventilatorv1_2.c,103 :: 		}
	GOTO       L_alarm1
L_alarm2:
;ventilatorv1_2.c,104 :: 		buz=0;
	BCF        PORTD+0, 2
;ventilatorv1_2.c,105 :: 		}
L_end_alarm:
	RETURN
; end of _alarm

_shiftdata595:

;ventilatorv1_2.c,108 :: 		void shiftdata595(int _shiftdata[])  //shift register
;ventilatorv1_2.c,112 :: 		i=8;
	MOVLW      8
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
;ventilatorv1_2.c,113 :: 		while (i>0)                  //loop to send 8bit data
L_shiftdata5953:
	MOVF       R4+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__shiftdata59575
	MOVF       R4+0, 0
	SUBLW      0
L__shiftdata59575:
	BTFSC      STATUS+0, 0
	GOTO       L_shiftdata5954
;ventilatorv1_2.c,115 :: 		SHIFT_DATA=_shiftdata[i-1]; //  send array value
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
	GOTO       L__shiftdata59576
	BCF        PORTB+0, 0
	GOTO       L__shiftdata59577
L__shiftdata59576:
	BSF        PORTB+0, 0
L__shiftdata59577:
;ventilatorv1_2.c,116 :: 		SHIFT_CLOCK = 1;
	BSF        PORTB+0, 2
;ventilatorv1_2.c,117 :: 		Delay_us(1);
	NOP
	NOP
;ventilatorv1_2.c,118 :: 		SHIFT_CLOCK = 0;
	BCF        PORTB+0, 2
;ventilatorv1_2.c,119 :: 		i--;
	MOVLW      1
	SUBWF      R4+0, 1
	BTFSS      STATUS+0, 0
	DECF       R4+1, 1
;ventilatorv1_2.c,120 :: 		}
	GOTO       L_shiftdata5953
L_shiftdata5954:
;ventilatorv1_2.c,121 :: 		}
L_end_shiftdata595:
	RETURN
; end of _shiftdata595

_latch595:

;ventilatorv1_2.c,123 :: 		void latch595()              //latch pin controll
;ventilatorv1_2.c,125 :: 		SHIFT_LATCH = 1;
	BSF        PORTB+0, 1
;ventilatorv1_2.c,126 :: 		Delay_us(1);
	NOP
	NOP
;ventilatorv1_2.c,127 :: 		SHIFT_LATCH = 0;
	BCF        PORTB+0, 1
;ventilatorv1_2.c,128 :: 		}
L_end_latch595:
	RETURN
; end of _latch595

_switches:

;ventilatorv1_2.c,132 :: 		void switches(){
;ventilatorv1_2.c,134 :: 		if (Button(&PORTB, 6, 1, 0)) {               // Detect logical zero
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
	GOTO       L_switches5
;ventilatorv1_2.c,135 :: 		oldbpmup = 1;                              // Update flag
	BSF        _oldbpmup+0, BitPos(_oldbpmup+0)
;ventilatorv1_2.c,136 :: 		}
L_switches5:
;ventilatorv1_2.c,137 :: 		if (oldbpmup && Button(&PORTB, 6, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldbpmup+0, BitPos(_oldbpmup+0)
	GOTO       L_switches8
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
	GOTO       L_switches8
L__switches67:
;ventilatorv1_2.c,138 :: 		oldbpmup = 0;                            // Update flag
	BCF        _oldbpmup+0, BitPos(_oldbpmup+0)
;ventilatorv1_2.c,139 :: 		bpmv++;                                //increment bpm level
	INCF       _bpmv+0, 1
	BTFSC      STATUS+0, 2
	INCF       _bpmv+1, 1
;ventilatorv1_2.c,141 :: 		if(bpmv>16){                     //limit bpm value
	MOVF       _bpmv+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__switches80
	MOVF       _bpmv+0, 0
	SUBLW      16
L__switches80:
	BTFSC      STATUS+0, 0
	GOTO       L_switches9
;ventilatorv1_2.c,142 :: 		bpmv=16;
	MOVLW      16
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilatorv1_2.c,143 :: 		}
L_switches9:
;ventilatorv1_2.c,144 :: 		if(bpmv<12){
	MOVLW      0
	SUBWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches81
	MOVLW      12
	SUBWF      _bpmv+0, 0
L__switches81:
	BTFSC      STATUS+0, 0
	GOTO       L_switches10
;ventilatorv1_2.c,145 :: 		bpmv=12;
	MOVLW      12
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilatorv1_2.c,146 :: 		}
L_switches10:
;ventilatorv1_2.c,149 :: 		}
L_switches8:
;ventilatorv1_2.c,151 :: 		if (Button(&PORTB, 7, 1, 0)) {               // Detect logical zero
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
	GOTO       L_switches11
;ventilatorv1_2.c,152 :: 		oldbpmdown = 1;                              // Update flag
	BSF        _oldbpmdown+0, BitPos(_oldbpmdown+0)
;ventilatorv1_2.c,153 :: 		}
L_switches11:
;ventilatorv1_2.c,154 :: 		if (oldbpmdown && Button(&PORTB, 7, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldbpmdown+0, BitPos(_oldbpmdown+0)
	GOTO       L_switches14
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
	GOTO       L_switches14
L__switches66:
;ventilatorv1_2.c,155 :: 		oldbpmdown = 0;                           // Update flag
	BCF        _oldbpmdown+0, BitPos(_oldbpmdown+0)
;ventilatorv1_2.c,157 :: 		bpmv--;                                      //decrement bpm value
	MOVLW      1
	SUBWF      _bpmv+0, 1
	BTFSS      STATUS+0, 0
	DECF       _bpmv+1, 1
;ventilatorv1_2.c,158 :: 		if(bpmv>16){                                 //limit bpm value
	MOVF       _bpmv+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__switches82
	MOVF       _bpmv+0, 0
	SUBLW      16
L__switches82:
	BTFSC      STATUS+0, 0
	GOTO       L_switches15
;ventilatorv1_2.c,159 :: 		bpmv=16;
	MOVLW      16
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilatorv1_2.c,160 :: 		}
L_switches15:
;ventilatorv1_2.c,161 :: 		if(bpmv<12){
	MOVLW      0
	SUBWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches83
	MOVLW      12
	SUBWF      _bpmv+0, 0
L__switches83:
	BTFSC      STATUS+0, 0
	GOTO       L_switches16
;ventilatorv1_2.c,162 :: 		bpmv=12;
	MOVLW      12
	MOVWF      _bpmv+0
	MOVLW      0
	MOVWF      _bpmv+1
;ventilatorv1_2.c,163 :: 		}
L_switches16:
;ventilatorv1_2.c,166 :: 		}
L_switches14:
;ventilatorv1_2.c,171 :: 		if (Button(&PORTB, 4, 1, 0)) {               // Detect logical zero
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
	GOTO       L_switches17
;ventilatorv1_2.c,172 :: 		oldvolup = 1;                              // Update flag
	BSF        _oldvolup+0, BitPos(_oldvolup+0)
;ventilatorv1_2.c,173 :: 		}
L_switches17:
;ventilatorv1_2.c,174 :: 		if (oldvolup && Button(&PORTB, 4, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldvolup+0, BitPos(_oldvolup+0)
	GOTO       L_switches20
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
	GOTO       L_switches20
L__switches65:
;ventilatorv1_2.c,175 :: 		oldvolup = 0;                    // Update flag
	BCF        _oldvolup+0, BitPos(_oldvolup+0)
;ventilatorv1_2.c,177 :: 		vol=vol+50;              //increment volume level by 50
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
;ventilatorv1_2.c,178 :: 		if(vol>550){                                         //limit volume level
	MOVF       R1+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches84
	MOVF       R1+0, 0
	SUBLW      38
L__switches84:
	BTFSC      STATUS+0, 0
	GOTO       L_switches21
;ventilatorv1_2.c,179 :: 		vol=550;
	MOVLW      38
	MOVWF      _vol+0
	MOVLW      2
	MOVWF      _vol+1
;ventilatorv1_2.c,180 :: 		}
L_switches21:
;ventilatorv1_2.c,181 :: 		if(vol<450){
	MOVLW      1
	SUBWF      _vol+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches85
	MOVLW      194
	SUBWF      _vol+0, 0
L__switches85:
	BTFSC      STATUS+0, 0
	GOTO       L_switches22
;ventilatorv1_2.c,182 :: 		vol=450;
	MOVLW      194
	MOVWF      _vol+0
	MOVLW      1
	MOVWF      _vol+1
;ventilatorv1_2.c,183 :: 		}
L_switches22:
;ventilatorv1_2.c,185 :: 		}
L_switches20:
;ventilatorv1_2.c,187 :: 		if (Button(&PORTB, 5, 1, 0)) {               // Detect logical zero
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
	GOTO       L_switches23
;ventilatorv1_2.c,188 :: 		oldvoldown = 1;                              // Update flag
	BSF        _oldvoldown+0, BitPos(_oldvoldown+0)
;ventilatorv1_2.c,189 :: 		}
L_switches23:
;ventilatorv1_2.c,190 :: 		if (oldvoldown && Button(&PORTB, 5, 1, 1)) {   // Detect zero-to-one transition
	BTFSS      _oldvoldown+0, BitPos(_oldvoldown+0)
	GOTO       L_switches26
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
	GOTO       L_switches26
L__switches64:
;ventilatorv1_2.c,191 :: 		oldvoldown = 0;                                   // Update flag
	BCF        _oldvoldown+0, BitPos(_oldvoldown+0)
;ventilatorv1_2.c,193 :: 		vol=vol-50;                                         //decrement volume level
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
;ventilatorv1_2.c,194 :: 		if(vol>550){                                         //limit volume level
	MOVF       R1+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches86
	MOVF       R1+0, 0
	SUBLW      38
L__switches86:
	BTFSC      STATUS+0, 0
	GOTO       L_switches27
;ventilatorv1_2.c,195 :: 		vol=550;
	MOVLW      38
	MOVWF      _vol+0
	MOVLW      2
	MOVWF      _vol+1
;ventilatorv1_2.c,196 :: 		}
L_switches27:
;ventilatorv1_2.c,197 :: 		if(vol<450){
	MOVLW      1
	SUBWF      _vol+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches87
	MOVLW      194
	SUBWF      _vol+0, 0
L__switches87:
	BTFSC      STATUS+0, 0
	GOTO       L_switches28
;ventilatorv1_2.c,198 :: 		vol=450;
	MOVLW      194
	MOVWF      _vol+0
	MOVLW      1
	MOVWF      _vol+1
;ventilatorv1_2.c,199 :: 		}
L_switches28:
;ventilatorv1_2.c,202 :: 		}
L_switches26:
;ventilatorv1_2.c,205 :: 		if ( !startstatus  && Button(&PORTC, 6, 1, 0)) {               // Detect logical zero
	MOVF       _startstatus+0, 0
	IORWF      _startstatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_switches31
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
	GOTO       L_switches31
L__switches63:
;ventilatorv1_2.c,207 :: 		startl=1;                                      //led indicator
	BSF        PORTD+0, 4
;ventilatorv1_2.c,208 :: 		startstatus = 1;                              // Update flag
	MOVLW      1
	MOVWF      _startstatus+0
	MOVLW      0
	MOVWF      _startstatus+1
;ventilatorv1_2.c,209 :: 		}
L_switches31:
;ventilatorv1_2.c,210 :: 		if (startstatus && Button(&PORTC, 7, 1, 0)) {   // Detect logical zero
	MOVF       _startstatus+0, 0
	IORWF      _startstatus+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_switches34
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
	GOTO       L_switches34
L__switches62:
;ventilatorv1_2.c,212 :: 		startl=0;                                    //led indicator
	BCF        PORTD+0, 4
;ventilatorv1_2.c,213 :: 		startstatus = 0;               // Update flag
	CLRF       _startstatus+0
	CLRF       _startstatus+1
;ventilatorv1_2.c,214 :: 		}
L_switches34:
;ventilatorv1_2.c,218 :: 		switch (vol){                       //led value for each volume level
	GOTO       L_switches35
;ventilatorv1_2.c,219 :: 		case 450:
L_switches37:
;ventilatorv1_2.c,220 :: 		led[5]=1;
	MOVLW      1
	MOVWF      _led+10
	MOVLW      0
	MOVWF      _led+11
;ventilatorv1_2.c,221 :: 		led[6]=0;
	CLRF       _led+12
	CLRF       _led+13
;ventilatorv1_2.c,222 :: 		led[7]=0;
	CLRF       _led+14
	CLRF       _led+15
;ventilatorv1_2.c,224 :: 		break;
	GOTO       L_switches36
;ventilatorv1_2.c,225 :: 		case 500:
L_switches38:
;ventilatorv1_2.c,226 :: 		led[5]=0;
	CLRF       _led+10
	CLRF       _led+11
;ventilatorv1_2.c,227 :: 		led[6]=1;
	MOVLW      1
	MOVWF      _led+12
	MOVLW      0
	MOVWF      _led+13
;ventilatorv1_2.c,228 :: 		led[7]=0;
	CLRF       _led+14
	CLRF       _led+15
;ventilatorv1_2.c,230 :: 		break;
	GOTO       L_switches36
;ventilatorv1_2.c,231 :: 		case 550:
L_switches39:
;ventilatorv1_2.c,232 :: 		led[5]=0;
	CLRF       _led+10
	CLRF       _led+11
;ventilatorv1_2.c,233 :: 		led[6]=0;
	CLRF       _led+12
	CLRF       _led+13
;ventilatorv1_2.c,234 :: 		led[7]=1;
	MOVLW      1
	MOVWF      _led+14
	MOVLW      0
	MOVWF      _led+15
;ventilatorv1_2.c,236 :: 		break;
	GOTO       L_switches36
;ventilatorv1_2.c,238 :: 		}
L_switches35:
	MOVF       _vol+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__switches88
	MOVLW      194
	XORWF      _vol+0, 0
L__switches88:
	BTFSC      STATUS+0, 2
	GOTO       L_switches37
	MOVF       _vol+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__switches89
	MOVLW      244
	XORWF      _vol+0, 0
L__switches89:
	BTFSC      STATUS+0, 2
	GOTO       L_switches38
	MOVF       _vol+1, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__switches90
	MOVLW      38
	XORWF      _vol+0, 0
L__switches90:
	BTFSC      STATUS+0, 2
	GOTO       L_switches39
L_switches36:
;ventilatorv1_2.c,240 :: 		switch (bpmv){                           //led value for each bpm value
	GOTO       L_switches40
;ventilatorv1_2.c,241 :: 		case 12:
L_switches42:
;ventilatorv1_2.c,242 :: 		led[0]=1;
	MOVLW      1
	MOVWF      _led+0
	MOVLW      0
	MOVWF      _led+1
;ventilatorv1_2.c,243 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilatorv1_2.c,244 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilatorv1_2.c,245 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilatorv1_2.c,246 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilatorv1_2.c,247 :: 		break;
	GOTO       L_switches41
;ventilatorv1_2.c,248 :: 		case 13:
L_switches43:
;ventilatorv1_2.c,249 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilatorv1_2.c,250 :: 		led[1]=1;
	MOVLW      1
	MOVWF      _led+2
	MOVLW      0
	MOVWF      _led+3
;ventilatorv1_2.c,251 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilatorv1_2.c,252 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilatorv1_2.c,253 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilatorv1_2.c,254 :: 		break;
	GOTO       L_switches41
;ventilatorv1_2.c,255 :: 		case 14:
L_switches44:
;ventilatorv1_2.c,256 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilatorv1_2.c,257 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilatorv1_2.c,258 :: 		led[2]=1;
	MOVLW      1
	MOVWF      _led+4
	MOVLW      0
	MOVWF      _led+5
;ventilatorv1_2.c,259 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilatorv1_2.c,260 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilatorv1_2.c,261 :: 		break;
	GOTO       L_switches41
;ventilatorv1_2.c,262 :: 		case 15:
L_switches45:
;ventilatorv1_2.c,263 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilatorv1_2.c,264 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilatorv1_2.c,265 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilatorv1_2.c,266 :: 		led[3]=1;
	MOVLW      1
	MOVWF      _led+6
	MOVLW      0
	MOVWF      _led+7
;ventilatorv1_2.c,267 :: 		led[4]=0;
	CLRF       _led+8
	CLRF       _led+9
;ventilatorv1_2.c,268 :: 		break;
	GOTO       L_switches41
;ventilatorv1_2.c,269 :: 		case 16:
L_switches46:
;ventilatorv1_2.c,270 :: 		led[0]=0;
	CLRF       _led+0
	CLRF       _led+1
;ventilatorv1_2.c,271 :: 		led[1]=0;
	CLRF       _led+2
	CLRF       _led+3
;ventilatorv1_2.c,272 :: 		led[2]=0;
	CLRF       _led+4
	CLRF       _led+5
;ventilatorv1_2.c,273 :: 		led[3]=0;
	CLRF       _led+6
	CLRF       _led+7
;ventilatorv1_2.c,274 :: 		led[4]=1;
	MOVLW      1
	MOVWF      _led+8
	MOVLW      0
	MOVWF      _led+9
;ventilatorv1_2.c,275 :: 		break;
	GOTO       L_switches41
;ventilatorv1_2.c,276 :: 		}
L_switches40:
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches91
	MOVLW      12
	XORWF      _bpmv+0, 0
L__switches91:
	BTFSC      STATUS+0, 2
	GOTO       L_switches42
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches92
	MOVLW      13
	XORWF      _bpmv+0, 0
L__switches92:
	BTFSC      STATUS+0, 2
	GOTO       L_switches43
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches93
	MOVLW      14
	XORWF      _bpmv+0, 0
L__switches93:
	BTFSC      STATUS+0, 2
	GOTO       L_switches44
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches94
	MOVLW      15
	XORWF      _bpmv+0, 0
L__switches94:
	BTFSC      STATUS+0, 2
	GOTO       L_switches45
	MOVLW      0
	XORWF      _bpmv+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__switches95
	MOVLW      16
	XORWF      _bpmv+0, 0
L__switches95:
	BTFSC      STATUS+0, 2
	GOTO       L_switches46
L_switches41:
;ventilatorv1_2.c,278 :: 		shiftdata595(led);                  //send out led data
	MOVLW      _led+0
	MOVWF      FARG_shiftdata595__shiftdata+0
	CALL       _shiftdata595+0
;ventilatorv1_2.c,279 :: 		latch595();
	CALL       _latch595+0
;ventilatorv1_2.c,282 :: 		}
L_end_switches:
	RETURN
; end of _switches

_selftest:

;ventilatorv1_2.c,285 :: 		void selftest(){
;ventilatorv1_2.c,295 :: 		testl=1;                                        //test led on
	BSF        PORTD+0, 3
;ventilatorv1_2.c,304 :: 		}
L_selftest48:
;ventilatorv1_2.c,305 :: 		}
L_end_selftest:
	RETURN
; end of _selftest

_read_sensor_data:

;ventilatorv1_2.c,307 :: 		void read_sensor_data(){     //reading all analog sensor data
;ventilatorv1_2.c,308 :: 		s4=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _s4+0
	MOVF       R0+1, 0
	MOVWF      _s4+1
;ventilatorv1_2.c,309 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_read_sensor_data51:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensor_data51
	DECFSZ     R12+0, 1
	GOTO       L_read_sensor_data51
	DECFSZ     R11+0, 1
	GOTO       L_read_sensor_data51
	NOP
;ventilatorv1_2.c,310 :: 		s9= ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _s9+0
	MOVF       R0+1, 0
	MOVWF      _s9+1
;ventilatorv1_2.c,311 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_read_sensor_data52:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensor_data52
	DECFSZ     R12+0, 1
	GOTO       L_read_sensor_data52
	DECFSZ     R11+0, 1
	GOTO       L_read_sensor_data52
	NOP
;ventilatorv1_2.c,312 :: 		s10 =  ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _s10+0
	MOVF       R0+1, 0
	MOVWF      _s10+1
;ventilatorv1_2.c,313 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_read_sensor_data53:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensor_data53
	DECFSZ     R12+0, 1
	GOTO       L_read_sensor_data53
	DECFSZ     R11+0, 1
	GOTO       L_read_sensor_data53
	NOP
;ventilatorv1_2.c,314 :: 		p1  = ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _p1+0
	MOVF       R0+1, 0
	MOVWF      _p1+1
;ventilatorv1_2.c,315 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_read_sensor_data54:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensor_data54
	DECFSZ     R12+0, 1
	GOTO       L_read_sensor_data54
	DECFSZ     R11+0, 1
	GOTO       L_read_sensor_data54
	NOP
;ventilatorv1_2.c,316 :: 		p2   = ADC_Read(4);
	MOVLW      4
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _p2+0
	MOVF       R0+1, 0
	MOVWF      _p2+1
;ventilatorv1_2.c,317 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_read_sensor_data55:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensor_data55
	DECFSZ     R12+0, 1
	GOTO       L_read_sensor_data55
	DECFSZ     R11+0, 1
	GOTO       L_read_sensor_data55
	NOP
;ventilatorv1_2.c,318 :: 		p3 =   ADC_Read(5);
	MOVLW      5
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _p3+0
	MOVF       R0+1, 0
	MOVWF      _p3+1
;ventilatorv1_2.c,319 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_read_sensor_data56:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensor_data56
	DECFSZ     R12+0, 1
	GOTO       L_read_sensor_data56
	DECFSZ     R11+0, 1
	GOTO       L_read_sensor_data56
	NOP
;ventilatorv1_2.c,320 :: 		p_1  =  ADC_Read(6);
	MOVLW      6
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _p_1+0
	MOVF       R0+1, 0
	MOVWF      _p_1+1
;ventilatorv1_2.c,321 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_read_sensor_data57:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensor_data57
	DECFSZ     R12+0, 1
	GOTO       L_read_sensor_data57
	DECFSZ     R11+0, 1
	GOTO       L_read_sensor_data57
	NOP
;ventilatorv1_2.c,322 :: 		p_2  =  ADC_Read(7);
	MOVLW      7
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _p_2+0
	MOVF       R0+1, 0
	MOVWF      _p_2+1
;ventilatorv1_2.c,323 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_read_sensor_data58:
	DECFSZ     R13+0, 1
	GOTO       L_read_sensor_data58
	DECFSZ     R12+0, 1
	GOTO       L_read_sensor_data58
	DECFSZ     R11+0, 1
	GOTO       L_read_sensor_data58
	NOP
;ventilatorv1_2.c,324 :: 		}
L_end_read_sensor_data:
	RETURN
; end of _read_sensor_data

_main:

;ventilatorv1_2.c,332 :: 		void main()
;ventilatorv1_2.c,335 :: 		ADCON1 = 0x80;
	MOVLW      128
	MOVWF      ADCON1+0
;ventilatorv1_2.c,336 :: 		TRISA  = 0xFF;// PORTA is input
	MOVLW      255
	MOVWF      TRISA+0
;ventilatorv1_2.c,337 :: 		PORTB=0;  // set portB as digital
	CLRF       PORTB+0
;ventilatorv1_2.c,338 :: 		TRISB=0xf0;  // set portB input/outputs
	MOVLW      240
	MOVWF      TRISB+0
;ventilatorv1_2.c,339 :: 		PORTC=0;  // set portC as digital
	CLRF       PORTC+0
;ventilatorv1_2.c,340 :: 		TRISC=0xff;  // set portC as inputs
	MOVLW      255
	MOVWF      TRISC+0
;ventilatorv1_2.c,341 :: 		PORTD=0x00;  // set portD as digital
	CLRF       PORTD+0
;ventilatorv1_2.c,342 :: 		TRISD=0x00;  // set portD as outputs
	CLRF       TRISD+0
;ventilatorv1_2.c,343 :: 		TRISE  = 0x07; // PORTE as analog input
	MOVLW      7
	MOVWF      TRISE+0
;ventilatorv1_2.c,344 :: 		ADC_Init();
	CALL       _ADC_Init+0
;ventilatorv1_2.c,347 :: 		ADC_Init();
	CALL       _ADC_Init+0
;ventilatorv1_2.c,349 :: 		selftest();//do self test
	CALL       _selftest+0
;ventilatorv1_2.c,351 :: 		while(1){
L_main59:
;ventilatorv1_2.c,352 :: 		read_sensor_data();
	CALL       _read_sensor_data+0
;ventilatorv1_2.c,353 :: 		switches();
	CALL       _switches+0
;ventilatorv1_2.c,354 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main61:
	DECFSZ     R13+0, 1
	GOTO       L_main61
	DECFSZ     R12+0, 1
	GOTO       L_main61
	DECFSZ     R11+0, 1
	GOTO       L_main61
	NOP
;ventilatorv1_2.c,356 :: 		}
	GOTO       L_main59
;ventilatorv1_2.c,357 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

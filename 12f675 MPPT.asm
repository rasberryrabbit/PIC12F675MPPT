
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;12f675 MPPT.mpas,61 :: 		begin
;12f675 MPPT.mpas,62 :: 		if T0IF_bit=1 then begin
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L__Interrupt3
;12f675 MPPT.mpas,63 :: 		if PWM_FLAG=1 then begin
	BTFSS      _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
	GOTO       L__Interrupt6
;12f675 MPPT.mpas,64 :: 		PWM_SIG:=0;
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,65 :: 		PWM_FLAG:=0;
	BCF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,66 :: 		ON_PWM:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _ON_PWM+0
;12f675 MPPT.mpas,68 :: 		TMR0:=255-ON_PWM;
	MOVF       _VOL_PWM+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;12f675 MPPT.mpas,69 :: 		end else begin
	GOTO       L__Interrupt7
L__Interrupt6:
;12f675 MPPT.mpas,71 :: 		TMR0:=255-PWM_MAX+ON_PWM;
	MOVF       _ON_PWM+0, 0
	ADDLW      55
	MOVWF      TMR0+0
;12f675 MPPT.mpas,72 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,73 :: 		PWM_FLAG:=1;
	BSF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,74 :: 		end;
L__Interrupt7:
;12f675 MPPT.mpas,75 :: 		T0IF_bit:=0;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;12f675 MPPT.mpas,76 :: 		end;
L__Interrupt3:
;12f675 MPPT.mpas,77 :: 		end;
L_end_Interrupt:
L__Interrupt54:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;12f675 MPPT.mpas,79 :: 		begin
;12f675 MPPT.mpas,80 :: 		CMCON:=7;
	MOVLW      7
	MOVWF      CMCON+0
;12f675 MPPT.mpas,81 :: 		ANSEL:=%00111100;       // ADC conversion clock = fRC, AN3, AN2;
	MOVLW      60
	MOVWF      ANSEL+0
;12f675 MPPT.mpas,83 :: 		TRISIO0_bit:=0;      // PWM
	BCF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;12f675 MPPT.mpas,84 :: 		TRISIO1_bit:=1;      // not Connected
	BSF        TRISIO1_bit+0, BitPos(TRISIO1_bit+0)
;12f675 MPPT.mpas,85 :: 		TRISIO2_bit:=1;      // AN2
	BSF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;12f675 MPPT.mpas,86 :: 		TRISIO4_bit:=1;      // AN3
	BSF        TRISIO4_bit+0, BitPos(TRISIO4_bit+0)
;12f675 MPPT.mpas,87 :: 		TRISIO5_bit:=0;      // LED
	BCF        TRISIO5_bit+0, BitPos(TRISIO5_bit+0)
;12f675 MPPT.mpas,89 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,90 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,91 :: 		PWM_FLAG:=1;
	BSF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,92 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,93 :: 		ON_PWM:=0;
	CLRF       _ON_PWM+0
;12f675 MPPT.mpas,94 :: 		VOL_PWM:=0;
	CLRF       _VOL_PWM+0
;12f675 MPPT.mpas,95 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
	CLRF       _TICK_1000+1
;12f675 MPPT.mpas,96 :: 		VCFG_bit:=1;
	BSF        VCFG_bit+0, BitPos(VCFG_bit+0)
;12f675 MPPT.mpas,97 :: 		CHS1_bit:=1;
	BSF        CHS1_bit+0, BitPos(CHS1_bit+0)
;12f675 MPPT.mpas,98 :: 		ADFM_bit:=1;
	BSF        ADFM_bit+0, BitPos(ADFM_bit+0)
;12f675 MPPT.mpas,100 :: 		OPTION_REG:=%01011111;        // ~4KHz @ 4MHz
	MOVLW      95
	MOVWF      OPTION_REG+0
;12f675 MPPT.mpas,101 :: 		TMR0IE_bit:=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;12f675 MPPT.mpas,103 :: 		LM358_diff:=cLM358_diff;
	CLRF       _LM358_diff+0
;12f675 MPPT.mpas,104 :: 		Delay_10ms;
	CALL       _Delay_10ms+0
;12f675 MPPT.mpas,106 :: 		if Write_OPAMP=0 then begin
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L__main10
;12f675 MPPT.mpas,107 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,108 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,109 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,110 :: 		adc_cur:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,111 :: 		EEPROM_Write(0, Lo(adc_cur));
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _adc_cur+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;12f675 MPPT.mpas,112 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,113 :: 		LED1:=1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,114 :: 		Delay_ms(700);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      142
	MOVWF      R12+0
	MOVLW      18
	MOVWF      R13+0
L__main12:
	DECFSZ     R13+0, 1
	GOTO       L__main12
	DECFSZ     R12+0, 1
	GOTO       L__main12
	DECFSZ     R11+0, 1
	GOTO       L__main12
	NOP
;12f675 MPPT.mpas,115 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,116 :: 		end;
L__main10:
;12f675 MPPT.mpas,120 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,121 :: 		LM358_diff:=EEPROM_Read(0);
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _LM358_diff+0
;12f675 MPPT.mpas,124 :: 		T1CKPS0_bit:=1;               // timer1 prescaler 1:2
	BSF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;12f675 MPPT.mpas,125 :: 		TMR1CS_bit:=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;12f675 MPPT.mpas,126 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      24
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,127 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,128 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,130 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,131 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,132 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;12f675 MPPT.mpas,134 :: 		GIE_bit:=1;                   // enable Interrupt
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;12f675 MPPT.mpas,136 :: 		TMR1ON_bit:=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;12f675 MPPT.mpas,138 :: 		VOL_PWM:=PWM_MID;
	MOVLW      111
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,139 :: 		flag_inc:=False;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,140 :: 		cur_prev:=0;
	CLRF       _cur_prev+0
	CLRF       _cur_prev+1
;12f675 MPPT.mpas,141 :: 		vol_prev1:=0;
	CLRF       _vol_prev1+0
	CLRF       _vol_prev1+1
;12f675 MPPT.mpas,143 :: 		powertime:=0;
	CLRF       _powertime+0
	CLRF       _powertime+1
;12f675 MPPT.mpas,144 :: 		prevtime:=0;
	CLRF       _prevtime+0
	CLRF       _prevtime+1
;12f675 MPPT.mpas,146 :: 		while True do begin
L__main14:
;12f675 MPPT.mpas,148 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__main19
;12f675 MPPT.mpas,149 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,150 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      24
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,151 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,152 :: 		Inc(TICK_1000);
	INCF       _TICK_1000+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TICK_1000+1, 1
;12f675 MPPT.mpas,153 :: 		end;
L__main19:
;12f675 MPPT.mpas,155 :: 		wPWM := TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wPWM+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wPWM+1
;12f675 MPPT.mpas,156 :: 		if wPWM - prevtime > LED1_tm then begin
	MOVF       _prevtime+0, 0
	SUBWF      _TICK_1000+0, 0
	MOVWF      R1+0
	MOVF       _prevtime+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _TICK_1000+1, 0
	MOVWF      R1+1
	MOVF       R1+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main56
	MOVF       R1+0, 0
	SUBWF      _LED1_tm+0, 0
L__main56:
	BTFSC      STATUS+0, 0
	GOTO       L__main22
;12f675 MPPT.mpas,157 :: 		prevtime := TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _prevtime+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _prevtime+1
;12f675 MPPT.mpas,158 :: 		LED1 := not LED1;
	MOVLW
	XORWF      GP5_bit+0, 1
;12f675 MPPT.mpas,159 :: 		end;
L__main22:
;12f675 MPPT.mpas,162 :: 		cur_prev:=adc_cur;
	MOVF       _adc_cur+0, 0
	MOVWF      _cur_prev+0
	MOVF       _adc_cur+1, 0
	MOVWF      _cur_prev+1
;12f675 MPPT.mpas,163 :: 		vol_prev2:=vol_prev1;
	MOVF       _vol_prev1+0, 0
	MOVWF      _vol_prev2+0
	MOVF       _vol_prev1+1, 0
	MOVWF      _vol_prev2+1
;12f675 MPPT.mpas,164 :: 		vol_prev1:=adc_vol;
	MOVF       _adc_vol+0, 0
	MOVWF      _vol_prev1+0
	MOVF       _adc_vol+1, 0
	MOVWF      _vol_prev1+1
;12f675 MPPT.mpas,166 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,167 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,168 :: 		for i:=0 to adc_max_loop-1 do begin
	CLRF       _i+0
L__main25:
;12f675 MPPT.mpas,169 :: 		wPWM:=ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _wPWM+0
	MOVF       R0+1, 0
	MOVWF      _wPWM+1
;12f675 MPPT.mpas,170 :: 		wTemp:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _wTemp+0
	MOVF       R0+1, 0
	MOVWF      _wTemp+1
;12f675 MPPT.mpas,171 :: 		adc_vol:=adc_vol+wPWM;
	MOVF       _wPWM+0, 0
	ADDWF      _adc_vol+0, 1
	MOVF       _wPWM+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_vol+1, 1
;12f675 MPPT.mpas,172 :: 		adc_cur:=adc_cur+wTemp;
	MOVF       R0+0, 0
	ADDWF      _adc_cur+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_cur+1, 1
;12f675 MPPT.mpas,173 :: 		end;
	MOVF       _i+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L__main28
	INCF       _i+0, 1
	GOTO       L__main25
L__main28:
;12f675 MPPT.mpas,174 :: 		adc_vol:=adc_vol div adc_max_loop;
	RRF        _adc_vol+1, 1
	RRF        _adc_vol+0, 1
	BCF        _adc_vol+1, 7
	RRF        _adc_vol+1, 1
	RRF        _adc_vol+0, 1
	BCF        _adc_vol+1, 7
	RRF        _adc_vol+1, 1
	RRF        _adc_vol+0, 1
	BCF        _adc_vol+1, 7
;12f675 MPPT.mpas,175 :: 		adc_cur:=adc_cur div adc_max_loop;
	RRF        _adc_cur+1, 1
	RRF        _adc_cur+0, 1
	BCF        _adc_cur+1, 7
	RRF        _adc_cur+1, 1
	RRF        _adc_cur+0, 1
	BCF        _adc_cur+1, 7
	RRF        _adc_cur+1, 1
	RRF        _adc_cur+0, 1
	BCF        _adc_cur+1, 7
;12f675 MPPT.mpas,176 :: 		adc_vol:=adc_vol * VOLMUL;
	RLF        _adc_vol+0, 1
	RLF        _adc_vol+1, 1
	BCF        _adc_vol+0, 0
	RLF        _adc_vol+0, 1
	RLF        _adc_vol+1, 1
	BCF        _adc_vol+0, 0
;12f675 MPPT.mpas,179 :: 		wPWM:=TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wPWM+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wPWM+1
;12f675 MPPT.mpas,180 :: 		if wPWM - powertime < _UPDATE_INT then
	MOVF       _powertime+0, 0
	SUBWF      _TICK_1000+0, 0
	MOVWF      R1+0
	MOVF       _powertime+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _TICK_1000+1, 0
	MOVWF      R1+1
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main57
	MOVLW      20
	SUBWF      R1+0, 0
L__main57:
	BTFSC      STATUS+0, 0
	GOTO       L__main30
;12f675 MPPT.mpas,181 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
L__main30:
;12f675 MPPT.mpas,182 :: 		powertime:=TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _powertime+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _powertime+1
;12f675 MPPT.mpas,184 :: 		power_prev:=power_curr;
	MOVF       _power_curr+0, 0
	MOVWF      _power_prev+0
	MOVF       _power_curr+1, 0
	MOVWF      _power_prev+1
	MOVF       _power_curr+2, 0
	MOVWF      _power_prev+2
	MOVF       _power_curr+3, 0
	MOVWF      _power_prev+3
;12f675 MPPT.mpas,185 :: 		power_curr:= adc_vol * adc_cur;
	MOVF       _adc_vol+0, 0
	MOVWF      R0+0
	MOVF       _adc_vol+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       _adc_cur+0, 0
	MOVWF      R4+0
	MOVF       _adc_cur+1, 0
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _power_curr+0
	MOVF       R0+1, 0
	MOVWF      _power_curr+1
	MOVF       R0+2, 0
	MOVWF      _power_curr+2
	MOVF       R0+3, 0
	MOVWF      _power_curr+3
;12f675 MPPT.mpas,187 :: 		if adc_cur>LM358_diff then begin
	MOVF       _adc_cur+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main58
	MOVF       _adc_cur+0, 0
	SUBWF      _LM358_diff+0, 0
L__main58:
	BTFSC      STATUS+0, 0
	GOTO       L__main33
;12f675 MPPT.mpas,189 :: 		if power_curr = power_prev then begin
	MOVF       _power_curr+3, 0
	XORWF      _power_prev+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main59
	MOVF       _power_curr+2, 0
	XORWF      _power_prev+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main59
	MOVF       _power_curr+1, 0
	XORWF      _power_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main59
	MOVF       _power_curr+0, 0
	XORWF      _power_prev+0, 0
L__main59:
	BTFSS      STATUS+0, 2
	GOTO       L__main36
;12f675 MPPT.mpas,190 :: 		LED1_tm:=125;
	MOVLW      125
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,191 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
;12f675 MPPT.mpas,192 :: 		end else if power_curr > power_prev then begin
L__main36:
	MOVF       _power_curr+3, 0
	SUBWF      _power_prev+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVF       _power_curr+2, 0
	SUBWF      _power_prev+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVF       _power_curr+1, 0
	SUBWF      _power_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVF       _power_curr+0, 0
	SUBWF      _power_prev+0, 0
L__main60:
	BTFSC      STATUS+0, 0
	GOTO       L__main39
;12f675 MPPT.mpas,193 :: 		LED1_tm:=100;
	MOVLW      100
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,194 :: 		end else begin
	GOTO       L__main40
L__main39:
;12f675 MPPT.mpas,195 :: 		LED1_tm:=75;
	MOVLW      75
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,196 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;12f675 MPPT.mpas,197 :: 		end;
L__main40:
;12f675 MPPT.mpas,198 :: 		if (adc_vol+vol_prev2+1) div 2 < vol_prev1 then
	MOVF       _vol_prev2+0, 0
	ADDWF      _adc_vol+0, 0
	MOVWF      R0+0
	MOVF       _adc_vol+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _vol_prev2+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      1
	MOVWF      R3+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      R3+1
	MOVF       R3+0, 0
	MOVWF      R1+0
	MOVF       R3+1, 0
	MOVWF      R1+1
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	MOVF       _vol_prev1+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main61
	MOVF       _vol_prev1+0, 0
	SUBWF      R1+0, 0
L__main61:
	BTFSC      STATUS+0, 0
	GOTO       L__main42
;12f675 MPPT.mpas,199 :: 		flag_inc:=true;
	MOVLW      255
	MOVWF      _flag_inc+0
L__main42:
;12f675 MPPT.mpas,200 :: 		end else begin
	GOTO       L__main34
L__main33:
;12f675 MPPT.mpas,201 :: 		LED1_tm:=75;
	MOVLW      75
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,202 :: 		VOL_PWM:=PWM_MID;
	MOVLW      111
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,203 :: 		flag_inc:=false;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,204 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;12f675 MPPT.mpas,205 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,206 :: 		power_flag:=0;
	CLRF       _power_flag+0
;12f675 MPPT.mpas,207 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
;12f675 MPPT.mpas,208 :: 		end;
L__main34:
;12f675 MPPT.mpas,211 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main45
;12f675 MPPT.mpas,212 :: 		if VOL_PWM<PWM_MAX then
	MOVLW      200
	SUBWF      _VOL_PWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main48
;12f675 MPPT.mpas,213 :: 		Inc(VOL_PWM)
	INCF       _VOL_PWM+0, 1
	GOTO       L__main49
;12f675 MPPT.mpas,214 :: 		else begin
L__main48:
;12f675 MPPT.mpas,215 :: 		VOL_PWM:=PWM_MAX;
	MOVLW      200
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,216 :: 		flag_inc:=false;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,217 :: 		end;
L__main49:
;12f675 MPPT.mpas,218 :: 		end else begin
	GOTO       L__main46
L__main45:
;12f675 MPPT.mpas,219 :: 		if VOL_PWM>PWM_MIN then
	MOVF       _VOL_PWM+0, 0
	SUBLW      2
	BTFSC      STATUS+0, 0
	GOTO       L__main51
;12f675 MPPT.mpas,220 :: 		Dec(VOL_PWM)
	DECF       _VOL_PWM+0, 1
	GOTO       L__main52
;12f675 MPPT.mpas,221 :: 		else begin
L__main51:
;12f675 MPPT.mpas,222 :: 		VOL_PWM:=PWM_MIN;
	MOVLW      2
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,223 :: 		flag_inc:=true;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,224 :: 		end;
L__main52:
;12f675 MPPT.mpas,225 :: 		end;
L__main46:
;12f675 MPPT.mpas,226 :: 		CONTLOOP:
L__main_CONTLOOP:
;12f675 MPPT.mpas,227 :: 		end;
	GOTO       L__main14
;12f675 MPPT.mpas,228 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main

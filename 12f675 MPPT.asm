
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;12f675 MPPT.mpas,60 :: 		begin
;12f675 MPPT.mpas,61 :: 		if T0IF_bit=1 then begin
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L__Interrupt2
;12f675 MPPT.mpas,62 :: 		if PWM_FLAG=1 then begin
	BTFSS      _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
	GOTO       L__Interrupt5
;12f675 MPPT.mpas,63 :: 		ON_PWM:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _ON_PWM+0
;12f675 MPPT.mpas,65 :: 		TMR0:=255-ON_PWM;
	MOVF       _VOL_PWM+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;12f675 MPPT.mpas,66 :: 		PWM_SIG:=0;
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,67 :: 		PWM_FLAG:=0;
	BCF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,68 :: 		end else begin
	GOTO       L__Interrupt6
L__Interrupt5:
;12f675 MPPT.mpas,70 :: 		TMR0:=255-PWM_MAX+ON_PWM;
	MOVF       _ON_PWM+0, 0
	MOVWF      TMR0+0
;12f675 MPPT.mpas,71 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,72 :: 		PWM_FLAG:=1;
	BSF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,73 :: 		end;
L__Interrupt6:
;12f675 MPPT.mpas,74 :: 		T0IF_bit:=0;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;12f675 MPPT.mpas,75 :: 		end;
L__Interrupt2:
;12f675 MPPT.mpas,76 :: 		end;
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

_main:

;12f675 MPPT.mpas,78 :: 		begin
;12f675 MPPT.mpas,79 :: 		CMCON:=7;
	MOVLW      7
	MOVWF      CMCON+0
;12f675 MPPT.mpas,80 :: 		ANSEL:=%00111100;       // ADC conversion clock = fRC, AN3, AN2;
	MOVLW      60
	MOVWF      ANSEL+0
;12f675 MPPT.mpas,82 :: 		TRISIO0_bit:=0;      // PWM
	BCF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;12f675 MPPT.mpas,83 :: 		TRISIO1_bit:=1;      // not Connected
	BSF        TRISIO1_bit+0, BitPos(TRISIO1_bit+0)
;12f675 MPPT.mpas,84 :: 		TRISIO2_bit:=1;      // AN2
	BSF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;12f675 MPPT.mpas,85 :: 		TRISIO4_bit:=1;      // AN3
	BSF        TRISIO4_bit+0, BitPos(TRISIO4_bit+0)
;12f675 MPPT.mpas,86 :: 		TRISIO5_bit:=0;      // LED
	BCF        TRISIO5_bit+0, BitPos(TRISIO5_bit+0)
;12f675 MPPT.mpas,88 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,89 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,90 :: 		PWM_FLAG:=1;
	BSF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,91 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,92 :: 		ON_PWM:=0;
	CLRF       _ON_PWM+0
;12f675 MPPT.mpas,93 :: 		VOL_PWM:=0;
	CLRF       _VOL_PWM+0
;12f675 MPPT.mpas,94 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;12f675 MPPT.mpas,95 :: 		VCFG_bit:=1;
	BSF        VCFG_bit+0, BitPos(VCFG_bit+0)
;12f675 MPPT.mpas,96 :: 		CHS1_bit:=1;
	BSF        CHS1_bit+0, BitPos(CHS1_bit+0)
;12f675 MPPT.mpas,97 :: 		ADFM_bit:=1;
	BSF        ADFM_bit+0, BitPos(ADFM_bit+0)
;12f675 MPPT.mpas,99 :: 		OPTION_REG:=%01011111;        // ~4KHz @ 4MHz
	MOVLW      95
	MOVWF      OPTION_REG+0
;12f675 MPPT.mpas,100 :: 		TMR0IE_bit:=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;12f675 MPPT.mpas,102 :: 		LM358_diff:=cLM358_diff;
	MOVLW      4
	MOVWF      _LM358_diff+0
;12f675 MPPT.mpas,104 :: 		if Write_OPAMP=0 then begin
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L__main9
;12f675 MPPT.mpas,105 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,106 :: 		adc_cur:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,107 :: 		EEPROM_Write(0, Lo(adc_cur));
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _adc_cur+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;12f675 MPPT.mpas,108 :: 		end;
L__main9:
;12f675 MPPT.mpas,112 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,113 :: 		LM358_diff:=EEPROM_Read(0);
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _LM358_diff+0
;12f675 MPPT.mpas,116 :: 		IncPWM_EQ:=0;
	CLRF       _IncPWM_EQ+0
;12f675 MPPT.mpas,117 :: 		IncPWM_EQ:=EEPROM_Read(3);
	MOVLW      3
	MOVWF      FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _IncPWM_EQ+0
;12f675 MPPT.mpas,119 :: 		T1CKPS0_bit:=1;               // timer prescaler 1:2
	BSF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;12f675 MPPT.mpas,120 :: 		TMR1CS_bit:=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;12f675 MPPT.mpas,121 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,122 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,124 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,125 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,126 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;12f675 MPPT.mpas,127 :: 		vol1:=0;
	CLRF       _vol1+0
;12f675 MPPT.mpas,128 :: 		vol2:=0;
	CLRF       _vol2+0
;12f675 MPPT.mpas,130 :: 		GIE_bit:=1;                   // enable Interrupt
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;12f675 MPPT.mpas,132 :: 		TMR1ON_bit:=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;12f675 MPPT.mpas,134 :: 		VOL_PWM:=PWM_LOW;
	MOVLW      1
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,135 :: 		lo_PWM:=PWM_LOW;
	MOVLW      1
	MOVWF      _lo_PWM+0
;12f675 MPPT.mpas,136 :: 		hi_PWM:=PWM_MAX;
	MOVLW      255
	MOVWF      _hi_PWM+0
;12f675 MPPT.mpas,137 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,138 :: 		adc_prev:=0;
	CLRF       _adc_prev+0
	CLRF       _adc_prev+1
;12f675 MPPT.mpas,140 :: 		while True do begin
L__main12:
;12f675 MPPT.mpas,142 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__main17
;12f675 MPPT.mpas,143 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,144 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,145 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,146 :: 		Inc(TICK_1000);
	INCF       _TICK_1000+0, 1
;12f675 MPPT.mpas,147 :: 		if TICK_1000>=LED1_tm then begin
	MOVF       _LED1_tm+0, 0
	SUBWF      _TICK_1000+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main20
;12f675 MPPT.mpas,148 :: 		LED1:=not LED1;
	MOVLW
	XORWF      GP5_bit+0, 1
;12f675 MPPT.mpas,149 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;12f675 MPPT.mpas,150 :: 		end;
L__main20:
;12f675 MPPT.mpas,151 :: 		end;
L__main17:
;12f675 MPPT.mpas,152 :: 		if (VOL_PWM>=(PWM_MAX-1)) then
	MOVLW      254
	SUBWF      _VOL_PWM+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main23
;12f675 MPPT.mpas,153 :: 		LED1_tm:=64
	MOVLW      64
	MOVWF      _LED1_tm+0
	GOTO       L__main24
;12f675 MPPT.mpas,154 :: 		else if (VOL_PWM<=lo_PWM) then
L__main23:
	MOVF       _VOL_PWM+0, 0
	SUBWF      _lo_PWM+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main26
;12f675 MPPT.mpas,155 :: 		LED1_tm:=90
	MOVLW      90
	MOVWF      _LED1_tm+0
	GOTO       L__main27
;12f675 MPPT.mpas,156 :: 		else
L__main26:
;12f675 MPPT.mpas,157 :: 		LED1_tm:=120;
	MOVLW      120
	MOVWF      _LED1_tm+0
L__main27:
L__main24:
;12f675 MPPT.mpas,159 :: 		power_prev:=power_curr;
	MOVF       _power_curr+0, 0
	MOVWF      _power_prev+0
	MOVF       _power_curr+1, 0
	MOVWF      _power_prev+1
	MOVF       _power_curr+2, 0
	MOVWF      _power_prev+2
	MOVF       _power_curr+3, 0
	MOVWF      _power_prev+3
;12f675 MPPT.mpas,160 :: 		adc_prev:=adc_cur;
	MOVF       _adc_cur+0, 0
	MOVWF      _adc_prev+0
	MOVF       _adc_cur+1, 0
	MOVWF      _adc_prev+1
;12f675 MPPT.mpas,162 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,163 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,164 :: 		for i:=0 to adc_max_loop-1 do begin
	CLRF       _i+0
L__main29:
;12f675 MPPT.mpas,165 :: 		adc_cur:=adc_cur+ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      _adc_cur+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_cur+1, 1
;12f675 MPPT.mpas,166 :: 		adc_vol:=adc_vol+ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      _adc_vol+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_vol+1, 1
;12f675 MPPT.mpas,167 :: 		end;
	MOVF       _i+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main32
	INCF       _i+0, 1
	GOTO       L__main29
L__main32:
;12f675 MPPT.mpas,168 :: 		adc_vol:=adc_vol div adc_max_loop;
;12f675 MPPT.mpas,169 :: 		adc_cur:=adc_cur div adc_max_loop;
;12f675 MPPT.mpas,171 :: 		if adc_cur>LM358_diff then
	MOVF       _adc_cur+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main72
	MOVF       _adc_cur+0, 0
	SUBWF      _LM358_diff+0, 0
L__main72:
	BTFSC      STATUS+0, 0
	GOTO       L__main34
;12f675 MPPT.mpas,172 :: 		adc_cur:=adc_cur-LM358_diff
	MOVF       _LM358_diff+0, 0
	SUBWF      _adc_cur+0, 1
	BTFSS      STATUS+0, 0
	DECF       _adc_cur+1, 1
	GOTO       L__main35
;12f675 MPPT.mpas,173 :: 		else
L__main34:
;12f675 MPPT.mpas,174 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
L__main35:
;12f675 MPPT.mpas,176 :: 		if (adc_cur>0) then begin
	MOVF       _adc_cur+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _adc_cur+0, 0
	SUBLW      0
L__main73:
	BTFSC      STATUS+0, 0
	GOTO       L__main37
;12f675 MPPT.mpas,177 :: 		if lo_PWM=0 then
	MOVF       _lo_PWM+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
;12f675 MPPT.mpas,178 :: 		lo_PWM:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _lo_PWM+0
L__main40:
;12f675 MPPT.mpas,179 :: 		power_curr:= adc_cur * adc_vol;
	MOVF       _adc_cur+0, 0
	MOVWF      R0+0
	MOVF       _adc_cur+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       _adc_vol+0, 0
	MOVWF      R4+0
	MOVF       _adc_vol+1, 0
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
;12f675 MPPT.mpas,180 :: 		if (vol1<>0) and (power_curr=power_prev) then begin
	MOVF       _vol1+0, 0
	XORLW      0
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R5+0
	MOVF       R0+3, 0
	XORWF      _power_prev+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       R0+2, 0
	XORWF      _power_prev+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       R0+1, 0
	XORWF      _power_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       R0+0, 0
	XORWF      _power_prev+0, 0
L__main74:
	MOVLW      255
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R4+0
	MOVF       R4+0, 0
	ANDWF      R5+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L__main43
;12f675 MPPT.mpas,185 :: 		if adc_cur>adc_prev then begin
	MOVF       _adc_cur+1, 0
	SUBWF      _adc_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main75
	MOVF       _adc_cur+0, 0
	SUBWF      _adc_prev+0, 0
L__main75:
	BTFSC      STATUS+0, 0
	GOTO       L__main46
;12f675 MPPT.mpas,186 :: 		flag_inc:=False;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,187 :: 		Inc_pwm:=IncPWM_EQ;
	MOVF       _IncPWM_EQ+0, 0
	MOVWF      _Inc_pwm+0
;12f675 MPPT.mpas,188 :: 		end else
	GOTO       L__main47
L__main46:
;12f675 MPPT.mpas,189 :: 		if adc_cur<adc_prev then begin
	MOVF       _adc_prev+1, 0
	SUBWF      _adc_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main76
	MOVF       _adc_prev+0, 0
	SUBWF      _adc_cur+0, 0
L__main76:
	BTFSC      STATUS+0, 0
	GOTO       L__main49
;12f675 MPPT.mpas,190 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,191 :: 		Inc_pwm:=IncPWM_EQ;
	MOVF       _IncPWM_EQ+0, 0
	MOVWF      _Inc_pwm+0
;12f675 MPPT.mpas,192 :: 		end else begin
	GOTO       L__main50
L__main49:
;12f675 MPPT.mpas,193 :: 		Inc_pwm:=0;
	CLRF       _Inc_pwm+0
;12f675 MPPT.mpas,194 :: 		LED1_tm:=240;
	MOVLW      240
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,195 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;12f675 MPPT.mpas,196 :: 		end;
L__main50:
L__main47:
;12f675 MPPT.mpas,197 :: 		vol2:=0;
	CLRF       _vol2+0
;12f675 MPPT.mpas,198 :: 		end else begin
	GOTO       L__main44
L__main43:
;12f675 MPPT.mpas,199 :: 		if Inc_pwm<Inc_Pwm_Max then
	MOVLW      11
	SUBWF      _Inc_pwm+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main52
;12f675 MPPT.mpas,200 :: 		Inc(Inc_pwm);
	INCF       _Inc_pwm+0, 1
L__main52:
;12f675 MPPT.mpas,201 :: 		if power_curr<power_prev then begin
	MOVF       _power_prev+3, 0
	SUBWF      _power_curr+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _power_prev+2, 0
	SUBWF      _power_curr+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _power_prev+1, 0
	SUBWF      _power_curr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _power_prev+0, 0
	SUBWF      _power_curr+0, 0
L__main77:
	BTFSC      STATUS+0, 0
	GOTO       L__main55
;12f675 MPPT.mpas,206 :: 		vol1:=vol2;
	MOVF       _vol2+0, 0
	MOVWF      _vol1+0
;12f675 MPPT.mpas,207 :: 		vol2:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _vol2+0
;12f675 MPPT.mpas,208 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;12f675 MPPT.mpas,210 :: 		if (vol1<>0) and (vol2<>0) then begin
	MOVF       _vol1+0, 0
	XORLW      0
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _VOL_PWM+0, 0
	XORLW      0
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main58
;12f675 MPPT.mpas,211 :: 		Inc_pwm:=0;
	CLRF       _Inc_pwm+0
;12f675 MPPT.mpas,212 :: 		wPWM:=vol1;
	MOVF       _vol1+0, 0
	MOVWF      _wPWM+0
	CLRF       _wPWM+1
;12f675 MPPT.mpas,213 :: 		wPWM:=(wPWM+vol2) div 2;
	MOVF       _vol2+0, 0
	ADDWF      _wPWM+0, 1
	BTFSC      STATUS+0, 0
	INCF       _wPWM+1, 1
	RRF        _wPWM+1, 1
	RRF        _wPWM+0, 1
	BCF        _wPWM+1, 7
;12f675 MPPT.mpas,214 :: 		VOL_PWM:=lo(wPWM);
	MOVF       _wPWM+0, 0
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,215 :: 		vol2:=0;
	CLRF       _vol2+0
;12f675 MPPT.mpas,217 :: 		wPWM:=VOL_PWM;
	MOVLW      0
	MOVWF      _wPWM+1
;12f675 MPPT.mpas,218 :: 		wPWM:=wPWM+(PWM_MAX-VOL_PWM) div 8;
	MOVF       _VOL_PWM+0, 0
	SUBLW      255
	MOVWF      R3+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R3+1
	SUBWF      R3+1, 1
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	ADDWF      _wPWM+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _wPWM+1, 1
;12f675 MPPT.mpas,219 :: 		hi_PWM:=lo(wPWM);
	MOVF       _wPWM+0, 0
	MOVWF      _hi_PWM+0
;12f675 MPPT.mpas,221 :: 		wPWM:=VOL_PWM-(VOL_PWM div 14);
	MOVLW      14
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       _VOL_PWM+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	SUBWF      _VOL_PWM+0, 0
	MOVWF      _wPWM+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       _wPWM+1
	SUBWF      _wPWM+1, 1
;12f675 MPPT.mpas,222 :: 		lo_PWM:=lo(wPWM);
	MOVF       _wPWM+0, 0
	MOVWF      _lo_PWM+0
;12f675 MPPT.mpas,223 :: 		continue;
	GOTO       L__main12
;12f675 MPPT.mpas,224 :: 		end;
L__main58:
;12f675 MPPT.mpas,225 :: 		end;
L__main55:
;12f675 MPPT.mpas,226 :: 		end;
L__main44:
;12f675 MPPT.mpas,227 :: 		end else begin
	GOTO       L__main38
L__main37:
;12f675 MPPT.mpas,229 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;12f675 MPPT.mpas,230 :: 		Inc_pwm:=Inc_Pwm_Max;
	MOVLW      11
	MOVWF      _Inc_pwm+0
;12f675 MPPT.mpas,231 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,232 :: 		vol2:=0;
	CLRF       _vol2+0
;12f675 MPPT.mpas,233 :: 		lo_PWM:=0;
	CLRF       _lo_PWM+0
;12f675 MPPT.mpas,234 :: 		hi_PWM:=PWM_MAX;
	MOVLW      255
	MOVWF      _hi_PWM+0
;12f675 MPPT.mpas,235 :: 		end;
L__main38:
;12f675 MPPT.mpas,237 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main61
;12f675 MPPT.mpas,238 :: 		if VOL_PWM<(hi_PWM-Inc_pwm) then begin
	MOVF       _Inc_pwm+0, 0
	SUBWF      _hi_PWM+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	SUBWF      _VOL_PWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main64
;12f675 MPPT.mpas,239 :: 		VOL_PWM:=VOL_PWM+Inc_pwm;
	MOVF       _Inc_pwm+0, 0
	ADDWF      _VOL_PWM+0, 1
;12f675 MPPT.mpas,240 :: 		end else
	GOTO       L__main65
L__main64:
;12f675 MPPT.mpas,241 :: 		VOL_PWM:=hi_PWM;
	MOVF       _hi_PWM+0, 0
	MOVWF      _VOL_PWM+0
L__main65:
;12f675 MPPT.mpas,242 :: 		end else begin
	GOTO       L__main62
L__main61:
;12f675 MPPT.mpas,243 :: 		if VOL_PWM>(lo_PWM+(Inc_Pwm_Max+1-Inc_pwm)) then begin
	MOVF       _Inc_pwm+0, 0
	SUBLW      12
	MOVWF      R0+0
	MOVF       R0+0, 0
	ADDWF      _lo_PWM+0, 0
	MOVWF      R1+0
	MOVF       _VOL_PWM+0, 0
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main67
;12f675 MPPT.mpas,244 :: 		VOL_PWM:=VOL_PWM-(Inc_Pwm_Max+1-Inc_pwm);
	MOVF       _Inc_pwm+0, 0
	SUBLW      12
	MOVWF      R0+0
	MOVF       R0+0, 0
	SUBWF      _VOL_PWM+0, 1
;12f675 MPPT.mpas,245 :: 		end else
	GOTO       L__main68
L__main67:
;12f675 MPPT.mpas,246 :: 		VOL_PWM:=lo_PWM;
	MOVF       _lo_PWM+0, 0
	MOVWF      _VOL_PWM+0
L__main68:
;12f675 MPPT.mpas,247 :: 		end;
L__main62:
;12f675 MPPT.mpas,248 :: 		end;
	GOTO       L__main12
;12f675 MPPT.mpas,249 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main

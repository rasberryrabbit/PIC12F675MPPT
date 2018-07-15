
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;12f675 MPPT.mpas,68 :: 		begin
;12f675 MPPT.mpas,69 :: 		if T0IF_bit=1 then begin
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L__Interrupt2
;12f675 MPPT.mpas,70 :: 		if PWM_FLAG=1 then begin
	BTFSS      _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
	GOTO       L__Interrupt5
;12f675 MPPT.mpas,71 :: 		ON_PWM:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _ON_PWM+0
;12f675 MPPT.mpas,73 :: 		TMR0:=255-ON_PWM;
	MOVF       _VOL_PWM+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;12f675 MPPT.mpas,74 :: 		PWM_SIG:=0;
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,75 :: 		PWM_FLAG:=0;
	BCF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,76 :: 		end else begin
	GOTO       L__Interrupt6
L__Interrupt5:
;12f675 MPPT.mpas,78 :: 		TMR0:=255-PWM_MAX+ON_PWM;
	MOVF       _ON_PWM+0, 0
	MOVWF      TMR0+0
;12f675 MPPT.mpas,79 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,80 :: 		PWM_FLAG:=1;
	BSF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,81 :: 		end;
L__Interrupt6:
;12f675 MPPT.mpas,82 :: 		T0IF_bit:=0;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;12f675 MPPT.mpas,83 :: 		end;
L__Interrupt2:
;12f675 MPPT.mpas,84 :: 		end;
L_end_Interrupt:
L__Interrupt82:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;12f675 MPPT.mpas,86 :: 		begin
;12f675 MPPT.mpas,87 :: 		CMCON:=7;
	MOVLW      7
	MOVWF      CMCON+0
;12f675 MPPT.mpas,88 :: 		ANSEL:=%00111100;       // ADC conversion clock = fRC, AN3, AN2;
	MOVLW      60
	MOVWF      ANSEL+0
;12f675 MPPT.mpas,90 :: 		TRISIO0_bit:=0;      // PWM
	BCF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;12f675 MPPT.mpas,91 :: 		TRISIO1_bit:=1;      // not Connected
	BSF        TRISIO1_bit+0, BitPos(TRISIO1_bit+0)
;12f675 MPPT.mpas,92 :: 		TRISIO2_bit:=1;      // AN2
	BSF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;12f675 MPPT.mpas,93 :: 		TRISIO4_bit:=1;      // AN3
	BSF        TRISIO4_bit+0, BitPos(TRISIO4_bit+0)
;12f675 MPPT.mpas,94 :: 		TRISIO5_bit:=0;      // LED
	BCF        TRISIO5_bit+0, BitPos(TRISIO5_bit+0)
;12f675 MPPT.mpas,96 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,97 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,98 :: 		PWM_FLAG:=1;
	BSF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,99 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,100 :: 		ON_PWM:=0;
	CLRF       _ON_PWM+0
;12f675 MPPT.mpas,101 :: 		VOL_PWM:=0;
	CLRF       _VOL_PWM+0
;12f675 MPPT.mpas,102 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;12f675 MPPT.mpas,103 :: 		VCFG_bit:=1;
	BSF        VCFG_bit+0, BitPos(VCFG_bit+0)
;12f675 MPPT.mpas,104 :: 		CHS1_bit:=1;
	BSF        CHS1_bit+0, BitPos(CHS1_bit+0)
;12f675 MPPT.mpas,105 :: 		ADFM_bit:=1;
	BSF        ADFM_bit+0, BitPos(ADFM_bit+0)
;12f675 MPPT.mpas,107 :: 		OPTION_REG:=%01011111;        // ~4KHz @ 4MHz
	MOVLW      95
	MOVWF      OPTION_REG+0
;12f675 MPPT.mpas,108 :: 		TMR0IE_bit:=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;12f675 MPPT.mpas,110 :: 		LM358_diff:=cLM358_diff;
	MOVLW      4
	MOVWF      _LM358_diff+0
;12f675 MPPT.mpas,112 :: 		if Write_OPAMP=0 then begin
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L__main9
;12f675 MPPT.mpas,113 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,114 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,115 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,116 :: 		adc_cur:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,117 :: 		EEPROM_Write(0, Lo(adc_cur));
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _adc_cur+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;12f675 MPPT.mpas,118 :: 		end;
L__main9:
;12f675 MPPT.mpas,122 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,123 :: 		LM358_diff:=EEPROM_Read(0);
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _LM358_diff+0
;12f675 MPPT.mpas,126 :: 		IncPWM_EQ:=0;
	CLRF       _IncPWM_EQ+0
;12f675 MPPT.mpas,127 :: 		IncPWM_EQ:=EEPROM_Read(3);
	MOVLW      3
	MOVWF      FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _IncPWM_EQ+0
;12f675 MPPT.mpas,129 :: 		T1CKPS0_bit:=1;               // timer prescaler 1:2
	BSF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;12f675 MPPT.mpas,130 :: 		TMR1CS_bit:=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;12f675 MPPT.mpas,131 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,132 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,134 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,135 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,136 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;12f675 MPPT.mpas,137 :: 		vol1:=0;
	CLRF       _vol1+0
;12f675 MPPT.mpas,138 :: 		vol2:=0;
	CLRF       _vol2+0
;12f675 MPPT.mpas,139 :: 		Reset_Tick100:=100;
	MOVLW      100
	MOVWF      _Reset_Tick100+0
;12f675 MPPT.mpas,140 :: 		Reset_Tick:=Reset_Tick_Start;
	MOVLW      220
	MOVWF      _Reset_Tick+0
	MOVLW      5
	MOVWF      _Reset_Tick+1
;12f675 MPPT.mpas,142 :: 		GIE_bit:=1;                   // enable Interrupt
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;12f675 MPPT.mpas,144 :: 		TMR1ON_bit:=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;12f675 MPPT.mpas,146 :: 		VOL_PWM:=PWM_LOW;
	MOVLW      1
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,147 :: 		lo_PWM:=PWM_LOW;
	MOVLW      1
	MOVWF      _lo_PWM+0
;12f675 MPPT.mpas,148 :: 		hi_PWM:=PWM_MAX;
	MOVLW      255
	MOVWF      _hi_PWM+0
;12f675 MPPT.mpas,149 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,150 :: 		adc_prev:=0;
	CLRF       _adc_prev+0
	CLRF       _adc_prev+1
;12f675 MPPT.mpas,152 :: 		while True do begin
L__main12:
;12f675 MPPT.mpas,154 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__main17
;12f675 MPPT.mpas,155 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,156 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,157 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,158 :: 		Inc(TICK_1000);
	INCF       _TICK_1000+0, 1
;12f675 MPPT.mpas,159 :: 		if TICK_1000>=LED1_tm then begin
	MOVF       _LED1_tm+0, 0
	SUBWF      _TICK_1000+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main20
;12f675 MPPT.mpas,160 :: 		LED1:=not LED1;
	MOVLW
	XORWF      GP5_bit+0, 1
;12f675 MPPT.mpas,161 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;12f675 MPPT.mpas,162 :: 		end;
L__main20:
;12f675 MPPT.mpas,185 :: 		end;
L__main17:
;12f675 MPPT.mpas,186 :: 		if (VOL_PWM>=(PWM_MAX-1)) then
	MOVLW      254
	SUBWF      _VOL_PWM+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main23
;12f675 MPPT.mpas,187 :: 		LED1_tm:=64
	MOVLW      64
	MOVWF      _LED1_tm+0
	GOTO       L__main24
;12f675 MPPT.mpas,188 :: 		else if (VOL_PWM<=lo_PWM) then
L__main23:
	MOVF       _VOL_PWM+0, 0
	SUBWF      _lo_PWM+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main26
;12f675 MPPT.mpas,189 :: 		LED1_tm:=90
	MOVLW      90
	MOVWF      _LED1_tm+0
	GOTO       L__main27
;12f675 MPPT.mpas,190 :: 		else
L__main26:
;12f675 MPPT.mpas,191 :: 		LED1_tm:=120;
	MOVLW      120
	MOVWF      _LED1_tm+0
L__main27:
L__main24:
;12f675 MPPT.mpas,193 :: 		power_prev:=power_curr;
	MOVF       _power_curr+0, 0
	MOVWF      _power_prev+0
	MOVF       _power_curr+1, 0
	MOVWF      _power_prev+1
	MOVF       _power_curr+2, 0
	MOVWF      _power_prev+2
	MOVF       _power_curr+3, 0
	MOVWF      _power_prev+3
;12f675 MPPT.mpas,194 :: 		adc_prev:=adc_cur;
	MOVF       _adc_cur+0, 0
	MOVWF      _adc_prev+0
	MOVF       _adc_cur+1, 0
	MOVWF      _adc_prev+1
;12f675 MPPT.mpas,196 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,197 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,198 :: 		for i:=0 to adc_max_loop-1 do begin
	CLRF       _i+0
L__main29:
;12f675 MPPT.mpas,199 :: 		adc_cur:=adc_cur+ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      _adc_cur+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_cur+1, 1
;12f675 MPPT.mpas,200 :: 		adc_vol:=adc_vol+ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      _adc_vol+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_vol+1, 1
;12f675 MPPT.mpas,201 :: 		end;
	MOVF       _i+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main32
	INCF       _i+0, 1
	GOTO       L__main29
L__main32:
;12f675 MPPT.mpas,202 :: 		adc_vol:=adc_vol div adc_max_loop;
;12f675 MPPT.mpas,203 :: 		adc_cur:=adc_cur div adc_max_loop;
;12f675 MPPT.mpas,205 :: 		if adc_cur>word(LM358_diff) then
	MOVF       _LM358_diff+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	MOVF       _adc_cur+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main84
	MOVF       _adc_cur+0, 0
	SUBWF      R1+0, 0
L__main84:
	BTFSC      STATUS+0, 0
	GOTO       L__main34
;12f675 MPPT.mpas,206 :: 		adc_cur:=adc_cur-word(LM358_diff)
	MOVF       _LM358_diff+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	SUBWF      _adc_cur+0, 1
	BTFSS      STATUS+0, 0
	DECF       _adc_cur+1, 1
	MOVF       R0+1, 0
	SUBWF      _adc_cur+1, 1
	GOTO       L__main35
;12f675 MPPT.mpas,207 :: 		else
L__main34:
;12f675 MPPT.mpas,208 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
L__main35:
;12f675 MPPT.mpas,210 :: 		if (adc_cur>0) then begin
	MOVF       _adc_cur+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main85
	MOVF       _adc_cur+0, 0
	SUBLW      0
L__main85:
	BTFSC      STATUS+0, 0
	GOTO       L__main37
;12f675 MPPT.mpas,211 :: 		if lo_PWM=0 then
	MOVF       _lo_PWM+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
;12f675 MPPT.mpas,212 :: 		lo_PWM:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _lo_PWM+0
L__main40:
;12f675 MPPT.mpas,213 :: 		power_curr:= adc_cur * adc_vol;
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
;12f675 MPPT.mpas,214 :: 		if power_curr=power_prev then begin
	MOVF       R0+3, 0
	XORWF      _power_prev+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main86
	MOVF       R0+2, 0
	XORWF      _power_prev+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main86
	MOVF       R0+1, 0
	XORWF      _power_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main86
	MOVF       R0+0, 0
	XORWF      _power_prev+0, 0
L__main86:
	BTFSS      STATUS+0, 2
	GOTO       L__main43
;12f675 MPPT.mpas,215 :: 		Inc_pwm:=0;
	CLRF       _Inc_pwm+0
;12f675 MPPT.mpas,216 :: 		if adc_cur>adc_prev then begin
	MOVF       _adc_cur+1, 0
	SUBWF      _adc_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main87
	MOVF       _adc_cur+0, 0
	SUBWF      _adc_prev+0, 0
L__main87:
	BTFSC      STATUS+0, 0
	GOTO       L__main46
;12f675 MPPT.mpas,217 :: 		flag_inc:=False;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,218 :: 		end else
	GOTO       L__main47
L__main46:
;12f675 MPPT.mpas,219 :: 		if adc_cur<adc_prev then begin
	MOVF       _adc_prev+1, 0
	SUBWF      _adc_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main88
	MOVF       _adc_prev+0, 0
	SUBWF      _adc_cur+0, 0
L__main88:
	BTFSC      STATUS+0, 0
	GOTO       L__main49
;12f675 MPPT.mpas,220 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,221 :: 		end else begin
	GOTO       L__main50
L__main49:
;12f675 MPPT.mpas,222 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;12f675 MPPT.mpas,223 :: 		end;
L__main50:
L__main47:
;12f675 MPPT.mpas,224 :: 		vol2:=0;
	CLRF       _vol2+0
;12f675 MPPT.mpas,225 :: 		LED1_tm:=240;
	MOVLW      240
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,226 :: 		continue;
	GOTO       L__main12
;12f675 MPPT.mpas,227 :: 		end else begin
L__main43:
;12f675 MPPT.mpas,228 :: 		if Inc_pwm<Inc_Pwm_Max then
	MOVLW      8
	SUBWF      _Inc_pwm+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main52
;12f675 MPPT.mpas,229 :: 		Inc(Inc_pwm);
	INCF       _Inc_pwm+0, 1
L__main52:
;12f675 MPPT.mpas,230 :: 		if power_curr<power_prev then begin
	MOVF       _power_prev+3, 0
	SUBWF      _power_curr+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main89
	MOVF       _power_prev+2, 0
	SUBWF      _power_curr+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main89
	MOVF       _power_prev+1, 0
	SUBWF      _power_curr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main89
	MOVF       _power_prev+0, 0
	SUBWF      _power_curr+0, 0
L__main89:
	BTFSC      STATUS+0, 0
	GOTO       L__main55
;12f675 MPPT.mpas,232 :: 		vol1:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _vol1+0
;12f675 MPPT.mpas,233 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;12f675 MPPT.mpas,235 :: 		if vol2<>0 then begin
	MOVF       _vol2+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main58
;12f675 MPPT.mpas,236 :: 		Inc_pwm:=0;
	CLRF       _Inc_pwm+0
;12f675 MPPT.mpas,237 :: 		hi(wPWM):=0;
	CLRF       _wPWM+1
;12f675 MPPT.mpas,238 :: 		lo(wPWM):=vol1;
	MOVF       _vol1+0, 0
	MOVWF      _wPWM+0
;12f675 MPPT.mpas,239 :: 		wPWM:=(wPWM+word(vol2)+1) div 2+3; { >=3 }
	MOVF       _vol2+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	ADDWF      _wPWM+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _wPWM+1, 1
	INCF       _wPWM+0, 1
	BTFSC      STATUS+0, 2
	INCF       _wPWM+1, 1
	RRF        _wPWM+1, 1
	RRF        _wPWM+0, 1
	BCF        _wPWM+1, 7
	MOVLW      3
	ADDWF      _wPWM+0, 1
	BTFSC      STATUS+0, 0
	INCF       _wPWM+1, 1
;12f675 MPPT.mpas,245 :: 		if (Hi(wPWM)<>0) or (Lo(wPWM)>PWM_MAX) then
	MOVF       _wPWM+1, 0
	XORLW      0
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _wPWM+0, 0
	SUBLW      255
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main61
;12f675 MPPT.mpas,246 :: 		wPWM:=word(PWM_MAX)
	MOVLW      255
	MOVWF      _wPWM+0
	MOVLW      0
	MOVWF      _wPWM+1
	GOTO       L__main62
;12f675 MPPT.mpas,247 :: 		else if Lo(wPWM)<PWM_LOW then
L__main61:
	MOVLW      1
	SUBWF      _wPWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main64
;12f675 MPPT.mpas,248 :: 		wPWM:=word(PWM_LOW);
	MOVLW      1
	MOVWF      _wPWM+0
	MOVLW      0
	MOVWF      _wPWM+1
L__main64:
L__main62:
;12f675 MPPT.mpas,250 :: 		VOL_PWM:=lo(wPWM);
	MOVF       _wPWM+0, 0
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,252 :: 		vol2:=0;
	CLRF       _vol2+0
;12f675 MPPT.mpas,254 :: 		wPWM:=(word(PWM_MAX-VOL_PWM)+((PWMHI_DIV+1) div 2)) div PWMHI_DIV;
	MOVF       _wPWM+0, 0
	SUBLW      255
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVLW      3
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      6
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _wPWM+0
	MOVF       R0+1, 0
	MOVWF      _wPWM+1
;12f675 MPPT.mpas,255 :: 		wPWM:=wPWM+word(VOL_PWM);
	MOVF       _VOL_PWM+0, 0
	MOVWF      R2+0
	CLRF       R2+1
	MOVF       R2+0, 0
	ADDWF      R0+0, 0
	MOVWF      _wPWM+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R2+1, 0
	MOVWF      _wPWM+1
;12f675 MPPT.mpas,256 :: 		if (Hi(wPWM)<>0) or (Lo(wPWM)>PWM_MAX) then
	MOVF       _wPWM+1, 0
	XORLW      0
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _wPWM+0, 0
	SUBLW      255
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main67
;12f675 MPPT.mpas,257 :: 		wPWM:=PWM_MAX;
	MOVLW      255
	MOVWF      _wPWM+0
	CLRF       _wPWM+1
L__main67:
;12f675 MPPT.mpas,258 :: 		hi_PWM:=lo(wPWM);
	MOVF       _wPWM+0, 0
	MOVWF      _hi_PWM+0
;12f675 MPPT.mpas,260 :: 		wPWM:=(word(VOL_PWM-PWM_LOW)+((PWMLO_DIV+1) div 2)) div PWMLO_DIV;
	MOVLW      1
	SUBWF      _VOL_PWM+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVLW      8
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      15
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _wPWM+0
	MOVF       R0+1, 0
	MOVWF      _wPWM+1
;12f675 MPPT.mpas,261 :: 		wPWM:=word(VOL_PWM)-wPWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _wPWM+0
	CLRF       _wPWM+1
	MOVF       R0+0, 0
	SUBWF      _wPWM+0, 1
	BTFSS      STATUS+0, 0
	DECF       _wPWM+1, 1
	MOVF       R0+1, 0
	SUBWF      _wPWM+1, 1
;12f675 MPPT.mpas,262 :: 		if (Hi(wPWM)<>0) or (Lo(wPWM)<PWM_LOW) then
	MOVF       _wPWM+1, 0
	XORLW      0
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVLW      1
	SUBWF      _wPWM+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main70
;12f675 MPPT.mpas,263 :: 		wPWM:=PWM_LOW;
	MOVLW      1
	MOVWF      _wPWM+0
	CLRF       _wPWM+1
L__main70:
;12f675 MPPT.mpas,264 :: 		lo_PWM:=lo(wPWM);
	MOVF       _wPWM+0, 0
	MOVWF      _lo_PWM+0
;12f675 MPPT.mpas,266 :: 		continue;
	GOTO       L__main12
;12f675 MPPT.mpas,267 :: 		end;
L__main58:
;12f675 MPPT.mpas,268 :: 		end else begin
	GOTO       L__main56
L__main55:
;12f675 MPPT.mpas,270 :: 		vol2:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _vol2+0
;12f675 MPPT.mpas,271 :: 		end;
L__main56:
;12f675 MPPT.mpas,273 :: 		end else begin
	GOTO       L__main38
L__main37:
;12f675 MPPT.mpas,275 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;12f675 MPPT.mpas,276 :: 		Inc_pwm:=Inc_Pwm_Max;
	MOVLW      8
	MOVWF      _Inc_pwm+0
;12f675 MPPT.mpas,277 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,278 :: 		vol2:=0;
	CLRF       _vol2+0
;12f675 MPPT.mpas,279 :: 		lo_PWM:=0;
	CLRF       _lo_PWM+0
;12f675 MPPT.mpas,280 :: 		hi_PWM:=PWM_MAX;
	MOVLW      255
	MOVWF      _hi_PWM+0
;12f675 MPPT.mpas,281 :: 		end;
L__main38:
;12f675 MPPT.mpas,283 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main73
;12f675 MPPT.mpas,284 :: 		if VOL_PWM<(hi_PWM-Inc_pwm) then begin
	MOVF       _Inc_pwm+0, 0
	SUBWF      _hi_PWM+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	SUBWF      _VOL_PWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main76
;12f675 MPPT.mpas,285 :: 		VOL_PWM:=VOL_PWM+Inc_pwm;
	MOVF       _Inc_pwm+0, 0
	ADDWF      _VOL_PWM+0, 1
;12f675 MPPT.mpas,286 :: 		end else
	GOTO       L__main77
L__main76:
;12f675 MPPT.mpas,287 :: 		VOL_PWM:=hi_PWM;
	MOVF       _hi_PWM+0, 0
	MOVWF      _VOL_PWM+0
L__main77:
;12f675 MPPT.mpas,288 :: 		end else begin
	GOTO       L__main74
L__main73:
;12f675 MPPT.mpas,289 :: 		if VOL_PWM>(lo_PWM+(Inc_Pwm_Max+1-Inc_pwm)) then begin
	MOVF       _Inc_pwm+0, 0
	SUBLW      9
	MOVWF      R0+0
	MOVF       R0+0, 0
	ADDWF      _lo_PWM+0, 0
	MOVWF      R1+0
	MOVF       _VOL_PWM+0, 0
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main79
;12f675 MPPT.mpas,290 :: 		VOL_PWM:=VOL_PWM-(Inc_Pwm_Max+1-Inc_pwm);
	MOVF       _Inc_pwm+0, 0
	SUBLW      9
	MOVWF      R0+0
	MOVF       R0+0, 0
	SUBWF      _VOL_PWM+0, 1
;12f675 MPPT.mpas,291 :: 		end else
	GOTO       L__main80
L__main79:
;12f675 MPPT.mpas,292 :: 		VOL_PWM:=lo_PWM;
	MOVF       _lo_PWM+0, 0
	MOVWF      _VOL_PWM+0
L__main80:
;12f675 MPPT.mpas,293 :: 		end;
L__main74:
;12f675 MPPT.mpas,294 :: 		end;
	GOTO       L__main12
;12f675 MPPT.mpas,295 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main

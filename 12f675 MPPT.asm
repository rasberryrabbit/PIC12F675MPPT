
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;12f675 MPPT.mpas,64 :: 		begin
;12f675 MPPT.mpas,65 :: 		if T0IF_bit=1 then begin
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L__Interrupt3
;12f675 MPPT.mpas,66 :: 		PWM_SIG:=not PWM_SIG;
	MOVLW
	XORWF      GP2_bit+0, 1
;12f675 MPPT.mpas,67 :: 		if PWM_SIG=0 then begin
	BTFSC      GP2_bit+0, BitPos(GP2_bit+0)
	GOTO       L__Interrupt6
;12f675 MPPT.mpas,68 :: 		doADCRead:=1;
	MOVLW      1
	MOVWF      _doADCRead+0
;12f675 MPPT.mpas,70 :: 		ON_PWM:=VOLPWM;
	MOVF       _VOLPWM+0, 0
	MOVWF      _ON_PWM+0
;12f675 MPPT.mpas,71 :: 		TMR0:=255-ON_PWM;
	MOVF       _VOLPWM+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;12f675 MPPT.mpas,72 :: 		end else begin
	GOTO       L__Interrupt7
L__Interrupt6:
;12f675 MPPT.mpas,74 :: 		TMR0:=TMR0BASE+ON_PWM;
	MOVF       _ON_PWM+0, 0
	ADDLW      55
	MOVWF      TMR0+0
;12f675 MPPT.mpas,75 :: 		end;
L__Interrupt7:
;12f675 MPPT.mpas,76 :: 		T0IF_bit:=0;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;12f675 MPPT.mpas,77 :: 		end;
L__Interrupt3:
;12f675 MPPT.mpas,78 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__Interrupt9
;12f675 MPPT.mpas,79 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,80 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,81 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,82 :: 		Inc(TICK_1000);
	INCF       _TICK_1000+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TICK_1000+1, 1
;12f675 MPPT.mpas,83 :: 		end;
L__Interrupt9:
;12f675 MPPT.mpas,84 :: 		end;
L_end_Interrupt:
L__Interrupt71:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_tick_diff:

;12f675 MPPT.mpas,87 :: 		begin
;12f675 MPPT.mpas,88 :: 		if a<b then
	MOVF       FARG_tick_diff_b+1, 0
	SUBWF      FARG_tick_diff_a+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tick_diff73
	MOVF       FARG_tick_diff_b+0, 0
	SUBWF      FARG_tick_diff_a+0, 0
L__tick_diff73:
	BTFSC      STATUS+0, 0
	GOTO       L__tick_diff13
;12f675 MPPT.mpas,89 :: 		result:=a+(65535-b)+1
	MOVF       FARG_tick_diff_b+0, 0
	SUBLW      255
	MOVWF      R0+0
	MOVF       FARG_tick_diff_b+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      255
	MOVWF      R0+1
	MOVF       FARG_tick_diff_a+0, 0
	ADDWF      R0+0, 1
	MOVF       FARG_tick_diff_a+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       R0+0, 0
	ADDLW      1
	MOVWF      R2+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      R2+1
	GOTO       L__tick_diff14
;12f675 MPPT.mpas,90 :: 		else
L__tick_diff13:
;12f675 MPPT.mpas,91 :: 		result:=a-b;
	MOVF       FARG_tick_diff_b+0, 0
	SUBWF      FARG_tick_diff_a+0, 0
	MOVWF      R2+0
	MOVF       FARG_tick_diff_b+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      FARG_tick_diff_a+1, 0
	MOVWF      R2+1
L__tick_diff14:
;12f675 MPPT.mpas,92 :: 		end;
	MOVF       R2+0, 0
	MOVWF      R0+0
	MOVF       R2+1, 0
	MOVWF      R0+1
L_end_tick_diff:
	RETURN
; end of _tick_diff

_main:

;12f675 MPPT.mpas,94 :: 		begin
;12f675 MPPT.mpas,95 :: 		CMCON:=7;
	MOVLW      7
	MOVWF      CMCON+0
;12f675 MPPT.mpas,96 :: 		ANSEL:=%00001001;       // AN3, AN0;
	MOVLW      9
	MOVWF      ANSEL+0
;12f675 MPPT.mpas,98 :: 		TRISIO0_bit:=1;         // AN0
	BSF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;12f675 MPPT.mpas,99 :: 		TRISIO1_bit:=1;         // VREF
	BSF        TRISIO1_bit+0, BitPos(TRISIO1_bit+0)
;12f675 MPPT.mpas,100 :: 		TRISIO2_bit:=0;         // PWM
	BCF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;12f675 MPPT.mpas,101 :: 		TRISIO4_bit:=1;         // AN3
	BSF        TRISIO4_bit+0, BitPos(TRISIO4_bit+0)
;12f675 MPPT.mpas,102 :: 		TRISIO5_bit:=0;         // LED
	BCF        TRISIO5_bit+0, BitPos(TRISIO5_bit+0)
;12f675 MPPT.mpas,103 :: 		VCFG_bit:=1;
	BSF        VCFG_bit+0, BitPos(VCFG_bit+0)
;12f675 MPPT.mpas,104 :: 		CHS1_bit:=1;
	BSF        CHS1_bit+0, BitPos(CHS1_bit+0)
;12f675 MPPT.mpas,105 :: 		ADFM_bit:=1;
	BSF        ADFM_bit+0, BitPos(ADFM_bit+0)
;12f675 MPPT.mpas,107 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,108 :: 		PWM_SIG:=1;
	BSF        GP2_bit+0, BitPos(GP2_bit+0)
;12f675 MPPT.mpas,109 :: 		LED1_tm:=100;
	MOVLW      100
	MOVWF      _LED1_tm+0
	CLRF       _LED1_tm+1
;12f675 MPPT.mpas,110 :: 		ON_PWM:=0;
	CLRF       _ON_PWM+0
;12f675 MPPT.mpas,111 :: 		VOLPWM:=0;
	CLRF       _VOLPWM+0
;12f675 MPPT.mpas,112 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
	CLRF       _TICK_1000+1
;12f675 MPPT.mpas,114 :: 		OPTION_REG:=%01011111;        // ~4KHz @ 4MHz
	MOVLW      95
	MOVWF      OPTION_REG+0
;12f675 MPPT.mpas,115 :: 		TMR0IE_bit:=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;12f675 MPPT.mpas,117 :: 		LM358_diff:=cLM358_diff;
	CLRF       _LM358_diff+0
;12f675 MPPT.mpas,118 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,119 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,120 :: 		ClrWDT;
	CLRWDT
;12f675 MPPT.mpas,122 :: 		if Write_OPAMP=0 then begin
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L__main17
;12f675 MPPT.mpas,123 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,124 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,125 :: 		adc_cur:=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,126 :: 		EEPROM_Write(0, Lo(adc_cur));
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _adc_cur+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;12f675 MPPT.mpas,127 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,128 :: 		LED1:=1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,129 :: 		Delay_ms(700);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      142
	MOVWF      R12+0
	MOVLW      18
	MOVWF      R13+0
L__main19:
	DECFSZ     R13+0, 1
	GOTO       L__main19
	DECFSZ     R12+0, 1
	GOTO       L__main19
	DECFSZ     R11+0, 1
	GOTO       L__main19
	NOP
;12f675 MPPT.mpas,130 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,131 :: 		end;
L__main17:
;12f675 MPPT.mpas,132 :: 		ClrWDT;
	CLRWDT
;12f675 MPPT.mpas,136 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,137 :: 		LM358_diff:=EEPROM_Read(0);
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _LM358_diff+0
;12f675 MPPT.mpas,139 :: 		if LM358_diff>$1f then
	MOVF       R0+0, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L__main21
;12f675 MPPT.mpas,140 :: 		LM358_diff:=0;
	CLRF       _LM358_diff+0
L__main21:
;12f675 MPPT.mpas,142 :: 		T1CKPS1_bit:=0;
	BCF        T1CKPS1_bit+0, BitPos(T1CKPS1_bit+0)
;12f675 MPPT.mpas,143 :: 		T1CKPS0_bit:=0;               // timer prescaler 1:1
	BCF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;12f675 MPPT.mpas,144 :: 		TMR1CS_bit:=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;12f675 MPPT.mpas,145 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,146 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,147 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,149 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,150 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,151 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;12f675 MPPT.mpas,153 :: 		TMR1IE_bit:=1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;12f675 MPPT.mpas,154 :: 		PEIE_bit:=1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;12f675 MPPT.mpas,156 :: 		GIE_bit:=1;                   // enable Interrupt
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;12f675 MPPT.mpas,158 :: 		TMR1ON_bit:=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;12f675 MPPT.mpas,160 :: 		VOLPWM:=PWM_MIN;
	MOVLW      10
	MOVWF      _VOLPWM+0
;12f675 MPPT.mpas,161 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,162 :: 		vol_prev1:=0;
	CLRF       _vol_prev1+0
	CLRF       _vol_prev1+1
;12f675 MPPT.mpas,164 :: 		powertime:=0;
	CLRF       _powertime+0
	CLRF       _powertime+1
;12f675 MPPT.mpas,165 :: 		prevtime:=0;
	CLRF       _prevtime+0
	CLRF       _prevtime+1
;12f675 MPPT.mpas,166 :: 		voltime:=0;
	CLRF       _voltime+0
	CLRF       _voltime+1
;12f675 MPPT.mpas,169 :: 		clrwdt;
	CLRWDT
;12f675 MPPT.mpas,170 :: 		delay_ms(300);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L__main23:
	DECFSZ     R13+0, 1
	GOTO       L__main23
	DECFSZ     R12+0, 1
	GOTO       L__main23
	DECFSZ     R11+0, 1
	GOTO       L__main23
;12f675 MPPT.mpas,171 :: 		LED1:=1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,172 :: 		delay_ms(300);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L__main24:
	DECFSZ     R13+0, 1
	GOTO       L__main24
	DECFSZ     R12+0, 1
	GOTO       L__main24
	DECFSZ     R11+0, 1
	GOTO       L__main24
;12f675 MPPT.mpas,173 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,174 :: 		clrwdt;
	CLRWDT
;12f675 MPPT.mpas,175 :: 		wdtimer:=0;
	CLRF       _wdtimer+0
	CLRF       _wdtimer+1
;12f675 MPPT.mpas,177 :: 		while True do begin
L__main26:
;12f675 MPPT.mpas,179 :: 		wtmp := TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wtmp+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wtmp+1
;12f675 MPPT.mpas,180 :: 		if tick_diff(wtmp, prevtime) > LED1_tm then begin
	MOVF       _TICK_1000+0, 0
	MOVWF      FARG_tick_diff_a+0
	MOVF       _TICK_1000+1, 0
	MOVWF      FARG_tick_diff_a+1
	MOVF       _prevtime+0, 0
	MOVWF      FARG_tick_diff_b+0
	MOVF       _prevtime+1, 0
	MOVWF      FARG_tick_diff_b+1
	CALL       _tick_diff+0
	MOVF       R0+1, 0
	SUBWF      _LED1_tm+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main75
	MOVF       R0+0, 0
	SUBWF      _LED1_tm+0, 0
L__main75:
	BTFSC      STATUS+0, 0
	GOTO       L__main31
;12f675 MPPT.mpas,181 :: 		prevtime := wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _prevtime+0
	MOVF       _wtmp+1, 0
	MOVWF      _prevtime+1
;12f675 MPPT.mpas,182 :: 		LED1 := not LED1;
	MOVLW
	XORWF      GP5_bit+0, 1
;12f675 MPPT.mpas,183 :: 		end;
L__main31:
;12f675 MPPT.mpas,185 :: 		wtmp := TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wtmp+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wtmp+1
;12f675 MPPT.mpas,186 :: 		if tick_diff(wtmp, wdtimer)>1000 then begin
	MOVF       _TICK_1000+0, 0
	MOVWF      FARG_tick_diff_a+0
	MOVF       _TICK_1000+1, 0
	MOVWF      FARG_tick_diff_a+1
	MOVF       _wdtimer+0, 0
	MOVWF      FARG_tick_diff_b+0
	MOVF       _wdtimer+1, 0
	MOVWF      FARG_tick_diff_b+1
	CALL       _tick_diff+0
	MOVF       R0+1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__main76
	MOVF       R0+0, 0
	SUBLW      232
L__main76:
	BTFSC      STATUS+0, 0
	GOTO       L__main34
;12f675 MPPT.mpas,187 :: 		clrwdt;
	CLRWDT
;12f675 MPPT.mpas,188 :: 		wdtimer:=0;
	CLRF       _wdtimer+0
	CLRF       _wdtimer+1
;12f675 MPPT.mpas,189 :: 		end;
L__main34:
;12f675 MPPT.mpas,192 :: 		vol_prev2:=vol_prev1;
	MOVF       _vol_prev1+0, 0
	MOVWF      _vol_prev2+0
	MOVF       _vol_prev1+1, 0
	MOVWF      _vol_prev2+1
;12f675 MPPT.mpas,193 :: 		vol_prev1:=adc_vol;
	MOVF       _adc_vol+0, 0
	MOVWF      _vol_prev1+0
	MOVF       _adc_vol+1, 0
	MOVWF      _vol_prev1+1
;12f675 MPPT.mpas,195 :: 		doADCRead:=0;
	CLRF       _doADCRead+0
;12f675 MPPT.mpas,196 :: 		while doADCRead=0 do ;
L__main37:
	MOVF       _doADCRead+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main37
;12f675 MPPT.mpas,198 :: 		adc_cur:=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,199 :: 		adc_vol:=ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_vol+0
	MOVF       R0+1, 0
	MOVWF      _adc_vol+1
;12f675 MPPT.mpas,200 :: 		for i:=1 to adc_max_loop-1 do begin
	MOVLW      1
	MOVWF      _i+0
L__main42:
;12f675 MPPT.mpas,201 :: 		xtmp:=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _xtmp+0
	MOVF       R0+1, 0
	MOVWF      _xtmp+1
;12f675 MPPT.mpas,202 :: 		wtmp:=ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _wtmp+0
	MOVF       R0+1, 0
	MOVWF      _wtmp+1
;12f675 MPPT.mpas,203 :: 		if xtmp > adc_cur then begin
	MOVF       _xtmp+1, 0
	SUBWF      _adc_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _xtmp+0, 0
	SUBWF      _adc_cur+0, 0
L__main77:
	BTFSC      STATUS+0, 0
	GOTO       L__main47
;12f675 MPPT.mpas,204 :: 		adc_cur:=xtmp;
	MOVF       _xtmp+0, 0
	MOVWF      _adc_cur+0
	MOVF       _xtmp+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,205 :: 		adc_vol:=wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _adc_vol+0
	MOVF       _wtmp+1, 0
	MOVWF      _adc_vol+1
;12f675 MPPT.mpas,206 :: 		end;
L__main47:
;12f675 MPPT.mpas,207 :: 		end;
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__main45
	INCF       _i+0, 1
	GOTO       L__main42
L__main45:
;12f675 MPPT.mpas,208 :: 		adc_vol:=adc_vol * VOLMUL;
	RLF        _adc_vol+0, 1
	RLF        _adc_vol+1, 1
	BCF        _adc_vol+0, 0
	RLF        _adc_vol+0, 1
	RLF        _adc_vol+1, 1
	BCF        _adc_vol+0, 0
;12f675 MPPT.mpas,211 :: 		wtmp:=TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wtmp+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wtmp+1
;12f675 MPPT.mpas,212 :: 		if tick_diff(wtmp, powertime) < _UPDATE_INT then
	MOVF       _TICK_1000+0, 0
	MOVWF      FARG_tick_diff_a+0
	MOVF       _TICK_1000+1, 0
	MOVWF      FARG_tick_diff_a+1
	MOVF       _powertime+0, 0
	MOVWF      FARG_tick_diff_b+0
	MOVF       _powertime+1, 0
	MOVWF      FARG_tick_diff_b+1
	CALL       _tick_diff+0
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVLW      25
	SUBWF      R0+0, 0
L__main78:
	BTFSC      STATUS+0, 0
	GOTO       L__main50
;12f675 MPPT.mpas,213 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
L__main50:
;12f675 MPPT.mpas,214 :: 		powertime:=wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _powertime+0
	MOVF       _wtmp+1, 0
	MOVWF      _powertime+1
;12f675 MPPT.mpas,216 :: 		power_prev:= power_curr;
	MOVF       _power_curr+0, 0
	MOVWF      _power_prev+0
	MOVF       _power_curr+1, 0
	MOVWF      _power_prev+1
	MOVF       _power_curr+2, 0
	MOVWF      _power_prev+2
	MOVF       _power_curr+3, 0
	MOVWF      _power_prev+3
;12f675 MPPT.mpas,217 :: 		power_curr:= dword(adc_vol * adc_cur);
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
;12f675 MPPT.mpas,231 :: 		if adc_cur>LM358_diff then begin
	MOVF       _adc_cur+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVF       _adc_cur+0, 0
	SUBWF      _LM358_diff+0, 0
L__main79:
	BTFSC      STATUS+0, 0
	GOTO       L__main53
;12f675 MPPT.mpas,233 :: 		if power_curr = power_prev then begin
	MOVF       _power_curr+3, 0
	XORWF      _power_prev+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVF       _power_curr+2, 0
	XORWF      _power_prev+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVF       _power_curr+1, 0
	XORWF      _power_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main80
	MOVF       _power_curr+0, 0
	XORWF      _power_prev+0, 0
L__main80:
	BTFSS      STATUS+0, 2
	GOTO       L__main56
;12f675 MPPT.mpas,234 :: 		LED1_tm:=500;
	MOVLW      244
	MOVWF      _LED1_tm+0
	MOVLW      1
	MOVWF      _LED1_tm+1
;12f675 MPPT.mpas,235 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
;12f675 MPPT.mpas,236 :: 		end else if power_curr < power_prev then begin
L__main56:
	MOVF       _power_prev+3, 0
	SUBWF      _power_curr+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main81
	MOVF       _power_prev+2, 0
	SUBWF      _power_curr+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main81
	MOVF       _power_prev+1, 0
	SUBWF      _power_curr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main81
	MOVF       _power_prev+0, 0
	SUBWF      _power_curr+0, 0
L__main81:
	BTFSC      STATUS+0, 0
	GOTO       L__main59
;12f675 MPPT.mpas,237 :: 		LED1_tm:=300;
	MOVLW      44
	MOVWF      _LED1_tm+0
	MOVLW      1
	MOVWF      _LED1_tm+1
;12f675 MPPT.mpas,238 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;12f675 MPPT.mpas,239 :: 		end else
	GOTO       L__main60
L__main59:
;12f675 MPPT.mpas,240 :: 		LED1_tm:=300;
	MOVLW      44
	MOVWF      _LED1_tm+0
	MOVLW      1
	MOVWF      _LED1_tm+1
L__main60:
;12f675 MPPT.mpas,246 :: 		end else begin
	GOTO       L__main54
L__main53:
;12f675 MPPT.mpas,247 :: 		LED1_tm:=200;
	MOVLW      200
	MOVWF      _LED1_tm+0
	CLRF       _LED1_tm+1
;12f675 MPPT.mpas,248 :: 		VOLPWM:=PWM_START;
	MOVLW      60
	MOVWF      _VOLPWM+0
;12f675 MPPT.mpas,249 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,250 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;12f675 MPPT.mpas,251 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,252 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
;12f675 MPPT.mpas,253 :: 		end;
L__main54:
;12f675 MPPT.mpas,256 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main62
;12f675 MPPT.mpas,257 :: 		if VOLPWM<PWM_MAX then
	MOVLW      200
	SUBWF      _VOLPWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main65
;12f675 MPPT.mpas,258 :: 		Inc(VOLPWM)
	INCF       _VOLPWM+0, 1
	GOTO       L__main66
;12f675 MPPT.mpas,259 :: 		else begin
L__main65:
;12f675 MPPT.mpas,260 :: 		VOLPWM:=PWM_MAX;
	MOVLW      200
	MOVWF      _VOLPWM+0
;12f675 MPPT.mpas,261 :: 		flag_inc:=false;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,262 :: 		end;
L__main66:
;12f675 MPPT.mpas,263 :: 		end else begin
	GOTO       L__main63
L__main62:
;12f675 MPPT.mpas,264 :: 		if VOLPWM>PWM_MIN then
	MOVF       _VOLPWM+0, 0
	SUBLW      10
	BTFSC      STATUS+0, 0
	GOTO       L__main68
;12f675 MPPT.mpas,265 :: 		Dec(VOLPWM)
	DECF       _VOLPWM+0, 1
	GOTO       L__main69
;12f675 MPPT.mpas,266 :: 		else begin
L__main68:
;12f675 MPPT.mpas,267 :: 		VOLPWM:=PWM_MIN;
	MOVLW      10
	MOVWF      _VOLPWM+0
;12f675 MPPT.mpas,268 :: 		flag_inc:=true;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,269 :: 		end;
L__main69:
;12f675 MPPT.mpas,270 :: 		end;
L__main63:
;12f675 MPPT.mpas,271 :: 		CONTLOOP:
L__main_CONTLOOP:
;12f675 MPPT.mpas,273 :: 		end;
	GOTO       L__main26
;12f675 MPPT.mpas,274 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main


_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;12f675 MPPT.mpas,62 :: 		begin
;12f675 MPPT.mpas,63 :: 		if T0IF_bit=1 then begin
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L__Interrupt3
;12f675 MPPT.mpas,64 :: 		PWM_SIG:=not PWM_SIG;
	MOVLW
	XORWF      GP0_bit+0, 1
;12f675 MPPT.mpas,65 :: 		if PWM_SIG=0 then begin
	BTFSC      GP0_bit+0, BitPos(GP0_bit+0)
	GOTO       L__Interrupt6
;12f675 MPPT.mpas,66 :: 		doADCRead:=1;
	MOVLW      1
	MOVWF      _doADCRead+0
;12f675 MPPT.mpas,68 :: 		ON_PWM:=VOLPWM;
	MOVF       _VOLPWM+0, 0
	MOVWF      _ON_PWM+0
;12f675 MPPT.mpas,69 :: 		TMR0:=255-ON_PWM;
	MOVF       _VOLPWM+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;12f675 MPPT.mpas,70 :: 		end else begin
	GOTO       L__Interrupt7
L__Interrupt6:
;12f675 MPPT.mpas,72 :: 		TMR0:=255-PWM_MAX+ON_PWM;
	MOVF       _ON_PWM+0, 0
	ADDLW      5
	MOVWF      TMR0+0
;12f675 MPPT.mpas,73 :: 		end;
L__Interrupt7:
;12f675 MPPT.mpas,74 :: 		T0IF_bit:=0;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;12f675 MPPT.mpas,75 :: 		end;
L__Interrupt3:
;12f675 MPPT.mpas,76 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__Interrupt9
;12f675 MPPT.mpas,77 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      248
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,78 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      48
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,79 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,80 :: 		Inc(TICK_1000);
	INCF       _TICK_1000+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TICK_1000+1, 1
;12f675 MPPT.mpas,81 :: 		end;
L__Interrupt9:
;12f675 MPPT.mpas,82 :: 		end;
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

;12f675 MPPT.mpas,84 :: 		begin
;12f675 MPPT.mpas,85 :: 		CMCON:=7;
	MOVLW      7
	MOVWF      CMCON+0
;12f675 MPPT.mpas,86 :: 		ANSEL:=%00111100;       // ADC conversion clock = fRC, AN3, AN2;
	MOVLW      60
	MOVWF      ANSEL+0
;12f675 MPPT.mpas,88 :: 		TRISIO0_bit:=0;      // PWM
	BCF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;12f675 MPPT.mpas,89 :: 		TRISIO1_bit:=1;      // not Connected
	BSF        TRISIO1_bit+0, BitPos(TRISIO1_bit+0)
;12f675 MPPT.mpas,90 :: 		TRISIO2_bit:=1;      // AN2
	BSF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;12f675 MPPT.mpas,91 :: 		TRISIO4_bit:=1;      // AN3
	BSF        TRISIO4_bit+0, BitPos(TRISIO4_bit+0)
;12f675 MPPT.mpas,92 :: 		TRISIO5_bit:=0;      // LED
	BCF        TRISIO5_bit+0, BitPos(TRISIO5_bit+0)
;12f675 MPPT.mpas,93 :: 		VCFG_bit:=1;
	BSF        VCFG_bit+0, BitPos(VCFG_bit+0)
;12f675 MPPT.mpas,94 :: 		CHS1_bit:=1;
	BSF        CHS1_bit+0, BitPos(CHS1_bit+0)
;12f675 MPPT.mpas,95 :: 		ADFM_bit:=1;
	BSF        ADFM_bit+0, BitPos(ADFM_bit+0)
;12f675 MPPT.mpas,97 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,98 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,99 :: 		LED1_tm:=100;
	MOVLW      100
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,100 :: 		ON_PWM:=0;
	CLRF       _ON_PWM+0
;12f675 MPPT.mpas,101 :: 		VOLPWM:=0;
	CLRF       _VOLPWM+0
;12f675 MPPT.mpas,102 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
	CLRF       _TICK_1000+1
;12f675 MPPT.mpas,104 :: 		OPTION_REG:=%01011111;        // ~4KHz @ 4MHz
	MOVLW      95
	MOVWF      OPTION_REG+0
;12f675 MPPT.mpas,105 :: 		TMR0IE_bit:=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;12f675 MPPT.mpas,107 :: 		LM358_diff:=cLM358_diff;
	CLRF       _LM358_diff+0
;12f675 MPPT.mpas,108 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,109 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,110 :: 		ClrWDT;
	CLRWDT
;12f675 MPPT.mpas,112 :: 		if Write_OPAMP=0 then begin
	BTFSC      GP3_bit+0, BitPos(GP3_bit+0)
	GOTO       L__main13
;12f675 MPPT.mpas,113 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,114 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,115 :: 		adc_cur:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,116 :: 		EEPROM_Write(0, Lo(adc_cur));
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _adc_cur+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;12f675 MPPT.mpas,117 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,118 :: 		LED1:=1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,119 :: 		Delay_ms(700);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      142
	MOVWF      R12+0
	MOVLW      18
	MOVWF      R13+0
L__main15:
	DECFSZ     R13+0, 1
	GOTO       L__main15
	DECFSZ     R12+0, 1
	GOTO       L__main15
	DECFSZ     R11+0, 1
	GOTO       L__main15
	NOP
;12f675 MPPT.mpas,120 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,121 :: 		end;
L__main13:
;12f675 MPPT.mpas,122 :: 		ClrWDT;
	CLRWDT
;12f675 MPPT.mpas,126 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;12f675 MPPT.mpas,127 :: 		LM358_diff:=EEPROM_Read(0);
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _LM358_diff+0
;12f675 MPPT.mpas,129 :: 		if LM358_diff>$1f then
	MOVF       R0+0, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L__main17
;12f675 MPPT.mpas,130 :: 		LM358_diff:=0;
	CLRF       _LM358_diff+0
L__main17:
;12f675 MPPT.mpas,132 :: 		T1CKPS1_bit:=0;
	BCF        T1CKPS1_bit+0, BitPos(T1CKPS1_bit+0)
;12f675 MPPT.mpas,133 :: 		T1CKPS0_bit:=0;               // timer prescaler 1:1
	BCF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;12f675 MPPT.mpas,134 :: 		TMR1CS_bit:=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;12f675 MPPT.mpas,135 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      48
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,136 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      248
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,137 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,139 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,140 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,141 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;12f675 MPPT.mpas,143 :: 		TMR1IE_bit:=1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;12f675 MPPT.mpas,144 :: 		PEIE_bit:=1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;12f675 MPPT.mpas,146 :: 		GIE_bit:=1;                   // enable Interrupt
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;12f675 MPPT.mpas,148 :: 		TMR1ON_bit:=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;12f675 MPPT.mpas,150 :: 		VOLPWM:=PWM_MID;
	MOVLW      120
	MOVWF      _VOLPWM+0
;12f675 MPPT.mpas,151 :: 		flag_inc:=False;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,152 :: 		vol_prev1:=0;
	CLRF       _vol_prev1+0
	CLRF       _vol_prev1+1
;12f675 MPPT.mpas,154 :: 		powertime:=0;
	CLRF       _powertime+0
	CLRF       _powertime+1
;12f675 MPPT.mpas,155 :: 		prevtime:=0;
	CLRF       _prevtime+0
	CLRF       _prevtime+1
;12f675 MPPT.mpas,156 :: 		voltime:=0;
	CLRF       _voltime+0
	CLRF       _voltime+1
;12f675 MPPT.mpas,159 :: 		clrwdt;
	CLRWDT
;12f675 MPPT.mpas,160 :: 		delay_ms(300);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L__main19:
	DECFSZ     R13+0, 1
	GOTO       L__main19
	DECFSZ     R12+0, 1
	GOTO       L__main19
	DECFSZ     R11+0, 1
	GOTO       L__main19
;12f675 MPPT.mpas,161 :: 		LED1:=1;
	BSF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,162 :: 		delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L__main20:
	DECFSZ     R13+0, 1
	GOTO       L__main20
	DECFSZ     R12+0, 1
	GOTO       L__main20
	DECFSZ     R11+0, 1
	GOTO       L__main20
	NOP
	NOP
;12f675 MPPT.mpas,163 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,164 :: 		clrwdt;
	CLRWDT
;12f675 MPPT.mpas,166 :: 		while True do begin
L__main22:
;12f675 MPPT.mpas,168 :: 		wtmp := TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wtmp+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wtmp+1
;12f675 MPPT.mpas,169 :: 		if wtmp - prevtime > LED1_tm then begin
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
	GOTO       L__main72
	MOVF       R1+0, 0
	SUBWF      _LED1_tm+0, 0
L__main72:
	BTFSC      STATUS+0, 0
	GOTO       L__main27
;12f675 MPPT.mpas,170 :: 		prevtime := wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _prevtime+0
	MOVF       _wtmp+1, 0
	MOVWF      _prevtime+1
;12f675 MPPT.mpas,171 :: 		LED1 := not LED1;
	MOVLW
	XORWF      GP5_bit+0, 1
;12f675 MPPT.mpas,172 :: 		end;
L__main27:
;12f675 MPPT.mpas,175 :: 		vol_prev2:=vol_prev1;
	MOVF       _vol_prev1+0, 0
	MOVWF      _vol_prev2+0
	MOVF       _vol_prev1+1, 0
	MOVWF      _vol_prev2+1
;12f675 MPPT.mpas,176 :: 		vol_prev1:=adc_vol;
	MOVF       _adc_vol+0, 0
	MOVWF      _vol_prev1+0
	MOVF       _adc_vol+1, 0
	MOVWF      _vol_prev1+1
;12f675 MPPT.mpas,178 :: 		doADCRead:=0;
	CLRF       _doADCRead+0
;12f675 MPPT.mpas,179 :: 		while doADCRead=0 do ;
L__main30:
	MOVF       _doADCRead+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main30
;12f675 MPPT.mpas,181 :: 		adc_cur:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,182 :: 		adc_vol:=ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_vol+0
	MOVF       R0+1, 0
	MOVWF      _adc_vol+1
;12f675 MPPT.mpas,183 :: 		for i:=0 to adc_max_loop-2 do begin
	CLRF       _i+0
L__main35:
;12f675 MPPT.mpas,184 :: 		xtmp:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _xtmp+0
	MOVF       R0+1, 0
	MOVWF      _xtmp+1
;12f675 MPPT.mpas,185 :: 		wtmp:=ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _wtmp+0
	MOVF       R0+1, 0
	MOVWF      _wtmp+1
;12f675 MPPT.mpas,186 :: 		adc_vol:=(adc_vol+wtmp) div 2;
	MOVF       R0+0, 0
	ADDWF      _adc_vol+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_vol+1, 1
	RRF        _adc_vol+1, 1
	RRF        _adc_vol+0, 1
	BCF        _adc_vol+1, 7
;12f675 MPPT.mpas,187 :: 		if xtmp > adc_cur then
	MOVF       _xtmp+1, 0
	SUBWF      _adc_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _xtmp+0, 0
	SUBWF      _adc_cur+0, 0
L__main73:
	BTFSC      STATUS+0, 0
	GOTO       L__main40
;12f675 MPPT.mpas,188 :: 		adc_cur:=xtmp;
	MOVF       _xtmp+0, 0
	MOVWF      _adc_cur+0
	MOVF       _xtmp+1, 0
	MOVWF      _adc_cur+1
L__main40:
;12f675 MPPT.mpas,190 :: 		end;
	MOVF       _i+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L__main38
	INCF       _i+0, 1
	GOTO       L__main35
L__main38:
;12f675 MPPT.mpas,191 :: 		adc_vol:=adc_vol * VOLMUL;
	RLF        _adc_vol+0, 1
	RLF        _adc_vol+1, 1
	BCF        _adc_vol+0, 0
	RLF        _adc_vol+0, 1
	RLF        _adc_vol+1, 1
	BCF        _adc_vol+0, 0
;12f675 MPPT.mpas,194 :: 		wtmp:=TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wtmp+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wtmp+1
;12f675 MPPT.mpas,195 :: 		if wtmp - powertime < _UPDATE_INT then
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
	GOTO       L__main74
	MOVLW      15
	SUBWF      R1+0, 0
L__main74:
	BTFSC      STATUS+0, 0
	GOTO       L__main43
;12f675 MPPT.mpas,196 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
L__main43:
;12f675 MPPT.mpas,197 :: 		clrwdt;
	CLRWDT
;12f675 MPPT.mpas,198 :: 		powertime:=wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _powertime+0
	MOVF       _wtmp+1, 0
	MOVWF      _powertime+1
;12f675 MPPT.mpas,200 :: 		power_prev:= power_curr;
	MOVF       _power_curr+0, 0
	MOVWF      _power_prev+0
	MOVF       _power_curr+1, 0
	MOVWF      _power_prev+1
	MOVF       _power_curr+2, 0
	MOVWF      _power_prev+2
	MOVF       _power_curr+3, 0
	MOVWF      _power_prev+3
;12f675 MPPT.mpas,201 :: 		power_curr:= dword(adc_vol * adc_cur);
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
;12f675 MPPT.mpas,204 :: 		wtmp:=TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wtmp+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wtmp+1
;12f675 MPPT.mpas,205 :: 		if ON_PWM>PWM_MID then begin
	MOVF       _ON_PWM+0, 0
	SUBLW      120
	BTFSC      STATUS+0, 0
	GOTO       L__main46
;12f675 MPPT.mpas,206 :: 		if wtmp - voltime > _PWM_CHECK then begin
	MOVF       _voltime+0, 0
	SUBWF      _wtmp+0, 0
	MOVWF      R1+0
	MOVF       _voltime+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _wtmp+1, 0
	MOVWF      R1+1
	MOVF       R1+1, 0
	SUBLW      8
	BTFSS      STATUS+0, 2
	GOTO       L__main75
	MOVF       R1+0, 0
	SUBLW      202
L__main75:
	BTFSC      STATUS+0, 0
	GOTO       L__main49
;12f675 MPPT.mpas,207 :: 		voltime:=wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _voltime+0
	MOVF       _wtmp+1, 0
	MOVWF      _voltime+1
;12f675 MPPT.mpas,208 :: 		adc_cur:=LM358_diff;
	MOVF       _LM358_diff+0, 0
	MOVWF      _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,209 :: 		end;
L__main49:
;12f675 MPPT.mpas,210 :: 		end else
	GOTO       L__main47
L__main46:
;12f675 MPPT.mpas,211 :: 		voltime:=wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _voltime+0
	MOVF       _wtmp+1, 0
	MOVWF      _voltime+1
L__main47:
;12f675 MPPT.mpas,213 :: 		if adc_cur>LM358_diff then begin
	MOVF       _adc_cur+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main76
	MOVF       _adc_cur+0, 0
	SUBWF      _LM358_diff+0, 0
L__main76:
	BTFSC      STATUS+0, 0
	GOTO       L__main52
;12f675 MPPT.mpas,215 :: 		if power_curr = power_prev then begin
	MOVF       _power_curr+3, 0
	XORWF      _power_prev+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _power_curr+2, 0
	XORWF      _power_prev+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _power_curr+1, 0
	XORWF      _power_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _power_curr+0, 0
	XORWF      _power_prev+0, 0
L__main77:
	BTFSS      STATUS+0, 2
	GOTO       L__main55
;12f675 MPPT.mpas,216 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,217 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
;12f675 MPPT.mpas,218 :: 		end else if power_curr < power_prev then begin
L__main55:
	MOVF       _power_prev+3, 0
	SUBWF      _power_curr+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVF       _power_prev+2, 0
	SUBWF      _power_curr+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVF       _power_prev+1, 0
	SUBWF      _power_curr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVF       _power_prev+0, 0
	SUBWF      _power_curr+0, 0
L__main78:
	BTFSC      STATUS+0, 0
	GOTO       L__main58
;12f675 MPPT.mpas,219 :: 		LED1_tm:=150;
	MOVLW      150
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,220 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;12f675 MPPT.mpas,221 :: 		end else
	GOTO       L__main59
L__main58:
;12f675 MPPT.mpas,222 :: 		LED1_tm:=200;
	MOVLW      200
	MOVWF      _LED1_tm+0
L__main59:
;12f675 MPPT.mpas,228 :: 		end else begin
	GOTO       L__main53
L__main52:
;12f675 MPPT.mpas,229 :: 		LED1_tm:=100;
	MOVLW      100
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,230 :: 		VOLPWM:=PWM_MID;
	MOVLW      120
	MOVWF      _VOLPWM+0
;12f675 MPPT.mpas,231 :: 		flag_inc:=false;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,232 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;12f675 MPPT.mpas,233 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,234 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
;12f675 MPPT.mpas,235 :: 		end;
L__main53:
;12f675 MPPT.mpas,238 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main61
;12f675 MPPT.mpas,239 :: 		if VOLPWM<PWM_MAX then
	MOVLW      250
	SUBWF      _VOLPWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main64
;12f675 MPPT.mpas,240 :: 		Inc(VOLPWM)
	INCF       _VOLPWM+0, 1
	GOTO       L__main65
;12f675 MPPT.mpas,241 :: 		else begin
L__main64:
;12f675 MPPT.mpas,242 :: 		VOLPWM:=PWM_MAX;
	MOVLW      250
	MOVWF      _VOLPWM+0
;12f675 MPPT.mpas,243 :: 		flag_inc:=false;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,244 :: 		end;
L__main65:
;12f675 MPPT.mpas,245 :: 		end else begin
	GOTO       L__main62
L__main61:
;12f675 MPPT.mpas,246 :: 		if VOLPWM>PWM_MIN then
	MOVF       _VOLPWM+0, 0
	SUBLW      1
	BTFSC      STATUS+0, 0
	GOTO       L__main67
;12f675 MPPT.mpas,247 :: 		Dec(VOLPWM)
	DECF       _VOLPWM+0, 1
	GOTO       L__main68
;12f675 MPPT.mpas,248 :: 		else begin
L__main67:
;12f675 MPPT.mpas,249 :: 		VOLPWM:=PWM_MIN;
	MOVLW      1
	MOVWF      _VOLPWM+0
;12f675 MPPT.mpas,250 :: 		flag_inc:=true;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,251 :: 		end;
L__main68:
;12f675 MPPT.mpas,252 :: 		end;
L__main62:
;12f675 MPPT.mpas,253 :: 		CONTLOOP:
L__main_CONTLOOP:
;12f675 MPPT.mpas,255 :: 		end;
	GOTO       L__main22
;12f675 MPPT.mpas,256 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main

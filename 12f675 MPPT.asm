
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;12f675 MPPT.mpas,48 :: 		begin
;12f675 MPPT.mpas,49 :: 		if T0IF_bit=1 then begin
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L__Interrupt2
;12f675 MPPT.mpas,51 :: 		if PWM_SIG=1 then begin
	BTFSS      GP0_bit+0, BitPos(GP0_bit+0)
	GOTO       L__Interrupt5
;12f675 MPPT.mpas,52 :: 		ON_PWM:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _ON_PWM+0
;12f675 MPPT.mpas,53 :: 		if ON_PWM=0 then
	MOVF       _VOL_PWM+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Interrupt8
;12f675 MPPT.mpas,54 :: 		TMR0:=255-PWM_MAX
	MOVLW      50
	MOVWF      TMR0+0
	GOTO       L__Interrupt9
;12f675 MPPT.mpas,55 :: 		else begin
L__Interrupt8:
;12f675 MPPT.mpas,56 :: 		TMR0:=255-ON_PWM;
	MOVF       _ON_PWM+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;12f675 MPPT.mpas,57 :: 		PWM_SIG:=0;
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,58 :: 		end;
L__Interrupt9:
;12f675 MPPT.mpas,59 :: 		end else begin
	GOTO       L__Interrupt6
L__Interrupt5:
;12f675 MPPT.mpas,60 :: 		TMR0:=255-PWM_MAX+ON_PWM;
	MOVF       _ON_PWM+0, 0
	ADDLW      50
	MOVWF      TMR0+0
;12f675 MPPT.mpas,61 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,62 :: 		end;
L__Interrupt6:
;12f675 MPPT.mpas,63 :: 		T0IF_bit:=0;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;12f675 MPPT.mpas,64 :: 		end else
	GOTO       L__Interrupt3
L__Interrupt2:
;12f675 MPPT.mpas,65 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__Interrupt11
;12f675 MPPT.mpas,66 :: 		Inc(TICK_1000);
	INCF       _TICK_1000+0, 1
;12f675 MPPT.mpas,67 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,68 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,69 :: 		if TICK_1000>LED1_Tm then begin
	MOVF       _TICK_1000+0, 0
	SUBWF      _LED1_tm+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__Interrupt14
;12f675 MPPT.mpas,70 :: 		LED1:=not LED1;
	MOVLW
	XORWF      GP5_bit+0, 1
;12f675 MPPT.mpas,71 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;12f675 MPPT.mpas,72 :: 		end;
L__Interrupt14:
;12f675 MPPT.mpas,73 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,74 :: 		end;
L__Interrupt11:
L__Interrupt3:
;12f675 MPPT.mpas,75 :: 		end;
L_end_Interrupt:
L__Interrupt52:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;12f675 MPPT.mpas,77 :: 		begin
;12f675 MPPT.mpas,78 :: 		CMCON:=7;
	MOVLW      7
	MOVWF      CMCON+0
;12f675 MPPT.mpas,79 :: 		ANSEL:=%00011100;       // 8/osc, AN3, AN2;
	MOVLW      28
	MOVWF      ANSEL+0
;12f675 MPPT.mpas,81 :: 		TRISIO0_bit:=0;      // PWM
	BCF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;12f675 MPPT.mpas,82 :: 		TRISIO1_bit:=1;      // not Connected
	BSF        TRISIO1_bit+0, BitPos(TRISIO1_bit+0)
;12f675 MPPT.mpas,83 :: 		TRISIO2_bit:=1;      // AN2
	BSF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;12f675 MPPT.mpas,84 :: 		TRISIO4_bit:=1;      // AN3
	BSF        TRISIO4_bit+0, BitPos(TRISIO4_bit+0)
;12f675 MPPT.mpas,85 :: 		TRISIO5_bit:=0;      // LED
	BCF        TRISIO5_bit+0, BitPos(TRISIO5_bit+0)
;12f675 MPPT.mpas,87 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,88 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,89 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,90 :: 		ON_PWM:=0;
	CLRF       _ON_PWM+0
;12f675 MPPT.mpas,91 :: 		VOL_PWM:=PWM_MAX;
	MOVLW      205
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,92 :: 		flag_inc:=False;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,93 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;12f675 MPPT.mpas,94 :: 		power_prev:=0;
	CLRF       _power_prev+0
	CLRF       _power_prev+1
	CLRF       _power_prev+2
	CLRF       _power_prev+3
;12f675 MPPT.mpas,95 :: 		offset_cur:=current_min;
	MOVLW      2
	MOVWF      _offset_cur+0
	CLRF       _offset_cur+1
;12f675 MPPT.mpas,97 :: 		Hi(offset_cur):=EEPROM_Read(0);
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _offset_cur+1
;12f675 MPPT.mpas,98 :: 		Lo(offset_cur):=EEPROM_Read(1);
	MOVLW      1
	MOVWF      FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _offset_cur+0
;12f675 MPPT.mpas,100 :: 		VCFG_bit:=1;
	BSF        VCFG_bit+0, BitPos(VCFG_bit+0)
;12f675 MPPT.mpas,102 :: 		OPTION_REG:=%11010000;        // ~2KHz @ 4MHz, enable weak pull-up
	MOVLW      208
	MOVWF      OPTION_REG+0
;12f675 MPPT.mpas,103 :: 		TMR0IE_bit:=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;12f675 MPPT.mpas,105 :: 		PEIE_bit:=1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;12f675 MPPT.mpas,107 :: 		T1CKPS0_bit:=1;               // timer prescaler 1:2
	BSF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;12f675 MPPT.mpas,108 :: 		TMR1CS_bit:=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;12f675 MPPT.mpas,109 :: 		TMR1IE_bit:=1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;12f675 MPPT.mpas,110 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,111 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,113 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,114 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,116 :: 		GIE_bit:=1;                   // enable Interrupt
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;12f675 MPPT.mpas,118 :: 		TMR1ON_bit:=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;12f675 MPPT.mpas,120 :: 		Delay_10ms;
	CALL       _Delay_10ms+0
;12f675 MPPT.mpas,122 :: 		while True do begin
L__main18:
;12f675 MPPT.mpas,124 :: 		temp_cur:=0;
	CLRF       _temp_cur+0
	CLRF       _temp_cur+1
;12f675 MPPT.mpas,125 :: 		for i:=0 to 60 do begin
	CLRF       _i+0
L__main23:
;12f675 MPPT.mpas,126 :: 		adc_cur:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,127 :: 		if temp_cur<adc_cur then
	MOVF       R0+1, 0
	SUBWF      _temp_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main54
	MOVF       R0+0, 0
	SUBWF      _temp_cur+0, 0
L__main54:
	BTFSC      STATUS+0, 0
	GOTO       L__main28
;12f675 MPPT.mpas,128 :: 		temp_cur:=adc_cur;
	MOVF       _adc_cur+0, 0
	MOVWF      _temp_cur+0
	MOVF       _adc_cur+1, 0
	MOVWF      _temp_cur+1
L__main28:
;12f675 MPPT.mpas,129 :: 		end;
	MOVF       _i+0, 0
	XORLW      60
	BTFSC      STATUS+0, 2
	GOTO       L__main26
	INCF       _i+0, 1
	GOTO       L__main23
L__main26:
;12f675 MPPT.mpas,130 :: 		adc_cur:=temp_cur;
	MOVF       _temp_cur+0, 0
	MOVWF      _adc_cur+0
	MOVF       _temp_cur+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,131 :: 		if adc_cur>offset_cur then begin
	MOVF       _temp_cur+1, 0
	SUBWF      _offset_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main55
	MOVF       _temp_cur+0, 0
	SUBWF      _offset_cur+0, 0
L__main55:
	BTFSC      STATUS+0, 0
	GOTO       L__main31
;12f675 MPPT.mpas,133 :: 		adc_vol:=ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_vol+0
	MOVF       R0+1, 0
	MOVWF      _adc_vol+1
;12f675 MPPT.mpas,134 :: 		power_curr:= adc_cur * adc_vol;
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
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
;12f675 MPPT.mpas,135 :: 		if power_curr<power_prev then
	MOVF       _power_prev+3, 0
	SUBWF      R0+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main56
	MOVF       _power_prev+2, 0
	SUBWF      R0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main56
	MOVF       _power_prev+1, 0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main56
	MOVF       _power_prev+0, 0
	SUBWF      R0+0, 0
L__main56:
	BTFSC      STATUS+0, 0
	GOTO       L__main34
;12f675 MPPT.mpas,136 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
L__main34:
;12f675 MPPT.mpas,137 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main37
;12f675 MPPT.mpas,138 :: 		if VOL_PWM<PWM_MAX then
	MOVLW      205
	SUBWF      _VOL_PWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main40
;12f675 MPPT.mpas,139 :: 		Inc(VOL_PWM);
	INCF       _VOL_PWM+0, 1
L__main40:
;12f675 MPPT.mpas,140 :: 		end else begin
	GOTO       L__main38
L__main37:
;12f675 MPPT.mpas,141 :: 		if VOL_PWM>PWM_LOW then
	MOVF       _VOL_PWM+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L__main43
;12f675 MPPT.mpas,142 :: 		Dec(VOL_PWM);
	DECF       _VOL_PWM+0, 1
L__main43:
;12f675 MPPT.mpas,143 :: 		end;
L__main38:
;12f675 MPPT.mpas,144 :: 		power_prev:=power_curr;
	MOVF       _power_curr+0, 0
	MOVWF      _power_prev+0
	MOVF       _power_curr+1, 0
	MOVWF      _power_prev+1
	MOVF       _power_curr+2, 0
	MOVWF      _power_prev+2
	MOVF       _power_curr+3, 0
	MOVWF      _power_prev+3
;12f675 MPPT.mpas,145 :: 		end else begin
	GOTO       L__main32
L__main31:
;12f675 MPPT.mpas,146 :: 		VOL_PWM:=PWM_MAX;
	MOVLW      205
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,147 :: 		flag_inc:=False;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,148 :: 		power_prev:=0;
	CLRF       _power_prev+0
	CLRF       _power_prev+1
	CLRF       _power_prev+2
	CLRF       _power_prev+3
;12f675 MPPT.mpas,149 :: 		end;
L__main32:
;12f675 MPPT.mpas,152 :: 		if VOL_PWM=PWM_MAX then
	MOVF       _VOL_PWM+0, 0
	XORLW      205
	BTFSS      STATUS+0, 2
	GOTO       L__main46
;12f675 MPPT.mpas,153 :: 		LED1_tm:=125
	MOVLW      125
	MOVWF      _LED1_tm+0
	GOTO       L__main47
;12f675 MPPT.mpas,154 :: 		else
L__main46:
;12f675 MPPT.mpas,155 :: 		if adc_cur<=offset_cur then
	MOVF       _adc_cur+1, 0
	SUBWF      _offset_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main57
	MOVF       _adc_cur+0, 0
	SUBWF      _offset_cur+0, 0
L__main57:
	BTFSS      STATUS+0, 0
	GOTO       L__main49
;12f675 MPPT.mpas,156 :: 		LED1_tm:=64
	MOVLW      64
	MOVWF      _LED1_tm+0
	GOTO       L__main50
;12f675 MPPT.mpas,157 :: 		else
L__main49:
;12f675 MPPT.mpas,158 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
L__main50:
L__main47:
;12f675 MPPT.mpas,159 :: 		end;
	GOTO       L__main18
;12f675 MPPT.mpas,160 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main

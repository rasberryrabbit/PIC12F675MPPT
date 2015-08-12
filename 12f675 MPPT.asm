
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;12f675 MPPT.mpas,45 :: 		begin
;12f675 MPPT.mpas,46 :: 		if T0IF_bit=1 then begin
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L__Interrupt2
;12f675 MPPT.mpas,48 :: 		if PWM_SIG=1 then begin
	BTFSS      GP0_bit+0, BitPos(GP0_bit+0)
	GOTO       L__Interrupt5
;12f675 MPPT.mpas,49 :: 		ON_PWM:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _ON_PWM+0
;12f675 MPPT.mpas,50 :: 		if ON_PWM=0 then
	MOVF       _VOL_PWM+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Interrupt8
;12f675 MPPT.mpas,51 :: 		TMR0:=255-PWM_MAX
	MOVLW      55
	MOVWF      TMR0+0
	GOTO       L__Interrupt9
;12f675 MPPT.mpas,52 :: 		else begin
L__Interrupt8:
;12f675 MPPT.mpas,53 :: 		TMR0:=255-ON_PWM;
	MOVF       _ON_PWM+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;12f675 MPPT.mpas,54 :: 		PWM_SIG:=0;
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,55 :: 		end;
L__Interrupt9:
;12f675 MPPT.mpas,56 :: 		end else begin
	GOTO       L__Interrupt6
L__Interrupt5:
;12f675 MPPT.mpas,57 :: 		TMR0:=255-PWM_MAX+ON_PWM;
	MOVF       _ON_PWM+0, 0
	ADDLW      55
	MOVWF      TMR0+0
;12f675 MPPT.mpas,58 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,59 :: 		end;
L__Interrupt6:
;12f675 MPPT.mpas,60 :: 		T0IF_bit:=0;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;12f675 MPPT.mpas,61 :: 		end else
	GOTO       L__Interrupt3
L__Interrupt2:
;12f675 MPPT.mpas,62 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__Interrupt11
;12f675 MPPT.mpas,63 :: 		Inc(TICK_1000);
	INCF       _TICK_1000+0, 1
;12f675 MPPT.mpas,64 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,65 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,66 :: 		if TICK_1000>LED1_Tm then begin
	MOVF       _TICK_1000+0, 0
	SUBWF      _LED1_tm+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__Interrupt14
;12f675 MPPT.mpas,67 :: 		LED1:=not LED1;
	MOVLW
	XORWF      GP5_bit+0, 1
;12f675 MPPT.mpas,68 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;12f675 MPPT.mpas,69 :: 		end;
L__Interrupt14:
;12f675 MPPT.mpas,70 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,71 :: 		end;
L__Interrupt11:
L__Interrupt3:
;12f675 MPPT.mpas,72 :: 		end;
L_end_Interrupt:
L__Interrupt65:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;12f675 MPPT.mpas,74 :: 		begin
;12f675 MPPT.mpas,75 :: 		CMCON:=7;
	MOVLW      7
	MOVWF      CMCON+0
;12f675 MPPT.mpas,76 :: 		ANSEL:=%00011100;       // 8/osc, AN3, AN2;
	MOVLW      28
	MOVWF      ANSEL+0
;12f675 MPPT.mpas,78 :: 		TRISIO0_bit:=0;      // PWM
	BCF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;12f675 MPPT.mpas,79 :: 		TRISIO1_bit:=1;      // not Connected
	BSF        TRISIO1_bit+0, BitPos(TRISIO1_bit+0)
;12f675 MPPT.mpas,80 :: 		TRISIO2_bit:=1;      // AN2
	BSF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;12f675 MPPT.mpas,81 :: 		TRISIO4_bit:=1;      // AN3
	BSF        TRISIO4_bit+0, BitPos(TRISIO4_bit+0)
;12f675 MPPT.mpas,82 :: 		TRISIO5_bit:=0;      // LED
	BCF        TRISIO5_bit+0, BitPos(TRISIO5_bit+0)
;12f675 MPPT.mpas,84 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,85 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,86 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,87 :: 		ON_PWM:=0;
	CLRF       _ON_PWM+0
;12f675 MPPT.mpas,88 :: 		VOL_PWM:=PWM_LOW;
	CLRF       _VOL_PWM+0
;12f675 MPPT.mpas,89 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;12f675 MPPT.mpas,90 :: 		power_prev:=0;
	CLRF       _power_prev+0
	CLRF       _power_prev+1
	CLRF       _power_prev+2
	CLRF       _power_prev+3
;12f675 MPPT.mpas,91 :: 		offset_cur:=0;
	CLRF       _offset_cur+0
	CLRF       _offset_cur+1
;12f675 MPPT.mpas,92 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,94 :: 		OPTION_REG:=%11010000;        // ~2KHz @ 4MHz, enable weak pull-up
	MOVLW      208
	MOVWF      OPTION_REG+0
;12f675 MPPT.mpas,95 :: 		TMR0IE_bit:=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;12f675 MPPT.mpas,97 :: 		PEIE_bit:=1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;12f675 MPPT.mpas,99 :: 		T1CKPS0_bit:=1;               // timer prescaler 1:2
	BSF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;12f675 MPPT.mpas,100 :: 		TMR1CS_bit:=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;12f675 MPPT.mpas,101 :: 		TMR1IE_bit:=1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;12f675 MPPT.mpas,102 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,103 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,105 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,106 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,108 :: 		GIE_bit:=1;                   // enable Interrupt
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;12f675 MPPT.mpas,110 :: 		TMR1ON_bit:=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;12f675 MPPT.mpas,112 :: 		Delay_10ms;
	CALL       _Delay_10ms+0
;12f675 MPPT.mpas,114 :: 		while True do begin
L__main18:
;12f675 MPPT.mpas,115 :: 		if VOL_PWM=PWM_LOW then
	MOVF       _VOL_PWM+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main23
;12f675 MPPT.mpas,116 :: 		offset_cur:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _offset_cur+0
	MOVF       R0+1, 0
	MOVWF      _offset_cur+1
L__main23:
;12f675 MPPT.mpas,118 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main26
;12f675 MPPT.mpas,119 :: 		if VOL_PWM<PWM_MAX then
	MOVLW      200
	SUBWF      _VOL_PWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main29
;12f675 MPPT.mpas,120 :: 		Inc(VOL_PWM);
	INCF       _VOL_PWM+0, 1
L__main29:
;12f675 MPPT.mpas,121 :: 		end else begin
	GOTO       L__main27
L__main26:
;12f675 MPPT.mpas,122 :: 		if VOL_PWM>PWM_LOW then
	MOVF       _VOL_PWM+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L__main32
;12f675 MPPT.mpas,123 :: 		Dec(VOL_PWM);
	DECF       _VOL_PWM+0, 1
L__main32:
;12f675 MPPT.mpas,124 :: 		end;
L__main27:
;12f675 MPPT.mpas,125 :: 		Delay_5ms;
	CALL       _Delay_5ms+0
;12f675 MPPT.mpas,127 :: 		adc_cur:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,128 :: 		if adc_cur>offset_cur then begin
	MOVF       R0+1, 0
	SUBWF      _offset_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVF       R0+0, 0
	SUBWF      _offset_cur+0, 0
L__main67:
	BTFSC      STATUS+0, 0
	GOTO       L__main35
;12f675 MPPT.mpas,129 :: 		adc_vol:=ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_vol+0
	MOVF       R0+1, 0
	MOVWF      _adc_vol+1
;12f675 MPPT.mpas,130 :: 		power_curr:=(adc_cur{ * curr_scale div 10})*adc_vol;
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
;12f675 MPPT.mpas,131 :: 		if power_curr>=power_prev then begin
	MOVF       _power_prev+3, 0
	SUBWF      R0+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVF       _power_prev+2, 0
	SUBWF      R0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVF       _power_prev+1, 0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVF       _power_prev+0, 0
	SUBWF      R0+0, 0
L__main68:
	BTFSS      STATUS+0, 0
	GOTO       L__main38
;12f675 MPPT.mpas,132 :: 		power_prev:=power_curr;
	MOVF       _power_curr+0, 0
	MOVWF      _power_prev+0
	MOVF       _power_curr+1, 0
	MOVWF      _power_prev+1
	MOVF       _power_curr+2, 0
	MOVWF      _power_prev+2
	MOVF       _power_curr+3, 0
	MOVWF      _power_prev+3
;12f675 MPPT.mpas,133 :: 		end else begin
	GOTO       L__main39
L__main38:
;12f675 MPPT.mpas,134 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main41
;12f675 MPPT.mpas,135 :: 		if VOL_PWM>PWM_LOW then
	MOVF       _VOL_PWM+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L__main44
;12f675 MPPT.mpas,136 :: 		Dec(VOL_PWM);
	DECF       _VOL_PWM+0, 1
L__main44:
;12f675 MPPT.mpas,137 :: 		end else begin
	GOTO       L__main42
L__main41:
;12f675 MPPT.mpas,138 :: 		if VOL_PWM<PWM_MAX then
	MOVLW      200
	SUBWF      _VOL_PWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main47
;12f675 MPPT.mpas,139 :: 		Inc(VOL_PWM);
	INCF       _VOL_PWM+0, 1
L__main47:
;12f675 MPPT.mpas,140 :: 		end;
L__main42:
;12f675 MPPT.mpas,141 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;12f675 MPPT.mpas,142 :: 		end;
L__main39:
;12f675 MPPT.mpas,143 :: 		end else begin
	GOTO       L__main36
L__main35:
;12f675 MPPT.mpas,144 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,145 :: 		power_prev:=0;
	CLRF       _power_prev+0
	CLRF       _power_prev+1
	CLRF       _power_prev+2
	CLRF       _power_prev+3
;12f675 MPPT.mpas,146 :: 		end;
L__main36:
;12f675 MPPT.mpas,149 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main50
;12f675 MPPT.mpas,150 :: 		if VOL_PWM=PWM_MAX then
	MOVF       _VOL_PWM+0, 0
	XORLW      200
	BTFSS      STATUS+0, 2
	GOTO       L__main53
;12f675 MPPT.mpas,151 :: 		flag_inc:=False;
	CLRF       _flag_inc+0
L__main53:
;12f675 MPPT.mpas,152 :: 		end else begin
	GOTO       L__main51
L__main50:
;12f675 MPPT.mpas,153 :: 		if VOL_PWM=PWM_LOW then
	MOVF       _VOL_PWM+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main56
;12f675 MPPT.mpas,154 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
L__main56:
;12f675 MPPT.mpas,155 :: 		end;
L__main51:
;12f675 MPPT.mpas,157 :: 		if VOL_PWM=PWM_MAX then
	MOVF       _VOL_PWM+0, 0
	XORLW      200
	BTFSS      STATUS+0, 2
	GOTO       L__main59
;12f675 MPPT.mpas,158 :: 		LED1_tm:=125
	MOVLW      125
	MOVWF      _LED1_tm+0
	GOTO       L__main60
;12f675 MPPT.mpas,159 :: 		else
L__main59:
;12f675 MPPT.mpas,160 :: 		if VOL_PWM=PWM_LOW then
	MOVF       _VOL_PWM+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main62
;12f675 MPPT.mpas,161 :: 		LED1_tm:=64
	MOVLW      64
	MOVWF      _LED1_tm+0
	GOTO       L__main63
;12f675 MPPT.mpas,162 :: 		else
L__main62:
;12f675 MPPT.mpas,163 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
L__main63:
L__main60:
;12f675 MPPT.mpas,164 :: 		end;
	GOTO       L__main18
;12f675 MPPT.mpas,165 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main


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
;12f675 MPPT.mpas,50 :: 		if PWM_FLAG=1 then begin
	BTFSS      _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
	GOTO       L__Interrupt5
;12f675 MPPT.mpas,51 :: 		ON_PWM:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _ON_PWM+0
;12f675 MPPT.mpas,53 :: 		TMR0:=255-ON_PWM;
	MOVF       _VOL_PWM+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;12f675 MPPT.mpas,54 :: 		PWM_SIG:=0;
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,55 :: 		PWM_FLAG:=0;
	BCF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,56 :: 		end else begin
	GOTO       L__Interrupt6
L__Interrupt5:
;12f675 MPPT.mpas,58 :: 		TMR0:=255-PWM_MAX+ON_PWM;
	MOVF       _ON_PWM+0, 0
	ADDLW      50
	MOVWF      TMR0+0
;12f675 MPPT.mpas,59 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,60 :: 		PWM_FLAG:=1;
	BSF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,61 :: 		end;
L__Interrupt6:
;12f675 MPPT.mpas,62 :: 		T0IF_bit:=0;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;12f675 MPPT.mpas,63 :: 		end else
	GOTO       L__Interrupt3
L__Interrupt2:
;12f675 MPPT.mpas,64 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__Interrupt8
;12f675 MPPT.mpas,65 :: 		Inc(TICK_1000);
	INCF       _TICK_1000+0, 1
;12f675 MPPT.mpas,66 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,67 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,68 :: 		if TICK_1000>LED1_Tm then begin
	MOVF       _TICK_1000+0, 0
	SUBWF      _LED1_tm+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__Interrupt11
;12f675 MPPT.mpas,69 :: 		LED1:=not LED1;
	MOVLW
	XORWF      GP5_bit+0, 1
;12f675 MPPT.mpas,70 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;12f675 MPPT.mpas,71 :: 		end;
L__Interrupt11:
;12f675 MPPT.mpas,72 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;12f675 MPPT.mpas,73 :: 		end;
L__Interrupt8:
L__Interrupt3:
;12f675 MPPT.mpas,74 :: 		end;
L_end_Interrupt:
L__Interrupt73:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_Adc_Readx:

;12f675 MPPT.mpas,77 :: 		begin
;12f675 MPPT.mpas,78 :: 		if ch=2 then
	MOVF       FARG_Adc_Readx_ch+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__Adc_Readx15
;12f675 MPPT.mpas,79 :: 		CHS0_bit:=0
	BCF        CHS0_bit+0, BitPos(CHS0_bit+0)
	GOTO       L__Adc_Readx16
;12f675 MPPT.mpas,80 :: 		else
L__Adc_Readx15:
;12f675 MPPT.mpas,81 :: 		CHS0_bit:=1;
	BSF        CHS0_bit+0, BitPos(CHS0_bit+0)
L__Adc_Readx16:
;12f675 MPPT.mpas,82 :: 		ADON_bit:=1;
	BSF        ADON_bit+0, BitPos(ADON_bit+0)
;12f675 MPPT.mpas,83 :: 		Delay_22us;
	CALL       _Delay_22us+0
;12f675 MPPT.mpas,84 :: 		GO_NOT_DONE_bit:=1;
	BSF        GO_NOT_DONE_bit+0, BitPos(GO_NOT_DONE_bit+0)
;12f675 MPPT.mpas,85 :: 		while GO_NOT_DONE_bit=1 do ;
L__Adc_Readx18:
	BTFSC      GO_NOT_DONE_bit+0, BitPos(GO_NOT_DONE_bit+0)
	GOTO       L__Adc_Readx18
;12f675 MPPT.mpas,86 :: 		Hi(Result):=ADRESH;
	MOVF       ADRESH+0, 0
	MOVWF      Adc_Readx_local_result+1
;12f675 MPPT.mpas,87 :: 		Lo(Result):=ADRESL;
	MOVF       ADRESL+0, 0
	MOVWF      Adc_Readx_local_result+0
;12f675 MPPT.mpas,88 :: 		ADON_bit:=0;
	BCF        ADON_bit+0, BitPos(ADON_bit+0)
;12f675 MPPT.mpas,89 :: 		end;
	MOVF       Adc_Readx_local_result+0, 0
	MOVWF      R0+0
	MOVF       Adc_Readx_local_result+1, 0
	MOVWF      R0+1
L_end_Adc_Readx:
	RETURN
; end of _Adc_Readx

_main:

;12f675 MPPT.mpas,91 :: 		begin
;12f675 MPPT.mpas,92 :: 		CMCON:=7;
	MOVLW      7
	MOVWF      CMCON+0
;12f675 MPPT.mpas,93 :: 		ANSEL:=%00011100;       // 8/osc, AN3, AN2;
	MOVLW      28
	MOVWF      ANSEL+0
;12f675 MPPT.mpas,95 :: 		TRISIO0_bit:=0;      // PWM
	BCF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;12f675 MPPT.mpas,96 :: 		TRISIO1_bit:=1;      // not Connected
	BSF        TRISIO1_bit+0, BitPos(TRISIO1_bit+0)
;12f675 MPPT.mpas,97 :: 		TRISIO2_bit:=1;      // AN2
	BSF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;12f675 MPPT.mpas,98 :: 		TRISIO4_bit:=1;      // AN3
	BSF        TRISIO4_bit+0, BitPos(TRISIO4_bit+0)
;12f675 MPPT.mpas,99 :: 		TRISIO5_bit:=0;      // LED
	BCF        TRISIO5_bit+0, BitPos(TRISIO5_bit+0)
;12f675 MPPT.mpas,101 :: 		LED1:=0;
	BCF        GP5_bit+0, BitPos(GP5_bit+0)
;12f675 MPPT.mpas,102 :: 		PWM_SIG:=1;
	BSF        GP0_bit+0, BitPos(GP0_bit+0)
;12f675 MPPT.mpas,103 :: 		PWM_FLAG:=1;
	BSF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;12f675 MPPT.mpas,104 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
;12f675 MPPT.mpas,105 :: 		ON_PWM:=0;
	CLRF       _ON_PWM+0
;12f675 MPPT.mpas,106 :: 		VOL_PWM:=PWM_LOW;
	CLRF       _VOL_PWM+0
;12f675 MPPT.mpas,107 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;12f675 MPPT.mpas,108 :: 		power_prev:=0;
	CLRF       _power_prev+0
	CLRF       _power_prev+1
	CLRF       _power_prev+2
	CLRF       _power_prev+3
;12f675 MPPT.mpas,109 :: 		offset_cur:=current_min;
	MOVLW      2
	MOVWF      _offset_cur+0
	CLRF       _offset_cur+1
;12f675 MPPT.mpas,110 :: 		last_cur:=0;
	CLRF       _last_cur+0
	CLRF       _last_cur+1
;12f675 MPPT.mpas,112 :: 		Hi(offset_cur):=EEPROM_Read(0);
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _offset_cur+1
;12f675 MPPT.mpas,113 :: 		Lo(offset_cur):=EEPROM_Read(1);
	MOVLW      1
	MOVWF      FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _offset_cur+0
;12f675 MPPT.mpas,115 :: 		VCFG_bit:=1;
	BSF        VCFG_bit+0, BitPos(VCFG_bit+0)
;12f675 MPPT.mpas,116 :: 		CHS1_bit:=1;
	BSF        CHS1_bit+0, BitPos(CHS1_bit+0)
;12f675 MPPT.mpas,117 :: 		ADFM_bit:=1;
	BSF        ADFM_bit+0, BitPos(ADFM_bit+0)
;12f675 MPPT.mpas,119 :: 		OPTION_REG:=%01010000;        // ~2KHz @ 4MHz, enable weak pull-up
	MOVLW      80
	MOVWF      OPTION_REG+0
;12f675 MPPT.mpas,120 :: 		TMR0IE_bit:=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;12f675 MPPT.mpas,122 :: 		PEIE_bit:=1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;12f675 MPPT.mpas,124 :: 		T1CKPS0_bit:=1;               // timer prescaler 1:2
	BSF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;12f675 MPPT.mpas,125 :: 		TMR1CS_bit:=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;12f675 MPPT.mpas,126 :: 		TMR1IE_bit:=1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;12f675 MPPT.mpas,127 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;12f675 MPPT.mpas,128 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;12f675 MPPT.mpas,130 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;12f675 MPPT.mpas,131 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;12f675 MPPT.mpas,133 :: 		GIE_bit:=1;                   // enable Interrupt
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;12f675 MPPT.mpas,135 :: 		TMR1ON_bit:=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;12f675 MPPT.mpas,137 :: 		VOL_PWM:=PWM_MAX div 2;
	MOVLW      102
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,138 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;12f675 MPPT.mpas,140 :: 		while True do begin
L__main24:
;12f675 MPPT.mpas,142 :: 		temp_cur:=0;
	CLRF       _temp_cur+0
	CLRF       _temp_cur+1
;12f675 MPPT.mpas,143 :: 		while PWM_FLAG=0 do ;
L__main29:
	BTFSS      _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
	GOTO       L__main29
;12f675 MPPT.mpas,144 :: 		for i:=0 to 3 do begin
	CLRF       _i+0
L__main34:
;12f675 MPPT.mpas,145 :: 		adc_cur:=Adc_Readx(2);
	MOVLW      2
	MOVWF      FARG_Adc_Readx_ch+0
	CALL       _Adc_Readx+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,146 :: 		temp_cur:=temp_cur+adc_cur;
	MOVF       R0+0, 0
	ADDWF      _temp_cur+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp_cur+1, 1
;12f675 MPPT.mpas,147 :: 		end;
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__main37
	INCF       _i+0, 1
	GOTO       L__main34
L__main37:
;12f675 MPPT.mpas,148 :: 		while PWM_FLAG=1 do ;
L__main39:
	BTFSC      _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
	GOTO       L__main39
;12f675 MPPT.mpas,149 :: 		for i:=0 to 3 do begin
	CLRF       _i+0
L__main44:
;12f675 MPPT.mpas,150 :: 		adc_cur:=Adc_Readx(2);
	MOVLW      2
	MOVWF      FARG_Adc_Readx_ch+0
	CALL       _Adc_Readx+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,151 :: 		temp_cur:=temp_cur+adc_cur;
	MOVF       R0+0, 0
	ADDWF      _temp_cur+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp_cur+1, 1
;12f675 MPPT.mpas,152 :: 		end;
	MOVF       _i+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L__main47
	INCF       _i+0, 1
	GOTO       L__main44
L__main47:
;12f675 MPPT.mpas,153 :: 		adc_cur:=temp_cur div 8;
	MOVF       _temp_cur+0, 0
	MOVWF      R1+0
	MOVF       _temp_cur+1, 0
	MOVWF      R1+1
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	MOVF       R1+0, 0
	MOVWF      _adc_cur+0
	MOVF       R1+1, 0
	MOVWF      _adc_cur+1
;12f675 MPPT.mpas,155 :: 		if adc_cur>offset_cur then begin
	MOVF       R1+1, 0
	SUBWF      _offset_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main76
	MOVF       R1+0, 0
	SUBWF      _offset_cur+0, 0
L__main76:
	BTFSC      STATUS+0, 0
	GOTO       L__main49
;12f675 MPPT.mpas,157 :: 		adc_vol:=Adc_Readx(3);
	MOVLW      3
	MOVWF      FARG_Adc_Readx_ch+0
	CALL       _Adc_Readx+0
	MOVF       R0+0, 0
	MOVWF      _adc_vol+0
	MOVF       R0+1, 0
	MOVWF      _adc_vol+1
;12f675 MPPT.mpas,158 :: 		power_curr:= adc_cur * adc_vol;
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
;12f675 MPPT.mpas,159 :: 		if power_curr<power_prev then
	MOVF       _power_prev+3, 0
	SUBWF      R0+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _power_prev+2, 0
	SUBWF      R0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _power_prev+1, 0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVF       _power_prev+0, 0
	SUBWF      R0+0, 0
L__main77:
	BTFSC      STATUS+0, 0
	GOTO       L__main52
;12f675 MPPT.mpas,160 :: 		flag_inc:=not flag_inc
	COMF       _flag_inc+0, 1
	GOTO       L__main53
;12f675 MPPT.mpas,161 :: 		else
L__main52:
;12f675 MPPT.mpas,162 :: 		if last_cur>adc_cur then
	MOVF       _last_cur+1, 0
	SUBWF      _adc_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVF       _last_cur+0, 0
	SUBWF      _adc_cur+0, 0
L__main78:
	BTFSC      STATUS+0, 0
	GOTO       L__main55
;12f675 MPPT.mpas,163 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
L__main55:
L__main53:
;12f675 MPPT.mpas,164 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main58
;12f675 MPPT.mpas,165 :: 		if VOL_PWM<PWM_MAX then
	MOVLW      205
	SUBWF      _VOL_PWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main61
;12f675 MPPT.mpas,166 :: 		Inc(VOL_PWM);
	INCF       _VOL_PWM+0, 1
L__main61:
;12f675 MPPT.mpas,167 :: 		end else begin
	GOTO       L__main59
L__main58:
;12f675 MPPT.mpas,168 :: 		if VOL_PWM>PWM_LOW then
	MOVF       _VOL_PWM+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L__main64
;12f675 MPPT.mpas,169 :: 		Dec(VOL_PWM);
	DECF       _VOL_PWM+0, 1
L__main64:
;12f675 MPPT.mpas,170 :: 		end;
L__main59:
;12f675 MPPT.mpas,171 :: 		power_prev:=power_curr;
	MOVF       _power_curr+0, 0
	MOVWF      _power_prev+0
	MOVF       _power_curr+1, 0
	MOVWF      _power_prev+1
	MOVF       _power_curr+2, 0
	MOVWF      _power_prev+2
	MOVF       _power_curr+3, 0
	MOVWF      _power_prev+3
;12f675 MPPT.mpas,172 :: 		end else begin
	GOTO       L__main50
L__main49:
;12f675 MPPT.mpas,173 :: 		VOL_PWM:=PWM_MAX;
	MOVLW      205
	MOVWF      _VOL_PWM+0
;12f675 MPPT.mpas,174 :: 		flag_inc:=False;
	CLRF       _flag_inc+0
;12f675 MPPT.mpas,175 :: 		power_prev:=0;
	CLRF       _power_prev+0
	CLRF       _power_prev+1
	CLRF       _power_prev+2
	CLRF       _power_prev+3
;12f675 MPPT.mpas,176 :: 		end;
L__main50:
;12f675 MPPT.mpas,177 :: 		last_cur:=adc_cur;
	MOVF       _adc_cur+0, 0
	MOVWF      _last_cur+0
	MOVF       _adc_cur+1, 0
	MOVWF      _last_cur+1
;12f675 MPPT.mpas,179 :: 		if VOL_PWM=PWM_MAX then
	MOVF       _VOL_PWM+0, 0
	XORLW      205
	BTFSS      STATUS+0, 2
	GOTO       L__main67
;12f675 MPPT.mpas,180 :: 		LED1_tm:=125
	MOVLW      125
	MOVWF      _LED1_tm+0
	GOTO       L__main68
;12f675 MPPT.mpas,181 :: 		else
L__main67:
;12f675 MPPT.mpas,182 :: 		if adc_cur<=offset_cur then
	MOVF       _adc_cur+1, 0
	SUBWF      _offset_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main79
	MOVF       _adc_cur+0, 0
	SUBWF      _offset_cur+0, 0
L__main79:
	BTFSS      STATUS+0, 0
	GOTO       L__main70
;12f675 MPPT.mpas,183 :: 		LED1_tm:=64
	MOVLW      64
	MOVWF      _LED1_tm+0
	GOTO       L__main71
;12f675 MPPT.mpas,184 :: 		else
L__main70:
;12f675 MPPT.mpas,185 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
L__main71:
L__main68:
;12f675 MPPT.mpas,186 :: 		end;
	GOTO       L__main24
;12f675 MPPT.mpas,187 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main


;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATtiny2313
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 32 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU WDTCSR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _UART0_DATA=R3
	.DEF _NDX_232=R2
	.DEF _default_Color=R5
	.DEF _Tmr_Cnt=R4
	.DEF _RS232_RS_Limit=R7

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x3
	.DB  0x0,0x6

_0x3:
	.DB  0x1B,0x2,0x52,0x0,0x0,0x0,0x0,0x3
	.DB  0xD

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x02
	.DW  __REG_VARS*2

	.DW  0x09
	.DW  _rtnMsg
	.DW  _0x3*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;	#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;    #include <stdio.h>
;	#include <delay.h>
;	#include <string.h>
;
;
;
;void SELECT_Light(unsigned char *USER_SELECT);
;void Clear_Set();
;void CHK_Light();
;
;
;
;#include "DEFINE.c"
;/*************************************************************************************
;		01. DEFINE.c
;
;*************************************************************************************/
;
;#define F_CPU   20000000
;
;unsigned char		    UART0_DATA		=	0;
;char				    RS232_BUFF[10];
;unsigned char           NDX_232 		=	0;
;bit 				    RS232_FLAG  	=   0;
;bit 				    RS_Finish_Flag  =   0;
;
;unsigned char	        default_Color   =   0x03;	// Amber
;char                    rtnMsg[9]       =   {0x1B, 0x02, 0x52, 0x00, 0x00, 0x00, 0x00, 0x03, 0x0D};

	.DSEG
;
;//unsigned char UART_CNT      =   0;
;//unsigned char txCnt = 0;
;//unsigned char ERROR_STR[20];
;
;unsigned char       Tmr_Cnt         =   0;
;unsigned char       RS232_RS_Limit  =   6;      // 1 = 5ms, 2 = 10ms, 5 = 25ms
;#include "PORT_INIT.c"
;/**************************************************************************************
;
;		02. Ports initialization
;
;*************************************************************************************/
;
;void PORT_INIT()
; 0000 000F {

	.CSEG
_PORT_INIT:
; .FSTART _PORT_INIT
;		// Crystal Oscillator division factor: 1
;
;#pragma optsize-
;    CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	OUT  0x26,R30
;    CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
;#ifdef _OPTIMIZE_SIZE_
;#pragma optsize+
;#endif
;
;
;			// PORT
;			DDRA=(0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	OUT  0x1A,R30
;			PORTA=(0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
;
;
;			DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
;			PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
;
;			DDRD=(0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
;			PORTD=(0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
;
;
;			// USART initialization
;			// Communication Parameters: 8 Data, 1 Stop, No Parity
;			// USART Receiver: On
;			// USART Transmitter: On
;			// USART Mode: Asynchronous
;			// USART Baud Rate: 9600
;
;			// X-TAL 20MHz Setting
;			UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
;            UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
;            UCSRC=(0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(6)
	OUT  0x3,R30
;            UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
;            UBRRL=0x81;      // Crystal 20MHz Setting
	LDI  R30,LOW(129)
	OUT  0x9,R30
;
;
;            /* 8MHz Setting */  /*
;            UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
;            UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
;            UCSRC=(0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
;            UBRRH=0x00;
;            UBRRL=0x33;
;            */
;
;
;             // Timer/Counter 1 initialization
;            // Clock source: System Clock
;            // Clock value: 2500.000 kHz
;            // Mode: Normal top=0xFFFF
;            // OC1A output: Disconnected
;            // OC1B output: Disconnected
;            // Noise Canceler: Off
;            // Input Capture on Rising Edge
;            // Timer Period: 5 ms
;            // Timer1 Overflow Interrupt: On
;            // Input Capture Interrupt: Off
;            // Compare A Match Interrupt: Off
;            // Compare B Match Interrupt: Off
;
;            TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;            TCCR1B=(0<<ICNC1) | (1<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(66)
	OUT  0x2E,R30
;            TCNT1H=0xCF;
	RCALL SUBOPT_0x0
;            TCNT1L=0x2C;
;            ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
;            ICR1L=0x00;
	OUT  0x24,R30
;            OCR1AH=0x00;
	OUT  0x2B,R30
;            OCR1AL=0x00;
	OUT  0x2A,R30
;            OCR1BH=0x00;
	OUT  0x29,R30
;            OCR1BL=0x00;
	OUT  0x28,R30
;
;}
	RET
; .FEND
;#include "TMR.c"
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0010 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    // Reinitialize Timer1 value
;    //TCNT1H=0xCF2C >> 8;
;    //TCNT1L=0xCF2C & 0xff;
;    TCNT1H=0xCF;
	RCALL SUBOPT_0x0
;    TCNT1L=0x2C;
;
;    // Place your code here
;    if(RS232_FLAG)
	SBIC 0x13,0
;    {
;        Tmr_Cnt++;
	INC  R4
;    }
;
;    if(RS232_FLAG && (Tmr_Cnt >= RS232_RS_Limit))
	SBIS 0x13,0
	RJMP _0x6
	CP   R4,R7
	BRSH _0x7
_0x6:
	RJMP _0x5
_0x7:
;    {
;       Clear_Set();
	RCALL _Clear_Set
;    }
;
;}
_0x5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;#include "UART.c"
;	/********************************************************************
;
;		UART
;
;	********************************************************************/
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 16
;char rx_buffer[RX_BUFFER_SIZE];
;
;// This flag is set on USART Receiver buffer overflow
;//bit rx_buffer_overflow;
;
;
;void putchar0(char c)
; 0000 0011 {
;    while ((UCSRA & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
;    UDR=c;
;}
;
;
;void putString0(char *c)
;{
_putString0:
; .FSTART _putString0
;    unsigned char PcCnt = 0;
;
;
;    for(PcCnt = 0; PcCnt <= 8 ; PcCnt++)
	ST   -Y,R26
	ST   -Y,R17
;	*c -> Y+1
;	PcCnt -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0xC:
	CPI  R17,9
	BRSH _0xD
;    {
;        while ((UCSRA & DATA_REGISTER_EMPTY)==0);
_0xE:
	SBIS 0xB,5
	RJMP _0xE
;        UDR=c[PcCnt];
	MOV  R30,R17
	LDD  R26,Y+1
	ADD  R26,R30
	LD   R30,X
	OUT  0xC,R30
;    }
	SUBI R17,-1
	RJMP _0xC
_0xD:
;
;
;    /*
;    for(PcCnt= 0 ; PcCnt < (sizeof(c)/sizeof(c[0])); PcCnt++)
;    {
;        while ((UCSRA & DATA_REGISTER_EMPTY)==0);
;        UDR=c[PcCnt];
;    }
;     */
;}
	RJMP _0x2060001
; .FEND
;
;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
;{
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;		char status,data;
;		status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
;		data=UDR;
	IN   R16,12
;
;		if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x11
;		   {
;					UART0_DATA=data;
	MOV  R3,R16
;                    //putchar0(UART0_DATA);
;
;                    //  if(UART0_DATA =="STX" )                                          // UART0_DATA가 STX 일 경우....
;                    //  if(UART0_DATA == 0x02)
;                    if(UART0_DATA == 0x1B)
	LDI  R30,LOW(27)
	CP   R30,R3
	BRNE _0x12
;                      {
;                              Tmr_Cnt = 0;
	CLR  R4
;                              NDX_232 = 0;
	CLR  R2
;                              RS232_FLAG = 1;
	SBI  0x13,0
;                      }
;
;                      if(RS232_FLAG)
_0x12:
	SBIS 0x13,0
	RJMP _0x15
;                      {
;                            //if(UART0_DATA == 0x02)
;                              if(UART0_DATA == 0x1B)
	LDI  R30,LOW(27)
	CP   R30,R3
	BREQ _0x39
;                              {
;                                      RS232_BUFF[NDX_232] =   UART0_DATA;
;                              }
;                              else
;                              {
;                                      RS232_BUFF[++NDX_232] =   UART0_DATA;
	INC  R2
_0x39:
	MOV  R30,R2
	SUBI R30,-LOW(_RS232_BUFF)
	ST   Z,R3
;                              }
;
;
;                              //if(UART0_DATA ==  0x03 && NDX_232 == 4)
;                              if((UART0_DATA ==  0x0D && NDX_232 == 5) || (UART0_DATA == 0x0D && NDX_232 == 8))
	LDI  R30,LOW(13)
	CP   R30,R3
	BRNE _0x19
	LDI  R30,LOW(5)
	CP   R30,R2
	BREQ _0x1B
_0x19:
	LDI  R30,LOW(13)
	CP   R30,R3
	BRNE _0x1C
	LDI  R30,LOW(8)
	CP   R30,R2
	BREQ _0x1B
_0x1C:
	RJMP _0x18
_0x1B:
;                              {
;                                        RS_Finish_Flag = 1;
	SBI  0x13,1
;									  	//RS232_FLAG = 0;
;                                        //NDX_232 = 0;
;                              }	        // END of if(상태요청, 또는 조명 상태변경 일 경우)
;
;                      }	                // END of  if(RS232_FLAG)
_0x18:
;
;                    UART0_DATA = 0;
_0x15:
	CLR  R3
;
;	   }	        // END of if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
;}                       // END of 	interrupt [USART_RXC] void usart_rx_isr(void)
_0x11:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;
;void Clear_Set()
; 0000 0015 {
_Clear_Set:
; .FSTART _Clear_Set
; 0000 0016 	memset(RS232_BUFF,0x00,sizeof(RS232_BUFF));             //Buff 초기화
	LDI  R30,LOW(_RS232_BUFF)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	RCALL _memset
; 0000 0017 	RS_Finish_Flag = 0;
	CBI  0x13,1
; 0000 0018     RS232_FLAG = 0;
	CBI  0x13,0
; 0000 0019 	Tmr_Cnt = 0;
	CLR  R4
; 0000 001A     NDX_232 = 0;
	CLR  R2
; 0000 001B }
	RET
; .FEND
;
;
;
;void CHK_Light()
; 0000 0020 {
_CHK_Light:
; .FSTART _CHK_Light
; 0000 0021         unsigned char cnt = 0;
; 0000 0022 
; 0000 0023         rtnMsg[4] = PINB.0 ;   // PORTB.0(R) 을 읽어 rtnMsg[4]에 저장
	ST   -Y,R17
;	cnt -> R17
	LDI  R17,0
	LDI  R30,0
	SBIC 0x16,0
	LDI  R30,1
	__PUTB1MN _rtnMsg,4
; 0000 0024         rtnMsg[5] = PINB.1;   // PORTB.1(G) 을 읽어 rtnMsg[5]에 저장
	LDI  R30,0
	SBIC 0x16,1
	LDI  R30,1
	__PUTB1MN _rtnMsg,5
; 0000 0025         rtnMsg[6] = PINB.2;   // PORTB.2(B) 을 읽어 rtnMsg[6]에 저장
	LDI  R30,0
	SBIC 0x16,2
	LDI  R30,1
	__PUTB1MN _rtnMsg,6
; 0000 0026 
; 0000 0027 
; 0000 0028         for(cnt = 4 ; cnt <= 6 ; cnt++)
	LDI  R17,LOW(4)
_0x26:
	CPI  R17,7
	BRSH _0x27
; 0000 0029         {
; 0000 002A             if(rtnMsg[cnt])
	LDI  R26,LOW(_rtnMsg)
	ADD  R26,R17
	LD   R30,X
	CPI  R30,0
	BREQ _0x28
; 0000 002B             {
; 0000 002C                 rtnMsg[cnt] = 0xFF;
	LDI  R26,LOW(_rtnMsg)
	ADD  R26,R17
	LDI  R30,LOW(255)
	ST   X,R30
; 0000 002D             }
; 0000 002E 
; 0000 002F             //putchar0(rtnMsg[cnt]);
; 0000 0030         }
_0x28:
	SUBI R17,-1
	RJMP _0x26
_0x27:
; 0000 0031 
; 0000 0032         putString0(rtnMsg);    // 조명상태 전송
	LDI  R26,LOW(_rtnMsg)
	RCALL _putString0
; 0000 0033 }
	LD   R17,Y+
	RET
; .FEND
;
;void SELECT_Light(unsigned char *USER_SELECT)
; 0000 0036 {
_SELECT_Light:
; .FSTART _SELECT_Light
; 0000 0037         unsigned char PORT_DATA = 0;
; 0000 0038 
; 0000 0039         if(USER_SELECT[4]) PORT_DATA += 1;      // R Color
	ST   -Y,R26
	ST   -Y,R17
;	*USER_SELECT -> Y+1
;	PORT_DATA -> R17
	LDI  R17,0
	LDD  R30,Y+1
	LDD  R30,Z+4
	CPI  R30,0
	BREQ _0x29
	SUBI R17,-LOW(1)
; 0000 003A 
; 0000 003B         if(USER_SELECT[5]) PORT_DATA += 2;      // G Color
_0x29:
	LDD  R30,Y+1
	LDD  R30,Z+5
	CPI  R30,0
	BREQ _0x2A
	SUBI R17,-LOW(2)
; 0000 003C 
; 0000 003D         if(USER_SELECT[6]) PORT_DATA += 4;      // B Color
_0x2A:
	LDD  R30,Y+1
	LDD  R30,Z+6
	CPI  R30,0
	BREQ _0x2B
	SUBI R17,-LOW(4)
; 0000 003E 
; 0000 003F         PORTB = PORT_DATA;
_0x2B:
	OUT  0x18,R17
; 0000 0040 
; 0000 0041         //putchar0(PORT_DATA);
; 0000 0042 
; 0000 0043         CHK_Light();      // 조명상태 전송
	RCALL _CHK_Light
; 0000 0044 }
_0x2060001:
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;
;
;void main(void)
; 0000 0048 {
_main:
; .FSTART _main
; 0000 0049         unsigned char lcnt = 0;
; 0000 004A         PORT_INIT();
;	lcnt -> R17
	LDI  R17,0
	RCALL _PORT_INIT
; 0000 004B 
; 0000 004C         #asm("sei");         // 전체 인터럽트 허용
	sei
; 0000 004D 
; 0000 004E         PORTB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 004F         delay_ms(250);
	LDI  R26,LOW(250)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0050 
; 0000 0051         for(lcnt = 1; lcnt <= 8; lcnt++)
	LDI  R17,LOW(1)
_0x2D:
	CPI  R17,9
	BRSH _0x2E
; 0000 0052         {
; 0000 0053             PORTB = lcnt;
	OUT  0x18,R17
; 0000 0054             delay_ms(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0055         }
	SUBI R17,-1
	RJMP _0x2D
_0x2E:
; 0000 0056 
; 0000 0057         PORTB = default_Color;
	OUT  0x18,R5
; 0000 0058 
; 0000 0059 
; 0000 005A     while (1)
_0x2F:
; 0000 005B     {
; 0000 005C                  // Place your code here
; 0000 005D 				if(RS_Finish_Flag)
	SBIS 0x13,1
	RJMP _0x32
; 0000 005E 				{
; 0000 005F                     switch (RS232_BUFF[2])
	__GETB1MN _RS232_BUFF,2
	LDI  R31,0
; 0000 0060                     {
; 0000 0061                         case 0x53 :     // 상태요청
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x36
; 0000 0062                             CHK_Light();
	RCALL _CHK_Light
; 0000 0063                             break;
	RJMP _0x35
; 0000 0064 
; 0000 0065                         case 0x43 :    // 조명변경
_0x36:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x35
; 0000 0066                             SELECT_Light(RS232_BUFF);
	LDI  R26,LOW(_RS232_BUFF)
	RCALL _SELECT_Light
; 0000 0067                             break;
; 0000 0068                     };
_0x35:
; 0000 0069 
; 0000 006A                     Clear_Set();
	RCALL _Clear_Set
; 0000 006B 
; 0000 006C 				}
; 0000 006D 
; 0000 006E     }
_0x32:
	RJMP _0x2F
; 0000 006F }
_0x38:
	RJMP _0x38
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R26
    ld   r26,y
    tst  r26
    breq memset1
    clr  r31
    ldd  r30,y+2
    ldd  r22,y+1
memset0:
    st   z+,r22
    dec  r26
    brne memset0
memset1:
    ldd  r30,y+2
	ADIW R28,3
	RET
; .FEND

	.CSEG

	.DSEG
_RS232_BUFF:
	.BYTE 0xA
_rtnMsg:
	.BYTE 0x9

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(207)
	OUT  0x2D,R30
	LDI  R30,LOW(44)
	OUT  0x2C,R30
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

;END OF CODE MARKER
__END_OF_CODE:

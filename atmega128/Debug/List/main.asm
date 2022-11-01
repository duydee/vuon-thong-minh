
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 20.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _index=R5
	.DEF _flag_uart=R4
	.DEF _id=R7
	.DEF _trangthai=R6
	.DEF _gioon=R9
	.DEF _phuton=R8
	.DEF _giooff=R11
	.DEF _phutoff=R10
	.DEF _tx_wr_index0=R13
	.DEF _tx_rd_index0=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_MainMenu:
	.DB  0x0,0x0,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x4D,0x41,0x49,0x4E,0x20,0x4D,0x45,0x4E
	.DB  0x55,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x53,0x65,0x6E,0x73,0x6F,0x72,0x73
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_SensorMenu*2),HIGH(_SensorMenu*2),0x0,0x0,0x20
	.DB  0x20,0x41,0x63,0x74,0x75,0x61,0x74,0x6F
	.DB  0x72,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_ActuatorMenu*2),HIGH(_ActuatorMenu*2),0x0,0x0,0x20
	.DB  0x20,0x53,0x65,0x74,0x74,0x69,0x6E,0x67
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_SettingMenu*2),HIGH(_SettingMenu*2),0x0,0x0
_SensorMenu:
	.DB  0x0,LOW(_MainMenu*2),HIGH(_MainMenu*2),0x20,0x20,0x20,0x20,0x53
	.DB  0x45,0x4E,0x53,0x4F,0x52,0x20,0x4D,0x45
	.DB  0x4E,0x55,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x54,0x65,0x6D,0x70,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_TempMenu*2),HIGH(_TempMenu*2),0x0,0x0,0x20
	.DB  0x20,0x48,0x75,0x6D,0x69,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HumiMenu*2),HIGH(_HumiMenu*2),0x0,0x0,0x20
	.DB  0x20,0x4D,0x6F,0x72,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_MoreSensorMenu*2),HIGH(_MoreSensorMenu*2),0x0,0x0
_ActuatorMenu:
	.DB  0x0,LOW(_MainMenu*2),HIGH(_MainMenu*2),0x20,0x20,0x20,0x20,0x41
	.DB  0x43,0x54,0x55,0x41,0x54,0x4F,0x52,0x20
	.DB  0x4D,0x45,0x4E,0x55,0x20,0x20,0x0,0x20
	.DB  0x20,0x54,0x68,0x69,0x65,0x74,0x20,0x62
	.DB  0x69,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_ThietbiMenu*2),HIGH(_ThietbiMenu*2),0x0,0x0,0x20
	.DB  0x20,0x52,0x65,0x6C,0x61,0x79,0x73,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_RelayMenu*2),HIGH(_RelayMenu*2),0x0,0x0,0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_SettingMenu:
	.DB  0x0,LOW(_MainMenu*2),HIGH(_MainMenu*2),0x20,0x20,0x20,0x20,0x53
	.DB  0x45,0x54,0x54,0x49,0x4E,0x47,0x53,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x48,0x65,0x6E,0x20,0x47,0x69,0x6F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_SettingHengio*2),HIGH(_SettingHengio*2),0x0,0x0,0x20
	.DB  0x20,0x41,0x75,0x74,0x6F,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_Auto*2),HIGH(_Auto*2),0x0,0x0,0x20
	.DB  0x20,0x44,0x6F,0x6E,0x67,0x20,0x42,0x6F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_DongBo*2),HIGH(_DongBo*2),0x0,0x0
_TempMenu:
	.DB  0x0,LOW(_SensorMenu*2),HIGH(_SensorMenu*2),0x20,0x20,0x20,0x20,0x54
	.DB  0x45,0x4D,0x50,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_HumiMenu:
	.DB  0x1,LOW(_SensorMenu*2),HIGH(_SensorMenu*2),0x20,0x20,0x20,0x20,0x48
	.DB  0x55,0x4D,0x49,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_MoreSensorMenu:
	.DB  0x0,LOW(_SensorMenu*2),HIGH(_SensorMenu*2),0x20,0x20,0x20,0x20,0x53
	.DB  0x45,0x4E,0x53,0x4F,0x52,0x20,0x4D,0x45
	.DB  0x4E,0x55,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x44,0x6F,0x20,0x61,0x6D,0x20,0x64
	.DB  0x61,0x74,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_DoAmDatMenu*2),HIGH(_DoAmDatMenu*2),0x0,0x0,0x20
	.DB  0x20,0x43,0x61,0x6D,0x20,0x42,0x69,0x65
	.DB  0x6E,0x20,0x4D,0x75,0x61,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_CamBienMuaMenu*2),HIGH(_CamBienMuaMenu*2),0x0,0x0,0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_DoAmDatMenu:
	.DB  0x2,LOW(_MoreSensorMenu*2),HIGH(_MoreSensorMenu*2),0x20,0x20,0x20,0x20,0x44
	.DB  0x6F,0x20,0x61,0x6D,0x20,0x64,0x61,0x74
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_CamBienMuaMenu:
	.DB  0x3,LOW(_MoreSensorMenu*2),HIGH(_MoreSensorMenu*2),0x20,0x20,0x20,0x43,0x61
	.DB  0x6D,0x20,0x42,0x69,0x65,0x6E,0x20,0x4D
	.DB  0x75,0x61,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_ThietbiMenu:
	.DB  0x0,LOW(_ActuatorMenu*2),HIGH(_ActuatorMenu*2),0x20,0x20,0x20,0x20,0x54
	.DB  0x68,0x69,0x65,0x74,0x20,0x62,0x69,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x44,0x65,0x6E,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_DenMenu*2),HIGH(_DenMenu*2),0x0,0x0,0x20
	.DB  0x20,0x51,0x75,0x61,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_QuatMenu*2),HIGH(_QuatMenu*2),0x0,0x0,0x20
	.DB  0x20,0x42,0x6F,0x6D,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_BomMenu*2),HIGH(_BomMenu*2),0x0,0x0
_DenMenu:
	.DB  0x0,LOW(_ThietbiMenu*2),HIGH(_ThietbiMenu*2),0x20,0x20,0x20,0x20,0x44
	.DB  0x65,0x6E,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_DenKhu1Menu*2),HIGH(_DenKhu1Menu*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_DenKhu2Menu*2),HIGH(_DenKhu2Menu*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_DenKhu3Menu*2),HIGH(_DenKhu3Menu*2),0x0,0x0
_DenKhu1Menu:
	.DB  0x4,LOW(_DenMenu*2),HIGH(_DenMenu*2),0x20,0x20,0x20,0x20,0x44
	.DB  0x65,0x6E,0x20,0x4B,0x68,0x75,0x20,0x31
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_DenKhu2Menu:
	.DB  0x5,LOW(_DenMenu*2),HIGH(_DenMenu*2),0x20,0x20,0x20,0x20,0x44
	.DB  0x65,0x6E,0x20,0x4B,0x68,0x75,0x20,0x32
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_DenKhu3Menu:
	.DB  0x6,LOW(_DenMenu*2),HIGH(_DenMenu*2),0x20,0x20,0x20,0x20,0x44
	.DB  0x65,0x6E,0x20,0x4B,0x68,0x75,0x20,0x33
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_QuatMenu:
	.DB  0x0,LOW(_ThietbiMenu*2),HIGH(_ThietbiMenu*2),0x20,0x20,0x20,0x20,0x51
	.DB  0x75,0x61,0x74,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x31,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_QuatKhu1Menu*2),HIGH(_QuatKhu1Menu*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x32,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_QuatKhu2Menu*2),HIGH(_QuatKhu2Menu*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x33,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_QuatKhu3Menu*2),HIGH(_QuatKhu3Menu*2),0x0,0x0
_QuatKhu1Menu:
	.DB  0x7,LOW(_QuatMenu*2),HIGH(_QuatMenu*2),0x20,0x20,0x20,0x20,0x51
	.DB  0x75,0x61,0x74,0x20,0x4B,0x68,0x75,0x20
	.DB  0x31,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_QuatKhu2Menu:
	.DB  0x8,LOW(_QuatMenu*2),HIGH(_QuatMenu*2),0x20,0x20,0x20,0x20,0x51
	.DB  0x75,0x61,0x74,0x20,0x4B,0x68,0x75,0x20
	.DB  0x32,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_QuatKhu3Menu:
	.DB  0x9,LOW(_QuatMenu*2),HIGH(_QuatMenu*2),0x20,0x20,0x20,0x20,0x51
	.DB  0x75,0x61,0x74,0x20,0x4B,0x68,0x75,0x20
	.DB  0x33,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_BomMenu:
	.DB  0x0,LOW(_ThietbiMenu*2),HIGH(_ThietbiMenu*2),0x20,0x20,0x20,0x20,0x42
	.DB  0x6F,0x6D,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_BomKhu1Menu*2),HIGH(_BomKhu1Menu*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_BomKhu2Menu*2),HIGH(_BomKhu2Menu*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_BomKhu3Menu*2),HIGH(_BomKhu3Menu*2),0x0,0x0
_BomKhu1Menu:
	.DB  0xA,LOW(_BomMenu*2),HIGH(_BomMenu*2),0x20,0x20,0x20,0x20,0x42
	.DB  0x6F,0x6D,0x20,0x4B,0x68,0x75,0x20,0x31
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_BomKhu2Menu:
	.DB  0xB,LOW(_BomMenu*2),HIGH(_BomMenu*2),0x20,0x20,0x20,0x20,0x42
	.DB  0x6F,0x6D,0x20,0x4B,0x68,0x75,0x20,0x32
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_BomKhu3Menu:
	.DB  0xC,LOW(_BomMenu*2),HIGH(_BomMenu*2),0x20,0x20,0x20,0x20,0x42
	.DB  0x6F,0x6D,0x20,0x4B,0x68,0x75,0x20,0x33
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_RelayMenu:
	.DB  0x0,LOW(_ThietbiMenu*2),HIGH(_ThietbiMenu*2),0x20,0x20,0x20,0x20,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4E,0x68,0x6F,0x6D,0x20,0x31,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_RelayNhom1Menu*2),HIGH(_RelayNhom1Menu*2),0x0,0x0,0x20
	.DB  0x20,0x4E,0x68,0x6F,0x6D,0x20,0x32,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_RelayNhom2Menu*2),HIGH(_RelayNhom2Menu*2),0x0,0x0,0x20
	.DB  0x20,0x4E,0x68,0x6F,0x6D,0x20,0x33,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_RelayNhom3Menu*2),HIGH(_RelayNhom3Menu*2),0x0,0x0
_RelayNhom1Menu:
	.DB  0x0,LOW(_RelayMenu*2),HIGH(_RelayMenu*2),0x20,0x20,0x20,0x20,0x4E
	.DB  0x68,0x6F,0x6D,0x20,0x31,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x52,0x65,0x6C,0x61,0x79,0x20,0x31
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_Relay1Menu*2),HIGH(_Relay1Menu*2),0x0,0x0,0x20
	.DB  0x20,0x52,0x65,0x6C,0x61,0x79,0x20,0x32
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_Relay2Menu*2),HIGH(_Relay2Menu*2),0x0,0x0,0x20
	.DB  0x20,0x52,0x65,0x6C,0x61,0x79,0x20,0x33
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_Relay3Menu*2),HIGH(_Relay3Menu*2),0x0,0x0
_Relay1Menu:
	.DB  0xD,LOW(_RelayNhom1Menu*2),HIGH(_RelayNhom1Menu*2),0x20,0x20,0x20,0x20,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_Relay2Menu:
	.DB  0xE,LOW(_RelayNhom1Menu*2),HIGH(_RelayNhom1Menu*2),0x20,0x20,0x20,0x20,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_Relay3Menu:
	.DB  0xF,LOW(_RelayNhom1Menu*2),HIGH(_RelayNhom1Menu*2),0x20,0x20,0x20,0x20,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_RelayNhom2Menu:
	.DB  0x0,LOW(_RelayMenu*2),HIGH(_RelayMenu*2),0x20,0x20,0x20,0x20,0x4E
	.DB  0x68,0x6F,0x6D,0x20,0x32,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x52,0x65,0x6C,0x61,0x79,0x20,0x34
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_Relay4Menu*2),HIGH(_Relay4Menu*2),0x0,0x0,0x20
	.DB  0x20,0x52,0x65,0x6C,0x61,0x79,0x20,0x35
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_Relay5Menu*2),HIGH(_Relay5Menu*2),0x0,0x0,0x20
	.DB  0x20,0x52,0x65,0x6C,0x61,0x79,0x20,0x36
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_Relay6Menu*2),HIGH(_Relay6Menu*2),0x0,0x0
_Relay4Menu:
	.DB  0x10,LOW(_RelayNhom2Menu*2),HIGH(_RelayNhom2Menu*2),0x20,0x20,0x20,0x20,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x34,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_Relay5Menu:
	.DB  0x11,LOW(_RelayNhom2Menu*2),HIGH(_RelayNhom2Menu*2),0x20,0x20,0x20,0x20,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x35,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_Relay6Menu:
	.DB  0x12,LOW(_RelayNhom2Menu*2),HIGH(_RelayNhom2Menu*2),0x20,0x20,0x20,0x20,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x36,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_RelayNhom3Menu:
	.DB  0x0,LOW(_RelayMenu*2),HIGH(_RelayMenu*2),0x20,0x20,0x20,0x20,0x4E
	.DB  0x68,0x6F,0x6D,0x20,0x33,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x52,0x65,0x6C,0x61,0x79,0x20,0x37
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_Relay7Menu*2),HIGH(_Relay7Menu*2),0x0,0x0,0x20
	.DB  0x20,0x52,0x65,0x6C,0x61,0x79,0x20,0x38
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_Relay8Menu*2),HIGH(_Relay8Menu*2),0x0,0x0,0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_Relay7Menu:
	.DB  0x13,LOW(_RelayNhom3Menu*2),HIGH(_RelayNhom3Menu*2),0x20,0x20,0x20,0x20,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x37,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_Relay8Menu:
	.DB  0x14,LOW(_RelayNhom3Menu*2),HIGH(_RelayNhom3Menu*2),0x20,0x20,0x20,0x20,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x38,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsActivation),HIGH(_ActuatorsActivation),0x20
	.DB  0x20,0x4E,0x6F,0x6E,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_SettingHengio:
	.DB  0x0,LOW(_SettingMenu*2),HIGH(_SettingMenu*2),0x20,0x20,0x20,0x20,0x48
	.DB  0x65,0x6E,0x20,0x47,0x69,0x6F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x44,0x65,0x6E,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDen*2),HIGH(_HengioDen*2),0x0,0x0,0x20
	.DB  0x20,0x51,0x75,0x61,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuat*2),HIGH(_HengioQuat*2),0x0,0x0,0x20
	.DB  0x20,0x42,0x6F,0x6D,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBom*2),HIGH(_HengioBom*2),0x0,0x0
_HengioDen:
	.DB  0x0,LOW(_SettingHengio*2),HIGH(_SettingHengio*2),0x20,0x20,0x20,0x20,0x48
	.DB  0x65,0x6E,0x20,0x47,0x69,0x6F,0x20,0x44
	.DB  0x65,0x6E,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu1*2),HIGH(_HengioDenKhu1*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu2*2),HIGH(_HengioDenKhu2*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu3*2),HIGH(_HengioDenKhu3*2),0x0,0x0
_HengioQuat:
	.DB  0x0,LOW(_SettingHengio*2),HIGH(_SettingHengio*2),0x20,0x20,0x20,0x20,0x48
	.DB  0x65,0x6E,0x20,0x47,0x69,0x6F,0x20,0x51
	.DB  0x75,0x61,0x74,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu1*2),HIGH(_HengioQuatKhu1*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu2*2),HIGH(_HengioQuatKhu2*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu3*2),HIGH(_HengioQuatKhu3*2),0x0,0x0
_HengioBom:
	.DB  0x0,LOW(_SettingHengio*2),HIGH(_SettingHengio*2),0x20,0x20,0x20,0x20,0x48
	.DB  0x65,0x6E,0x20,0x47,0x69,0x6F,0x20,0x42
	.DB  0x6F,0x6D,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu1*2),HIGH(_HengioBomKhu1*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu2*2),HIGH(_HengioBomKhu2*2),0x0,0x0,0x20
	.DB  0x20,0x4B,0x68,0x75,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu3*2),HIGH(_HengioBomKhu3*2),0x0,0x0
_HengioDenKhu1:
	.DB  0x0,LOW(_HengioDen*2),HIGH(_HengioDen*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4B,0x68,0x75,0x20,0x31,0x20,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu1Lan1*2),HIGH(_HengioDenKhu1Lan1*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu1Lan2*2),HIGH(_HengioDenKhu1Lan2*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu1Lan3*2),HIGH(_HengioDenKhu1Lan3*2),0x0,0x0
_HengioDenKhu1Lan1:
	.DB  0x0,LOW(_HengioDenKhu1*2),HIGH(_HengioDenKhu1*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x31,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioDenKhu1Lan2:
	.DB  0x1,LOW(_HengioDenKhu1*2),HIGH(_HengioDenKhu1*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x32,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioDenKhu1Lan3:
	.DB  0x2,LOW(_HengioDenKhu1*2),HIGH(_HengioDenKhu1*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x33,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioDenKhu2:
	.DB  0x0,LOW(_HengioDen*2),HIGH(_HengioDen*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4B,0x68,0x75,0x20,0x32,0x20,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu2Lan1*2),HIGH(_HengioDenKhu2Lan1*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu2Lan2*2),HIGH(_HengioDenKhu2Lan2*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu2Lan3*2),HIGH(_HengioDenKhu2Lan3*2),0x0,0x0
_HengioDenKhu2Lan1:
	.DB  0x3,LOW(_HengioDenKhu2*2),HIGH(_HengioDenKhu2*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x31,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioDenKhu2Lan2:
	.DB  0x4,LOW(_HengioDenKhu2*2),HIGH(_HengioDenKhu2*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x32,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioDenKhu2Lan3:
	.DB  0x5,LOW(_HengioDenKhu2*2),HIGH(_HengioDenKhu2*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x33,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioDenKhu3:
	.DB  0x0,LOW(_HengioDen*2),HIGH(_HengioDen*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4B,0x68,0x75,0x20,0x33,0x20,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu3Lan1*2),HIGH(_HengioDenKhu3Lan1*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu3Lan2*2),HIGH(_HengioDenKhu3Lan2*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioDenKhu3Lan3*2),HIGH(_HengioDenKhu3Lan3*2),0x0,0x0
_HengioDenKhu3Lan1:
	.DB  0x6,LOW(_HengioDenKhu3*2),HIGH(_HengioDenKhu3*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x31,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioDenKhu3Lan2:
	.DB  0x7,LOW(_HengioDenKhu3*2),HIGH(_HengioDenKhu3*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x32,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioDenKhu3Lan3:
	.DB  0x8,LOW(_HengioDenKhu3*2),HIGH(_HengioDenKhu3*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x33,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioQuatKhu1:
	.DB  0x0,LOW(_HengioQuat*2),HIGH(_HengioQuat*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4B,0x68,0x75,0x20,0x31,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu1Lan1*2),HIGH(_HengioQuatKhu1Lan1*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu1Lan2*2),HIGH(_HengioQuatKhu1Lan2*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu1Lan3*2),HIGH(_HengioQuatKhu1Lan3*2),0x0,0x0
_HengioQuatKhu1Lan1:
	.DB  0x9,LOW(_HengioQuatKhu1*2),HIGH(_HengioQuatKhu1*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioQuatKhu1Lan2:
	.DB  0xA,LOW(_HengioQuatKhu1*2),HIGH(_HengioQuatKhu1*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioQuatKhu1Lan3:
	.DB  0xB,LOW(_HengioQuatKhu1*2),HIGH(_HengioQuatKhu1*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioQuatKhu2:
	.DB  0x0,LOW(_HengioQuat*2),HIGH(_HengioQuat*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4B,0x68,0x75,0x20,0x32,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu2Lan1*2),HIGH(_HengioQuatKhu2Lan1*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu2Lan2*2),HIGH(_HengioQuatKhu2Lan2*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu2Lan3*2),HIGH(_HengioQuatKhu2Lan3*2),0x0,0x0
_HengioQuatKhu2Lan1:
	.DB  0xC,LOW(_HengioQuatKhu2*2),HIGH(_HengioQuatKhu2*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioQuatKhu2Lan2:
	.DB  0xD,LOW(_HengioQuatKhu2*2),HIGH(_HengioQuatKhu2*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioQuatKhu2Lan3:
	.DB  0xE,LOW(_HengioQuatKhu2*2),HIGH(_HengioQuatKhu2*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioQuatKhu3:
	.DB  0x0,LOW(_HengioQuat*2),HIGH(_HengioQuat*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4B,0x68,0x75,0x20,0x33,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu3Lan1*2),HIGH(_HengioQuatKhu3Lan1*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu3Lan2*2),HIGH(_HengioQuatKhu3Lan2*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioQuatKhu3Lan3*2),HIGH(_HengioQuatKhu3Lan3*2),0x0,0x0
_HengioQuatKhu3Lan1:
	.DB  0xF,LOW(_HengioQuatKhu3*2),HIGH(_HengioQuatKhu3*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioQuatKhu3Lan2:
	.DB  0x10,LOW(_HengioQuatKhu3*2),HIGH(_HengioQuatKhu3*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioQuatKhu3Lan3:
	.DB  0x11,LOW(_HengioQuatKhu3*2),HIGH(_HengioQuatKhu3*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioBomKhu1:
	.DB  0x0,LOW(_HengioBom*2),HIGH(_HengioBom*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4B,0x68,0x75,0x20,0x31,0x20,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu1Lan1*2),HIGH(_HengioBomKhu1Lan1*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu1Lan2*2),HIGH(_HengioBomKhu1Lan2*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu1Lan3*2),HIGH(_HengioBomKhu1Lan3*2),0x0,0x0
_HengioBomKhu1Lan1:
	.DB  0x12,LOW(_HengioBomKhu1*2),HIGH(_HengioBomKhu1*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x31,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioBomKhu1Lan2:
	.DB  0x13,LOW(_HengioBomKhu1*2),HIGH(_HengioBomKhu1*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x32,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioBomKhu1Lan3:
	.DB  0x14,LOW(_HengioBomKhu1*2),HIGH(_HengioBomKhu1*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x33,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioBomKhu2:
	.DB  0x0,LOW(_HengioBom*2),HIGH(_HengioBom*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4B,0x68,0x75,0x20,0x32,0x20,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu2Lan1*2),HIGH(_HengioBomKhu2Lan1*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu2Lan2*2),HIGH(_HengioBomKhu2Lan2*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu2Lan3*2),HIGH(_HengioBomKhu2Lan3*2),0x0,0x0
_HengioBomKhu2Lan1:
	.DB  0x15,LOW(_HengioBomKhu2*2),HIGH(_HengioBomKhu2*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x31,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioBomKhu2Lan2:
	.DB  0x16,LOW(_HengioBomKhu2*2),HIGH(_HengioBomKhu2*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x32,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioBomKhu2Lan3:
	.DB  0x17,LOW(_HengioBomKhu2*2),HIGH(_HengioBomKhu2*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x33,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioBomKhu3:
	.DB  0x0,LOW(_HengioBom*2),HIGH(_HengioBom*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4B,0x68,0x75,0x20,0x33,0x20,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x31,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu3Lan1*2),HIGH(_HengioBomKhu3Lan1*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x32,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu3Lan2*2),HIGH(_HengioBomKhu3Lan2*2),0x0,0x0,0x20
	.DB  0x20,0x4C,0x61,0x6E,0x20,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_HengioBomKhu3Lan3*2),HIGH(_HengioBomKhu3Lan3*2),0x0,0x0
_HengioBomKhu3Lan1:
	.DB  0x18,LOW(_HengioBomKhu3*2),HIGH(_HengioBomKhu3*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x31,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioBomKhu3Lan2:
	.DB  0x19,LOW(_HengioBomKhu3*2),HIGH(_HengioBomKhu3*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x32,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_HengioBomKhu3Lan3:
	.DB  0x1A,LOW(_HengioBomKhu3*2),HIGH(_HengioBomKhu3*2),0x20,0x48,0x65,0x6E,0x20
	.DB  0x47,0x69,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x4C,0x61,0x6E,0x20,0x33,0x20,0x0,0x20
	.DB  0x20,0x47,0x69,0x6F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x50,0x68,0x75,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x44,0x65,0x6C
	.DB  0x65,0x74,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDelete),HIGH(_ActuatorsDelete)
_Auto:
	.DB  0x0,LOW(_SettingMenu*2),HIGH(_SettingMenu*2),0x20,0x20,0x20,0x20,0x41
	.DB  0x75,0x74,0x6F,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x41,0x75,0x74,0x6F,0x20,0x44,0x65
	.DB  0x6E,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_AutoDen*2),HIGH(_AutoDen*2),0x0,0x0,0x20
	.DB  0x20,0x41,0x75,0x74,0x6F,0x20,0x51,0x75
	.DB  0x61,0x74,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_AutoQuat*2),HIGH(_AutoQuat*2),0x0,0x0,0x20
	.DB  0x20,0x41,0x75,0x74,0x6F,0x20,0x42,0x6F
	.DB  0x6D,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_AutoBom*2),HIGH(_AutoBom*2),0x0,0x0
_AutoDen:
	.DB  0x15,LOW(_Auto*2),HIGH(_Auto*2),0x20,0x20,0x20,0x20,0x41
	.DB  0x75,0x74,0x6F,0x20,0x44,0x65,0x6E,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_AutoON),HIGH(_AutoON),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_AutoOFF),HIGH(_AutoOFF),0x20
	.DB  0x20,0x54,0x72,0x61,0x6E,0x67,0x20,0x54
	.DB  0x68,0x61,0x69,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_AutoQuat:
	.DB  0x16,LOW(_Auto*2),HIGH(_Auto*2),0x20,0x20,0x20,0x20,0x41
	.DB  0x75,0x74,0x6F,0x20,0x51,0x75,0x61,0x74
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_AutoON),HIGH(_AutoON),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_AutoOFF),HIGH(_AutoOFF),0x20
	.DB  0x20,0x54,0x72,0x61,0x6E,0x67,0x20,0x54
	.DB  0x68,0x61,0x69,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_AutoBom:
	.DB  0x17,LOW(_Auto*2),HIGH(_Auto*2),0x20,0x20,0x20,0x20,0x41
	.DB  0x75,0x74,0x6F,0x20,0x42,0x6F,0x6D,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x4F,0x4E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_AutoON),HIGH(_AutoON),0x20
	.DB  0x20,0x4F,0x46,0x46,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_AutoOFF),HIGH(_AutoOFF),0x20
	.DB  0x20,0x54,0x72,0x61,0x6E,0x67,0x20,0x54
	.DB  0x68,0x61,0x69,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0
_DongBo:
	.DB  0x0,LOW(_SettingMenu*2),HIGH(_SettingMenu*2),0x20,0x20,0x20,0x20,0x44
	.DB  0x6F,0x6E,0x67,0x20,0x42,0x6F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x44,0x6F,0x6E,0x67,0x20,0x42,0x6F
	.DB  0x20,0x54,0x68,0x69,0x65,0x74,0x20,0x42
	.DB  0x69,0x20,0x0,0x0,0x0,LOW(_ActuatorsDongBoThietBi),HIGH(_ActuatorsDongBoThietBi),0x20
	.DB  0x20,0x44,0x6F,0x6E,0x67,0x20,0x42,0x6F
	.DB  0x20,0x48,0x65,0x6E,0x20,0x47,0x69,0x6F
	.DB  0x20,0x20,0x0,0x0,0x0,LOW(_ActuatorsDongBoHenGio),HIGH(_ActuatorsDongBoHenGio),0x20
	.DB  0x20,0x48,0x75,0x6F,0x6E,0x67,0x20,0x44
	.DB  0x61,0x6E,0x20,0x44,0x6F,0x6E,0x67,0x20
	.DB  0x42,0x6F,0x0,LOW(_HuongDanDongBo*2),HIGH(_HuongDanDongBo*2),0x0,0x0
_HuongDanDongBo:
	.DB  0x0,LOW(_DongBo*2),HIGH(_DongBo*2),0x20,0x20,0x48,0x75,0x6F
	.DB  0x6E,0x67,0x20,0x44,0x61,0x6E,0x20,0x44
	.DB  0x6F,0x6E,0x67,0x20,0x42,0x6F,0x0,0x20
	.DB  0x20,0x44,0x65,0x6E,0x20,0x44,0x6F,0x6E
	.DB  0x67,0x20,0x42,0x6F,0x20,0x54,0x61,0x74
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x6C,0x61,0x20,0x44,0x6F,0x6E,0x67
	.DB  0x20,0x42,0x6F,0x20,0x58,0x6F,0x6E,0x67
	.DB  0x20,0x20,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,LOW(_DongBo*2),HIGH(_DongBo*2),0x0,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x61:
	.DB  0x37
_0x62:
	.DB  0x1
_0x0:
	.DB  0x7B,0x22,0x74,0x79,0x70,0x65,0x22,0x3A
	.DB  0x25,0x64,0x2C,0x22,0x69,0x64,0x22,0x3A
	.DB  0x25,0x64,0x2C,0x22,0x73,0x74,0x61,0x74
	.DB  0x75,0x73,0x22,0x3A,0x25,0x64,0x7D,0xD
	.DB  0xA,0x0,0x7B,0x22,0x74,0x79,0x70,0x65
	.DB  0x22,0x3A,0x25,0x64,0x7D,0xD,0xA,0x0
	.DB  0x7B,0x22,0x74,0x79,0x70,0x65,0x22,0x3A
	.DB  0x25,0x64,0x2C,0x22,0x73,0x74,0x61,0x74
	.DB  0x75,0x73,0x22,0x3A,0x25,0x64,0x7D,0xD
	.DB  0xA,0x0,0x7B,0x22,0x74,0x79,0x70,0x65
	.DB  0x22,0x3A,0x25,0x64,0x2C,0x22,0x69,0x64
	.DB  0x22,0x3A,0x25,0x64,0x2C,0x22,0x67,0x69
	.DB  0x6F,0x22,0x3A,0x25,0x64,0x2C,0x22,0x70
	.DB  0x68,0x75,0x74,0x22,0x3A,0x25,0x64,0x7D
	.DB  0xD,0xA,0x0,0x7B,0x22,0x74,0x79,0x70
	.DB  0x65,0x22,0x3A,0x25,0x64,0x2C,0x22,0x69
	.DB  0x64,0x22,0x3A,0x25,0x64,0x7D,0xD,0xA
	.DB  0x0,0x20,0x4F,0x4E,0x20,0x20,0x48,0x3A
	.DB  0x25,0x64,0x2C,0x20,0x4D,0x3A,0x25,0x64
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x4F,0x46
	.DB  0x46,0x20,0x48,0x3A,0x25,0x64,0x2C,0x20
	.DB  0x4D,0x3A,0x25,0x64,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x54,0x72,0x61,0x6E,0x67
	.DB  0x20,0x54,0x68,0x61,0x69,0x3A,0x20,0x4F
	.DB  0x46,0x46,0x20,0x20,0x0,0x20,0x20,0x54
	.DB  0x72,0x61,0x6E,0x67,0x20,0x54,0x68,0x61
	.DB  0x69,0x3A,0x20,0x4F,0x4E,0x20,0x20,0x20
	.DB  0x0,0x3E,0x0,0x20,0x20,0x54,0x69,0x6D
	.DB  0x65,0x3A,0x20,0x25,0x32,0x64,0x3A,0x25
	.DB  0x30,0x32,0x64,0x3A,0x25,0x30,0x32,0x64
	.DB  0x20,0x20,0x20,0x0,0x20,0x54,0x68,0x75
	.DB  0x20,0x25,0x64,0x2C,0x25,0x32,0x64,0x2F
	.DB  0x25,0x30,0x32,0x64,0x2F,0x25,0x64,0x20
	.DB  0x20,0x20,0x0,0x20,0x54,0x3A,0x20,0x25
	.DB  0x64,0x25,0x64,0x2E,0x30,0x20,0x43,0x20
	.DB  0x20,0x48,0x3A,0x20,0x25,0x64,0x2E,0x25
	.DB  0x64,0x20,0x0,0x20,0x44,0x41,0x44,0x3A
	.DB  0x25,0x64,0x20,0x2C,0x4B,0x48,0x4F,0x4E
	.DB  0x47,0x20,0x4D,0x55,0x41,0x20,0x0,0x20
	.DB  0x44,0x41,0x44,0x3A,0x25,0x64,0x20,0x2C
	.DB  0x20,0x4D,0x55,0x41,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x7B,0x22,0x74,0x79,0x70
	.DB  0x65,0x22,0x3A,0x25,0x64,0x2C,0x22,0x74
	.DB  0x65,0x6D,0x70,0x22,0x3A,0x25,0x64,0x2C
	.DB  0x22,0x68,0x75,0x6D,0x69,0x22,0x3A,0x25
	.DB  0x64,0x2C,0x22,0x64,0x61,0x64,0x22,0x3A
	.DB  0x25,0x64,0x2C,0x22,0x63,0x62,0x6D,0x75
	.DB  0x61,0x22,0x3A,0x25,0x64,0x7D,0xD,0xA
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _DoAmDat
	.DW  _0x61*2

	.DW  0x01
	.DW  _CamBienMua
	.DW  _0x62*2

	.DW  0x14
	.DW  _0x10B
	.DW  _0x0*2+177

	.DW  0x14
	.DW  _0x10B+20
	.DW  _0x0*2+197

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
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

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include "main.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "./lib/port.h"
;#include "./lib/userdef.h"
;#include "./lib/menu.h"

	.CSEG
_ActuatorsDelete:
; .FSTART _ActuatorsDelete
	RET
; .FEND
_ActuatorsActivation:
; .FSTART _ActuatorsActivation
	ST   -Y,R26
;	Device -> Y+1
;	Status -> Y+0
	CALL SUBOPT_0x0
	LDD  R30,Y+7
	CALL SUBOPT_0x1
	LDD  R30,Y+10
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	LDD  R30,Y+1
	CALL SUBOPT_0x3
	BRNE _0x6
	LD   R30,Y
	CALL SUBOPT_0x4
	RJMP _0x5
_0x6:
	SBIW R30,0
	BRNE _0x7
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	RJMP _0x5
_0x7:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8
	RJMP _0x5
_0x8:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x9
	RJMP _0x5
_0x9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xA
	LD   R30,Y
	CALL SUBOPT_0x7
	RJMP _0x5
_0xA:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
	RJMP _0x5
_0xB:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xC
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	RJMP _0x5
_0xC:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xD
	LD   R30,Y
	CALL SUBOPT_0xB
	RJMP _0x5
_0xD:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xE
	CALL SUBOPT_0x5
	CALL SUBOPT_0xC
	RJMP _0x5
_0xE:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xF
	CALL SUBOPT_0x9
	CALL SUBOPT_0xD
	RJMP _0x5
_0xF:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x10
	LD   R30,Y
	CALL SUBOPT_0xE
	RJMP _0x5
_0x10:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x11
	CALL SUBOPT_0x5
	CALL SUBOPT_0xF
	RJMP _0x5
_0x11:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x12
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10
	RJMP _0x5
_0x12:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x13
	LD   R30,Y
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_Relays
	ANDI R30,0xFE
	RJMP _0x164
_0x13:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x14
	CALL SUBOPT_0x5
	LDS  R30,_Relays
	ANDI R30,0xFD
	RJMP _0x164
_0x14:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x15
	CALL SUBOPT_0x9
	LDS  R30,_Relays
	ANDI R30,0xFB
	RJMP _0x164
_0x15:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x16
	LD   R30,Y
	CALL SUBOPT_0x11
	LDS  R30,_Relays
	ANDI R30,0XF7
	RJMP _0x164
_0x16:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x17
	LD   R30,Y
	CALL SUBOPT_0x12
	RJMP _0x164
_0x17:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x18
	LD   R30,Y
	CALL SUBOPT_0x13
	RJMP _0x164
_0x18:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x19
	LD   R30,Y
	CALL SUBOPT_0x14
	RJMP _0x164
_0x19:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x5
	LD   R30,Y
	CALL SUBOPT_0x15
_0x164:
	OR   R30,R0
	STS  _Relays,R30
_0x5:
	LDS  R30,_Relays
	STS  4352,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	RJMP _0x20A0007
; .FEND
_ActuatorsDongBoThietBi:
; .FSTART _ActuatorsDongBoThietBi
	ST   -Y,R26
;	Device -> Y+1
;	Status -> Y+0
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	RJMP _0x20A0007
; .FEND
_ActuatorsDongBoHenGio:
; .FSTART _ActuatorsDongBoHenGio
	ST   -Y,R26
;	Device -> Y+1
;	Status -> Y+0
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1B
	RJMP _0x20A0007
; .FEND
_AutoON:
; .FSTART _AutoON
	ST   -Y,R26
;	Device -> Y+1
;	Status -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0x15)
	BRNE _0x1F
	LDI  R30,LOW(1)
	STS  _flagAutoDen,R30
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	RJMP _0x165
_0x1F:
	LDD  R26,Y+1
	CPI  R26,LOW(0x16)
	BRNE _0x21
	LDI  R30,LOW(1)
	STS  _flagAutoQuat,R30
	CALL SUBOPT_0x0
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	CALL SUBOPT_0x0
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
	CALL SUBOPT_0x0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x22
	RJMP _0x165
_0x21:
	LDD  R26,Y+1
	CPI  R26,LOW(0x17)
	BRNE _0x23
	LDI  R30,LOW(1)
	STS  _flagAutoBom,R30
	CALL SUBOPT_0x0
	CALL SUBOPT_0x24
	CALL SUBOPT_0x21
	CALL SUBOPT_0x0
	CALL SUBOPT_0x25
	CALL SUBOPT_0x21
	CALL SUBOPT_0x0
	CALL SUBOPT_0x26
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x23
_0x165:
	CALL __PUTPARD1
	__GETD1N 0x1
	CALL SUBOPT_0x27
_0x23:
	RJMP _0x20A0007
; .FEND
_AutoOFF:
; .FSTART _AutoOFF
	ST   -Y,R26
;	Device -> Y+1
;	Status -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0x15)
	BRNE _0x24
	LDI  R30,LOW(0)
	STS  _flagAutoDen,R30
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x28
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x28
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	RJMP _0x166
_0x24:
	LDD  R26,Y+1
	CPI  R26,LOW(0x16)
	BRNE _0x26
	LDI  R30,LOW(0)
	STS  _flagAutoQuat,R30
	CALL SUBOPT_0x0
	CALL SUBOPT_0x20
	CALL SUBOPT_0x29
	CALL SUBOPT_0x0
	CALL SUBOPT_0x22
	CALL SUBOPT_0x29
	CALL SUBOPT_0x0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x29
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x22
	RJMP _0x166
_0x26:
	LDD  R26,Y+1
	CPI  R26,LOW(0x17)
	BRNE _0x28
	LDI  R30,LOW(0)
	STS  _flagAutoBom,R30
	CALL SUBOPT_0x0
	CALL SUBOPT_0x24
	CALL SUBOPT_0x29
	CALL SUBOPT_0x0
	CALL SUBOPT_0x25
	CALL SUBOPT_0x29
	CALL SUBOPT_0x0
	CALL SUBOPT_0x26
	CALL SUBOPT_0x29
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x23
_0x166:
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL SUBOPT_0x27
_0x28:
_0x20A0007:
	ADIW R28,2
	RET
; .FEND
;#include "./lib/lcd20x4.h"
;#include "./lib/dht11.h"
;#include "./lib/uart0.h"
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	ST   -Y,R17
;	data -> R17
	IN   R17,12
	CPI  R17,10
	BRNE _0x29
	LDI  R30,LOW(1)
	MOV  R4,R30
	CLR  R5
	RJMP _0x2A
_0x29:
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R17
	INC  R5
_0x2A:
	LD   R17,Y+
	RJMP _0x173
; .FEND
_uart_handler:
; .FSTART _uart_handler
	TST  R4
	BRNE PC+2
	RJMP _0x2B
	__GETB1MN _rx_buffer,1
	CALL SUBOPT_0x2A
	__GETB1MN _rx_buffer,2
	ADD  R26,R30
	SUBI R26,LOW(48)
	MOV  R7,R26
	LDS  R30,_rx_buffer
	LDI  R31,0
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x2F
	__GETB1MN _rx_buffer,3
	SUBI R30,LOW(48)
	MOV  R6,R30
	LDI  R30,LOW(20)
	CP   R30,R7
	BRNE _0x30
	SBI  0x12,4
	IN   R30,0x37
	ORI  R30,4
	OUT  0x37,R30
_0x30:
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,0
	BRNE _0x36
	STS  _arrStatuTB,R6
	MOV  R30,R6
	CALL SUBOPT_0x4
	CALL SUBOPT_0x19
	RJMP _0x35
_0x36:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x37
	__PUTBMRN _arrStatuTB,1,6
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x6
	CALL SUBOPT_0x19
	RJMP _0x35
_0x37:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x38
	__PUTBMRN _arrStatuTB,2,6
	CALL SUBOPT_0x2C
	LDS  R30,_Sensors
	ANDI R30,0xFB
	OR   R30,R0
	CALL SUBOPT_0x2D
	RJMP _0x35
_0x38:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x39
	__PUTBMRN _arrStatuTB,3,6
	MOV  R30,R6
	CALL SUBOPT_0x11
	LDS  R30,_Sensors
	ANDI R30,0XF7
	OR   R30,R0
	CALL SUBOPT_0x2D
	RJMP _0x35
_0x39:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3A
	__PUTBMRN _arrStatuTB,4,6
	MOV  R30,R6
	CALL SUBOPT_0x7
	CALL SUBOPT_0x16
	RJMP _0x35
_0x3A:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x3B
	__PUTBMRN _arrStatuTB,5,6
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x8
	CALL SUBOPT_0x16
	RJMP _0x35
_0x3B:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x3C
	__PUTBMRN _arrStatuTB,6,6
	CALL SUBOPT_0x2C
	CALL SUBOPT_0xA
	CALL SUBOPT_0x16
	RJMP _0x35
_0x3C:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x3D
	__PUTBMRN _arrStatuTB,7,6
	MOV  R30,R6
	CALL SUBOPT_0xB
	CALL SUBOPT_0x17
	RJMP _0x35
_0x3D:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x3E
	__PUTBMRN _arrStatuTB,8,6
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xC
	CALL SUBOPT_0x17
	RJMP _0x35
_0x3E:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x3F
	__PUTBMRN _arrStatuTB,9,6
	CALL SUBOPT_0x2C
	CALL SUBOPT_0xD
	CALL SUBOPT_0x17
	RJMP _0x35
_0x3F:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x40
	__PUTBMRN _arrStatuTB,10,6
	MOV  R30,R6
	CALL SUBOPT_0xE
	CALL SUBOPT_0x18
	RJMP _0x35
_0x40:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x41
	__PUTBMRN _arrStatuTB,11,6
	CALL SUBOPT_0x2B
	CALL SUBOPT_0xF
	CALL SUBOPT_0x18
	RJMP _0x35
_0x41:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x42
	__PUTBMRN _arrStatuTB,12,6
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x10
	CALL SUBOPT_0x18
	RJMP _0x35
_0x42:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x43
	__PUTBMRN _arrStatuTB,13,6
	MOV  R30,R6
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_Relays
	ANDI R30,0xFE
	RJMP _0x167
_0x43:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x44
	__PUTBMRN _arrStatuTB,14,6
	CALL SUBOPT_0x2B
	LDS  R30,_Relays
	ANDI R30,0xFD
	RJMP _0x167
_0x44:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x45
	__PUTBMRN _arrStatuTB,15,6
	CALL SUBOPT_0x2C
	LDS  R30,_Relays
	ANDI R30,0xFB
	RJMP _0x167
_0x45:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x46
	__PUTBMRN _arrStatuTB,16,6
	MOV  R30,R6
	CALL SUBOPT_0x11
	LDS  R30,_Relays
	ANDI R30,0XF7
	RJMP _0x167
_0x46:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x47
	__PUTBMRN _arrStatuTB,17,6
	MOV  R30,R6
	CALL SUBOPT_0x12
	RJMP _0x167
_0x47:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x48
	__PUTBMRN _arrStatuTB,18,6
	MOV  R30,R6
	CALL SUBOPT_0x13
	RJMP _0x167
_0x48:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x49
	__PUTBMRN _arrStatuTB,19,6
	MOV  R30,R6
	CALL SUBOPT_0x14
	RJMP _0x167
_0x49:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x35
	__PUTBMRN _arrStatuTB,20,6
	MOV  R30,R6
	CALL SUBOPT_0x15
_0x167:
	OR   R30,R0
	STS  _Relays,R30
	STS  4352,R30
_0x35:
	RJMP _0x2E
_0x2F:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0x4B
	__GETB1MN _rx_buffer,3
	CALL SUBOPT_0x2A
	__GETB1MN _rx_buffer,4
	ADD  R26,R30
	SUBI R26,LOW(48)
	MOV  R9,R26
	__GETB1MN _rx_buffer,5
	CALL SUBOPT_0x2A
	__GETB1MN _rx_buffer,6
	ADD  R26,R30
	SUBI R26,LOW(48)
	MOV  R8,R26
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_arrGioOn)
	SBCI R31,HIGH(-_arrGioOn)
	ST   Z,R9
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_arrPhutOn)
	SBCI R31,HIGH(-_arrPhutOn)
	ST   Z,R8
	RJMP _0x2E
_0x4B:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0x4C
	LDI  R30,LOW(26)
	CP   R30,R7
	BRNE _0x4D
	SBI  0x12,4
	IN   R30,0x37
	ORI  R30,4
	OUT  0x37,R30
_0x4D:
	__GETB1MN _rx_buffer,3
	CALL SUBOPT_0x2A
	__GETB1MN _rx_buffer,4
	ADD  R26,R30
	SUBI R26,LOW(48)
	MOV  R11,R26
	__GETB1MN _rx_buffer,5
	CALL SUBOPT_0x2A
	__GETB1MN _rx_buffer,6
	ADD  R26,R30
	SUBI R26,LOW(48)
	MOV  R10,R26
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_arrGioOff)
	SBCI R31,HIGH(-_arrGioOff)
	ST   Z,R11
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_arrPhutOff)
	SBCI R31,HIGH(-_arrPhutOff)
	ST   Z,R10
	RJMP _0x2E
_0x4C:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0x50
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_arrGioOn)
	SBCI R31,HIGH(-_arrGioOn)
	CALL SUBOPT_0x2E
	SUBI R30,LOW(-_arrPhutOn)
	SBCI R31,HIGH(-_arrPhutOn)
	CALL SUBOPT_0x2E
	SUBI R30,LOW(-_arrGioOff)
	SBCI R31,HIGH(-_arrGioOff)
	CALL SUBOPT_0x2E
	SUBI R30,LOW(-_arrPhutOff)
	SBCI R31,HIGH(-_arrPhutOff)
	LDI  R26,LOW(70)
	STD  Z+0,R26
	RJMP _0x2E
_0x50:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0x51
	CALL SUBOPT_0x2F
	__PUTBMRN _arrStatuTB,4,6
	__PUTBMRN _arrStatuTB,5,6
	__PUTBMRN _arrStatuTB,6,6
	__POINTW2MN _arrStatuTB,21
	MOV  R30,R6
	ST   X,R30
	STS  _flagAutoDen,R30
	RJMP _0x2E
_0x51:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0x52
	CALL SUBOPT_0x2F
	__PUTBMRN _arrStatuTB,7,6
	__PUTBMRN _arrStatuTB,8,6
	__PUTBMRN _arrStatuTB,9,6
	__POINTW2MN _arrStatuTB,22
	MOV  R30,R6
	ST   X,R30
	STS  _flagAutoQuat,R30
	RJMP _0x2E
_0x52:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x2E
	CALL SUBOPT_0x2F
	__PUTBMRN _arrStatuTB,10,6
	__PUTBMRN _arrStatuTB,11,6
	__PUTBMRN _arrStatuTB,12,6
	__GETB1MN _rx_buffer,1
	SUBI R30,LOW(48)
	__PUTB1MN _arrStatuTB,23
	STS  _flagAutoBom,R30
_0x2E:
	CLR  R4
_0x2B:
	RET
; .FEND
_usart0_tx_isr:
; .FSTART _usart0_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0x54
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
	LDI  R30,LOW(64)
	CP   R30,R12
	BRNE _0x55
	CLR  R12
_0x55:
_0x54:
_0x173:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
_putchar:
; .FSTART _putchar
	ST   -Y,R26
;	c -> Y+0
_0x56:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x40)
	BREQ _0x56
	cli
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x5A
	SBIC 0xB,5
	RJMP _0x59
_0x5A:
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
	LDI  R30,LOW(64)
	CP   R30,R13
	BRNE _0x5C
	CLR  R13
_0x5C:
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
	RJMP _0x5D
_0x59:
	LD   R30,Y
	OUT  0xC,R30
_0x5D:
	sei
	RJMP _0x20A0006
; .FEND
;#include "./lib/myadc.h"
_read_adc:
; .FSTART _read_adc
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xE0)
	OUT  0x7,R30
	__DELAY_USB 67
	SBI  0x6,6
_0x5E:
	SBIS 0x6,4
	RJMP _0x5E
	SBI  0x6,4
	IN   R30,0x5
_0x20A0006:
	ADIW R28,1
	RET
; .FEND
;
;unsigned char s,h,m; // Bien cho ham thoi gian
;unsigned char thu,d,n,y; // Bien cho ham ngay thang nam
;char display_buffer[20];
;
;char I_RH,D_RH,I_Temp,D_Temp,CheckSum;  //DO AM VA NHIET DO
;int doam=0; //do am dung hien thi
;unsigned char temperature;  // nhiet do lm35
;char DoAmDat=55;               // do am dat

	.DSEG
;char CamBienMua=1;            // cam bien mua
;
;//flag Auto
;unsigned char flagAutoDen=0 ,flagAutoQuat=0 ,flagAutoBom=0;
;
;//arr hen gio
;unsigned char arrStatuTB[25];
;char arrGioOn[30] , arrGioOff[30];
;char arrPhutOn[30], arrPhutOff[30];
;char arrFlagHenGio[30];
;
;
;//dinh nghia lai ham
;void setup();
;void MenuDisplay(flash struct Menu *,unsigned char);
;void screenMainDisplay();
;//void setTime();
;void getTime();
;void NhietdoVadoam();
;void valueinitSensor();
;void setValuesInitHengio();
;void HenGio();
;
;int timeSensor=0;   //0.99s
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 002C {

	.CSEG
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
; 0000 002D     // Reinitialize Timer1 value
; 0000 002E     TCNT1H=0xB3B5 >> 8;
	LDI  R30,LOW(179)
	OUT  0x2D,R30
; 0000 002F     TCNT1L=0xB3B5 & 0xff;
	LDI  R30,LOW(181)
	OUT  0x2C,R30
; 0000 0030 
; 0000 0031     ++timeSensor;
	LDI  R26,LOW(_timeSensor)
	LDI  R27,HIGH(_timeSensor)
	CALL SUBOPT_0x30
; 0000 0032     if(timeSensor==20)  //20s
	LDS  R26,_timeSensor
	LDS  R27,_timeSensor+1
	SBIW R26,20
	BRNE _0x63
; 0000 0033     {
; 0000 0034         NhietdoVadoam();
	RCALL _NhietdoVadoam
; 0000 0035         timeSensor=0;
	LDI  R30,LOW(0)
	STS  _timeSensor,R30
	STS  _timeSensor+1,R30
; 0000 0036     }
; 0000 0037 }
_0x63:
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
;void main(void)
; 0000 003A {
_main:
; .FSTART _main
; 0000 003B      unsigned char select=1 , flagMenu=0 ;
; 0000 003C      flash struct Menu *menu;
; 0000 003D 
; 0000 003E      setup();
;	select -> R17
;	flagMenu -> R16
;	*menu -> R18,R19
	LDI  R17,1
	LDI  R16,0
	RCALL _setup
; 0000 003F 
; 0000 0040      LcdInit();
	CALL _LcdInit
; 0000 0041 
; 0000 0042      s=0; m=38; h=10;
	LDI  R30,LOW(0)
	STS  _s,R30
	LDI  R30,LOW(38)
	STS  _m,R30
	LDI  R30,LOW(10)
	STS  _h,R30
; 0000 0043      thu=3; n=11; d=1; y=22;
	LDI  R30,LOW(3)
	STS  _thu,R30
	LDI  R30,LOW(11)
	STS  _n,R30
	LDI  R30,LOW(1)
	STS  _d,R30
	LDI  R30,LOW(22)
	STS  _y,R30
; 0000 0044 
; 0000 0045      setValuesInitHengio();
	RCALL _setValuesInitHengio
; 0000 0046      valueinitSensor();
	RCALL _valueinitSensor
; 0000 0047      //setTime();
; 0000 0048 
; 0000 0049      //printf( "{\"type\":%d}\r\n" , getalldataStatusTB);
; 0000 004A      //printf( "{\"type\":%d}\r\n" , getalldataHengioTB);
; 0000 004B 
; 0000 004C     while (1)
_0x64:
; 0000 004D     {
; 0000 004E          getTime();
	RCALL _getTime
; 0000 004F          screenMainDisplay();
	RCALL _screenMainDisplay
; 0000 0050          uart_handler();
	RCALL _uart_handler
; 0000 0051          HenGio();
	RCALL _HenGio
; 0000 0052 
; 0000 0053          //auto thiet bi
; 0000 0054          if(flagAutoDen==1)
	LDS  R26,_flagAutoDen
	CPI  R26,LOW(0x1)
	BRNE _0x67
; 0000 0055          {
; 0000 0056             if(h >= 18 | CamBienMua==1)  // neu lon hon 6 gio toi va troi mua thi den bat
	LDS  R26,_h
	LDI  R30,LOW(18)
	CALL __GEB12U
	MOV  R0,R30
	LDS  R26,_CamBienMua
	LDI  R30,LOW(1)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x68
; 0000 0057             {
; 0000 0058                 if(Dens.thietbiall != 0xFF)
	LDS  R26,_Dens
	CPI  R26,LOW(0xFF)
	BREQ _0x69
; 0000 0059                 {
; 0000 005A                     Dens.thietbiall=0xFF;
	LDI  R30,LOW(255)
	STS  _Dens,R30
; 0000 005B                     Den_Activation;
	CALL SUBOPT_0x16
; 0000 005C                 }
; 0000 005D             }
_0x69:
; 0000 005E             else
	RJMP _0x6A
_0x68:
; 0000 005F             {
; 0000 0060                 if(Dens.thietbiall != 0x00)
	LDS  R30,_Dens
	CPI  R30,0
	BREQ _0x6B
; 0000 0061                 {
; 0000 0062                     Dens.thietbiall=0x00;
	LDI  R30,LOW(0)
	STS  _Dens,R30
; 0000 0063                     Den_Activation;
	CALL SUBOPT_0x16
; 0000 0064                 }
; 0000 0065             }
_0x6B:
_0x6A:
; 0000 0066          }
; 0000 0067          if(flagAutoQuat==1)
_0x67:
	LDS  R26,_flagAutoQuat
	CPI  R26,LOW(0x1)
	BRNE _0x6C
; 0000 0068          {
; 0000 0069             if(temperature >= 32)  // neu nhiet do lon hon 32 C thi quat bat
	LDS  R26,_temperature
	CPI  R26,LOW(0x20)
	BRLO _0x6D
; 0000 006A             {
; 0000 006B                 if(Quats.thietbiall != 0xFF)
	LDS  R26,_Quats
	CPI  R26,LOW(0xFF)
	BREQ _0x6E
; 0000 006C                 {
; 0000 006D                     Quats.thietbiall = 0xFF;
	LDI  R30,LOW(255)
	STS  _Quats,R30
; 0000 006E                     Quat_Activation;
	CALL SUBOPT_0x17
; 0000 006F                 }
; 0000 0070             }
_0x6E:
; 0000 0071             else
	RJMP _0x6F
_0x6D:
; 0000 0072             {
; 0000 0073                 if(Quats.thietbiall != 0x00)
	LDS  R30,_Quats
	CPI  R30,0
	BREQ _0x70
; 0000 0074                 {
; 0000 0075                     Quats.thietbiall = 0x00;
	LDI  R30,LOW(0)
	STS  _Quats,R30
; 0000 0076                     Quat_Activation;
	CALL SUBOPT_0x17
; 0000 0077                 }
; 0000 0078             }
_0x70:
_0x6F:
; 0000 0079          }
; 0000 007A          if(flagAutoBom==1)
_0x6C:
	LDS  R26,_flagAutoBom
	CPI  R26,LOW(0x1)
	BRNE _0x71
; 0000 007B          {
; 0000 007C             if( DoAmDat <= 20)  // neu nho hon 20% thi bom bat
	LDS  R26,_DoAmDat
	CPI  R26,LOW(0x15)
	BRSH _0x72
; 0000 007D             {
; 0000 007E                 if(Boms.thietbiall != 0xFF)
	LDS  R26,_Boms
	CPI  R26,LOW(0xFF)
	BREQ _0x73
; 0000 007F                 {
; 0000 0080                     Boms.thietbiall = 0xFF;
	LDI  R30,LOW(255)
	STS  _Boms,R30
; 0000 0081                     Bom_Activation;
	CALL SUBOPT_0x18
; 0000 0082                 }
; 0000 0083             }
_0x73:
; 0000 0084             else
	RJMP _0x74
_0x72:
; 0000 0085             {
; 0000 0086                 if(Boms.thietbiall != 0x00)
	LDS  R30,_Boms
	CPI  R30,0
	BREQ _0x75
; 0000 0087                 {
; 0000 0088                     Boms.thietbiall = 0x00;
	LDI  R30,LOW(0)
	STS  _Boms,R30
; 0000 0089                     Bom_Activation;
	CALL SUBOPT_0x18
; 0000 008A                 }
; 0000 008B             }
_0x75:
_0x74:
; 0000 008C          }
; 0000 008D 
; 0000 008E          //menu
; 0000 008F          if(btnMENU == 0)
_0x71:
	SBIC 0x0,5
	RJMP _0x76
; 0000 0090          {
; 0000 0091             flagMenu=1;
	LDI  R16,LOW(1)
; 0000 0092             menu = &MainMenu;
	LDI  R30,LOW(_MainMenu*2)
	LDI  R31,HIGH(_MainMenu*2)
	CALL SUBOPT_0x31
; 0000 0093             MenuDisplay(menu,select);
; 0000 0094 
; 0000 0095             while(flagMenu == 1)
_0x77:
	CPI  R16,1
	BREQ PC+2
	RJMP _0x79
; 0000 0096             {
; 0000 0097                  uart_handler();
	RCALL _uart_handler
; 0000 0098                  if(btnHOME == 0)
	SBIC 0x0,6
	RJMP _0x7A
; 0000 0099                  {
; 0000 009A                     flagMenu=0;
	LDI  R16,LOW(0)
; 0000 009B                     while(btnHOME == 0);
_0x7B:
	SBIS 0x0,6
	RJMP _0x7B
; 0000 009C                  }
; 0000 009D 
; 0000 009E                  if(btnUP == 0 )
_0x7A:
	SBIC 0x0,2
	RJMP _0x7E
; 0000 009F                  {
; 0000 00A0                    select = (select==1)?3:select-1;
	CPI  R17,1
	BRNE _0x7F
	LDI  R30,LOW(3)
	RJMP _0x80
_0x7F:
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,1
_0x80:
	CALL SUBOPT_0x32
; 0000 00A1                    MenuDisplay(menu,select);
; 0000 00A2 
; 0000 00A3                    while(btnUP == 0);
_0x82:
	SBIS 0x0,2
	RJMP _0x82
; 0000 00A4                  }
; 0000 00A5 
; 0000 00A6                  if(btnDOWN == 0 )
_0x7E:
	SBIC 0x0,3
	RJMP _0x85
; 0000 00A7                  {
; 0000 00A8                    select = (select==3)?1:select+1;
	CPI  R17,3
	BRNE _0x86
	LDI  R30,LOW(1)
	RJMP _0x87
_0x86:
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,1
_0x87:
	CALL SUBOPT_0x32
; 0000 00A9                    MenuDisplay(menu,select);
; 0000 00AA                    while(btnDOWN == 0);
_0x89:
	SBIS 0x0,3
	RJMP _0x89
; 0000 00AB                  }
; 0000 00AC 
; 0000 00AD                  if(btnRIGHT == 0 )
_0x85:
	SBIC 0x0,1
	RJMP _0x8C
; 0000 00AE                  {
; 0000 00AF                    switch(select)
	MOV  R30,R17
	CALL SUBOPT_0x3
; 0000 00B0                    {
; 0000 00B1                         case 1:
	BRNE _0x90
; 0000 00B2                             menu=(menu->Menulist1 == NULL)?menu:menu->Menulist1;
	MOVW R30,R18
	ADIW R30,43
	CALL __GETW2PF
	SBIW R26,0
	BRNE _0x91
	MOVW R30,R18
	RJMP _0x92
_0x91:
	MOVW R30,R18
	ADIW R30,43
	CALL __GETW1PF
_0x92:
	RJMP _0x168
; 0000 00B3                             break;
; 0000 00B4                         case 2:
_0x90:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x94
; 0000 00B5                             menu=(menu->Menulist2 == NULL)?menu:menu->Menulist2;
	MOVW R30,R18
	SUBI R30,LOW(-67)
	SBCI R31,HIGH(-67)
	CALL __GETW2PF
	SBIW R26,0
	BRNE _0x95
	MOVW R30,R18
	RJMP _0x96
_0x95:
	MOVW R30,R18
	SUBI R30,LOW(-67)
	SBCI R31,HIGH(-67)
	CALL __GETW1PF
_0x96:
	RJMP _0x168
; 0000 00B6                             break;
; 0000 00B7                         case 3:
_0x94:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8F
; 0000 00B8                             menu=(menu->Menulist3 == NULL)?menu:menu->Menulist3;
	MOVW R30,R18
	CALL SUBOPT_0x33
	BRNE _0x99
	MOVW R30,R18
	RJMP _0x9A
_0x99:
	MOVW R30,R18
	SUBI R30,LOW(-91)
	SBCI R31,HIGH(-91)
	CALL __GETW1PF
_0x9A:
_0x168:
	MOVW R18,R30
; 0000 00B9                             break;
; 0000 00BA                    }
_0x8F:
; 0000 00BB                    MenuDisplay(menu,select);
	CALL SUBOPT_0x34
; 0000 00BC                    while(btnRIGHT == 0);
_0x9C:
	SBIS 0x0,1
	RJMP _0x9C
; 0000 00BD                  }
; 0000 00BE 
; 0000 00BF                  if(btnLEFT == 0 )
_0x8C:
	SBIC 0x0,0
	RJMP _0x9F
; 0000 00C0                  {
; 0000 00C1                    menu=(menu->pre == NULL)?menu:menu->pre;
	MOVW R30,R18
	ADIW R30,1
	CALL __GETW2PF
	SBIW R26,0
	BRNE _0xA0
	MOVW R30,R18
	RJMP _0xA1
_0xA0:
	MOVW R30,R18
	ADIW R30,1
	CALL __GETW1PF
_0xA1:
	CALL SUBOPT_0x31
; 0000 00C2                    MenuDisplay(menu,select);
; 0000 00C3                    while (btnLEFT == 0);
_0xA3:
	SBIS 0x0,0
	RJMP _0xA3
; 0000 00C4                  }
; 0000 00C5 
; 0000 00C6                  if(btnGO == 0)
_0x9F:
	SBIC 0x0,4
	RJMP _0xA6
; 0000 00C7                  {
; 0000 00C8                    unsigned char flagHengio=0, flagsetTime=0; //flagsetTime = 0 set gio , flagsetTime = 1 set phut
; 0000 00C9                    switch(select)
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
;	flagHengio -> Y+1
;	flagsetTime -> Y+0
	MOV  R30,R17
	CALL SUBOPT_0x3
; 0000 00CA                    {
; 0000 00CB                         case 1:
	BREQ PC+2
	RJMP _0xAA
; 0000 00CC                             if(menu->ActivationON != NULL)
	MOVW R30,R18
	ADIW R30,45
	CALL __GETW1PF
	SBIW R30,0
	BREQ _0xAB
; 0000 00CD                             {
; 0000 00CE                                 menu->ActivationON(menu->menuID,ON);
	MOVW R30,R18
	LPM  R30,Z
	ST   -Y,R30
	LDI  R26,LOW(1)
	MOVW R30,R18
	ADIW R30,45
	CALL __GETW1PF
	ICALL
; 0000 00CF                                 arrStatuTB[menu->menuID]=1;
	MOVW R30,R18
	CALL SUBOPT_0x35
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 00D0                             }
; 0000 00D1                             else if(menu->ActivationSet)
	RJMP _0xAC
_0xAB:
	CALL SUBOPT_0x36
	BRNE PC+2
	RJMP _0xAD
; 0000 00D2                             {
; 0000 00D3                                 while(btnGO == 0);
_0xAE:
	SBIS 0x0,4
	RJMP _0xAE
; 0000 00D4                                 flagHengio = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 00D5                                 while(flagHengio == 1 ) // vao mode hen gio
_0xB1:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0xB3
; 0000 00D6                                 {
; 0000 00D7                                     while(flagsetTime == 0)  // set Gio on
_0xB4:
	LD   R30,Y
	CPI  R30,0
	BRNE _0xB6
; 0000 00D8                                     {
; 0000 00D9                                         if(btnUP == 0 )
	SBIC 0x0,2
	RJMP _0xB7
; 0000 00DA                                         {
; 0000 00DB                                             delay_ms(150);
	CALL SUBOPT_0x37
; 0000 00DC                                             arrGioOn[menu->menuID]++;
	CALL SUBOPT_0x38
; 0000 00DD                                             if(arrGioOn[menu->menuID] > 23)
	SUBI R30,LOW(-_arrGioOn)
	SBCI R31,HIGH(-_arrGioOn)
	LD   R26,Z
	CPI  R26,LOW(0x18)
	BRLO _0xB8
; 0000 00DE                                             {
; 0000 00DF                                                 arrGioOn[menu->menuID]=0;
	CALL SUBOPT_0x39
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 00E0                                             }
; 0000 00E1                                         }
_0xB8:
; 0000 00E2                                         if(btnDOWN == 0 )
_0xB7:
	SBIC 0x0,3
	RJMP _0xB9
; 0000 00E3                                         {
; 0000 00E4                                             delay_ms(150);
	CALL SUBOPT_0x37
; 0000 00E5                                             arrGioOn[menu->menuID]--;
	SUBI R30,LOW(1)
	ST   X,R30
; 0000 00E6                                             if(arrGioOn[menu->menuID] <= 0)
	CALL SUBOPT_0x39
	LD   R26,Z
	CPI  R26,0
	BRNE _0xBA
; 0000 00E7                                             {
; 0000 00E8                                                 arrGioOn[menu->menuID]=23;
	CALL SUBOPT_0x39
	LDI  R26,LOW(23)
	STD  Z+0,R26
; 0000 00E9                                             }
; 0000 00EA                                         }
_0xBA:
; 0000 00EB                                         if(btnRIGHT == 0)
_0xB9:
	SBIC 0x0,1
	RJMP _0xBB
; 0000 00EC                                         {
; 0000 00ED                                             flagsetTime=1;
	LDI  R30,LOW(1)
	ST   Y,R30
; 0000 00EE                                             while(btnRIGHT == 0); //quay lai ve set phut on
_0xBC:
	SBIS 0x0,1
	RJMP _0xBC
; 0000 00EF                                         }
; 0000 00F0                                         if(btnGO == 0)
_0xBB:
	SBIC 0x0,4
	RJMP _0xBF
; 0000 00F1                                         {
; 0000 00F2                                             flagHengio=0;
	CALL SUBOPT_0x3A
; 0000 00F3                                             flagsetTime=-1;
; 0000 00F4                                             while(btnGO == 0);
_0xC0:
	SBIS 0x0,4
	RJMP _0xC0
; 0000 00F5                                         }
; 0000 00F6                                         MenuDisplay(menu,select);
_0xBF:
	CALL SUBOPT_0x34
; 0000 00F7                                     }
	RJMP _0xB4
_0xB6:
; 0000 00F8                                     while(flagsetTime == 1)  // set  Phut  on
_0xC3:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0xC5
; 0000 00F9                                     {
; 0000 00FA                                         if(btnUP == 0 )
	SBIC 0x0,2
	RJMP _0xC6
; 0000 00FB                                         {
; 0000 00FC                                             delay_ms(150);
	CALL SUBOPT_0x3B
; 0000 00FD                                             arrPhutOn[menu->menuID]++;
	CALL SUBOPT_0x38
; 0000 00FE                                             if(arrPhutOn[menu->menuID] > 59)
	SUBI R30,LOW(-_arrPhutOn)
	SBCI R31,HIGH(-_arrPhutOn)
	LD   R26,Z
	CPI  R26,LOW(0x3C)
	BRLO _0xC7
; 0000 00FF                                             {
; 0000 0100                                                 arrPhutOn[menu->menuID]=0;
	CALL SUBOPT_0x3C
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0101                                             }
; 0000 0102                                         }
_0xC7:
; 0000 0103                                         if(btnDOWN == 0 )
_0xC6:
	SBIC 0x0,3
	RJMP _0xC8
; 0000 0104                                         {
; 0000 0105                                             delay_ms(150);
	CALL SUBOPT_0x3B
; 0000 0106                                             arrPhutOn[menu->menuID]--;
	SUBI R30,LOW(1)
	ST   X,R30
; 0000 0107                                             if(arrPhutOn[menu->menuID] <= 0)
	CALL SUBOPT_0x3C
	LD   R26,Z
	CPI  R26,0
	BRNE _0xC9
; 0000 0108                                             {
; 0000 0109                                                 arrPhutOn[menu->menuID]=59;
	CALL SUBOPT_0x3C
	LDI  R26,LOW(59)
	STD  Z+0,R26
; 0000 010A                                             }
; 0000 010B                                         }
_0xC9:
; 0000 010C                                         if(btnLEFT == 0)
_0xC8:
	SBIC 0x0,0
	RJMP _0xCA
; 0000 010D                                         {
; 0000 010E                                             flagsetTime=0;  //quay lai ve set gio on
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 010F                                             while(btnLEFT == 0);
_0xCB:
	SBIS 0x0,0
	RJMP _0xCB
; 0000 0110                                         }
; 0000 0111                                         if(btnGO == 0)
_0xCA:
	SBIC 0x0,4
	RJMP _0xCE
; 0000 0112                                         {
; 0000 0113                                             flagHengio=0;
	CALL SUBOPT_0x3A
; 0000 0114                                             flagsetTime=-1;
; 0000 0115                                             while(btnGO == 0);
_0xCF:
	SBIS 0x0,4
	RJMP _0xCF
; 0000 0116                                         }
; 0000 0117                                         MenuDisplay(menu,select);
_0xCE:
	CALL SUBOPT_0x34
; 0000 0118                                     }
	RJMP _0xC3
_0xC5:
; 0000 0119                                     printf("{\"type\":%d,\"id\":%d,\"gio\":%d,\"phut\":%d}\r\n",hengioOns,menu->menuID,a ...
	__POINTW1FN _0x0,74
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x39
	LD   R30,Z
	CALL SUBOPT_0x1
	CALL SUBOPT_0x3C
	LD   R30,Z
	CALL SUBOPT_0x1
	LDI  R24,16
	CALL _printf
	ADIW R28,18
; 0000 011A                                 }
	RJMP _0xB1
_0xB3:
; 0000 011B                             }
; 0000 011C                             break;
_0xAD:
_0xAC:
	RJMP _0xA9
; 0000 011D                         case 2:
_0xAA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xD2
; 0000 011E                             if(menu->ActivationOFF != NULL)
	MOVW R30,R18
	SUBI R30,LOW(-69)
	SBCI R31,HIGH(-69)
	CALL __GETW1PF
	SBIW R30,0
	BREQ _0xD3
; 0000 011F                             {
; 0000 0120                                 menu->ActivationOFF(menu->menuID,OFF);
	MOVW R30,R18
	LPM  R30,Z
	ST   -Y,R30
	LDI  R26,LOW(0)
	MOVW R30,R18
	SUBI R30,LOW(-69)
	SBCI R31,HIGH(-69)
	CALL __GETW1PF
	ICALL
; 0000 0121                                 arrStatuTB[menu->menuID]=0;
	MOVW R30,R18
	CALL SUBOPT_0x35
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0122                             }
; 0000 0123                             else if(menu->ActivationSet)
	RJMP _0xD4
_0xD3:
	CALL SUBOPT_0x36
	BRNE PC+2
	RJMP _0xD5
; 0000 0124                             {
; 0000 0125                                 while(btnGO == 0);
_0xD6:
	SBIS 0x0,4
	RJMP _0xD6
; 0000 0126                                 flagHengio = 1;
	LDI  R30,LOW(1)
	STD  Y+1,R30
; 0000 0127                                 while(flagHengio == 1 )
_0xD9:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0xDB
; 0000 0128                                 {
; 0000 0129                                     while(flagsetTime == 0)  // set Gio off
_0xDC:
	LD   R30,Y
	CPI  R30,0
	BRNE _0xDE
; 0000 012A                                     {
; 0000 012B                                         if(btnUP == 0 )
	SBIC 0x0,2
	RJMP _0xDF
; 0000 012C                                         {
; 0000 012D                                             delay_ms(150);
	CALL SUBOPT_0x3E
; 0000 012E                                             arrGioOff[menu->menuID]++;
	CALL SUBOPT_0x38
; 0000 012F                                             if(arrGioOff[menu->menuID] > 23)
	SUBI R30,LOW(-_arrGioOff)
	SBCI R31,HIGH(-_arrGioOff)
	LD   R26,Z
	CPI  R26,LOW(0x18)
	BRLO _0xE0
; 0000 0130                                             {
; 0000 0131                                                 arrGioOff[menu->menuID]=0;
	CALL SUBOPT_0x3F
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0132                                             }
; 0000 0133                                         }
_0xE0:
; 0000 0134                                         if(btnDOWN == 0 )
_0xDF:
	SBIC 0x0,3
	RJMP _0xE1
; 0000 0135                                         {
; 0000 0136                                             delay_ms(150);
	CALL SUBOPT_0x3E
; 0000 0137                                             arrGioOff[menu->menuID]--;
	SUBI R30,LOW(1)
	ST   X,R30
; 0000 0138                                             if(arrGioOff[menu->menuID] <= 0)
	CALL SUBOPT_0x3F
	LD   R26,Z
	CPI  R26,0
	BRNE _0xE2
; 0000 0139                                             {
; 0000 013A                                                 arrGioOff[menu->menuID]=23;
	CALL SUBOPT_0x3F
	LDI  R26,LOW(23)
	STD  Z+0,R26
; 0000 013B                                             }
; 0000 013C                                         }
_0xE2:
; 0000 013D                                         if(btnRIGHT == 0)
_0xE1:
	SBIC 0x0,1
	RJMP _0xE3
; 0000 013E                                         {
; 0000 013F                                             flagsetTime=1;
	LDI  R30,LOW(1)
	ST   Y,R30
; 0000 0140                                             while(btnRIGHT == 0); //quay lai ve set phut  off
_0xE4:
	SBIS 0x0,1
	RJMP _0xE4
; 0000 0141                                         }
; 0000 0142                                         if(btnGO == 0)
_0xE3:
	SBIC 0x0,4
	RJMP _0xE7
; 0000 0143                                         {
; 0000 0144                                             flagHengio=0;
	CALL SUBOPT_0x3A
; 0000 0145                                             flagsetTime=-1;
; 0000 0146                                             while(btnGO == 0);
_0xE8:
	SBIS 0x0,4
	RJMP _0xE8
; 0000 0147                                         }
; 0000 0148                                         MenuDisplay(menu,select);
_0xE7:
	CALL SUBOPT_0x34
; 0000 0149                                     }
	RJMP _0xDC
_0xDE:
; 0000 014A                                     while(flagsetTime == 1)  // set  Phut   off
_0xEB:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0xED
; 0000 014B                                     {
; 0000 014C                                         if(btnUP == 0 )
	SBIC 0x0,2
	RJMP _0xEE
; 0000 014D                                         {
; 0000 014E                                             delay_ms(150);
	CALL SUBOPT_0x40
; 0000 014F                                             arrPhutOff[menu->menuID]++;
	CALL SUBOPT_0x38
; 0000 0150                                             if(arrPhutOff[menu->menuID] > 59)
	SUBI R30,LOW(-_arrPhutOff)
	SBCI R31,HIGH(-_arrPhutOff)
	LD   R26,Z
	CPI  R26,LOW(0x3C)
	BRLO _0xEF
; 0000 0151                                             {
; 0000 0152                                                 arrPhutOff[menu->menuID]=0;
	CALL SUBOPT_0x41
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0153                                             }
; 0000 0154                                         }
_0xEF:
; 0000 0155                                         if(btnDOWN == 0 )
_0xEE:
	SBIC 0x0,3
	RJMP _0xF0
; 0000 0156                                         {
; 0000 0157                                             delay_ms(150);
	CALL SUBOPT_0x40
; 0000 0158                                             arrPhutOff[menu->menuID]--;
	SUBI R30,LOW(1)
	ST   X,R30
; 0000 0159                                             if(arrPhutOff[menu->menuID] <= 0)
	CALL SUBOPT_0x41
	LD   R26,Z
	CPI  R26,0
	BRNE _0xF1
; 0000 015A                                             {
; 0000 015B                                                 arrPhutOff[menu->menuID]=59;
	CALL SUBOPT_0x41
	LDI  R26,LOW(59)
	STD  Z+0,R26
; 0000 015C                                             }
; 0000 015D                                         }
_0xF1:
; 0000 015E                                         if(btnLEFT == 0)
_0xF0:
	SBIC 0x0,0
	RJMP _0xF2
; 0000 015F                                         {
; 0000 0160                                             flagsetTime=0;  //quay lai ve set gio off
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0161                                             while(btnLEFT == 0);
_0xF3:
	SBIS 0x0,0
	RJMP _0xF3
; 0000 0162                                         }
; 0000 0163                                         if(btnGO == 0)
_0xF2:
	SBIC 0x0,4
	RJMP _0xF6
; 0000 0164                                         {
; 0000 0165                                             flagHengio=0;
	CALL SUBOPT_0x3A
; 0000 0166                                             flagsetTime=-1;
; 0000 0167                                             while(btnGO == 0);
_0xF7:
	SBIS 0x0,4
	RJMP _0xF7
; 0000 0168                                         }
; 0000 0169                                         MenuDisplay(menu,select);
_0xF6:
	CALL SUBOPT_0x34
; 0000 016A                                     }
	RJMP _0xEB
_0xED:
; 0000 016B                                     printf("{\"type\":%d,\"id\":%d,\"gio\":%d,\"phut\":%d}\r\n",hengioOffs,menu->menuID, ...
	__POINTW1FN _0x0,74
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x3
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3F
	LD   R30,Z
	CALL SUBOPT_0x1
	CALL SUBOPT_0x41
	LD   R30,Z
	CALL SUBOPT_0x1
	LDI  R24,16
	CALL _printf
	ADIW R28,18
; 0000 016C                                 }
	RJMP _0xD9
_0xDB:
; 0000 016D                             }
; 0000 016E                             break;
_0xD5:
_0xD4:
	RJMP _0xA9
; 0000 016F                         case 3:
_0xD2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xA9
; 0000 0170                             if(menu->ActivationSet != NULL)
	CALL SUBOPT_0x36
	BREQ _0xFB
; 0000 0171                             {
; 0000 0172                                 setValuesInitHengio();
	RCALL _setValuesInitHengio
; 0000 0173                                 printf("{\"type\":%d,\"id\":%d}\r\n",deleteHengio,menu->menuID);
	__POINTW1FN _0x0,115
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1D
	MOVW R30,R18
	LPM  R30,Z
	CALL SUBOPT_0x1
	LDI  R24,8
	CALL _printf
	ADIW R28,10
; 0000 0174                             }
; 0000 0175                    }
_0xFB:
_0xA9:
; 0000 0176 
; 0000 0177                    MenuDisplay(menu,select);
	CALL SUBOPT_0x34
; 0000 0178                    while(btnGO == 0);
_0xFC:
	SBIS 0x0,4
	RJMP _0xFC
; 0000 0179                  }
	ADIW R28,2
; 0000 017A             }
_0xA6:
	RJMP _0x77
_0x79:
; 0000 017B             while(btnMENU == 0);
_0xFF:
	SBIS 0x0,5
	RJMP _0xFF
; 0000 017C          }
; 0000 017D          delay_ms(1000);
_0x76:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 017E     }
	RJMP _0x64
; 0000 017F }
_0x102:
	RJMP _0x102
; .FEND
;
;void valueinitSensor()
; 0000 0182 {
_valueinitSensor:
; .FSTART _valueinitSensor
; 0000 0183     //gia tri ban dau
; 0000 0184      arrStatuTB[Device_Temp]=1;
	LDI  R30,LOW(1)
	STS  _arrStatuTB,R30
; 0000 0185      arrStatuTB[Device_Humi]=1;
	__PUTB1MN _arrStatuTB,1
; 0000 0186      arrStatuTB[Device_DoAmDat]=1;
	__PUTB1MN _arrStatuTB,2
; 0000 0187      arrStatuTB[Device_Mua]=1;
	__PUTB1MN _arrStatuTB,3
; 0000 0188 
; 0000 0189      Sensors.thietbi.TB0=1;
	LDS  R30,_Sensors
	ORI  R30,1
	CALL SUBOPT_0x42
; 0000 018A      Sensors.thietbi.TB1=1;
	ORI  R30,2
	CALL SUBOPT_0x42
; 0000 018B      Sensors.thietbi.TB2=1;
	ORI  R30,4
	CALL SUBOPT_0x42
; 0000 018C      Sensors.thietbi.TB3=1;
	ORI  R30,8
	CALL SUBOPT_0x2D
; 0000 018D      Sensor_Activation;
; 0000 018E }
	RET
; .FEND
;
;//void setTime()
;//{
;//    rtc_set_time(h,m,s);
;//    rtc_set_date(thu,d,n,y);
;//}
;
;void getTime()
; 0000 0197 {
_getTime:
; .FSTART _getTime
; 0000 0198     rtc_get_time(&h,&m,&s);
	LDI  R30,LOW(_h)
	LDI  R31,HIGH(_h)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_m)
	LDI  R31,HIGH(_m)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	CALL _rtc_get_time
; 0000 0199     rtc_get_date(&thu,&d,&n,&y);
	LDI  R30,LOW(_thu)
	LDI  R31,HIGH(_thu)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_d)
	LDI  R31,HIGH(_d)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_n)
	LDI  R31,HIGH(_n)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_y)
	LDI  R27,HIGH(_y)
	CALL _rtc_get_date
; 0000 019A }
	RET
; .FEND
;
;void MenuDisplay(flash struct Menu *menu,unsigned char select){
; 0000 019C void MenuDisplay(flash struct Menu *menu,unsigned char select){
_MenuDisplay:
; .FSTART _MenuDisplay
; 0000 019D 
; 0000 019E     PrintFlash(menu->Title,0,0);
	ST   -Y,R26
;	*menu -> Y+1
;	select -> Y+0
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x43
; 0000 019F 
; 0000 01A0     if( menu->ActivationSet != NULL && menu->Menulist3 == NULL && menu->ActivationON == NULL && menu->ActivationOFF == N ...
	SUBI R30,LOW(-93)
	SBCI R31,HIGH(-93)
	CALL __GETW2PF
	SBIW R26,0
	BREQ _0x104
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	CALL SUBOPT_0x33
	BRNE _0x104
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,45
	CALL __GETW2PF
	SBIW R26,0
	BRNE _0x104
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SUBI R30,LOW(-69)
	SBCI R31,HIGH(-69)
	CALL __GETW2PF
	SBIW R26,0
	BREQ _0x105
_0x104:
	RJMP _0x103
_0x105:
; 0000 01A1     {
; 0000 01A2         sprintf(display_buffer," ON  H:%d, M:%d    ",arrGioOn[menu->menuID],arrPhutOn[menu->menuID]);
	CALL SUBOPT_0x44
	__POINTW1FN _0x0,137
	CALL SUBOPT_0x45
	SUBI R30,LOW(-_arrGioOn)
	SBCI R31,HIGH(-_arrGioOn)
	LD   R30,Z
	CALL SUBOPT_0x1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	LPM  R30,Z
	CALL SUBOPT_0x46
	CALL SUBOPT_0x1
	CALL SUBOPT_0x47
; 0000 01A3         Print(display_buffer,1,0);
	CALL SUBOPT_0x48
; 0000 01A4         sprintf(display_buffer," OFF H:%d, M:%d    ",arrGioOff[menu->menuID],arrPhutOff[menu->menuID]);
	__POINTW1FN _0x0,157
	CALL SUBOPT_0x45
	SUBI R30,LOW(-_arrGioOff)
	SBCI R31,HIGH(-_arrGioOff)
	LD   R30,Z
	CALL SUBOPT_0x1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	LPM  R30,Z
	CALL SUBOPT_0x49
	CALL SUBOPT_0x1
	CALL SUBOPT_0x47
; 0000 01A5         Print(display_buffer,2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x4A
; 0000 01A6     }
; 0000 01A7     else
	RJMP _0x106
_0x103:
; 0000 01A8     {
; 0000 01A9         PrintFlash(menu->List1,1,0);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,23
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	CALL SUBOPT_0x43
; 0000 01AA         PrintFlash(menu->List2,2,0);
	ADIW R30,47
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	CALL SUBOPT_0x4B
; 0000 01AB     }
_0x106:
; 0000 01AC 
; 0000 01AD     if(menu->Menulist1 == NULL && menu->Menulist2 == NULL && menu->Menulist3 == NULL && menu->ActivationSet == NULL  )
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,43
	CALL __GETW2PF
	SBIW R26,0
	BRNE _0x108
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SUBI R30,LOW(-67)
	SBCI R31,HIGH(-67)
	CALL __GETW2PF
	SBIW R26,0
	BRNE _0x108
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	CALL SUBOPT_0x33
	BRNE _0x108
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SUBI R30,LOW(-93)
	SBCI R31,HIGH(-93)
	CALL __GETW2PF
	SBIW R26,0
	BREQ _0x109
_0x108:
	RJMP _0x107
_0x109:
; 0000 01AE     {
; 0000 01AF         if(arrStatuTB[menu->menuID]==0)
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	CALL SUBOPT_0x35
	LD   R30,Z
	CPI  R30,0
	BRNE _0x10A
; 0000 01B0         {
; 0000 01B1            Print("  Trang Thai: OFF  ",3,0);
	__POINTW1MN _0x10B,0
	RJMP _0x169
; 0000 01B2         }
; 0000 01B3         else
_0x10A:
; 0000 01B4         {
; 0000 01B5            Print("  Trang Thai: ON   ",3,0);
	__POINTW1MN _0x10B,20
_0x169:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	CALL SUBOPT_0x4A
; 0000 01B6         }
; 0000 01B7     }
; 0000 01B8     else
	RJMP _0x10D
_0x107:
; 0000 01B9     {
; 0000 01BA         PrintFlash(menu->List3,3,0);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SUBI R30,LOW(-71)
	SBCI R31,HIGH(-71)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	CALL SUBOPT_0x4B
; 0000 01BB     }
_0x10D:
; 0000 01BC 
; 0000 01BD     PrintFlash(">",select,0);
	__POINTW1FN _0x0,217
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	CALL SUBOPT_0x4B
; 0000 01BE }
	ADIW R28,3
	RET
; .FEND

	.DSEG
_0x10B:
	.BYTE 0x28
;
;void screenMainDisplay()
; 0000 01C1 {

	.CSEG
_screenMainDisplay:
; .FSTART _screenMainDisplay
; 0000 01C2     sprintf(display_buffer,"  Time: %2d:%02d:%02d   ",h,m,s);
	CALL SUBOPT_0x44
	__POINTW1FN _0x0,219
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_h
	CALL SUBOPT_0x1
	LDS  R30,_m
	CALL SUBOPT_0x1
	LDS  R30,_s
	CALL SUBOPT_0x1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01C3     Print(display_buffer,0,0);
	CALL SUBOPT_0x44
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4A
; 0000 01C4     sprintf(display_buffer," Thu %d,%2d/%02d/%d   ",thu,n,d,2000+y);
	CALL SUBOPT_0x44
	__POINTW1FN _0x0,244
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_thu
	CALL SUBOPT_0x1
	LDS  R30,_n
	CALL SUBOPT_0x1
	LDS  R30,_d
	CALL SUBOPT_0x1
	LDS  R30,_y
	LDI  R31,0
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4D
; 0000 01C5     Print(display_buffer,1,0);
	CALL SUBOPT_0x48
; 0000 01C6     //NhietdoVadoam();
; 0000 01C7     //kiem tra loi
; 0000 01C8 //    if( (I_RH + D_RH + I_Temp + D_Temp) != CheckSum )
; 0000 01C9 //    {
; 0000 01CA //    }
; 0000 01CB //    else
; 0000 01CC //    {
; 0000 01CD //       sprintf(display_buffer," T: %d%d.0 C  H: %d.%d ",temperature/10,temperature%10,doam,D_RH);
; 0000 01CE //       Print(display_buffer,2,0);
; 0000 01CF //    }
; 0000 01D0     sprintf(display_buffer," T: %d%d.0 C  H: %d.%d ",temperature/10,temperature%10,doam,D_RH);
	__POINTW1FN _0x0,267
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_temperature
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	CALL SUBOPT_0x4C
	LDS  R26,_temperature
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	CALL SUBOPT_0x4C
	LDS  R30,_doam
	LDS  R31,_doam+1
	CALL SUBOPT_0x4C
	LDS  R30,_D_RH
	CALL SUBOPT_0x1
	CALL SUBOPT_0x4D
; 0000 01D1     Print(display_buffer,2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x4A
; 0000 01D2     if(CamBienMua==0)
	LDS  R30,_CamBienMua
	CPI  R30,0
	BRNE _0x10E
; 0000 01D3     {
; 0000 01D4         sprintf(display_buffer," DAD:%d ,KHONG MUA ",DoAmDat);
	CALL SUBOPT_0x44
	__POINTW1FN _0x0,291
	RJMP _0x16A
; 0000 01D5         Print(display_buffer,3,0);
; 0000 01D6     }
; 0000 01D7     else
_0x10E:
; 0000 01D8     {
; 0000 01D9         sprintf(display_buffer," DAD:%d , MUA      ",DoAmDat);
	CALL SUBOPT_0x44
	__POINTW1FN _0x0,311
_0x16A:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_DoAmDat
	CALL SUBOPT_0x1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01DA         Print(display_buffer,3,0);
	CALL SUBOPT_0x44
	LDI  R30,LOW(3)
	CALL SUBOPT_0x4A
; 0000 01DB     }
; 0000 01DC }
	RET
; .FEND
;
;void NhietdoVadoam()
; 0000 01DF {
_NhietdoVadoam:
; .FSTART _NhietdoVadoam
; 0000 01E0     //gui xung start
; 0000 01E1     Request();
	CALL _Request
; 0000 01E2     //doi xung phan hoi
; 0000 01E3     Response();
	CALL _Response
; 0000 01E4     //doc 40bits data tu cam bien
; 0000 01E5     I_RH = Receive_data();
	CALL _Receive_data
	STS  _I_RH,R30
; 0000 01E6     D_RH = Receive_data();
	CALL _Receive_data
	STS  _D_RH,R30
; 0000 01E7     I_Temp = Receive_data();
	CALL _Receive_data
	STS  _I_Temp,R30
; 0000 01E8     D_Temp = Receive_data();
	CALL _Receive_data
	STS  _D_Temp,R30
; 0000 01E9     CheckSum = Receive_data();
	CALL _Receive_data
	STS  _CheckSum,R30
; 0000 01EA     temperature = read_adc(7);
	LDI  R26,LOW(7)
	RCALL _read_adc
	STS  _temperature,R30
; 0000 01EB 
; 0000 01EC     doam =(int)I_RH;  //do am hien thi tren lcd
	LDS  R30,_I_RH
	LDI  R31,0
	STS  _doam,R30
	STS  _doam+1,R31
; 0000 01ED     printf("{\"type\":%d,\"temp\":%d,\"humi\":%d,\"dad\":%d,\"cbmua\":%d}\r\n",sensors,temperature,I_RH,DoAmDat,CamBienM ...
	__POINTW1FN _0x0,331
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	LDS  R30,_temperature
	CALL SUBOPT_0x1
	LDS  R30,_I_RH
	CALL SUBOPT_0x1
	LDS  R30,_DoAmDat
	CALL SUBOPT_0x1
	LDS  R30,_CamBienMua
	CALL SUBOPT_0x1
	LDI  R24,20
	CALL _printf
	ADIW R28,22
; 0000 01EE }
	RET
; .FEND
;
;
;void setValuesInitHengio()
; 0000 01F2 {
_setValuesInitHengio:
; .FSTART _setValuesInitHengio
; 0000 01F3     unsigned char j;
; 0000 01F4    //set gia tri ban dau cho hen gio
; 0000 01F5     for(j=0;j <= 26;j++)
	ST   -Y,R17
;	j -> R17
	LDI  R17,LOW(0)
_0x111:
	CPI  R17,27
	BRSH _0x112
; 0000 01F6     {
; 0000 01F7         arrGioOn[j]=70;
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
; 0000 01F8         arrPhutOn[j]=70;
	SUBI R30,LOW(-_arrPhutOn)
	SBCI R31,HIGH(-_arrPhutOn)
	CALL SUBOPT_0x4F
; 0000 01F9         arrGioOff[j]=70;
	SUBI R30,LOW(-_arrGioOff)
	SBCI R31,HIGH(-_arrGioOff)
	CALL SUBOPT_0x4F
; 0000 01FA         arrPhutOff[j]=70;
	SUBI R30,LOW(-_arrPhutOff)
	SBCI R31,HIGH(-_arrPhutOff)
	CALL SUBOPT_0x4F
; 0000 01FB         arrFlagHenGio[j]=0;
	CALL SUBOPT_0x50
; 0000 01FC     }
	SUBI R17,-1
	RJMP _0x111
_0x112:
; 0000 01FD }
	RJMP _0x20A0004
; .FEND
;
;void checkHengioDen(unsigned char tb, unsigned char gioOn, unsigned char phutOn, unsigned char gioOff, unsigned char phu ...
; 0000 0200 {
_checkHengioDen:
; .FSTART _checkHengioDen
; 0000 0201     if(h == gioOn && m == phutOn && flagStatus == 0)
	CALL SUBOPT_0x51
;	tb -> Y+6
;	gioOn -> Y+5
;	phutOn -> Y+4
;	gioOff -> Y+3
;	phutOff -> Y+2
;	flagStatus -> Y+1
;	id -> Y+0
	BRNE _0x114
	CALL SUBOPT_0x52
	BRNE _0x114
	LDD  R26,Y+1
	CPI  R26,LOW(0x0)
	BREQ _0x115
_0x114:
	RJMP _0x113
_0x115:
; 0000 0202     {
; 0000 0203             if(tb == 0)
	LDD  R30,Y+6
	CPI  R30,0
	BRNE _0x116
; 0000 0204             {
; 0000 0205                //arrStatuTB[Device_Den_Khu1] = 1;
; 0000 0206                Dens.thietbi.TB0 = 1;
	LDS  R30,_Dens
	ORI  R30,1
	CALL SUBOPT_0x53
; 0000 0207                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu1 , ON );
	__GETD1N 0x4
	RJMP _0x16B
; 0000 0208             }
; 0000 0209             else if(tb == 1)
_0x116:
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x118
; 0000 020A             {
; 0000 020B                //arrStatuTB[Device_Den_Khu2] = 1;
; 0000 020C                Dens.thietbi.TB1 = 1;
	LDS  R30,_Dens
	ORI  R30,2
	CALL SUBOPT_0x53
; 0000 020D                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu2 , ON );
	__GETD1N 0x5
	RJMP _0x16B
; 0000 020E             }
; 0000 020F             else if(tb == 2)
_0x118:
	LDD  R26,Y+6
	CPI  R26,LOW(0x2)
	BRNE _0x11A
; 0000 0210             {
; 0000 0211                //arrStatuTB[Device_Den_Khu3] = 1;
; 0000 0212                Dens.thietbi.TB2 = 1;
	LDS  R30,_Dens
	ORI  R30,4
	CALL SUBOPT_0x53
; 0000 0213                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu3 , ON );
	__GETD1N 0x6
_0x16B:
	CALL __PUTPARD1
	CALL SUBOPT_0x1E
; 0000 0214             }
; 0000 0215 
; 0000 0216             Den_Activation;
_0x11A:
	CALL SUBOPT_0x16
; 0000 0217             arrFlagHenGio[id] = 1;
	CALL SUBOPT_0x54
; 0000 0218     }
; 0000 0219     if(h == gioOff && m == phutOff && flagStatus == 1)
_0x113:
	CALL SUBOPT_0x55
	BRNE _0x11C
	CALL SUBOPT_0x56
	BRNE _0x11C
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BREQ _0x11D
_0x11C:
	RJMP _0x11B
_0x11D:
; 0000 021A     {
; 0000 021B             if(tb == 0)
	LDD  R30,Y+6
	CPI  R30,0
	BRNE _0x11E
; 0000 021C             {
; 0000 021D                //arrStatuTB[Device_Den_Khu1] = 1;
; 0000 021E                Dens.thietbi.TB0 = 0;
	LDS  R30,_Dens
	ANDI R30,0xFE
	CALL SUBOPT_0x53
; 0000 021F                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu1 , OFF );
	__GETD1N 0x4
	RJMP _0x16C
; 0000 0220             }
; 0000 0221             else if(tb == 1)
_0x11E:
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x120
; 0000 0222             {
; 0000 0223                //arrStatuTB[Device_Den_Khu2] = 1;
; 0000 0224                Dens.thietbi.TB1 =0;
	LDS  R30,_Dens
	ANDI R30,0xFD
	CALL SUBOPT_0x53
; 0000 0225                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu2 , OFF );
	__GETD1N 0x5
	RJMP _0x16C
; 0000 0226             }
; 0000 0227             else if(tb == 2)
_0x120:
	LDD  R26,Y+6
	CPI  R26,LOW(0x2)
	BRNE _0x122
; 0000 0228             {
; 0000 0229                //arrStatuTB[Device_Den_Khu3] = 1;
; 0000 022A                Dens.thietbi.TB2 = 0;
	LDS  R30,_Dens
	ANDI R30,0xFB
	CALL SUBOPT_0x53
; 0000 022B                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Den_Khu3 , OFF );
	__GETD1N 0x6
_0x16C:
	CALL __PUTPARD1
	CALL SUBOPT_0x28
; 0000 022C             }
; 0000 022D             Den_Activation;
_0x122:
	CALL SUBOPT_0x16
; 0000 022E             arrFlagHenGio[id] = 0;
	CALL SUBOPT_0x57
; 0000 022F     }
; 0000 0230 }
_0x11B:
	RJMP _0x20A0005
; .FEND
;void checkHengioQuat(unsigned char tb, unsigned char gioOn, unsigned char phutOn, unsigned char gioOff, unsigned char ph ...
; 0000 0232 {
_checkHengioQuat:
; .FSTART _checkHengioQuat
; 0000 0233     if(h == gioOn && m == phutOn && flagStatus == 0)
	CALL SUBOPT_0x51
;	tb -> Y+6
;	gioOn -> Y+5
;	phutOn -> Y+4
;	gioOff -> Y+3
;	phutOff -> Y+2
;	flagStatus -> Y+1
;	id -> Y+0
	BRNE _0x124
	CALL SUBOPT_0x52
	BRNE _0x124
	LDD  R26,Y+1
	CPI  R26,LOW(0x0)
	BREQ _0x125
_0x124:
	RJMP _0x123
_0x125:
; 0000 0234     {
; 0000 0235             if(tb == 0)
	LDD  R30,Y+6
	CPI  R30,0
	BRNE _0x126
; 0000 0236             {
; 0000 0237                //arrStatuTB[Device_Quat_Khu1] = 1;
; 0000 0238                Quats.thietbi.TB0 =1;
	LDS  R30,_Quats
	ORI  R30,1
	CALL SUBOPT_0x58
; 0000 0239                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu1 , ON );
	CALL SUBOPT_0x20
	RJMP _0x16D
; 0000 023A             }
; 0000 023B             else if(tb == 1)
_0x126:
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x128
; 0000 023C             {
; 0000 023D                //arrStatuTB[Device_Quat_Khu2] = 1;
; 0000 023E                 Quats.thietbi.TB1 =1;
	LDS  R30,_Quats
	ORI  R30,2
	CALL SUBOPT_0x58
; 0000 023F                 printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu2 , ON );
	CALL SUBOPT_0x22
	RJMP _0x16D
; 0000 0240             }
; 0000 0241             else if(tb == 2)
_0x128:
	LDD  R26,Y+6
	CPI  R26,LOW(0x2)
	BRNE _0x12A
; 0000 0242             {
; 0000 0243                //arrStatuTB[Device_Quat_Khu3] = 1;
; 0000 0244                 Quats.thietbi.TB2 =1;
	LDS  R30,_Quats
	ORI  R30,4
	CALL SUBOPT_0x58
; 0000 0245                 printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu3 , ON );
	CALL SUBOPT_0x23
_0x16D:
	CALL __PUTPARD1
	CALL SUBOPT_0x1E
; 0000 0246             }
; 0000 0247             Quat_Activation;
_0x12A:
	CALL SUBOPT_0x17
; 0000 0248             arrFlagHenGio[id] = 1;
	CALL SUBOPT_0x54
; 0000 0249     }
; 0000 024A     if(h == gioOff && m == phutOff && flagStatus == 1)
_0x123:
	CALL SUBOPT_0x55
	BRNE _0x12C
	CALL SUBOPT_0x56
	BRNE _0x12C
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BREQ _0x12D
_0x12C:
	RJMP _0x12B
_0x12D:
; 0000 024B     {
; 0000 024C             if(tb == 0)
	LDD  R30,Y+6
	CPI  R30,0
	BRNE _0x12E
; 0000 024D             {
; 0000 024E                //arrStatuTB[Device_Quat_Khu1] = 0;
; 0000 024F                Quats.thietbi.TB0 =0;
	LDS  R30,_Quats
	ANDI R30,0xFE
	CALL SUBOPT_0x58
; 0000 0250                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu1 , OFF );
	CALL SUBOPT_0x20
	RJMP _0x16E
; 0000 0251             }
; 0000 0252             else if(tb == 1)
_0x12E:
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x130
; 0000 0253             {
; 0000 0254                //arrStatuTB[Device_Quat_Khu2] = 0;
; 0000 0255                Quats.thietbi.TB1 =0;
	LDS  R30,_Quats
	ANDI R30,0xFD
	CALL SUBOPT_0x58
; 0000 0256                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu2 , OFF );
	CALL SUBOPT_0x22
	RJMP _0x16E
; 0000 0257             }
; 0000 0258             else if(tb == 2)
_0x130:
	LDD  R26,Y+6
	CPI  R26,LOW(0x2)
	BRNE _0x132
; 0000 0259             {
; 0000 025A                //arrStatuTB[Device_Quat_Khu3] = 0;
; 0000 025B                Quats.thietbi.TB2 =0;
	LDS  R30,_Quats
	ANDI R30,0xFB
	CALL SUBOPT_0x58
; 0000 025C                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Quat_Khu3 , OFF );
	CALL SUBOPT_0x23
_0x16E:
	CALL __PUTPARD1
	CALL SUBOPT_0x28
; 0000 025D             }
; 0000 025E             Quat_Activation;
_0x132:
	CALL SUBOPT_0x17
; 0000 025F             arrFlagHenGio[id] = 0;
	CALL SUBOPT_0x57
; 0000 0260     }
; 0000 0261 
; 0000 0262 }
_0x12B:
	RJMP _0x20A0005
; .FEND
;void checkHengioBom(unsigned char tb, unsigned char gioOn, unsigned char phutOn, unsigned char gioOff, unsigned char phu ...
; 0000 0264 {
_checkHengioBom:
; .FSTART _checkHengioBom
; 0000 0265     if(h == gioOn && m == phutOn && flagStatus == 0)
	CALL SUBOPT_0x51
;	tb -> Y+6
;	gioOn -> Y+5
;	phutOn -> Y+4
;	gioOff -> Y+3
;	phutOff -> Y+2
;	flagStatus -> Y+1
;	id -> Y+0
	BRNE _0x134
	CALL SUBOPT_0x52
	BRNE _0x134
	LDD  R26,Y+1
	CPI  R26,LOW(0x0)
	BREQ _0x135
_0x134:
	RJMP _0x133
_0x135:
; 0000 0266     {
; 0000 0267             if(tb == 0)
	LDD  R30,Y+6
	CPI  R30,0
	BRNE _0x136
; 0000 0268             {
; 0000 0269                //arrStatuTB[Device_Bom_Khu1] = 1;
; 0000 026A                Boms.thietbi.TB0 = 1 ;
	LDS  R30,_Boms
	ORI  R30,1
	CALL SUBOPT_0x59
; 0000 026B                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu1 , ON );
	CALL SUBOPT_0x24
	RJMP _0x16F
; 0000 026C             }
; 0000 026D             else if(tb == 1)
_0x136:
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x138
; 0000 026E             {
; 0000 026F                //arrStatuTB[Device_Bom_Khu2] = 1;
; 0000 0270                Boms.thietbi.TB1 = 1;
	LDS  R30,_Boms
	ORI  R30,2
	CALL SUBOPT_0x59
; 0000 0271                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu2 , ON );
	CALL SUBOPT_0x25
	RJMP _0x16F
; 0000 0272             }
; 0000 0273             else if(tb == 2)
_0x138:
	LDD  R26,Y+6
	CPI  R26,LOW(0x2)
	BRNE _0x13A
; 0000 0274             {
; 0000 0275                //arrStatuTB[Device_Bom_Khu3] = 1;
; 0000 0276                Boms.thietbi.TB2 = 1;
	LDS  R30,_Boms
	ORI  R30,4
	CALL SUBOPT_0x59
; 0000 0277                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu3 , ON );
	CALL SUBOPT_0x26
_0x16F:
	CALL __PUTPARD1
	CALL SUBOPT_0x1E
; 0000 0278             }
; 0000 0279             Bom_Activation;
_0x13A:
	CALL SUBOPT_0x18
; 0000 027A             arrFlagHenGio[id] = 1;
	CALL SUBOPT_0x54
; 0000 027B     }
; 0000 027C     if(h == gioOff && m == phutOff && flagStatus == 1)
_0x133:
	CALL SUBOPT_0x55
	BRNE _0x13C
	CALL SUBOPT_0x56
	BRNE _0x13C
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BREQ _0x13D
_0x13C:
	RJMP _0x13B
_0x13D:
; 0000 027D     {
; 0000 027E             if(tb == 0)
	LDD  R30,Y+6
	CPI  R30,0
	BRNE _0x13E
; 0000 027F             {
; 0000 0280                //arrStatuTB[Device_Bom_Khu1] = 0;
; 0000 0281                 Boms.thietbi.TB0 = 0;
	LDS  R30,_Boms
	ANDI R30,0xFE
	CALL SUBOPT_0x59
; 0000 0282                 printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu1 , OFF );
	CALL SUBOPT_0x24
	RJMP _0x170
; 0000 0283             }
; 0000 0284             else if(tb == 1)
_0x13E:
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x140
; 0000 0285             {
; 0000 0286                //arrStatuTB[Device_Bom_Khu2] = 0;
; 0000 0287                Boms.thietbi.TB1 = 0;
	LDS  R30,_Boms
	ANDI R30,0xFD
	CALL SUBOPT_0x59
; 0000 0288                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu2 , OFF );
	CALL SUBOPT_0x25
	RJMP _0x170
; 0000 0289             }
; 0000 028A             else if(tb == 2)
_0x140:
	LDD  R26,Y+6
	CPI  R26,LOW(0x2)
	BRNE _0x142
; 0000 028B             {
; 0000 028C                //arrStatuTB[Device_Bom_Khu3] = 0;
; 0000 028D                Boms.thietbi.TB2 = 0;
	LDS  R30,_Boms
	ANDI R30,0xFB
	CALL SUBOPT_0x59
; 0000 028E                printf( "{\"type\":%d,\"id\":%d,\"status\":%d}\r\n" , statusTB, Device_Bom_Khu3 , OFF );
	CALL SUBOPT_0x26
_0x170:
	CALL __PUTPARD1
	CALL SUBOPT_0x28
; 0000 028F             }
; 0000 0290             Bom_Activation;
_0x142:
	CALL SUBOPT_0x18
; 0000 0291             arrFlagHenGio[id] = 0;
	CALL SUBOPT_0x57
; 0000 0292     }
; 0000 0293 }
_0x13B:
_0x20A0005:
	ADIW R28,7
	RET
; .FEND
;
;void HenGio()
; 0000 0296 {
_HenGio:
; .FSTART _HenGio
; 0000 0297     unsigned char i;
; 0000 0298 
; 0000 0299     for(i=0;i<=Hengio_BomKhu3Lan3;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x144:
	CPI  R17,27
	BRLO PC+2
	RJMP _0x145
; 0000 029A     {
; 0000 029B             switch(i)
	MOV  R30,R17
	LDI  R31,0
; 0000 029C             {
; 0000 029D                 //hen gio den
; 0000 029E                 case Hengio_DenKhu1Lan1:
	SBIW R30,0
	BRNE _0x149
; 0000 029F                     checkHengioDen(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 02A0                     break;
	RJMP _0x148
; 0000 02A1                 case Hengio_DenKhu1Lan2:
_0x149:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x14A
; 0000 02A2                     checkHengioDen(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 02A3                     break;
	RJMP _0x148
; 0000 02A4                 case Hengio_DenKhu1Lan3:
_0x14A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x14B
; 0000 02A5                     checkHengioDen(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 02A6                     break;
	RJMP _0x148
; 0000 02A7                 case Hengio_DenKhu2Lan1:
_0x14B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x14C
; 0000 02A8                     checkHengioDen(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 02A9                     break;
	RJMP _0x148
; 0000 02AA                 case Hengio_DenKhu2Lan2:
_0x14C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x14D
; 0000 02AB                     checkHengioDen(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 02AC                     break;
	RJMP _0x148
; 0000 02AD                 case Hengio_DenKhu2Lan3:
_0x14D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x14E
; 0000 02AE                     checkHengioDen(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 02AF                     break;
	RJMP _0x148
; 0000 02B0                 case Hengio_DenKhu3Lan1:
_0x14E:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x14F
; 0000 02B1                     checkHengioDen(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 02B2                     break;
	RJMP _0x148
; 0000 02B3                 case Hengio_DenKhu3Lan2:
_0x14F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x150
; 0000 02B4                     checkHengioDen(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 02B5                     break;
	RJMP _0x148
; 0000 02B6                 case Hengio_DenKhu3Lan3:
_0x150:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x151
; 0000 02B7                     checkHengioDen(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
; 0000 02B8                     break;
	RJMP _0x148
; 0000 02B9                 //hen gio quat
; 0000 02BA                 case Hengio_QuatKhu1Lan1:
_0x151:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x152
; 0000 02BB                     checkHengioQuat(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
; 0000 02BC                     break;
	RJMP _0x148
; 0000 02BD                 case Hengio_QuatKhu1Lan2:
_0x152:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x153
; 0000 02BE                     checkHengioQuat(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
; 0000 02BF                     break;
	RJMP _0x148
; 0000 02C0                 case Hengio_QuatKhu1Lan3:
_0x153:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x154
; 0000 02C1                     checkHengioQuat(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
; 0000 02C2                     break;
	RJMP _0x148
; 0000 02C3                 case Hengio_QuatKhu2Lan1:
_0x154:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x155
; 0000 02C4                     checkHengioQuat(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
; 0000 02C5                     break;
	RJMP _0x148
; 0000 02C6                 case Hengio_QuatKhu2Lan2:
_0x155:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x156
; 0000 02C7                     checkHengioQuat(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
; 0000 02C8                     break;
	RJMP _0x148
; 0000 02C9                 case Hengio_QuatKhu2Lan3:
_0x156:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x157
; 0000 02CA                     checkHengioQuat(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
; 0000 02CB                     break;
	RJMP _0x148
; 0000 02CC                 case Hengio_QuatKhu3Lan1:
_0x157:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x158
; 0000 02CD                     checkHengioQuat(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
; 0000 02CE                     break;
	RJMP _0x148
; 0000 02CF                 case Hengio_QuatKhu3Lan2:
_0x158:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x159
; 0000 02D0                     checkHengioQuat(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
; 0000 02D1                     break;
	RJMP _0x148
; 0000 02D2                 case Hengio_QuatKhu3Lan3:
_0x159:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x15A
; 0000 02D3                     checkHengioQuat(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
; 0000 02D4                     break;
	RJMP _0x148
; 0000 02D5                 //hen gio bom
; 0000 02D6                 case Hengio_BomKhu1Lan1:
_0x15A:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x15B
; 0000 02D7                     checkHengioBom(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	LDI  R30,LOW(0)
	RJMP _0x171
; 0000 02D8                     break;
; 0000 02D9                 case Hengio_BomKhu1Lan2:
_0x15B:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x15C
; 0000 02DA                     checkHengioBom(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	LDI  R30,LOW(0)
	RJMP _0x171
; 0000 02DB                     break;
; 0000 02DC                 case Hengio_BomKhu1Lan3:
_0x15C:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x15D
; 0000 02DD                     checkHengioBom(0 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	LDI  R30,LOW(0)
	RJMP _0x171
; 0000 02DE                     break;
; 0000 02DF                 case Hengio_BomKhu2Lan1:
_0x15D:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0x15E
; 0000 02E0                     checkHengioBom(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	LDI  R30,LOW(1)
	RJMP _0x171
; 0000 02E1                     break;
; 0000 02E2                 case Hengio_BomKhu2Lan2:
_0x15E:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0x15F
; 0000 02E3                     checkHengioBom(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	LDI  R30,LOW(1)
	RJMP _0x171
; 0000 02E4                     break;
; 0000 02E5                 case Hengio_BomKhu2Lan3:
_0x15F:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0x160
; 0000 02E6                     checkHengioBom(1 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
	LDI  R30,LOW(1)
	RJMP _0x171
; 0000 02E7                     break;
; 0000 02E8                 case Hengio_BomKhu3Lan1:
_0x160:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BREQ _0x172
; 0000 02E9                     checkHengioBom(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
; 0000 02EA                     break;
; 0000 02EB                 case Hengio_BomKhu3Lan2:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BREQ _0x172
; 0000 02EC                     checkHengioBom(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
; 0000 02ED                     break;
; 0000 02EE                 case Hengio_BomKhu3Lan3:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0x148
; 0000 02EF                     checkHengioBom(2 , arrGioOn[i], arrPhutOn[i] , arrGioOff[i], arrPhutOff[i],arrFlagHenGio[i],i);
_0x172:
	LDI  R30,LOW(2)
_0x171:
	ST   -Y,R30
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_arrFlagHenGio)
	SBCI R31,HIGH(-_arrFlagHenGio)
	LD   R30,Z
	ST   -Y,R30
	MOV  R26,R17
	RCALL _checkHengioBom
; 0000 02F0                     break;
; 0000 02F1             }
_0x148:
; 0000 02F2     }
	SUBI R17,-1
	RJMP _0x144
_0x145:
; 0000 02F3 }
_0x20A0004:
	LD   R17,Y+
	RET
; .FEND
;
;void setup(){
; 0000 02F5 void setup(){
_setup:
; .FSTART _setup
; 0000 02F6 
; 0000 02F7 // Input/Output Ports initialization
; 0000 02F8 // Port A initialization
; 0000 02F9 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02FA DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 02FB // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02FC PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 02FD 
; 0000 02FE // Port B initialization
; 0000 02FF // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0300 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0301 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0302 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0303 
; 0000 0304 // Port C initialization
; 0000 0305 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0306 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0307 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0308 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0309 
; 0000 030A // Port D initialization
; 0000 030B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 030C DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(16)
	OUT  0x11,R30
; 0000 030D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 030E PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 030F 
; 0000 0310 // Port E initialization
; 0000 0311 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0312 DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 0313 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0314 PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 0315 
; 0000 0316 // Port F initialization
; 0000 0317 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0318 DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 0319 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 031A PORTF=(1<<PORTF7) | (1<<PORTF6) | (1<<PORTF5) | (1<<PORTF4) | (1<<PORTF3) | (1<<PORTF2) | (1<<PORTF1) | (1<<PORTF0);
	LDI  R30,LOW(255)
	STS  98,R30
; 0000 031B 
; 0000 031C // Port G initialization
; 0000 031D // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 031E DDRG=(0<<DDG4) | (1<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	LDI  R30,LOW(8)
	STS  100,R30
; 0000 031F // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0320 PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 0321 
; 0000 0322 
; 0000 0323 
; 0000 0324 // Timer/Counter 1 initialization
; 0000 0325 // Clock source: System Clock
; 0000 0326 // Clock value: 19.531 kHz
; 0000 0327 // Mode: Normal top=0xFFFF
; 0000 0328 // OC1A output: Disconnected
; 0000 0329 // OC1B output: Disconnected
; 0000 032A // OC1C output: Disconnected
; 0000 032B // Noise Canceler: Off
; 0000 032C // Input Capture on Falling Edge
; 0000 032D // Timer Period: 0.99999 s
; 0000 032E // Timer1 Overflow Interrupt: On
; 0000 032F // Input Capture Interrupt: Off
; 0000 0330 // Compare A Match Interrupt: Off
; 0000 0331 // Compare B Match Interrupt: Off
; 0000 0332 // Compare C Match Interrupt: Off
; 0000 0333 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0334 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 0335 TCNT1H=0xB3;
	LDI  R30,LOW(179)
	OUT  0x2D,R30
; 0000 0336 TCNT1L=0xB5;
	LDI  R30,LOW(181)
	OUT  0x2C,R30
; 0000 0337 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0338 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0339 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 033A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 033B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 033C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 033D OCR1CH=0x00;
	STS  121,R30
; 0000 033E OCR1CL=0x00;
	STS  120,R30
; 0000 033F 
; 0000 0340 
; 0000 0341 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0342 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0000 0343 ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0344 
; 0000 0345 
; 0000 0346 // External SRAM page configuration:
; 0000 0347 MCUCR|=(1<<SRE);
	IN   R30,0x35
	ORI  R30,0x80
	OUT  0x35,R30
; 0000 0348 
; 0000 0349 // USART0 initialization
; 0000 034A // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 034B // USART0 Receiver: On
; 0000 034C // USART0 Transmitter: On
; 0000 034D // USART0 Mode: Asynchronous
; 0000 034E // USART0 Baud Rate: 9600
; 0000 034F UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0350 UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0351 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0352 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0353 UBRR0L=0x81;
	LDI  R30,LOW(129)
	OUT  0x9,R30
; 0000 0354 
; 0000 0355 // ADC initialization
; 0000 0356 // ADC Clock frequency: 156.250 kHz
; 0000 0357 // ADC Voltage Reference: Int., cap. on AREF
; 0000 0358 // Only the 8 most significant bits of
; 0000 0359 // the AD conversion result are used
; 0000 035A ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 035B ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 035C SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 035D 
; 0000 035E // Bit-Banged I2C Bus initialization
; 0000 035F // I2C Port: PORTD
; 0000 0360 // I2C SDA bit: 1
; 0000 0361 // I2C SCL bit: 0
; 0000 0362 // Bit Rate: 100 kHz
; 0000 0363 // Note: I2C settings are specified in the
; 0000 0364 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0365 i2c_init();
	CALL _i2c_init
; 0000 0366 
; 0000 0367 // DS1307 Real Time Clock initialization
; 0000 0368 // Square wave output on pin SQW/OUT: On
; 0000 0369 // Square wave frequency: 1Hz
; 0000 036A rtc_init(0,1,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _rtc_init
; 0000 036B 
; 0000 036C // Global enable interrupts
; 0000 036D #asm("sei")
	sei
; 0000 036E 
; 0000 036F }
	RET
; .FEND
;#include "dht11.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;#define DHT11_PIN  6
;
;void Request()                /* Microcontroller send start pulse/request */
; 0001 0007 {

	.CSEG
_Request:
; .FSTART _Request
; 0001 0008     DDRD |= (1<<DHT11_PIN);
	SBI  0x11,6
; 0001 0009     PORTD &= ~(1<<DHT11_PIN);    /* set to low pin */
	CBI  0x12,6
; 0001 000A     delay_ms(20);            /* wait for 20ms */
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 000B     PORTD |= (1<<DHT11_PIN);    /* set to high pin */
	SBI  0x12,6
; 0001 000C }
	RET
; .FEND
;
;void Response()                /* receive response from DHT11 */
; 0001 000F {
_Response:
; .FSTART _Response
; 0001 0010     DDRD &= ~(1<<DHT11_PIN);
	CBI  0x11,6
; 0001 0011     while(PIND & (1<<DHT11_PIN));
_0x20003:
	SBIC 0x10,6
	RJMP _0x20003
; 0001 0012     while((PIND & (1<<DHT11_PIN))==0);
_0x20006:
	SBIS 0x10,6
	RJMP _0x20006
; 0001 0013     while(PIND & (1<<DHT11_PIN));
_0x20009:
	SBIC 0x10,6
	RJMP _0x20009
; 0001 0014 }
	RET
; .FEND
;
;char Receive_data()            /* receive data */
; 0001 0017 {
_Receive_data:
; .FSTART _Receive_data
; 0001 0018     char q,c=0;
; 0001 0019     for ( q=0; q<8; q++)
	ST   -Y,R17
	ST   -Y,R16
;	q -> R17
;	c -> R16
	LDI  R16,0
	LDI  R17,LOW(0)
_0x2000D:
	CPI  R17,8
	BRSH _0x2000E
; 0001 001A     {
; 0001 001B         while((PIND & (1<<DHT11_PIN)) == 0);  /* check received bit 0 or 1 */
_0x2000F:
	SBIS 0x10,6
	RJMP _0x2000F
; 0001 001C         delay_us(30);
	__DELAY_USB 200
; 0001 001D         if(PIND & (1<<DHT11_PIN))/* if high pulse is greater than 30ms */
	SBIS 0x10,6
	RJMP _0x20012
; 0001 001E         c = (c<<1)|(0x01);    /* then its logic HIGH */
	MOV  R30,R16
	LSL  R30
	ORI  R30,1
	MOV  R16,R30
; 0001 001F         else            /* otherwise its logic LOW */
	RJMP _0x20013
_0x20012:
; 0001 0020         c = (c<<1);
	LSL  R16
; 0001 0021         while(PIND & (1<<DHT11_PIN));
_0x20013:
_0x20014:
	SBIC 0x10,6
	RJMP _0x20014
; 0001 0022     }
	SUBI R17,-1
	RJMP _0x2000D
_0x2000E:
; 0001 0023     return c;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0001 0024 }
; .FEND
;
;
;#include "lcd20x4.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;//LCD
;#define LCDE_H (PORTG |= (1<<3))
;#define LCDE_L (PORTG &= ~(1<<3))
;
;#define LCD_DATA *(unsigned char *) (Base_address + CS9)
;#define LCD_INS *(unsigned char *) (Base_address + CS10)
;
;void LcdInit()
; 0002 000B {

	.CSEG
_LcdInit:
; .FSTART _LcdInit
; 0002 000C     LCD_INS = 0x38; LCDE_H; delay_us(1); LCDE_L; delay_us(1);
	LDI  R30,LOW(56)
	CALL SUBOPT_0x61
; 0002 000D     delay_us(200);
; 0002 000E     LCD_INS = 0x0C; LCDE_H; delay_us(1); LCDE_L; delay_us(1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x61
; 0002 000F     delay_us(200);
; 0002 0010     LCD_INS = 0x06; LCDE_H; delay_us(1); LCDE_L; delay_us(1);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x61
; 0002 0011     delay_us(200);
; 0002 0012     //LCD_INS = 0x01; LCDE_H; delay_us(1); LCDE_L; delay_us(1);
; 0002 0013     //delay_us(200);
; 0002 0014 }
	RET
; .FEND
;
;void PrintFlash(flash char *str, unsigned char row , unsigned char col)
; 0002 0017 {
_PrintFlash:
; .FSTART _PrintFlash
; 0002 0018     unsigned char add;
; 0002 0019     switch(row)
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+3
;	row -> Y+2
;	col -> Y+1
;	add -> R17
	LDD  R30,Y+2
	LDI  R31,0
; 0002 001A     {
; 0002 001B         case 0: add = 0x80; break;
	SBIW R30,0
	BRNE _0x40006
	LDI  R17,LOW(128)
	RJMP _0x40005
; 0002 001C         case 1: add = 0xC0; break;
_0x40006:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x40007
	LDI  R17,LOW(192)
	RJMP _0x40005
; 0002 001D         case 2: add = 0x94; break;
_0x40007:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x40008
	LDI  R17,LOW(148)
	RJMP _0x40005
; 0002 001E         case 3: add = 0xD4; break;
_0x40008:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x40005
	LDI  R17,LOW(212)
; 0002 001F     }
_0x40005:
; 0002 0020     LCD_INS = add + col;
	CALL SUBOPT_0x62
; 0002 0021     LCDE_H; delay_us(1); LCDE_L; delay_us(100);
; 0002 0022     while(*(str) != '\0')
_0x4000A:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x4000C
; 0002 0023     {
; 0002 0024         LCD_DATA = *str++;
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ADIW R30,1
	STD  Y+3,R30
	STD  Y+3+1,R31
	SBIW R30,1
	LPM  R30,Z
	CALL SUBOPT_0x63
; 0002 0025         LCDE_H; delay_us(1); LCDE_L; delay_us(100);
; 0002 0026     }
	RJMP _0x4000A
_0x4000C:
; 0002 0027 }
	LDD  R17,Y+0
	RJMP _0x20A0003
; .FEND
;
;void Print( char *str, unsigned char row , unsigned char col)
; 0002 002A {
_Print:
; .FSTART _Print
; 0002 002B     unsigned char add;
; 0002 002C     switch(row)
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+3
;	row -> Y+2
;	col -> Y+1
;	add -> R17
	LDD  R30,Y+2
	LDI  R31,0
; 0002 002D     {
; 0002 002E         case 0: add = 0x80; break;
	SBIW R30,0
	BRNE _0x40010
	LDI  R17,LOW(128)
	RJMP _0x4000F
; 0002 002F         case 1: add = 0xC0; break;
_0x40010:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x40011
	LDI  R17,LOW(192)
	RJMP _0x4000F
; 0002 0030         case 2: add = 0x94; break;
_0x40011:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x40012
	LDI  R17,LOW(148)
	RJMP _0x4000F
; 0002 0031         case 3: add = 0xD4; break;
_0x40012:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4000F
	LDI  R17,LOW(212)
; 0002 0032     }
_0x4000F:
; 0002 0033     LCD_INS = add + col;
	CALL SUBOPT_0x62
; 0002 0034     LCDE_H; delay_us(1); LCDE_L; delay_us(100);
; 0002 0035     while(*(str) != '\0')
_0x40014:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x40016
; 0002 0036     {
; 0002 0037         LCD_DATA = *str++;
	LD   R30,X+
	STD  Y+3,R26
	STD  Y+3+1,R27
	CALL SUBOPT_0x63
; 0002 0038         LCDE_H; delay_us(1); LCDE_L; delay_us(100);
; 0002 0039     }
	RJMP _0x40014
_0x40016:
; 0002 003A }
	LDD  R17,Y+0
	RJMP _0x20A0003
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_usart_G100:
; .FSTART _put_usart_G100
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	CALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x30
	RJMP _0x20A0001
; .FEND
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x30
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0003:
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x64
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x64
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x65
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x66
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x65
	CALL SUBOPT_0x67
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x65
	CALL SUBOPT_0x67
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x65
	CALL SUBOPT_0x68
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x65
	CALL SUBOPT_0x68
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x64
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x64
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x66
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x64
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x66
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x69
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0002
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x69
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x6A
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x6A
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2020003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2020003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2020004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2020004:
	CALL SUBOPT_0x6B
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL SUBOPT_0x6C
_0x20A0001:
	ADIW R28,3
	RET
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x6B
	LDI  R26,LOW(0)
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL _i2c_stop
	ADIW R28,6
	RET
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x6B
	LDI  R26,LOW(3)
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	CALL SUBOPT_0x6F
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
	CALL SUBOPT_0x6E
	CALL _i2c_stop
	ADIW R28,8
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND

	.DSEG
_Relays:
	.BYTE 0x1
_Dens:
	.BYTE 0x1
_Quats:
	.BYTE 0x1
_Boms:
	.BYTE 0x1
_Sensors:
	.BYTE 0x1
_flagAutoDen:
	.BYTE 0x1
_flagAutoQuat:
	.BYTE 0x1
_flagAutoBom:
	.BYTE 0x1
_rx_buffer:
	.BYTE 0xFA
_arrStatuTB:
	.BYTE 0x19
_arrGioOn:
	.BYTE 0x1E
_arrPhutOn:
	.BYTE 0x1E
_arrGioOff:
	.BYTE 0x1E
_arrPhutOff:
	.BYTE 0x1E
_tx_buffer0:
	.BYTE 0x40
_tx_counter0:
	.BYTE 0x1
_s:
	.BYTE 0x1
_h:
	.BYTE 0x1
_m:
	.BYTE 0x1
_thu:
	.BYTE 0x1
_d:
	.BYTE 0x1
_n:
	.BYTE 0x1
_y:
	.BYTE 0x1
_display_buffer:
	.BYTE 0x14
_I_RH:
	.BYTE 0x1
_D_RH:
	.BYTE 0x1
_I_Temp:
	.BYTE 0x1
_D_Temp:
	.BYTE 0x1
_CheckSum:
	.BYTE 0x1
_doam:
	.BYTE 0x2
_temperature:
	.BYTE 0x1
_DoAmDat:
	.BYTE 0x1
_CamBienMua:
	.BYTE 0x1
_arrFlagHenGio:
	.BYTE 0x1E
_timeSensor:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:285 WORDS
SUBOPT_0x0:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x1:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2:
	LDI  R24,12
	CALL _printf
	ADIW R28,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_Sensors
	ANDI R30,0xFE
	OR   R30,R0
	STS  _Sensors,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LD   R30,Y
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R30,_Sensors
	ANDI R30,0xFD
	OR   R30,R0
	STS  _Sensors,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_Dens
	ANDI R30,0xFE
	OR   R30,R0
	STS  _Dens,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDS  R30,_Dens
	ANDI R30,0xFD
	OR   R30,R0
	STS  _Dens,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LD   R30,Y
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDS  R30,_Dens
	ANDI R30,0xFB
	OR   R30,R0
	STS  _Dens,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_Quats
	ANDI R30,0xFE
	OR   R30,R0
	STS  _Quats,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDS  R30,_Quats
	ANDI R30,0xFD
	OR   R30,R0
	STS  _Quats,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDS  R30,_Quats
	ANDI R30,0xFB
	OR   R30,R0
	STS  _Quats,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_Boms
	ANDI R30,0xFE
	OR   R30,R0
	STS  _Boms,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDS  R30,_Boms
	ANDI R30,0xFD
	OR   R30,R0
	STS  _Boms,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDS  R30,_Boms
	ANDI R30,0xFB
	OR   R30,R0
	STS  _Boms,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	MOV  R0,R30
	LDS  R30,_Relays
	ANDI R30,0xEF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R0,R30
	LDS  R30,_Relays
	ANDI R30,0xDF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_Relays
	ANDI R30,0xBF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDS  R30,_Relays
	ANDI R30,0x7F
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x16:
	LDS  R30,_Dens
	STS  4353,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x17:
	LDS  R30,_Quats
	STS  4354,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x18:
	LDS  R30,_Boms
	STS  4355,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDS  R30,_Sensors
	STS  4356,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	__GETD1N 0x5
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	CBI  0x12,4
	IN   R30,0x37
	ANDI R30,0xFB
	OUT  0x37,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	__GETD1N 0x6
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	__GETD1N 0x4
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x1E:
	__GETD1N 0x1
	CALL __PUTPARD1
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	__POINTW1FN _0x0,48
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	__GETD1N 0x7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	CALL __PUTPARD1
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	__GETD1N 0x8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	__GETD1N 0x9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	__GETD1N 0xB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	__GETD1N 0xC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	CALL __PUTPARD1
	LDI  R24,8
	CALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x28:
	__GETD1N 0x0
	CALL __PUTPARD1
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	CALL __PUTPARD1
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	SUBI R30,LOW(48)
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	MOV  R30,R6
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2C:
	MOV  R30,R6
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	STS  _Sensors,R30
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDI  R26,LOW(70)
	STD  Z+0,R26
	MOV  R30,R7
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	__GETB1MN _rx_buffer,1
	SUBI R30,LOW(48)
	MOV  R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x30:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	MOVW R18,R30
	ST   -Y,R19
	ST   -Y,R18
	MOV  R26,R17
	JMP  _MenuDisplay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	MOV  R17,R30
	ST   -Y,R19
	ST   -Y,R18
	MOV  R26,R17
	JMP  _MenuDisplay

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	SUBI R30,LOW(-91)
	SBCI R31,HIGH(-91)
	CALL __GETW2PF
	SBIW R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x34:
	ST   -Y,R19
	ST   -Y,R18
	MOV  R26,R17
	JMP  _MenuDisplay

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LPM  R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_arrStatuTB)
	SBCI R31,HIGH(-_arrStatuTB)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	MOVW R30,R18
	SUBI R30,LOW(-93)
	SBCI R31,HIGH(-93)
	CALL __GETW1PF
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x37:
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
	MOVW R30,R18
	LPM  R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_arrGioOn)
	SBCI R31,HIGH(-_arrGioOn)
	MOVW R26,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x38:
	SUBI R30,-LOW(1)
	ST   X,R30
	MOVW R30,R18
	LPM  R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	MOVW R30,R18
	LPM  R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_arrGioOn)
	SBCI R31,HIGH(-_arrGioOn)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(0)
	STD  Y+1,R30
	LDI  R30,LOW(255)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
	MOVW R30,R18
	LPM  R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_arrPhutOn)
	SBCI R31,HIGH(-_arrPhutOn)
	MOVW R26,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3C:
	MOVW R30,R18
	LPM  R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_arrPhutOn)
	SBCI R31,HIGH(-_arrPhutOn)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	CALL __PUTPARD1
	MOVW R30,R18
	LPM  R30,Z
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3E:
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
	MOVW R30,R18
	LPM  R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_arrGioOff)
	SBCI R31,HIGH(-_arrGioOff)
	MOVW R26,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3F:
	MOVW R30,R18
	LPM  R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_arrGioOff)
	SBCI R31,HIGH(-_arrGioOff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x40:
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
	MOVW R30,R18
	LPM  R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_arrPhutOff)
	SBCI R31,HIGH(-_arrPhutOff)
	MOVW R26,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x41:
	MOVW R30,R18
	LPM  R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_arrPhutOff)
	SBCI R31,HIGH(-_arrPhutOff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	STS  _Sensors,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _PrintFlash
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(_display_buffer)
	LDI  R31,HIGH(_display_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	LPM  R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x46:
	LDI  R31,0
	SUBI R30,LOW(-_arrPhutOn)
	SBCI R31,HIGH(-_arrPhutOn)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _Print
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x49:
	LDI  R31,0
	SUBI R30,LOW(-_arrPhutOff)
	SBCI R31,HIGH(-_arrPhutOff)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4A:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _Print

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _PrintFlash

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x4E:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_arrGioOn)
	SBCI R31,HIGH(-_arrGioOn)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(70)
	STD  Z+0,R26
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	SUBI R30,LOW(-_arrFlagHenGio)
	SBCI R31,HIGH(-_arrFlagHenGio)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	ST   -Y,R26
	LDD  R30,Y+5
	LDS  R26,_h
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	LDD  R30,Y+4
	LDS  R26,_m
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x53:
	STS  _Dens,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_arrFlagHenGio)
	SBCI R31,HIGH(-_arrFlagHenGio)
	LDI  R26,LOW(1)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	LDD  R30,Y+3
	LDS  R26,_h
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	LDD  R30,Y+2
	LDS  R26,_m
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	LD   R30,Y
	LDI  R31,0
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x58:
	STS  _Quats,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x59:
	STS  _Boms,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5A:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x5B:
	LD   R30,Z
	ST   -Y,R30
	MOV  R30,R17
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:141 WORDS
SUBOPT_0x5C:
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_arrGioOff)
	SBCI R31,HIGH(-_arrGioOff)
	LD   R30,Z
	ST   -Y,R30
	MOV  R30,R17
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x5D:
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_arrFlagHenGio)
	SBCI R31,HIGH(-_arrFlagHenGio)
	LD   R30,Z
	ST   -Y,R30
	MOV  R26,R17
	JMP  _checkHengioDen

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5E:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5F:
	LDI  R30,LOW(2)
	ST   -Y,R30
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x60:
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_arrFlagHenGio)
	SBCI R31,HIGH(-_arrFlagHenGio)
	LD   R30,Z
	ST   -Y,R30
	MOV  R26,R17
	JMP  _checkHengioQuat

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x61:
	STS  4362,R30
	LDS  R30,101
	ORI  R30,8
	STS  101,R30
	__DELAY_USB 7
	LDS  R30,101
	ANDI R30,0XF7
	STS  101,R30
	__DELAY_USB 7
	__DELAY_USW 1000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x62:
	LDD  R30,Y+1
	ADD  R30,R17
	STS  4362,R30
	LDS  R30,101
	ORI  R30,8
	STS  101,R30
	__DELAY_USB 7
	LDS  R30,101
	ANDI R30,0XF7
	STS  101,R30
	__DELAY_USW 500
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x63:
	STS  4361,R30
	LDS  R30,101
	ORI  R30,8
	STS  101,R30
	__DELAY_USB 7
	LDS  R30,101
	ANDI R30,0XF7
	STS  101,R30
	__DELAY_USW 500
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x64:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x65:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x66:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x67:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x68:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	CALL _i2c_start
	LDI  R26,LOW(208)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6C:
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6D:
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	LDI  R26,LOW(1)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	MOV  R26,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6F:
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x70:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	JMP  _i2c_read


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x12 ;PORTD
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,33
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,67
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1388
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__GEB12U:
	CP   R26,R30
	LDI  R30,1
	BRSH __GEB12U1
	CLR  R30
__GEB12U1:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:

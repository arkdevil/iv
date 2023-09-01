@echo off
cls
echo      ▄▄                  █
echo     ▀▀▀  Virus Magazine  █ Box 10, Kiev 148, Ukraine       IV   1996
echo     ▀██ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ █ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀ ▀▀▀▀▐▀▀▀  █▀▀▀▀▀▀▀█
echo      ▐█ █▀▄ █▀▀ ▄▀▀ ▄▀▀ ▄█▄ ▄▀▀ █▀█    ▌ █ ▄▀█ █ ▄▀▀ █▄▄   █ █ █▀█ █ 
echo       █ █ █ █▀  █▀  █    █  █▀  █ █    █ █ █ █ █ █   █     █ █ █ █ █
echo       █ ▐ ▐ ▐   ▐▄▄ ▐▄▄  ▐  ▐▄▄ ▐▄▀     ▀█ ▀▄█ ▐ ▐▄▄ ▐▄▄▄  █ █ █▄█ █
echo       ▐ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  █▄▄▄▄▄▄▄█
echo          (C) Copyright, 1994-96, by STEALTH group WorldWide, unLtd.
echo 
 
echo [ZOO v1.2] (cl) Dirty Nazi [Stealth group WorldWide]
echo NE-EXE files infector.
echo Infects DOS part of NE program.
echo Original length: 383b, length of linked EXE: 415b.
echo Press a key to compile...
pause >nul
cls
tasm.exe zoo.asm /m2 >nul
tlink.exe zoo.obj /t >nul
del zoo.map
del zoo.obj

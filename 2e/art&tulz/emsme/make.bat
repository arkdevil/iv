@ECHO OFF
ECHO      ▄▄                  █
ECHO     ▀▀▀  Virus Magazine  █ Box 176, Kiev 210, Ukraine      IV  1997
ECHO     ▀██ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ █ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀ ▀▀▀▀▐▀▀▀  █▀▀▀▀▀▀█
ECHO      ▐█ █▀▄ █▀▀ ▄▀▀ ▄▀▀ ▄█▄ ▄▀▀ █▀█    ▌ █ ▄▀█ █ ▄▀▀ █▄▄   █ ▀▀▀█ █
ECHO       █ █ █ █▀  █▀  █    █  █▀  █ █    █ █ █ █ █ █   █     █ ▄▄▄█ █
ECHO       █ ▐ ▐ ▐   ▐▄▄ ▐▄▄  ▐  ▐▄▄ ▐▄▀     ▀█ ▀▄█ ▐ ▐▄▄ ▐▄▄▄  █ █▄▄▄ █
ECHO       ▐ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  █▄▄▄▄▄▄█
ECHO          (C) Copyright, 1994-97, by STEALTH group WorldWide, unLtd.
ECHO         http://www.geocities.com/CapitolHill/8131 sgww@hotmail.com
ECHO            Digest of IV 8 - 11 russian, including Moscow issues
tasm emmedemo.asm/m2
tasm emme.asm/m2
tlink  emmedemo+emme/t
del emmedemo.obj
del emme.obj
del *.map
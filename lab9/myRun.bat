@echo off
REM echo Hello! This is gonna create assembly objects and link them automatically creating the .exe file


nasm -fobj c29_reverseWords.asm
nasm -fobj c29_main.asm
alink c29_main.obj c29_reverseWords.obj -oPE -subsys console -entry start
echo.
c29_main.exe
echo.
pause
@echo off

set errorlevel=0
masm %1.asm;
choice ### Continue linking? 
if errorlevel 2 goto :exit

:link
link %1.obj;
set errorlevel=0
choice ### Wanna Debug?
if errorlevel 2 goto :exit
echo :
debug %1.exe

:run
if %2==-r %1

:exit
echo :
echo !! Good Bye :) !!!


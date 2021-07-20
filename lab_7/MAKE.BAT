@echo off

del app.com
del keyb.com
del timer.com

cd tools

ml ..\src\main.asm
del main.obj
ren main.com ..\app.com

rem ml ..\src\timer.asm
rem del timer.obj
rem ren timer.com ..\timer.com

rem ml ..\src\keyb.asm
rem del keyb.obj
rem ren keyb.com ..\keyb.com

cd ..
@echo on

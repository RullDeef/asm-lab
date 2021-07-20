


del app.exe
if not exist obj md obj
cd tools

if exist ..\obj\main.obj del ..\obj\main.obj
ml ..\src\main.asm /c
ren main.obj ..\obj\main.obj

link ..\obj\main.obj,..\app.exe < ..\make.bat
cd ..

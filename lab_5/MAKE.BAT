


del app.exe
if not exist obj md obj
cd tools

if exist ..\obj\main.obj del ..\obj\main.obj
ml ..\src\main.asm /c
ren main.obj ..\obj\main.obj

if exist ..\obj\matrix.obj del ..\obj\matrix.obj
ml ..\src\matrix.asm /c
ren matrix.obj ..\obj\matrix.obj

if exist ..\obj\prompt.obj del ..\obj\prompt.obj
ml ..\src\prompt.asm /c
ren prompt.obj ..\obj\prompt.obj

link ..\obj\main.obj ..\obj\matrix.obj ..\obj\prompt.obj,..\app.exe < ..\make.bat
cd ..

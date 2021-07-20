


del app.exe
if not exist obj md obj
cd tools

if exist ..\obj\main.obj del ..\obj\main.obj
ml ..\src\main.asm /c
ren main.obj ..\obj\main.obj

if exist ..\obj\input.obj del ..\obj\input.obj
ml ..\src\input.asm /c
ren input.obj ..\obj\input.obj

if exist ..\obj\ubin.obj del ..\obj\ubin.obj
ml ..\src\ubin.asm /c
ren ubin.obj ..\obj\ubin.obj

if exist ..\obj\dec.obj del ..\obj\dec.obj
ml ..\src\dec.asm /c
ren dec.obj ..\obj\dec.obj

link ..\obj\main.obj ..\obj\input.obj ..\obj\ubin.obj ..\obj\dec.obj,..\app.exe < ..\make.bat
cd ..

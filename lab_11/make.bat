@echo off

if exist bin/main.obj del bin/main.obj
if exist app.exe del app.exe

\masm32\bin\ml.exe /I\masm32\include /Fomain.obj /c /coff src\main.asm
if not exist obj mkdir obj
move /Y .\main.obj obj\
\masm32\bin\link.exe /LIBPATH:\masm32\lib /SUBSYSTEM:WINDOWS /OUT:app.exe obj\main.obj

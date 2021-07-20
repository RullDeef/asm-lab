run : fpu.exe nofpu.exe
	./fpu.exe
	./nofpu.exe

fpu.exe : fpu.s
	gcc -o $@ $^

nofpu.exe : nofpu.s
	gcc -o $@ $^

fpu.s : fpu.c
	gcc -S -fno-asynchronous-unwind-tables -m80387 -o $@ $^

nofpu.s : fpu.c
	gcc -S -fno-asynchronous-unwind-tables -mno-80387 -o $@ $^

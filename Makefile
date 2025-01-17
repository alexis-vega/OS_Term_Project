CC=/usr/bin/cc -g

all:  bison-config flex-config nutshell

bison-config:
	bison -d nutshparser.y

flex-config:
	flex nutshscanner.l

nutshell: 
	$(CC) nutshell.c nutshparser.tab.c lex.yy.c -o nutshell.o

clean:
	rm nutshparser.tab.c nutshparser.tab.h lex.yy.c nutshell.o
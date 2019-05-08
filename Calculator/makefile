calc: flex  bison
	gcc -o calc calc.tab.c lex.yy.c -lfl

flex: calc.l
	flex -l calc.l

bison: calc.y
	bison -dv calc.y

clean:
	rm calc calc.tab.c lex.yy.c calc.tab.h

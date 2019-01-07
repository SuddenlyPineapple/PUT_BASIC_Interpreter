cls
bison -dy bison.y
flex lex.l
g++ lex.yy.c y.tab.c -o test.exe
test.exe < example_program.txt
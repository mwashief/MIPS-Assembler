
bison -d -y -v parser.y
g++ -w -c -o y.o y.tab.c
flex scanner.l
g++ -w -c -o l.o lex.yy.c
g++ -o parse y.o l.o
parse input.txt
LogisimCompatible

PAUSE


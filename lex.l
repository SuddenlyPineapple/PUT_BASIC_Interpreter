%option noyywrap 
/* eliminuje jakis rzaki bug wystepujacy we flexie, gdzie funkcja yywrap() wywolywana na koncu pliku nie dziala tak jak powinna z niokreslonych przyczyn */

%{
#include <iostream>
#include <string>
#include <cstring>
#include <vector>

#include "structs.h"
#include "y.tab.h"

int yyparse();
inline void assign_yyval_vName(char* text);

%}

%%
"PRINT"|"print" return PRINT;
"IF"|"if" return IF;
"WHILE"|"while" return WHILE;

"+"|"-"|"*"|"/"|"^" {
	yylval.vName = new std::string(yytext);
	return OPERATOR;
}

[A-Za-z]+ {
	yylval.vName = new std::string(yytext);
	return VAR;
}

[0-9]+ {
	yylval.iValue = atoi(yytext);
	return NUMBER;
	}

"=="|">"|">="|"<"|"<="|"!=" {
	yylval.vName = new std::string(yytext);
	return CMP;
}

[=;] {
	return yytext[0];
}

[ \t\n] ;

.	{
	return UNK;
	}

"//".*$   { /*komentarz*/ }

%%

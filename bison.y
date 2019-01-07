%{
	#include <iostream>
	#include <stdio.h>
	#include <stdlib.h>
    #include <map>
    #include <math.h>
	#include <algorithm>
	#include <cstring>
	#include <stack>
	#include "structs.h"

	/* Funkcje narzedzia lex */
	int yylex();
	void yyerror(std::string msg);

	/* Przechowywanie zmiennych i ich wartosci */
	std::map<std::string, int> variables;
	int instructionCounter = 0;
	
	static const std::map<std::string, int> order = {{"",0},{"+",0},{"-",0},{"*",1},{"/",1},{"^",2}};

	inline int execute(std::vector<Instruction>& instructions, int &i);
	inline int calc_exp(const std::vector<Ex_element>& expression);
	inline int arytmetic_calc(int &left, const std::string &op, int &right);

	/* Struktura przechowująca wszystkie instrukcje */
	// std::vector<Instruction> Instructions;
	// int liczbaInstrukcji = 0;

%}

%union {
    int iValue;
    std::string* vName;
	std::vector<Instruction>* Instructions;
    std::vector<Ex_element>* Expressions;
};

/* Wyrażenia nieterminalne */
%start PROGRAM //START of BISON interpratation
%type <Expressions> EXP //EXPRESSION - Wyrazenie
%type <iValue> CONDITION //CONDITION
%type <Instructions> ASSIGN // VAR ASSIGMENT
%type <Instructions> INSTRUCTION
%type <vName> VAR // VARIABLE

/* Tokeny z typem */
%token <iValue> NUMBER
%token <vName> CMP // COMPARATOR
%token <vName> OPERATOR //Instruction operator

/* Tokeny bez typu */
%token UNK PRINT VAR IF WHILE


%%
PROGRAM : PROGRAM INSTRUCTION ';' {
			for(int i = 0; i < $2->size(); i++){
                execute(*$2, i);
			}
		}
		| PROGRAM INSTRUCTION { yyerror("Missing ';' at the end of Instruction"); }
		| /* nic */
		;

INSTRUCTION : PRINT EXP { $$ = new std::vector<Instruction>{Instruction(drukuj, *$2)}; }
			| ASSIGN { $$ = $1; }
			| IF CONDITION INSTRUCTION {
				$$ = $3;
				$$->insert($$->begin(), Instruction(jezeli, std::vector<Ex_element>{Ex_element($2)}));
			}
			| WHILE VAR ASSIGN INSTRUCTION {
				$$ = $4;
				$$->insert($$->begin(), $3->begin(), $3->end());
				Instruction temp;
				temp.typ = petla;
				temp.varName = *$2;
				$$->insert($$->begin(), temp);
			}
			;

ASSIGN : VAR '=' EXP { $$ = new std::vector<Instruction>{Instruction(alloc, *$3, *$1)};}

EXP : NUMBER {$$ = new std::vector<Ex_element>{Ex_element($1)};}
	| VAR { if(variables.find((*$1)) == variables.end()) yyerror(("Variable " + (*$1) + " undeclared").c_str() );
		$$ = new std::vector<Ex_element>{Ex_element(*$1)};
		}
	| EXP OPERATOR NUMBER {
		($$->back()).operation = *$2;
		$$->emplace_back(Ex_element($3));
	}
	| EXP OPERATOR VAR {
		($$->back()).operation = *$2;
		$$->emplace_back(Ex_element(*$3));
	}
	;

CONDITION 	: EXP { 
				int a = calc_exp(*$1);
				a != 0 ? $$ = 1 : $$ = 0;
			}
			| EXP CMP EXP {
				int a = calc_exp(*$1);
				int b = calc_exp(*$3);
				//std::cout << a << " "  << (*$2) << " " << b << "\n";
				if((*$2) == ">") a > b ? $$ = 1: $$ = 0;
				else if((*$2) == "<") a < b ? $$ = 1 : $$ = 0;
				else if((*$2) == "==") a == b ? $$ = 1 : $$ = 0;
				else if((*$2) == ">=") a >= b ? $$ = 1 : $$ = 0;
				else if((*$2) == "<=") a <= b ? $$ = 1 : $$ = 0;
				else if((*$2) == "!=") a != b ? $$ = 1 : $$ = 0;
				else $$ = 0;
			}
			;

%%

int main(){
	yyparse();
	return 0;
}

void yyerror(std::string msg){
	std::cerr << "Error: " << msg << "!\n";
}

int arytmetic_calc(int& left, const std::string& op, int& right){
	if(op == "+") left += right;
	else if(op == "-") left -= right;
	else if(op == "*") left *= right;
	else if(op == "/") left /= right;
	else if(op == "^") left = pow(left, right);
}

int calc_exp(const std::vector<Ex_element>& expression){
	int result = 0; //Zmienna przechowująca wynik obliczen
    int tmpCalc = 0;
	int tmpVar = 0;
	
	expression[0].varName == "" ? result = expression[0].value : result = variables[expression[0].varName]; //Pierwsza liczba do wyniku
	if(expression.size() < 2) return result;

	std::stack<Ex_element> remembered;

	for(int i = 0; i < expression.size() - 1; i++){
		expression[i+1].varName == "" ? tmpVar = expression[i+1].value : tmpVar = variables[expression[i+1].varName]; //Pobieranie zmiennej lub odczytywanie wartosci elementu

        if( order.at(expression[i].operation) >= order.at(expression[i+1].operation) ) {
            remembered.empty() ? arytmetic_calc(result, expression[i].operation, tmpVar) : arytmetic_calc(tmpCalc, expression[i].operation, tmpVar);
        } else {
            tmpCalc = tmpVar; 
            remembered.emplace(expression[i]);
        }

        while(!remembered.empty()){
            if( order.at(remembered.top().operation) >= order.at(expression[i + 1].operation) ) {
                if( remembered.size() > 1 ) { 
                    remembered.top().varName == "" ? tmpVar = remembered.top().value : tmpVar = variables[remembered.top().varName];      
					arytmetic_calc(tmpCalc, remembered.top().operation, tmpVar);
                } else 
					arytmetic_calc(result, remembered.top().operation, tmpCalc);

                remembered.pop();
                if(remembered.empty()) tmpCalc = 0;
            }
            else break;
        }
	}
	return result;
}

int execute(std::vector<Instruction>& instructions, int &i){
	Instruction &instr = instructions[i];
	//std::cout << ++instructionCounter << " : " << i << "# "; instr.display();

	switch(instr.typ){
        case alloc : {
            variables[instr.varName] = calc_exp(instr.expression);
            std::cout << "Zmienna " << instr.varName << " ma wartosc " << variables[instr.varName] << "\n";
            break;
        }
		case drukuj : {
            std::cout << calc_exp(instr.expression) << "\n";
            break;
        }
		case jezeli : {
			if(instr.expression[0].value == 0) i++;
			break;
		}
		case petla : {
			const std::string controlVar = instr.varName;
			int action = 2;
			int control = 1;
			i+=2;
			while(variables[controlVar] != 0){
				//std::cout << "\n" << "It " << g++ << "\n";
				execute(instructions, action); 
				execute(instructions, control);
			}
			break;
		}
    }
	return 0;
}



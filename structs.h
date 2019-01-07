#ifndef STRUCTS_H
#define STRUCTS_H
    
#include <string>
#include <vector>
#include <iostream>

/* Typy operacji - wykorzystywane w stukturze instrukcji */
enum OPERATIONS{jezeli, drukuj, alloc, petla};

/* Equation element - rownania zagniezdzone w instrukcji sa w ten sposob wykonywane osobno i dzieki temu mozemy je zapamietac w jednej instrukcji*/
struct Ex_element {
    std::string varName;
    int value;
    std::string operation = "";

    Ex_element() {}
    Ex_element(const int& val, std::string varName = "") : value(val), varName(varName) {}
    Ex_element(std::string varName = "") : varName(varName) {}

};

/* Struktura Instrukcji */
struct Instruction {
    enum OPERATIONS typ;
    std::vector<Ex_element> expression;
    std::string varName;

    Instruction(){}

    Instruction(OPERATIONS typ, std::vector<Ex_element> expression, std::string varName = ""):
        typ(typ),
        expression(expression),
        varName(varName)
    {}

    void display(){
        const char* operationNames[] = {"jezeli", "drukuj", "alloc", "petla"};
        std::cout 	<< "Instruction: type(" << operationNames[this->typ]
                    << "), name(" << this->varName 
                    << "), EXP(";

        for(int i = 0; i < expression.size(); i++){
		    if(expression[i].varName == "") std::cout << expression[i].value << expression[i].operation;
            else std::cout << expression[i].varName << expression[i].operation;
	    }
        std::cout << ")\n";
    }
};

#endif
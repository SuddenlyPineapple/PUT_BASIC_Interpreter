# PUT_BASIC_Interpreter
Simple interpreter of my own BASIC programming language. It's project for my studies at Poznan University of Technology.

## Language Syntax
### Instructions
  - `VARIABLE_NAME = EXP` - it's variable assigments instruction,
  - `PRINT` - `PRINT EXP` or `PRINT VARIABLE_NAME`,
  - `IF` - `IF(EXP CMP EXP) INSTRUCTION`,
  - `WHILE` - `WHILE VARIABLE_NAME VARIABLE_CONTROL INSTRUCTION` - where `VARIABLE NAME` is variable which control loop, `VARIABLE_CONTROL` is instruction, which changes variable controling loop and `INSTRUCTION` is instruction executing while looping.

### Symbols Description
  - `EXP` - (expression) - for example `a+5-b*3+2^2`:
    - `NUMBER` - single number,
    - `VAR` -single variable,
    - `OPERATOR` - `+`,`-`,`*`,`/`,`^` - operators addition, subtraction, multiplication, division and  of variables/numbers,
  - `CMP` - it's comparator implemented as `>`
  - `INSTRUCTION` - single or multiple instructions - in our grammar this stands for line of this language code.

## Functionality
PUT_BASIC is able to:
 - perform basic arythmetic operations in proper order,
 - do simple error detection,
 - make conditions checking and then execute instruction whether condition is true or not,
 - perform actions in loops,
 - printing some stuff on screen - like value of variable or expression.

## Example program
Check example_program.PB file.

## Required Software
For run this interpreter you need this dependencies: 
  - any C++ compilator
  - Flex binaries
  - Bison/Yacc binaries
  
## Run
When you install all dependencies just start in command line `start.bat`file. If you are linux user change it's extension to `.sh` and delete `cls` instruction from this script.

## Special Thanks
[Gunock](https://github.com/Gunock) - for the concept of the stack of calculations, which made it possible to perform calculations in the correct order.

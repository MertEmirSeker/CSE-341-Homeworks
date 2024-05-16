%{
#include "gpp_lexer.c"    // Include the lexer generated by Flex
#include "y.tab.h"        // Include the header file generated by Yacc
%}

%union
{
    char* str_val;          // Define a union for semantic values with string type
}

%token KW_AND KW_OR KW_NOT KW_EQUAL KW_LESS KW_NIL KW_LIST KW_APPEND KW_CONCAT KW_SET KW_FOR KW_IF KW_EXIT KW_LOAD KW_DISPLAY KW_TRUE KW_FALSE
%token OP_PLUS OP_MINUS OP_DIV OP_MULT OP_OP OP_CP OP_COMMA
%token COMMENT
%token <str_val> VALUEF KW_DEF IDENTIFIER
%type <str_val> EXP FUNCTION

%%

START: /* empty */
    | START EXP { printf("Result = %s\n", $2); } // Print the result of an expression
    | START FUNCTION { ; }                          // Handle function definitions
    | START OP_OP KW_EXIT OP_CP { printf("Exiting the G++ Language Interpreter using Flex and Yacc. Goodbye!!!\n"); exit(0); }
    ;

EXP: 
    | VALUEF { $$ = $1; }                         // Valuef or identifier
    | IDENTIFIER { $$ = $1; }
    | OP_OP OP_PLUS EXP EXP OP_CP { if ($3[0] >= '0' && $3[0] <= '9' && $4[0] >= '0' && $4[0] <= '9') 
                                        $$ = add_fractions($3, $4);   // Add fractions if both operands are numeric
                                    else 
                                        $$ = create_operation_string("+", $3, $4);   // Otherwise, create a string for the operation
                                  }
    | OP_OP OP_MINUS EXP EXP OP_CP { if ($3[0] >= '0' && $3[0] <= '9' && $4[0] >= '0' && $4[0] <= '9') 
                                        $$ = sub_fractions($3, $4);   // Subtract fractions if both operands are numeric
                                    else 
                                        $$ = create_operation_string("-", $3, $4);
                                  }
    | OP_OP OP_MULT EXP EXP OP_CP { if ($3[0] >= '0' && $3[0] <= '9' && $4[0] >= '0' && $4[0] <= '9') 
                                        $$ = mult_fractions($3, $4);  // Multiply fractions if both operands are numeric
                                    else 
                                        $$ = create_operation_string("*", $3, $4);
                                  }
    | OP_OP OP_DIV EXP EXP OP_CP { if ($3[0] >= '0' && $3[0] <= '9' && $4[0] >= '0' && $4[0] <= '9') 
                                        $$ = div_fractions($3, $4);   // Divide fractions if both operands are numeric
                                    else 
                                        $$ = create_operation_string("/", $3, $4);
                                 }
    | OP_OP IDENTIFIER EXP OP_CP { char* args[1] = {$3}; $$ = execute_function($2, args, 1); }   // Function with 1 argument or definition
    | OP_OP IDENTIFIER EXP EXP OP_CP { char* args[2] = {$3, $4}; $$ = execute_function($2, args, 2); }   // Function with 2 arguments or definition
    | OP_OP IDENTIFIER EXP EXP EXP OP_CP { char* args[3] = {$3, $4, $5}; $$ = execute_function($2, args, 3); }   // Function with 3 arguments or definition
    ;

FUNCTION:
    | OP_OP KW_DEF IDENTIFIER EXP OP_CP { char* args[1] = {NULL}; define_function($3, $4, args, 0); }   // Function definition with 0 arguments
    | OP_OP KW_DEF IDENTIFIER IDENTIFIER EXP OP_CP { char* args[1] = {$4}; define_function($3, $5, args, 1); }   // Function definition with 1 argument
    | OP_OP KW_DEF IDENTIFIER IDENTIFIER IDENTIFIER EXP OP_CP { char* args[2] = {$4, $5}; define_function($3, $6, args, 2); }   // Function definition with 2 arguments
    ;

%%

int main()
{
    printf("Welcome to G++ Language Interpreter using Flex and Yacc!!!\n");
    printf("Please type an expression or (exit) to exit.\n");

    while (1)
    {
        yyparse();   // Start parsing user input
    }

    return 0;
}
%{
    #include <stdio.h> 
    int yylex(void); 
    void yyerror(char *); 
%} 
%token Lit_int
%token IGUAL
%token Palabra_reservada
%token Identificador
%token Operador
%token Opcompuesto

%token Lit_float
%token Lit_bool
%token Lit_char
%token Lit_String



%% 
expr: 
        Identificador IGUAL Lit_int          {printf("Correcto");}
        ; 


%% 
void yyerror(char *s) { 
    fprintf(stderr, "%s\n", s); 
} 
int main(void) { 
    yyparse(); 
    return 0; 
} 

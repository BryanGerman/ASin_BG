%{
#include <stdio.h>
int yylex(void);
void yyerror(char *);
extern FILE* yyin;
extern FILE* yyout;
int errors;
%}
%token Lit_int
%token IGUAL
%token Palabra_reservada
%token Identificador
%token Operador
%token Opcompuesto
%token OpControl
%token OP
%token OPLog
%token OpLogControl
%token TipoDato
%token Lit_float
%token ENTERO
%token ENTERO_NEG
%token Lit_bool
%token Lit_char
%token Lit_String
%token ASIGNACION
%token PUNTOCOM
%token SEPARADOR
%token AGRPAR_AB
%token AGRPAR_CE
%token AGRCOR_AB 
%token AGRCOR_CE
%token AGRLLAV_AB 
%token AGRLLAV_CE
%token IF
%token THEN
%token ELSE
%token WHILE
%token DO
%token INPUT
%token OUTPUT
%token RETURN

%%
prog: 
		prog atribucion
		|prog asignacionglobal
		|prog funcion
		|prog if
		|prog while
		|prog asignacionLocal
		|
		;

asignacionglobal:
		TipoDato ASIGNACION Identificador {fprintf(yyout,"Asignacion Global");}
		|TipoDato 
		|error {errors++;}
		;
funcion:
		TipoDato Identificador ASIGNACION stackAsig bloqueComandos		{fprintf(yyout,"funcion");}
		|TipoDato Identificador ASIGNACION AGRPAR_AB  AGRPAR_CE bloqueComandos  {fprintf(yyout,"funcion");}
		|TipoDato tamaVector IGUAL valor					{fprintf(yyout,"funcion");}
		;


atribucion:
		Identificador IGUAL stackOp		{fprintf(yyout,"atribucion");}
		| Identificador IGUAL valor		{fprintf(yyout,"atribucion");}
		| Identificador IGUAL Identificador 	{fprintf(yyout,"atribucion");}
		;

tamaVector: 	
		AGRCOR_AB ENTERO AGRCOR_CE
		;

if: 
		IF stackOpLogControl
		|IF stackOpLogControl THEN bloqueComandos
		|IF stackOpLogControl THEN bloqueComandos ELSE bloqueComandos
		|IF stackOpLogControl THEN if
		|IF stackOpLogControl THEN if ELSE bloqueComandos
		;

while:
		|WHILE stackOpLogControl DO bloqueComandos
		|WHILE stackOpLogControl DO while
		|DO bloqueComandos WHILE stackOpLogControl
		|DO while WHILE stackOpLogControl
		;

stackOpLogControl: 	
		AGRPAR_AB stackOpLogControl AGRPAR_CE
		|Identificador OpControl Identificador
		|Identificador OpControl valor
		|Identificador OpControl OperacionArit
		|AGRPAR_AB stackOpLogControl AGRPAR_CE OpLogControl stackOpLogControl
		|Identificador OpControl Identificador OpLogControl stackOpLogControl
		|Identificador OpControl valor OpLogControl stackOpLogControl
		|Identificador OpControl OperacionArit OpLogControl stackOpLogControl
		|AGRPAR_AB stackOpLogControl AGRPAR_CE bloqueComandos
		|Identificador OpControl Identificador bloqueComandos
		|Identificador OpControl valor bloqueComandos
		|Identificador OpControl OperacionArit bloqueComandos
		|AGRPAR_AB stackOpLogControl AGRPAR_CE OpLogControl stackOpLogControl bloqueComandos
		|Identificador OpControl Identificador OpLogControl stackOpLogControl bloqueComandos
		|Identificador OpControl valor OpLogControl stackOpLogControl bloqueComandos
		|Identificador OpControl OperacionArit OpLogControl stackOpLogControl bloqueComandos
		;

bloqueComandos: 
		AGRLLAV_AB AGRLLAV_CE
		|AGRLLAV_AB asignacionLocal AGRLLAV_CE
		|AGRLLAV_AB atribucion AGRLLAV_CE
		|stackAsig
		;

stackAsig: 	
		AGRPAR_AB stackAsig AGRPAR_CE
		|lista
		;
stackOp: 	
		AGRPAR_AB stackOp AGRPAR_CE
		|OperacionArit
		|OperacionLog
		;

OperacionArit:
		Identificador OP valor 
		|valor OP valor	
		|Identificador OP Identificador	
		|Identificador OP OperacionArit
		|valor OP OperacionArit
		;
OperacionLog:
		Identificador OPLog valor 
		|valor OPLog valor	
		|Identificador OPLog Identificador
		|Identificador OPLog OperacionLog
		|valor OPLog OperacionLog
		;

lista:
		TipoDato ASIGNACION Identificador
		|lista SEPARADOR lista
		; 

asignacionLocal:
		TipoDato ASIGNACION Identificador PUNTOCOM {fprintf(yyout,"asignacionLocal");}
		;
valor: 
		ENTERO_NEG
		|ENTERO
		|Lit_float 
		|Lit_char
		|Lit_bool
		|Lit_String
		;

		
	
%%
void yyerror(char *s) { 
    fprintf(stderr, "%s\n", s);}

/*int main(void) { 
    yyparse(); 
    return 0; 
} */

int main () {
        yyin = fopen ("Codigo.txt", "r");
        yyout = fopen ("output.txt","w");
        yyparse();
      	fclose(yyout);
}

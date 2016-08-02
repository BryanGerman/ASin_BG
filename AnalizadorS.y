%{
#include <stdio.h>
int yylex(void);
void yyerror(char *);
extern char* yytext;
extern int yylval;
extern FILE* yyin;
extern FILE* yyout;
extern char* yycopy;
int errors;
%}
%token Lit_int
%token IGUAL
%token Palabra_reservada
%token <identificador>Identificador
%token Operador
%token Opcompuesto
%token OpControl
%token OP
%token OPLog
%token OpLogControl
%token <tipo>TipoDato
%token Lit_float
%token <entero>ENTERO
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

%union {
int entero;
char* tipo;
char* identificador;
}


%%
prog: 
		prog asignacionglobal
		|prog funcion
		|
		;

asignacionglobal:
		TipoDato ASIGNACION Identificador 
		;
funcion:
		TipoDato Identificador ASIGNACION stackAsig AGRLLAV_AB bloqueComandosFunciones RETURN Identificador AGRLLAV_CE	{fprintf(yyout," funcion ");}
		|TipoDato Identificador ASIGNACION AGRPAR_AB  AGRPAR_CE AGRLLAV_AB bloqueComandosFunciones RETURN Identificador AGRLLAV_CE  {fprintf(yyout," funcion ");}
		|TipoDato tamaVector Identificador AGRPAR_AB  AGRPAR_CE AGRLLAV_AB bloqueComandosFunciones RETURN Identificador AGRLLAV_CE  {fprintf(yyout," funcion ");}
		|TipoDato tamaVector Identificador stackAsig AGRLLAV_AB bloqueComandosFunciones RETURN Identificador AGRLLAV_CE  {fprintf(yyout," funcion ");}
		;
tamaVector: 	
		AGRCOR_AB ENTERO AGRCOR_CE
		;
bloqueComandosFunciones: 
		stackAsig bloqueComandosFunciones 		
		|atribucion bloqueComandosFunciones		
		|asignacionLocal bloqueComandosFunciones	
		|if bloqueComandosFunciones			
		|while bloqueComandosFunciones			
		|stackAsig					
		|atribucion					
		|asignacionLocal				
		|if						
		|while						
		|input
		|output
		;

if: 
		IF stackOpLogControl				
		|IF stackOpLogControl THEN bloqueComandosIF	
		|IF stackOpLogControl THEN bloqueComandosIF ELSE bloqueComandosIF	
		|IF stackOpLogControl THEN AGRLLAV_AB if AGRLLAV_CE	
		|IF stackOpLogControl THEN AGRLLAV_AB if AGRLLAV_CE ELSE AGRLLAV_AB bloqueComandosIF AGRLLAV_CE
		;

bloqueComandosIF: 
		AGRLLAV_AB bloqueComandosIF AGRLLAV_CE	
		|atribucion			
		|asignacionLocal			
		|atribucion bloqueComandosIF		
		|asignacionLocal bloqueComandosIF	
		|while					
		|input
		|output
		;

while:
		WHILE stackOpLogControl DO bloqueComandosWhile
		|WHILE stackOpLogControl DO while		
		|DO bloqueComandosWhile WHILE stackOpLogControl	
		|DO while WHILE stackOpLogControl		
		|if						
		;

stackOpLogControl: 	
		AGRPAR_AB stackOpLogControl AGRPAR_CE
		|Identificador OpControl Identificador
		|Identificador OpControl valorNumerico
		|Identificador OpControl valorCaracter
		|Identificador OpControl OperacionArit
		|AGRPAR_AB stackOpLogControl AGRPAR_CE OpLogControl stackOpLogControl
		|Identificador OpControl Identificador OpLogControl stackOpLogControl
		|Identificador OpControl valorNumerico OpLogControl stackOpLogControl
		|Identificador OpControl valorCaracter OpLogControl stackOpLogControl
		|Identificador OpControl OperacionArit OpLogControl stackOpLogControl
		|AGRPAR_AB stackOpLogControl AGRPAR_CE bloqueComandosWhile
		|Identificador OpControl Identificador bloqueComandosWhile
		|Identificador OpControl valorNumerico bloqueComandosWhile
		|Identificador OpControl valorCaracter bloqueComandosWhile
		|Identificador OpControl OperacionArit bloqueComandosWhile
		|AGRPAR_AB stackOpLogControl AGRPAR_CE OpLogControl stackOpLogControl bloqueComandosWhile
		|Identificador OpControl Identificador OpLogControl stackOpLogControl bloqueComandosWhile
		|Identificador OpControl valorNumerico OpLogControl stackOpLogControl bloqueComandosWhile
		|Identificador OpControl valorCaracter OpLogControl stackOpLogControl bloqueComandosWhile
		|Identificador OpControl OperacionArit OpLogControl stackOpLogControl bloqueComandosWhile
		;
bloqueComandosWhile: 
		AGRLLAV_AB bloqueComandosWhile AGRLLAV_CE 	
		|atribucion					
		|asignacionLocal				
		|atribucion bloqueComandosWhile			
		|asignacionLocal bloqueComandosWhile		
		|if						
		|input
		|output
		;

atribucion:
		Identificador IGUAL stackOp		
		| Identificador IGUAL valorNumerico	
		| Identificador IGUAL valorCaracter	
		| Identificador IGUAL Identificador 	
		| Identificador AGRCOR_AB ENTERO AGRCOR_CE IGUAL valorNumerico 
		| Identificador AGRCOR_AB ENTERO AGRCOR_CE IGUAL valorCaracter
		| Identificador AGRCOR_AB ENTERO AGRCOR_CE IGUAL Identificador AGRCOR_AB ENTERO AGRCOR_CE 
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
		Identificador OP valorNumerico 		
		|valorNumerico OP valorNumerico		
		|Identificador OP Identificador		
		|Identificador OP OperacionArit		
		|valorNumerico OP OperacionArit		
		;
OperacionLog:
		Identificador OPLog valorNumerico 
		|valorNumerico OPLog valorNumerico	
		|Identificador OPLog Identificador
		|Identificador OPLog OperacionLog
		|valorNumerico OPLog OperacionLog
		;

lista:
		TipoDato ASIGNACION Identificador
		|lista SEPARADOR lista
		; 

asignacionLocal:
		TipoDato ASIGNACION Identificador PUNTOCOM  {fprintf(datos,"%s,%s,0,Asignacion Local\n",$3,$1);}
		;
valorNumerico: 
		ENTERO_NEG
		|ENTERO
		|Lit_float 
		;
valorCaracter:
		Lit_char
		|Lit_bool
		|Lit_String
		;

input:
		INPUT AGRPAR_AB Lit_String AGRPAR_CE	
		;
output:
		OUTPUT AGRPAR_AB Lit_String SEPARADOR Identificador AGRPAR_CE 
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
        yyout = fopen ("output.csv","w");
        yyparse();
      	fclose(yyout);
}

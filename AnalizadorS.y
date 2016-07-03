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
		prog asignacionglobal
		|prog funcion
		|
		;

asignacionglobal:
		TipoDato ASIGNACION Identificador {fprintf(yyout," AsignacionGlobal ");}
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
		stackAsig bloqueComandosFunciones 		{fprintf(yyout," Parte de la funcion ");}
		|atribucion bloqueComandosFunciones		{fprintf(yyout," Parte de la funcion ");}
		|asignacionLocal bloqueComandosFunciones	{fprintf(yyout," Parte de la funcion ");}
		|if bloqueComandosFunciones			{fprintf(yyout," Parte de la funcion ");}
		|while bloqueComandosFunciones			{fprintf(yyout," Parte de la funcion ");}
		|stackAsig					{fprintf(yyout," Parte de la funcion ");}
		|atribucion					{fprintf(yyout," Parte de la funcion ");}
		|asignacionLocal				{fprintf(yyout," Parte de la funcion ");}
		|if						{fprintf(yyout," Parte de la funcion ");}
		|while						{fprintf(yyout," Parte de la funcion ");}
		|input
		|output
		;

if: 
		IF stackOpLogControl				{fprintf(yyout," if ");}
		|IF stackOpLogControl THEN bloqueComandosIF	{fprintf(yyout," if ");}
		|IF stackOpLogControl THEN bloqueComandosIF ELSE bloqueComandosIF	{fprintf(yyout," if ");}
		|IF stackOpLogControl THEN AGRLLAV_AB if AGRLLAV_CE	{fprintf(yyout," if ");}
		|IF stackOpLogControl THEN AGRLLAV_AB if AGRLLAV_CE ELSE AGRLLAV_AB bloqueComandosIF AGRLLAV_CE {fprintf(yyout," if ");}
		;

bloqueComandosIF: 
		AGRLLAV_AB bloqueComandosIF AGRLLAV_CE	{fprintf(yyout," Parte del if ");}
		|atribucion				{fprintf(yyout," Parte del if ");}
		|asignacionLocal			{fprintf(yyout," Parte del if ");}
		|atribucion bloqueComandosIF		{fprintf(yyout," Parte del if ");}
		|asignacionLocal bloqueComandosIF	{fprintf(yyout," Parte del if ");}
		|while					{fprintf(yyout," Parte del if ");}
		|input
		|output
		;

while:
		WHILE stackOpLogControl DO bloqueComandosWhile	{fprintf(yyout," while ");}
		|WHILE stackOpLogControl DO while		{fprintf(yyout," while ");}
		|DO bloqueComandosWhile WHILE stackOpLogControl	{fprintf(yyout," while ");}
		|DO while WHILE stackOpLogControl		{fprintf(yyout," while ");}
		|if						{fprintf(yyout," while ");}
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
		AGRLLAV_AB bloqueComandosWhile AGRLLAV_CE 	{fprintf(yyout," Parte del while ");}
		|atribucion					{fprintf(yyout," Parte del while ");}
		|asignacionLocal				{fprintf(yyout," Parte del while ");}
		|atribucion bloqueComandosWhile			{fprintf(yyout," Parte del while ");}
		|asignacionLocal bloqueComandosWhile		{fprintf(yyout," Parte del while ");}
		|if						{fprintf(yyout," Parte del while ");}
		|input
		|output
		;

atribucion:
		Identificador IGUAL stackOp		{fprintf(yyout," atribucion");}
		| Identificador IGUAL valorNumerico	{fprintf(yyout," atribucion");}
		| Identificador IGUAL valorCaracter	{fprintf(yyout," atribucion ");}
		| Identificador IGUAL Identificador 	{fprintf(yyout," atribucion ");}
		| Identificador AGRCOR_AB ENTERO AGRCOR_CE IGUAL valorNumerico {fprintf(yyout," atribucion ");}
		| Identificador AGRCOR_AB ENTERO AGRCOR_CE IGUAL valorCaracter {fprintf(yyout," atribucion ");}
		| Identificador AGRCOR_AB ENTERO AGRCOR_CE IGUAL Identificador AGRCOR_AB ENTERO AGRCOR_CE {fprintf(yyout," atribucion ");}
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
		Identificador OP valorNumerico 		{fprintf(yyout," Operacion aritmetica ");}
		|valorNumerico OP valorNumerico		{fprintf(yyout," Operacion aritmetica ");}
		|Identificador OP Identificador		{fprintf(yyout," Operacion aritmetica ");}
		|Identificador OP OperacionArit		{fprintf(yyout," Operacion aritmetica ");}
		|valorNumerico OP OperacionArit		{fprintf(yyout," Operacion aritmetica ");}
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
		TipoDato ASIGNACION Identificador PUNTOCOM {fprintf(yyout,"asignacionLocal");}
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
		INPUT AGRPAR_AB Lit_String AGRPAR_CE	{fprintf(yyout," printf ");}
		;
output:
		OUTPUT AGRPAR_AB Lit_String SEPARADOR Identificador AGRPAR_CE {fprintf(yyout," scanf ");}
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

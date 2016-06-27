%{
#include <stdlib.h> 
void yyerror(char *); 
#include "AnalizadorS.tab.h" 
int num_lineas = 0, num_caracteres = 0;
FILE * salida;
%}
ID       [a-z][a-z|A-Z|0-9]*
DIGITO [0-9]
CHAR  [a-z|0-9]


%%
\n {	++num_lineas;
	++num_caracteres;
}

int|float|bool|char|string					return TipoDato;

if|then|else|while|do|input|output|return 			return Palabra_reservada;

{ID}        {	yylval = *yytext;
		return Identificador;}

"="		return IGUAL;


","|"("|")"|"["|"]"|"{"|"}"|"+"|"-"|"*"|"/"|"<"|">"|"!"|"%"|"&"|"$" {return Operador;}

"<="|">="|"=="|"!="|"&&"|"||"  {return Opcompuesto;}

{DIGITO}*|"-"{DIGITO}* { 	yylval = atoi(yytext); 
				return Lit_int;}

{DIGITO}*",""0"+|{DIGITO}*","{DIGITO}+|"-"{DIGITO}*",""0"+|"-"{DIGITO}*","{DIGITO}+  { 		yylval = atoi(yytext); 
												return Lit_float;}

true|false|TRUE|FALSE	{ return Lit_bool;}

"'"[a-z|A-Z|0-9]"'"  {return Lit_char;}

"\""[^\n]*"\"" {return Lit_String;}

"/""*"[^·]*"*""/"

"\/""\/"[^}\n]*

[ \t]+ 



.       {    
	fprintf(salida, "Error en la línea: %d    %s\n",num_caracteres, yytext );
}




%%


int yywrap(void) { 
	 yyin = fopen( "Codigo.txt", "r" );
	salida = fopen("CodigoTokenClasses.txt","w");
    return 1; 
}

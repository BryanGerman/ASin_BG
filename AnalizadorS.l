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

int|float|bool|char|string|if|then|else|while|do|input|output|return {
	    fprintf(salida," Palabra_reservada ");
	    }

{ID}        {
		
		fprintf( salida," Identificador ");
		return Identificador;}

"="		return IGUAL;

","|":"|"("|")"|"["|"]"|"{"|"}"|"+"|"-"|"*"|"/"|"<"|">"|"!"|"%"|"&"|"$" {fprintf( salida," Operador ");}

"<="|">="|"=="|"!="|"&&"|"||"  {fprintf(salida," Opcompuesto ");}

{DIGITO}*|"-"{DIGITO}* { 
					
			fprintf(salida," Lit_int ");
			return Lit_int;	}

{DIGITO}*",""0"+|{DIGITO}*","{DIGITO}+|"-"{DIGITO}*",""0"+|"-"{DIGITO}*","{DIGITO}+  { fprintf(salida," Lit_float ");}

true|false|TRUE|FALSE	{ fprintf(salida,"Lit_bool ");}

"'"[a-z|A-Z|0-9]"'"  {fprintf (salida,"Lit_char ");}

"\""[^\n]*"\"" {fprintf(salida,"Lit_String");}

"/""*"[^·]*"*""/"

"\/""\/"[^}\n]*

[ \t]+ 

";"	fprintf(salida, "\n");

.       {    
	fprintf(salida, "Error en la línea: %d    %s\n",num_caracteres, yytext );
}




%%


int yywrap(void) { 
	 yyin = fopen( "Codigo.txt", "r" );
	salida = fopen("CodigoTokenClasses.txt","w");
    return 1; 
}
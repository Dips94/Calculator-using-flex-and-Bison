%{
#include <stdio.h>
#include "calc.tab.h"
%}

%option yylineno

digit	([0-9])

%%

"print"       {       return(TOK_PRINT);}

"main"       {	return(TOK_MAIN);   }

"float"		{	return(TOK_FLOAT);	}

[a-z][a-zA-Z0-9]* {	strcpy(yylval.id.name,yytext); 
			yylval.id.floatvalue  = 0.0;
		     return(TOK_ID);    } 

{digit}+\.{digit}+	{
		sscanf(yytext, "%f", &(yylval.float_val));
		return TOK_NUM;
		}


"{"	{	return(TOK_OPEN);	}
"}"	{	return(TOK_CLOSE);	}
";"	{	return(TOK_SEMICOLON);	}
"="	{	return(TOK_EQUALS);	}
"-"	{	return(TOK_SUB);	}
"*"	{	return(TOK_MUL);	}
"("	{	return(TOK_OP);      }
")"	{	return(TOK_CL);      }
[ \t]                     ;
[ \n]			  ;
. {printf("Lexical Analysis Error: %c \n",
			yytext[0]);
	}

%%

%{
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
%}

%token TOK_SEMICOLON TOK_SUB TOK_MUL TOK_MAIN TOK_NUM TOK_PRINT TOK_ID TOK_OPEN TOK_CLOSE TOK_EQUALS TOK_FLOAT TOK_OP TOK_CL

%union{
        float float_val;
	struct identifier id;
	int int_val;
	
}

%code requires {

struct identifier
{
char name[100];
float floatvalue;
};
}

%code {
struct identifier idlist[10000];
int symtab_size=0;

struct identifier* initialize(struct identifier id)
{
     int k;
	k = symtab_size;
        for(;k>=0;k--){
                if(!strcmp(id.name,idlist[k].name)){
                        return &idlist[k];
                }
        }
        return NULL;
}


}

%type <float_val> expr TOK_NUM
%type <id> TOK_ID
%type <int_val> TOK_OPEN TOK_CLOSE block

%left TOK_SUB
%left TOK_MUL
%left UMINUS
%right TOK_EQUALS
%%

program: 
	TOK_MAIN TOK_OP TOK_CL TOK_OPEN stmts TOK_CLOSE
;

stmts: 
	| stmt stmts

;


stmt: 
	TOK_FLOAT TOK_ID TOK_SEMICOLON
	{	
		 struct identifier *id = initialize($2);
		 strcpy(idlist[symtab_size].name,$2.name);
		 symtab_size++;
        		
	}
	| TOK_ID TOK_EQUALS expr TOK_SEMICOLON
	{
		struct identifier *id=initialize($1);
		id->floatvalue=$3;
	}
	| TOK_PRINT TOK_ID TOK_SEMICOLON
	{
		
		struct identifier *id = initialize($2);
                        if(id){
                                fprintf(stdout,"%.1f\n",id->floatvalue);
                                }
	}
	| block
	
;

block:
	TOK_OPEN { $1 = symtab_size; } 
	stmts
	TOK_CLOSE { symtab_size = $1 - 1 ; }
	TOK_SEMICOLON

;

expr: 	 
	expr TOK_SUB expr
	  {
		$$ = $1 - $3;
	  }
	| expr TOK_MUL expr
	  {
		$$ = $1 * $3;
	  }
	| TOK_SUB expr
     	  {
		$$ = -($2); 
	  } 
	| TOK_OP TOK_SUB expr TOK_CL
     	  {
		$$ = -($3); 
	  } 	
	| TOK_ID
	  {
		 struct identifier *id=initialize($1);
                        if(!id)
                        {
                                fprintf(stderr,"%s not defined.\n",$1.name);
                                return -1;
                        }
                        $$ = id->floatvalue;
	  }
	| TOK_NUM
	  { 	
		$$ = $1;
	  }

;


%%

int yyerror(char *s)
{
	extern int yylineno;
	printf("Parsing error: line %d\n",yylineno);
	return 0;
}

int main()
{
   struct identifier idlist[10000];
   yyparse();
   return 0;
}

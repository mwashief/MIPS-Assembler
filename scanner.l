%{
#include<iostream>
#include<vector>
#include<stdlib.h>
#include<string.h>
#include<string>
#include "segment.cpp"
#include "y.tab.h"


using namespace std;

extern YYSTYPE yylval;
void yyerror(char *);

int line_count = 0;


%}


digit [0-9]
letter [A-Za-z]
delim [ \t\r\f\v]
newline \n
ws [delim]+
id (_|{letter})(_|{letter}|{digit})*
integer [-+]?{digit}+

%option caseless

%%

{delim}+	{}
{newline} {line_count++;}



"add"	{ 
			Segment *s= new  Segment((char*)"1011");
			yylval = (YYSTYPE)s;
			return ADD;
		}

"addi"	{ 
			Segment *s= new  Segment((char*)"0110");
			yylval = (YYSTYPE)s;
			return ADDI;
		}

"sub"	{ 
			Segment *s= new  Segment((char*)"0010");
			yylval = (YYSTYPE)s;
			return SUB;
		}

"subi"	{ 
			Segment *s= new  Segment((char*)"0101");
			yylval = (YYSTYPE)s;
			return SUBI;
		}

"and"	{ 
			Segment *s= new  Segment((char*)"1000");
			yylval = (YYSTYPE)s;
			return AND;
		}

"andi"	{ 
			Segment *s= new  Segment((char*)"0011");
			yylval = (YYSTYPE)s;
			return ANDI;
		}

"or"	{ 
			Segment *s= new  Segment((char*)"0000");
			yylval = (YYSTYPE)s;
			return OR;
		}

"ori"	{ 
			Segment *s= new  Segment((char*)"1100");
			yylval = (YYSTYPE)s;
			return ORI;
		}

"sll"	{ 
			Segment *s= new  Segment((char*)"1010");
			yylval = (YYSTYPE)s;
			return SLL;
		}

"srl"	{ 
			Segment *s= new  Segment((char*)"0100");
			yylval = (YYSTYPE)s;
			return SRL;
		}

"nor"	{ 
			Segment *s= new  Segment((char*)"1111");
			yylval = (YYSTYPE)s;
			return NOR;
		}

"sw"	{ 
			Segment *s= new  Segment((char*)"0111");
			yylval = (YYSTYPE)s;
			return SW;
		}

"lw"	{ 
			Segment *s= new  Segment((char*)"1001");
			yylval = (YYSTYPE)s;
			return LW;
		}

"beq"	{ 
			Segment *s= new  Segment((char*)"1110");
			yylval = (YYSTYPE)s;
			return BEQ;
		}

"bneq"	{ 
			Segment *s= new  Segment((char*)"0001");
			yylval = (YYSTYPE)s;
			return BNEQ;
		}

"j"		{ 
			Segment *s= new  Segment((char*)"1101");
			yylval = (YYSTYPE)s;
			return JMP;
		}

":"		{return COLON;}

"," 	{ return COMMA;}

"$zero"	{ 
			Segment *s= new  Segment((char*)"0000");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$t0"	{ 
			Segment *s= new  Segment((char*)"0001");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$t1"	{ 
			Segment *s= new  Segment((char*)"0010");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$t2"	{ 
			Segment *s= new  Segment((char*)"0011");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$t3"	{ 
			Segment *s= new  Segment((char*)"0100");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$t4"	{ 
			Segment *s= new  Segment((char*)"0101");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$t5"	{ 
			Segment *s= new  Segment((char*)"0110");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$s0"	{ 
			Segment *s= new  Segment((char*)"0111");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$s1"	{ 
			Segment *s= new  Segment((char*)"1000");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$s2"	{ 
			Segment *s= new  Segment((char*)"1001");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$s3"	{ 
			Segment *s= new  Segment((char*)"1010");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$s4"	{ 
			Segment *s= new  Segment((char*)"1011");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$s5"	{ 
			Segment *s= new  Segment((char*)"1100");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$s6"	{ 
			Segment *s= new  Segment((char*)"1101");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$s7"	{ 
			Segment *s= new  Segment((char*)"1110");
			yylval = (YYSTYPE)s;
			return REG;
		}

"$sp"	{ 
			Segment *s= new  Segment((char*)"1111");
			yylval = (YYSTYPE)s;
			return REG;
		}


"("		{return LPAREN;}

")"		{return RPAREN;}


{integer}	{
				Segment *s= new  Segment(yytext);
				yylval = (YYSTYPE)s;
				return INT;
			}


{id} 		{	 
				
				Segment *s= new  Segment(yytext);
				yylval = (YYSTYPE)s;	
				return ID;
			}


%%

int yywrap(void)
{
	return 1;
}

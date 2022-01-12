%{

#include<iostream>
#include<cstdlib>
#include<vector>
#include<cstring>
#include<cmath>
#include<string>
#include<map>
#include<fstream>
#include<sstream>
#include<bitset>
#include "segment.cpp"
#define YYSTYPE Segment*

using namespace std;

int yyparse(void);
int yylex(void);

FILE *fp;
ofstream codeout("Machine Code.txt");
extern FILE *yyin;
extern int line_count;
extern char* yytext;
int pc = 0;

map<string, Segment*> labels;


void yyerror(char *s)
{
	cout << "Error at Line " << line_count << ":( Syntax error" << endl;
}

vector<string> split(string s)
{
    vector<string> result;
    istringstream iss(s);
    for(string t; iss >> t; )result.push_back(t);
    return result;
}

void adapt(string s)
{
    ifstream ifs(s.c_str());
    vector<string> preLines;
    string curLine = "";
    //int i = 0;
    while(getline(ifs, curLine))
    {
        vector<string> curTokens = split(curLine);
        if(curTokens[0] == "mov")
        {
        	if(curTokens[2].at(0) == '$') preLines.push_back("add " + curTokens[1] + " $zero, " + curTokens[2]);
        	else preLines.push_back("addi " + curTokens[1] + " $zero, " + curTokens[2]);
        }
        else if(curTokens[0] == "inc")
        {
        	preLines.push_back("addi " + curTokens[1] + ", " + curTokens[1] + ", 1");        
        }
        else if(curTokens[0] == "dec")
        {
        	preLines.push_back("subi " + curTokens[1] + ", " + curTokens[1] + ", 1");        
        }
        else if(curTokens[0] == "push")
        {
        	preLines.push_back("addi $sp, $sp, -1");
        	preLines.push_back("sw " + curTokens[1] + ", 0($sp)");
        }
        else if(curTokens[0] == "pop")
        {
        	preLines.push_back("lw " + curTokens[1] + ", 0($sp)");
        	preLines.push_back("addi $sp, $sp, 1");
        }
        else if(curTokens[0] == "muli")
        {
        	preLines.push_back("addi " + curTokens[1] + " $zero, 0");
        	int num = atoi(curTokens[3].c_str());
        	bool neg = 0;
        	if(num < 0)
        	{
        		num = -num;
        		neg = 1;
        	}
        	for(int i=0; i<num; num--)
        	{
        		preLines.push_back("add " + curTokens[1] + " " + curTokens[2] + " " + curTokens[1].substr(0, curTokens[1].size()-1));
        	}
        	if(neg)
        	{
        		preLines.push_back("sub " + curTokens[1] + " $zero, " + curTokens[1].substr(0, curTokens[1].size()-1));
        	}
        }
        else if(curTokens[0] == "slt")
        {
        	preLines.push_back("sub " + curTokens[1] + " " + curTokens[2] + " " + curTokens[3]);
        	preLines.push_back("srl " + curTokens[1] + " " + curTokens[1] + " " + "7");
        }
        else
        {
        	preLines.push_back(curLine);
        }

    }
    ifs.close();
    ofstream ofs("adapted.txt");
    for(int i=0; i<preLines.size(); i++)
    {
        //cout << preLines[i] << endl;
        ofs << preLines[i] << endl;
    }
}



%}

%token ADD ADDI SUB SUBI AND ANDI OR ORI SLL SRL NOR SW LW BEQ BNEQ JMP COLON COMMA LPAREN RPAREN REG INT ID


%%

start:  	statements
			{
				for(int i=0; i<$1->alist.size(); i++)
				{
					if($1->alist[i]->alist.size() != 0 && ($1->alist[i]->alist[0]->name == "0001" || $1->alist[i]->alist[0]->name == "1110"))
					{
						bitset<8> saved($1->alist[i]->alist.back()->name);
						int value = saved.to_ulong() - $1->alist[i]->pc - 1;
						$1->alist[i]->alist.pop_back();
						$1->alist[i]->alist.push_back(new Segment(bitset<8>(value).to_string()));
					}
					string str = $1->alist[i]->getCode();
					if(str != "") codeout << str << endl;
				}
			}
;

statements:	statement
			{
				Segment* s = new Segment();
				s->alist.push_back($1);
				$$ = s;
			}
			| statements statement
			{
				$1->alist.push_back($2);
				$$ = $1;
			}
;

statement: 	rtype
			{
				pc++;
				$$ = $1;
			}
			| itype
			{
				pc++;
				$$ = $1;
			}
			| jtype
			{
				pc++;
				$$ = $1;
			}
			| label
;

label: 	ID COLON
		{
			string s = bitset<8>(pc).to_string();
			map<string, Segment*>::iterator it;
			it = labels.find($1->name);
			if(it != labels.end())
			{
				it->second->name = s;
			}
			else
			{
				labels.insert(make_pair($1->name, new Segment(s)));
			}
			$$= new Segment("");
		}
;

rtype: 	ADD REG COMMA REG COMMA REG
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($4);
			s->alist.push_back($6);
			s->alist.push_back($2);
			s->alist.push_back(new Segment("0000"));
			$$ = s;
		}
		| SUB REG COMMA REG COMMA REG
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($4);
			s->alist.push_back($6);
			s->alist.push_back($2);
			s->alist.push_back(new Segment("0000"));
			$$ = s;
		}
		| AND REG COMMA REG COMMA REG
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($4);
			s->alist.push_back($6);
			s->alist.push_back($2);
			s->alist.push_back(new Segment("0000"));
			$$ = s;
		}
		| OR REG COMMA REG COMMA REG
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($4);
			s->alist.push_back($6);
			s->alist.push_back($2);
			s->alist.push_back(new Segment("0000"));
			$$ = s;
		}
		| NOR REG COMMA REG COMMA REG
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($4);
			s->alist.push_back($6);
			s->alist.push_back($2);
			s->alist.push_back(new Segment("0000"));
			$$ = s;
		}
		| SLL REG COMMA REG COMMA INT
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back(new Segment("0000"));
			s->alist.push_back($4);
			s->alist.push_back($2);
			int shiftAmount = atoi($6->name.c_str());
			string num = bitset<4>(shiftAmount).to_string();
			s->alist.push_back(new Segment(num));
			$$ = s;
		}
		| SRL REG COMMA REG COMMA INT
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back(new Segment("0000"));
			s->alist.push_back($4);
			s->alist.push_back($2);
			int shiftAmount = atoi($6->name.c_str());
			string num = bitset<4>(shiftAmount).to_string();
			s->alist.push_back(new Segment(num));
			$$ = s;
		}
;

itype: 	ADDI REG COMMA REG COMMA INT
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($4);
			s->alist.push_back($2);
			int immediate = atoi($6->name.c_str());
			string num = bitset<8>(immediate).to_string();
			s->alist.push_back(new Segment(num));
			$$ = s;
		}
		| SUBI REG COMMA REG COMMA INT
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($4);
			s->alist.push_back($2);
			int immediate = atoi($6->name.c_str());
			string num = bitset<8>(immediate).to_string();
			s->alist.push_back(new Segment(num));
			$$ = s;
		}
		| ANDI REG COMMA REG COMMA INT
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($4);
			s->alist.push_back($2);
			int immediate = atoi($6->name.c_str());
			string num = bitset<8>(immediate).to_string();
			s->alist.push_back(new Segment(num));
			$$ = s;
		}
		| ORI REG COMMA REG COMMA INT
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($4);
			s->alist.push_back($2);
			int immediate = atoi($6->name.c_str());
			string num = bitset<8>(immediate).to_string();
			s->alist.push_back(new Segment(num));
			$$ = s;
		}
		| LW REG COMMA INT LPAREN REG RPAREN
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($6);
			s->alist.push_back($2);
			int immediate = atoi($4->name.c_str());
			string num = bitset<8>(immediate).to_string();
			s->alist.push_back(new Segment(num));
			$$ = s;
		}
		| SW REG COMMA INT LPAREN REG RPAREN
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($6);
			s->alist.push_back($2);
			int immediate = atoi($4->name.c_str());
			string num = bitset<8>(immediate).to_string();
			s->alist.push_back(new Segment(num));
			$$ = s;
		}
		| BEQ REG COMMA REG COMMA ID
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($2);
			s->alist.push_back($4);
			Segment* temp = new Segment("00000000");
			map<string, Segment*>::iterator it;
			it = labels.find($6->name);
			s->pc = pc;
			if(it != labels.end())
			{
				temp = it->second;
			}
			else
			{
				labels.insert(make_pair($6->name, temp));
			}
			s->alist.push_back(temp);
			$$ = s;
		}
		| BNEQ REG COMMA REG COMMA ID
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($2);
			s->alist.push_back($4);
			Segment* temp = new Segment("00000000");
			map<string, Segment*>::iterator it;
			it = labels.find($6->name);
			s->pc = pc;
			if(it != labels.end())
			{
				temp = it->second;
			}
			else
			{
				labels.insert(make_pair($6->name, temp));
			}
			s->alist.push_back(temp);
			$$ = s;
		}
		| BEQ REG COMMA REG COMMA INT
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($2);
			s->alist.push_back($4);
			Segment* temp = new Segment("00000000");
			s->pc = pc;
			int immediate = atoi($6->name.c_str());
			string num = bitset<8>(immediate+pc+1).to_string();
			s->alist.push_back(new Segment(num));
			$$ = s;
		}
		| BNEQ REG COMMA REG COMMA INT
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			s->alist.push_back($2);
			s->alist.push_back($4);
			Segment* temp = new Segment("00000000");
			s->pc = pc;
			int immediate = atoi($6->name.c_str());
			string num = bitset<8>(immediate+pc+1).to_string();
			s->alist.push_back(new Segment(num));
			$$ = s;
		}
;

jtype: JMP ID
		{
			Segment* s = new Segment();
			s->alist.push_back($1);
			Segment* temp = new Segment("00000000");
			map<string, Segment*>::iterator it;
			it = labels.find($2->name);
			if(it != labels.end())
			{
				temp = it->second;
			}
			else
			{
				labels.insert(make_pair($2->name, temp));
			}
			s->alist.push_back(temp);
			s->alist.push_back(new Segment("00000000"));
			$$ = s;

		}
;




%%

int main(int argc,char *argv[])
{
	adapt(argv[1]);
	if((fp=fopen("adapted.txt","r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	yyin=fp;
	yyparse();
	codeout.close();
	
	return 0;
}


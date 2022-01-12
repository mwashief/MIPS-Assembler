
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ADD = 258,
     ADDI = 259,
     SUB = 260,
     SUBI = 261,
     AND = 262,
     ANDI = 263,
     OR = 264,
     ORI = 265,
     SLL = 266,
     SRL = 267,
     NOR = 268,
     SW = 269,
     LW = 270,
     BEQ = 271,
     BNEQ = 272,
     JMP = 273,
     COLON = 274,
     COMMA = 275,
     LPAREN = 276,
     RPAREN = 277,
     REG = 278,
     INT = 279,
     ID = 280
   };
#endif
/* Tokens.  */
#define ADD 258
#define ADDI 259
#define SUB 260
#define SUBI 261
#define AND 262
#define ANDI 263
#define OR 264
#define ORI 265
#define SLL 266
#define SRL 267
#define NOR 268
#define SW 269
#define LW 270
#define BEQ 271
#define BNEQ 272
#define JMP 273
#define COLON 274
#define COMMA 275
#define LPAREN 276
#define RPAREN 277
#define REG 278
#define INT 279
#define ID 280




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;



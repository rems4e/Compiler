/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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
     tNOMBRE = 258,
     tID = 259,
     tFCT = 260,
     tPO = 261,
     tPF = 262,
     tVIR = 263,
     tBO = 264,
     tBF = 265,
     tINT = 266,
     tCONST = 267,
     tPLUS = 268,
     tMOINS = 269,
     tDIV = 270,
     tMUL = 271,
     tEGAL = 272,
     tF = 273,
     tMAIN = 274,
     END_OF_FILE = 275
   };
#endif
/* Tokens.  */
#define tNOMBRE 258
#define tID 259
#define tFCT 260
#define tPO 261
#define tPF 262
#define tVIR 263
#define tBO 264
#define tBF 265
#define tINT 266
#define tCONST 267
#define tPLUS 268
#define tMOINS 269
#define tDIV 270
#define tMUL 271
#define tEGAL 272
#define tF 273
#define tMAIN 274
#define END_OF_FILE 275




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 46 "desc.y"
{int nb; char* var;}
/* Line 1529 of yacc.c.  */
#line 91 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;


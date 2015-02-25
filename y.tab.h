#define tNOMBRE 257
#define tID 258
#define tFCT 259
#define tPO 260
#define tPF 261
#define tVIR 262
#define tBO 263
#define tBF 264
#define tINT 265
#define tCONST 266
#define tPLUS 267
#define tMOINS 268
#define tDIV 269
#define tMUL 270
#define tEGAL 271
#define tF 272
#define tMAIN 273
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {int nb; char* var;} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;

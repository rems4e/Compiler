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
#define tBOOL 267
#define tPLUS 268
#define tMOINS 269
#define tDIV 270
#define tMUL 271
#define tEGAL 272
#define tBOOLEGAL 273
#define tINFEGAL 274
#define tSUPEGAL 275
#define tSUP 276
#define tINF 277
#define tF 278
#define tMAIN 279
#define tIF 280
#define tTHEN 281
#define END_OF_FILE 282
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {int nb; char* var;} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;

%{
  #include <stdio.h>

  #ifdef DEBUG
    #define DEBUG_YACC(list...) \
      printf(list);
  #else
    #define DEBUG_YACC(list...)
  #endif


  #define TRAITER_INSTRUCTION(A, B, C, D) \
    {                                     \
      printf("\"");                       \
      print_binaire(A, 8);                \
      printf("\" \& \"");                 \
      print_binaire(B, 8);                \
      printf("\" \& \"");                 \
      print_binaire(C, 8);                \
      printf("\" \& \"");                 \
      print_binaire(D, 8);                \
      printf("\",\n ");                   \
    } while (0);

  void print_binaire(int nombre, int taille) {
    int mask = 1 << (taille - 1);
    while (mask) {
      if ((nombre & mask) == 0) {
        printf("0");
      } else {
        printf("1");
      }
      mask = mask >> 1;
    }
  }

  #define DEST_ADD   0x1
  #define DEST_MUL   0x2
  #define DEST_SOU   0x3
  #define DEST_DIV   0x4
  #define DEST_COP   0x5
  #define DEST_AFC   0x6
  #define DEST_JMP   0x7
  #define DEST_JMF   0x8
  #define DEST_INF   0x9
  #define DEST_SUP   0xA
  #define DEST_EQU   0xB
  #define DEST_PRI   0xC
  #define DEST_LOAD  0xD
  #define DEST_STORE 0xE

%}

%token ADD MUL SOU DIV COP AFC JMP JMF INF SUP EQU PRI ENT

%%

instructions : instruction instructions |
               ;

instruction : instruction_add |
              instruction_mul |
              instruction_sou |
              instruction_div |
              instruction_cop |
              instruction_afc |
              instruction_jmp |
              instruction_jmf |
              instruction_inf |
              instruction_sup |
              instruction_equ |
              instruction_pri
              ;

instruction_add : ADD ENT ENT ENT {
                    TRAITER_INSTRUCTION(DEST_LOAD,  $2, 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  $3, 2, 0);
                    TRAITER_INSTRUCTION(DEST_ADD,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, $3, 1, 0);
                  };

instruction_mul : MUL ENT ENT ENT {
                    TRAITER_INSTRUCTION(DEST_LOAD,  $2, 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  $3, 2, 0);
                    TRAITER_INSTRUCTION(DEST_MUL,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, $3, 1, 0);
                  };

instruction_sou : SOU ENT ENT ENT {
                    TRAITER_INSTRUCTION(DEST_LOAD,  $2, 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  $3, 2, 0);
                    TRAITER_INSTRUCTION(DEST_SOU,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, $3, 1, 0);
                  };

instruction_div : DIV ENT ENT ENT {
                    TRAITER_INSTRUCTION(DEST_LOAD,  $2, 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  $3, 2, 0);
                    TRAITER_INSTRUCTION(DEST_DIV,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, $3, 1, 0);
                  };

instruction_cop : COP ENT ENT {
                    TRAITER_INSTRUCTION(DEST_LOAD,  $3, 1, 0);
                    TRAITER_INSTRUCTION(DEST_STORE, $2, 1, 0);
                  };

instruction_afc : AFC ENT ENT {
                    TRAITER_INSTRUCTION(DEST_AFC,   $3, 1, 0);
                    TRAITER_INSTRUCTION(DEST_STORE, $2, 1, 0);
                  };

instruction_jmp : JMP ENT {
                    TRAITER_INSTRUCTION(DEST_JMP, $2, 0, 0);
                  };

instruction_jmf : JMF ENT ENT {
                    TRAITER_INSTRUCTION(DEST_LOAD,  $2, 1, 0);
                    TRAITER_INSTRUCTION(DEST_JMF,   $3, 1, 0);
                  };

instruction_inf : INF ENT ENT ENT {
                    TRAITER_INSTRUCTION(DEST_LOAD,  $2, 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  $3, 2, 0);
                    TRAITER_INSTRUCTION(DEST_INF,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, $3, 1, 0);
                  };

instruction_sup : SUP ENT ENT ENT {
                    TRAITER_INSTRUCTION(DEST_LOAD,  $2, 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  $3, 2, 0);
                    TRAITER_INSTRUCTION(DEST_SUP,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, $3, 1, 0);
                  };

instruction_equ : EQU ENT ENT ENT {
                    TRAITER_INSTRUCTION(DEST_LOAD,  $2, 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  $3, 2, 0);
                    TRAITER_INSTRUCTION(DEST_EQU,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, $3, 1, 0);
                  };

instruction_pri : PRI ENT {
                    TRAITER_INSTRUCTION(DEST_LOAD,  $2, 1, 0);
                    TRAITER_INSTRUCTION(DEST_PRI,    2, 1, 1);
                  };

%%

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv) {
  int ret;
  printf("(");
  ret = yyparse();
  printf("others => (others => '0'));\n");
  return ret;
}

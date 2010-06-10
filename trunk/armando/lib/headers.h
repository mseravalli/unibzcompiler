/****************************************************************************** 
 *                                                                            *
 * file name: headers.h                                                       *
 * author: Armando Miraglia                                                   *
 * email: armando.miraglia@stud-inf.unibz.it                                  *
 * version: 0.1                                                               *
 *                                                                            *
 * last modification: 28/05/10 10:36                                          *
 * last mod. author: Armando                                                  *
 *                                                                            *
 ******************************************************************************/

typedef struct char_node {
    char a;                 // character of the string (EOS == '\0')
    struct char_node *next; // pointer to the next character
} char_node;

typedef struct sym_node {
    struct sym_node*    next;
    int                 token;
    char_node           *lexeme;
    int                 type;       // 0 == ganz
                                    // 1 == genau
} sym_node;

/******************************************************************************/
sym_node *add_symbol(int token, char *lexeme, int type);
void print_symbols();

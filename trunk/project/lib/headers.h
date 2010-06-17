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

#define DEFAULT_IVAL 0
#define DEFAULT_FVAL 0.0f

typedef struct char_node {
    char a;                 // character of the string (EOS == '\0')
    struct char_node *next; // pointer to the next character
} char_node;

typedef struct sym_node {
    struct sym_node*    next;
    int                 token;
    char_node           *lexeme;
    float               fval;
    int                 ival;
    char                type;
} sym_node;

/******************************************************************************/
sym_node *add_symbol(int token, char *lexeme, char type);
int modify_symbol(char* lexeme, char* v);
int find_symbol(char *lexeme);
sym_node* getSymNode(int position);
void print_symbols();
char* bool_compare (char* a, char* b, char op);
char* num_compare (char* a, char* b, char op);
char* calculate (char* a, char* b, char op);
char* itoa (int);
char* ftoa (float);

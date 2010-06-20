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

/* each character of a lexeme till and of string */
typedef struct char_node {
    char a;                 // character of the string (EOS == '\0')
    struct char_node *next; // pointer to the next character
} char_node;

/* node of a symbol table */
typedef struct sym_node {
    struct sym_node*    next;
    char_node           *lexeme;
    int                 token;
    int                 line;
    char                type;
    struct scope        *nscope;    // new scope of the encountered scope
} sym_node;

/*
 * structure that identifies a scope by its name, stores
 * the symbol node in which the scope is placed and the
 * new symbol table.
 */ 
typedef struct scope {
    sym_node        *parent;
    char_node       *lexeme;
    sym_node        *symtbl;
} scope;

/******************************************************************************/
scope       *init_scope(sym_node *parent, char_node *lexeme);
sym_node    *add_symbol(int token, char *lexeme, int line,int type, scope* nscope);
//int         isCorrectType(char a, char b);
int         find_symbol(char *lexeme);
//sym_node    *get_node(int position);
void        print_symbols();
//char*       bool_compare(char* a, char* b, char op);
//char*       num_compare(char* a, char* b, char op);

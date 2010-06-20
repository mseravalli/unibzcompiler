/****************************************************************************** 
 *                                                                            *
 * file name: headers.h                                                       *
 * author: Armando Miraglia                                                   *
 * email: armando.miraglia@stud-inf.unibz.it                                  *
 * version: 0.1                                                               *
 *                                                                            *
 * last modification: 20/06/10 15:56                                          *
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
    int                 type;
    struct scope        *nscope;    // new scope of the encountered scope
} sym_node;

/*
 * structure that identifies a scope by its name, stores
 * the symbol node in which the scope is placed and the
 * new symbol table.
 */ 
typedef struct scope {
    struct scope    *parent;
    char_node       *lexeme;
    sym_node        *symtbl;
} scope;

/******************************************************************************/
scope       *init_scope(scope *parent, char_node *lexeme);
int         exit_scope();
char_node   *generate_scope_name();
sym_node    *add_symbol(int token, char *lexeme, int line,int type, int is_scope);
//int         isCorrectType(char a, char b);
int         find_symbol(char *lexeme);
//sym_node    *get_node(int position);
void        print_all();
void        print_symbols();
void        print_scope();
//char*       bool_compare(char* a, char* b, char op);
//char*       num_compare(char* a, char* b, char op);

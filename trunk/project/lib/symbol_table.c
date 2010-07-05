/****************************************************************************** 
 *                                                                            *
 * file name: symbol_table.c                                                  *
 * author: Armando Miraglia                                                   *
 * email: armando.miraglia@stud-inf.unibz.it                                  *
 * version: 0.1                                                               *
 *                                                                            *
 * last modification: 20/06/10 15:42                                          *
 * last mod. author: Armando + Manuel                                         *
 *                                                                            *
 ******************************************************************************/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include "headers.h"

/************************* Others *********************************************/
int             scope_cnt = 0;  // used for generating name scopes

/******************** String Names Handeling (lexemes) ************************/
char_node       *names = NULL;  // this will contain all the names that are also
                                // called lexemes (values of the identifiers)

/******************** Actual Symbol Table *************************************/
scope           *actual_scope = NULL;   // the actual scope 
scope           *main_scope = NULL;     // the main scope (this pointer is
                                        // never changed otherwise the ref. to
                                        // the main table is lost.

/******************************************************************************/
char_node       *add_lexeme(char *new);
void            print_lexeme(char_node *start);
sym_node        *search_table(char *lexeme, sym_node *tbl);

/******************************************************************************/

/*
 * initialization of the necessary data strutures
 */
void
init() {
    char_node *tmp;

    tmp = add_lexeme("main");               // add the name in the lexemes' list
    main_scope = init_scope(NULL, tmp);     // initialize the scope
    actual_scope = main_scope;              // keep track of the actual scope
    free(tmp);
}

/*
 * this function is intended to create a new scope and the releted
 * new symbol table when a new scope is found.
 * the lexeme has to be already in the lexeme structure.
 */
scope
*init_scope(scope *parent, char_node *lexeme) {
    scope *t;      // temporary scope node
    // new scope
    t = (scope *)malloc(sizeof(scope *));
    t->parent = parent;     // the calling symbol node
    t->lexeme = lexeme;     // name of the scope
    t->symtbl = NULL;       // new symbol table

    actual_scope = t;
    return t;
}

/*
 * returns the pointer to the symbol table of the 
 * actual scope.
 */
scope
*this_scope() {
    return actual_scope;
}

/*
 * function intended to exit from the actual scope and step back
 * to the previous one. It checks if we are in the main scope: in this
 * case we cannot step back (no parent is defined).
 * Returns 0 if the execution has been correctly executed,
 * 1 when parent is set to NULL.
 */
int
exit_scope() {
    if(actual_scope->parent == NULL) {
        return 1;
    } else {
        actual_scope = actual_scope->parent;
        return 0;
    }
}

/*
 * this function generates a new name for the scope and saves it
 * into the lexeme structure.
 */
char_node
*generate_scope_name() {
    char t;
    char_node *s;

    t = scope_cnt++ + '0';
    s = add_lexeme( strcat("scope", &t) );
    printf("%p\n", s);
    return s;
}

/*
 * Adding a new symbol into the actual symbol table, that is different
 * depending on what the actual_scpe global variable is pointing to.
 * If the "is_scope" parameter is different from 0 the symbol is
 * considered as a scope so a new scope will be produced (and the
 * new symbol table).
 */
sym_node
*add_symbol(int token, char *lexeme, int line, int type, int is_scope) {
    sym_node *p = actual_scope->symtbl; // obtain the head of the actual scope
                                        // symbol table
    sym_node *t;

    // firstly advance the pointer through the list
    // if necessary
    while(p != NULL && p->next != NULL) {
        p = p->next;
    }

    // creation of the node to be added
    t = (sym_node *)malloc(sizeof(sym_node));
    t->token = token;
    t->lexeme = add_lexeme(lexeme);
    t->line = line;
    t->type = type;
    t->nscope = NULL;       // default not a scope
    t->next = NULL;         // default is the last element

    // if the symbol represents a new scope init the new scope
    // and assign it to the the symbolt in the table
    if(is_scope != 0) {
        t->nscope = init_scope(actual_scope, t->lexeme);
    }

    // p could be NULL if the symbol table is empty (so is treated
    // as a special case
    if(p == NULL) {
        // if we have initialized a new scope the actual scope is changed
        // so we have to add the entry in the previos scope.
        // Differently we can directly add the entry into the symbol table
        if(is_scope != 0) {
            actual_scope->parent->symtbl = t;
        } else {
            actual_scope->symtbl = t;
        }
    } else {
        p->next = t;
    }

    return t;
}

/*
 * search a specific symbol table
 */
sym_node 
*search_table(char *lexeme, sym_node *tbl) {
    sym_node    *p        = tbl;
    sym_node    *result   = NULL;
    char_node   *q        = NULL;
    char        *r        = lexeme;
    int         found     = 0;
    int         i;
    //int         position  = -1;
    int         str_len   = strlen(lexeme);

    // if the table is empty return a "not found" result
    if(p == NULL) {
       return result;
    }

    // differently start to check the presence of it
    // in the symbol table
    while(p != NULL && found == 0 ) {
        //position++;     // step forward
        q = p->lexeme;

        // start to compare lexemes
        i = -1;
        while(q->a != '\0' && i < str_len) {
            if(q->a != *r) {
                break;
            }

            q = q->next;
            r++;
            i++;
        }

        if ( !(q->a != '\0' || i != (str_len - 1)) ) {
            result = p;
            found = 1;
        }

        p = p->next;
    }

    return result;
}

/* 
 * the function is intended to find the entry of the symbol
 * table stored in the actual scope or in one of the enclosing one.
 * Considering the shape of the symbol table, thi function traverses
 * the nasted symbols from the current scope up to the main one.
 */
void
find_symbol(char *lexeme, sym_node **node, scope **actual) {
    scope       *s        = actual_scope;  // actual scope pointer
    sym_node    *p        = NULL;
    sym_node    *found    = NULL;          // resulting pointer, that
                                           // points to the searched element

    // main loop for traversing the entire symbol table
    // ("busy wating" implementation).
    while (1) {
        if(s->parent != NULL) {
            p = s->symtbl;
            // search for the element
            found = search_table(lexeme, p);
            if(found == NULL) {
                s = s->parent;
            } else {
                break;
            }
        } else {
            // we have reached the main scope so after finishing
            // searching we can exit from the loop also if we didn't
            // find the searched element
            p = s->symtbl;
            found = search_table(lexeme, p);
            break;
        }
    }

    *node = found;
    *actual = s;
}

/*
 * obtain the symbol node from the symbol table
 * given the position (generally obtained using
 * the find_node above).
 */
sym_node *get_node(int position){
	int i;

	if(position == -1){
		return NULL;
	}

	sym_node *p = actual_scope->symtbl;
	for(i = 0; i < position; i++ ){
		p = p->next;
	}

	return p;
}


/*
 * prints the infos of the current scope 
 */
void
print_scope() {
    scope *p = actual_scope;

    if(p == NULL) {
        printf("-- scope empty --\n");
    } else {
        printf("-- parent: %p", p->parent);
        printf(" lexeme: ");
        print_lexeme(p->lexeme);
        printf(" symbol table: %p", p->symtbl);
        printf("\n");
    }
    printf("\n");
}

/*
 * prints the complete symbol table (also their scopes)
 * TODO: not printing scopse but only the actual scope's
 *       symbol table.
 */
void
print_symbols() {
    sym_node *p = actual_scope->symtbl;

    if(p == NULL) {
        printf("-- symbol tabel empty --\n");
    } else {
        while(p != NULL) {
            printf("-- token: %d", p->token);
            printf(" lexeme: ");
            print_lexeme(p->lexeme);
            printf(" line: %d", p->line);
            printf(" type: %d", p->type);
            printf(" scope: %p", p->nscope);
            printf("\n");
            p = p->next;
        }
    }
    printf("\n");
}


/******************************************************************************/

/*
 * This function is intended for a local use. Giving it a string,
 * the function will add it at the and of the list containing
 * all the lexemes encountered during parsing.
 * '\0' is the End Of String characther and determines the and of the lexems.
 * 
 * The function returns the pointer to the starting character of the added
 * lexeme.
 *
 * example:
 *   ___________________________
 *  |f|i|s|t|EOS|s|e|c|o|n|d|EOS| but implemented as a list
 *   ---------------------------
 *
 */
char_node *add_lexeme(char *new) {
    char_node *p, *t, *start;
    char *q;
    int i;                      // index used for storing the
                                // address of the first char of the lexeme

    p = names;
    q = new;

    // firstly advance the pointer through the list
    // if necessary
    while(p != NULL && p->next != NULL) {
        p = p->next;
    }
    

    i = 0;
    while(q != NULL && *q != '\0' ) {
        // creation of the node to be added
        t = (char_node *)malloc(sizeof(char_node));
        t->a = *q;
        t->next = NULL;

        // p could be NULL if names have never been
        // initialized. In this case after inserting the node
        // I won't move one step forward.
        if(p == NULL) {
            names = t;
            p = names;
            if(i++ == 0) {
                start = p;
            }
        } else {
            p->next = t;
            if(i++ == 0) {
                start = p->next;
            }

            p = p->next;
        }

        // after adding the node to the list of strings
        // I have to move one step forward both through
        // the string
        q++;
    }

    // add always the last '\0' character and return
    // the pointer to the first character
    t = (char_node *)malloc(sizeof(char_node));
    t->a = '\0';
    t->next = NULL;
    p->next = t;

    return start;
}

/*
 * The function is intended to print a lexeme stored into the
 * lexeme list. The pointer poiting to the starting char of the lexeme  
 * is needed as parameter.
 */
void print_lexeme(char_node *start) {
    char_node *p = start;

    while(p != NULL && p->a != '\0') {
        printf("%c", p->a);
        p = p->next;
    }
}


// --- TEST GESTIONE DEI LEXEMES ---
//int main() {
//    char_node *first, *second;
//
//    first = add_lexeme("qualche dubbio");
//    second = add_lexeme("uff");
//    printf("@address: %p\n", first);
//    printf("@address: %p\n", second);
//    print_lexeme(first);
//    printf("\n");
//    print_lexeme(second);
//    printf("\n");
//
//    return 0;
//}
// --- END ---

// --- PER TESTARE LA SYMBOL TABLE ---
//int main() {
//    sym_node *r = NULL;
//    scope *s = NULL;
//
//    char_node *tmp = add_lexeme("main");  // add the name in the lexemes' list
//    main_scope = init_scope(NULL, tmp);   // initialize the scope
//    actual_scope = main_scope;            // keep track of the actual scope
//    free(tmp);
//
//    // --- PRIMO SCOPE ---
//    find_symbol("a", &r, &s);
//    printf("\tresult 'a': %p; scope: %p\n", r, s);
//    add_symbol(10, "a", 1, 1, 0);
//    find_symbol("a", &r, &s);
//    printf("\tresult 'a': %p; scope: %p\n", r, s);
//    add_symbol(10, "b", 2, 1, 0);
//    find_symbol("b", &r, &s);
//    printf("\tresult 'b': %p; scope: %p\n", r, s);
//    add_symbol(10, "c", 2, 1, 0);
//    find_symbol("c", &r, &s);
//    printf("\tresult 'c': %p; scope: %p\n", r, s);
//    print_scope();
//    print_symbols();
//    // --- FINE PRIMO SCOPE ---
//    printf("\n ====== \n");
//
//    // --- SECONDO SCOPE ---
//    add_symbol(10, "scope1", 2, 1, 1);
//    find_symbol("c", &r, &s);
//    printf("\tresult 'c': %p; scope: %p\n", r, s);
//    print_scope();
//    print_symbols();
//    exit_scope();
//    printf("\n ====== \n");
//    // --- FILE SECONDO SCOPE ---
//
//    // --- TERZO SCOPE ---
//    add_symbol(10, "scope2", 2, 1, 1);
//    find_symbol("c", &r, &s);
//    printf("\tresult 'c': %p; scope: %p\n", r, s);
//    add_symbol(10, "b", 2, 1, 0);
//    find_symbol("b", &r, &s);
//    printf("\tresult 'b': %p; scope: %p\n", r, s);
//    add_symbol(10, "c", 2, 1, 0);
//    find_symbol("c", &r, &s);
//    printf("\tresult 'c': %p; scope: %p\n", r, s);
//    print_scope();
//    print_symbols();
//    exit_scope();
//    printf("\n ====== \n");
//    // --- FINE TERZO SCOPE ---
//
//    // --- PRIMO SCOPE ---
//    print_scope();
//    print_symbols();
//    // --- FINE PRIMO SCOPE ---
//    return 0;
//}
// --- END ---

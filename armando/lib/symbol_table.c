/****************************************************************************** 
 *                                                                            *
 * file name: symbol_table.c                                                  *
 * author: Armando Miraglia                                                   *
 * email: armando.miraglia@stud-inf.unibz.it                                  *
 * version: 0.1                                                               *
 *                                                                            *
 * last modification: 10/06/10 00:42                                          *
 * last mod. author: Armando                                                  *
 *                                                                            *
 ******************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include "headers.h"

/******************** String Names Handeling (lexemes) ************************/
char_node *names = NULL;    // this will contain all the names that are also
                            // called lexemes (values of the identifiers)

/******************** Actual Symbol Table *************************************/
sym_node *tbl_head = NULL;          // haad of the symbol table (list imp.)

/******************************************************************************/
char_node *add_lexeme(char *new);
void print_lexeme(char_node *start);

/******************************************************************************/
/* */
sym_node *add_symbol(int token, char *lexeme, int type) {
    sym_node *p = tbl_head;
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
    t->type = type;
    t->next = NULL;

    // p could be NULL if the symbol table is empty (so is treated
    // as a special caae
    if(p == NULL) {
        tbl_head = t;
    } else {
        p->next = t;
    }

    return t;
}

/* */
void print_symbols() {
    sym_node *p = tbl_head;

    if(p == NULL) {
        printf("-- symbol tabel empty --\n");
    } else {
        while(p != NULL) {
            printf("-- token: %d", p->token);
            printf(" lexeme ");
            print_lexeme(p->lexeme);
            printf(" type %d", p->type);
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
 *   ________________________
 *  |f|i|s|t||EOS|s|e|c|o|n|d| but implemented as a list
 *   ------------------------
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

//int main() {
// --- PER SOLO LA GESTIONE DEI LEXEMES ---
//    char_node *first, *second;

//    first = add_lexeme("qualche dubbio");
//    second = add_lexeme("uff");

//    printf("@address: %p\n", first);
//    printf("@address: %p\n", second);
//    print_lexeme(first);
//    printf("\n");
//    print_lexeme(second);
//    printf("\n");
// --- END ---

// --- PER TESTARE LA SYMBOL TABLE ---
//    printf("------- Sym Tabel -------\n");
//    print_symbols();
//    add_symbol(10, "qualche dubbio", 1);
//    print_symbols();
//    add_symbol(10, "uff", 2);
//    print_symbols();
// --- END ---

//    return 0;
//}

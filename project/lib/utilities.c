/****************************************************************************** 
 *                                                                            *
 * file name: utilities.c                                                     *
 * author: Armando Miraglia                                                   *
 * email: armando.miraglia@stud-inf.unibz.it                                  *
 * version: 0.1                                                               *
 *                                                                            *
 * last modification: 28/05/10 10:36                                          *
 * last mod. author: Armando                                                  *
 *                                                                            *
 ******************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include "headers.h"

/******************** Actual Symbol Table *************************************/
sym_node *table_head = NULL;        // haad of the symbol table (list imp.)

/******************** String Names Handeling (lexemes) ************************/
typedef struct char_node {
    char a;                 // character of the string (EOS == '\0'
    struct char_node *next; // pointer to the next character
} char_node;

char_node *names = NULL;    // this will contain all the names that are also
                            // called lexemes (values of the identifiers)

void add_string(char *new);
void print_lexeme(char_node *start);

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
        printf("%c", *p);
        p = p->next;
    }
    printf("\n");
}

//int main() {
//    char_node *first, *second;
//
//    first = add_lexeme("qualche dubbio");
//    second = add_lexeme("uff");
//
//    print_lexeme(first);
//    print_lexeme(second);
//}

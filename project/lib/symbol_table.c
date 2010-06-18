/****************************************************************************** 
 *                                                                            *
 * file name: symbol_table.c                                                  *
 * author: Armando Miraglia                                                   *
 * email: armando.miraglia@stud-inf.unibz.it                                  *
 * version: 0.1                                                               *
 *                                                                            *
 * last modification: 11/06/10 00:42                                          *
 * last mod. author: Armando + Manuel                                         *
 *                                                                            *
 ******************************************************************************/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include "headers.h"
//#include "../lex/lex.daitsch.c"     // contains the constants that we will
                                    // use to check type;

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
sym_node *add_symbol(int token, char *lexeme, char type) {
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
    t->fval = DEFAULT_FVAL;
    t->ival = DEFAULT_IVAL;
    t->type = type;
    t->next = NULL;

    // p could be NULL if the symbol table is empty (so is treated
    // as a special case
    if(p == NULL) {
        tbl_head = t;
    } else {
        p->next = t;
    }

    return t;
}

/* TODO
 * the function is intended to find the entry of the symbol
 * table storing the information realted to a specific lexeme.
 * The function returns -1 if the lexeme was not found
 * in the symbol table otherwise it will return the index
 * the entry (0, first postion; 1, second position and so
 * on);
 */

int find_symbol(char *lexeme) {
    sym_node *p = tbl_head;
    char_node *q        = NULL;
    char      *r        = lexeme;
    int       found     = 0;
    int       i;
    int       position  = -1;
    int       str_len   = strlen(lexeme);

    // if the table is empty return a "not found" result
    if(p == NULL) {
       return -1;
    }

    // differently start to check the presence of it
    // in the symbol table
    while(p != NULL && found == 0 ) {
        position++;     // step forward
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

        if ( !(q->a != '\0' || i != (str_len-1)) ) {
            found = 1;
        }

        p = p->next;
    }

    if(found == 1) {
        return position;
    } else {
        return -1;
    }
}

sym_node *getSymNode(int position){
	int i;

	if(position == -1){
		return NULL;
	}

	sym_node *p = tbl_head;
	for(i = 0; i < position; i++ ){
		p = p->next;
	}

	return p;
}


// FIXME: non serve in parte questo metodo. Serve solo
//        inttoreal() per la conversione del tipo
int modify_symbol(char* lexeme, char* v) {
    sym_node *p;     // locate the symbol
    char myType;

	float val;
	
	if(isdigit(v[0]) || v[0] == '-'){
		val = atof(v);
	}
	//if v is a lexeme
	else {
		sym_node *p = NULL;
		if(getSymNode(find_symbol(v)) != NULL){
			p = getSymNode(find_symbol(v));
			val = p->fval;
		} else {
			printf("error: %s never declared\n", v);
			return 1;
		}
	}


	p = getSymNode(find_symbol(lexeme));

    // determinate if we have a float or an int and whether
    // it correspondes to our type
    if((val - (int) val) == 0 ){
        myType = 'i';
	}
    else
        myType = 'f';


	if(val == 0 || val == 1)
		myType = 'b';

	//type check
	if( !isCorrectType(p->type, myType) ){
		return 1;
	}
    //change the symbol
    if(p->type == 'i' || p->type == 'b'){
        p->ival = (int) val;
		p->fval = (int) val;
	}
    else if (p->type == 'f')
        p->fval = val;

    return 0;
}

int isCorrectType(char a, char b){
	if(a == b) {
		return 1;
	}

	switch (a) {

	case 'i':
		if(b != 'f')
			return 1;
		else
			return 0;
	case 'f':
		return 1;

	case 'b':
		return 0;

	default:
		return 0;
	}
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
            printf(" ival %d", p->ival);
            printf(" fval %f", p->fval);
            printf(" type %c", p->type);
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
 *  |f|i|s|t|EOS|s|e|c|o|n|d| but implemented as a list
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

char* bool_compare (char* a, char* b, char op){
	
	int valA = 0;
	int valB = 0;

	if(a != NULL){
		//if a is a number or a result
		if(isdigit(a[0]) || a[0] == '-'){
			valA = atoi(a);
		}
		//if a is a lexeme
		else {
			sym_node *p = NULL;
			if(getSymNode(find_symbol(a)) != NULL){
				p = getSymNode(find_symbol(a));
				valA = p->ival;
			} else {
				printf("error: %s never declared\n", a);
				return NULL;
			}
			
		}
	}

	if(b != NULL){
		//if b is a number or a result
		if(isdigit(b[0]) || b[0] == '-'){
			valB = atoi(b);
		}
		//if b is a lexeme
		else {
			sym_node *p = NULL;
			if(getSymNode(find_symbol(b)) != NULL){
				p = getSymNode(find_symbol(b));
				valB = p->ival;
			} else {
				printf("error: %s never declared\n", b);
				return NULL;
			}
		}
	}

	switch (op) {
		//OR operation
		case '|':
			return itoa(valA || valB);
			break;
		//AND operation
		case '&':
			return itoa(valA && valB);
			break;
		//NOT operation
		case '!':
			return itoa(!valA);
			break;
		default:
			return NULL;
			break;
	}
}

// FIXME: utile, ma non con i char (itoa e ftoa vanno
//        rimossi)
char* num_compare (char* a, char* b, char op){
	float valA = 0;
	float valB = 0;

	if(a != NULL){
		//if a is a number or a result
		if(isdigit(a[0]) || a[0] == '-'){
			valA = atof(a);
		}
		//if a is a lexeme
		else {
			sym_node *p = NULL;
			if(getSymNode(find_symbol(a)) != NULL){
				p = getSymNode(find_symbol(a));
				valA = p->fval;
			} else {
				printf("error: %s never declared\n", a);
				return NULL;
			}
		}
	}

	if(b != NULL){
		//if b is a number or a result
		if(isdigit(b[0]) || b[0] == '-'){
			valB = atof(b);
		}
		//if b is a lexeme
		else {
			sym_node *p = NULL;
			if(getSymNode(find_symbol(b)) != NULL){
				p = getSymNode(find_symbol(b));
				valB = p->fval;
			} else {
				printf("error: %s never declared\n", b);
				return NULL;
			}
		}
	}

	//printf("rel comparing %s %c %s ", a, op, b);
	//printf("where %s = %f and %s = %f \n", a, valA, b, valB);

	switch (op) {
		//EQUALS operation
		case '=':
			return itoa(valA == valB);
			break;
		//LESS THAN operation
		case '<':
			return itoa(valA < valB);
			break;
		//GREATER THAN operation
		case '>':
			return itoa(valA > valB);
			break;
		default:
			return NULL;
			break;
	}
}

// FIXME: da modificare; questo deve diventare
//        tipo "emit" che si trova negli esempi delle
//        slide
char* calculate (char* a, char* b, char op){
	float valA = 0;
	float valB = 0;

	if(a != NULL){
		//if a is a number or a result
		if(isdigit(a[0]) || a[0] == '-'){
			valA = atof(a);
		}
		//if a is a lexeme
		else {
			sym_node *p = NULL;
			if(getSymNode(find_symbol(a)) != NULL){
				p = getSymNode(find_symbol(a));
				valA = p->fval;
			} else {
				printf("error: %s never declared\n", a);
				return NULL;
			}
		}
	}

	
	if(b != NULL){
		//if b is a number or a result
		if(isdigit(b[0]) || b[0] == '-'){
			valB = atof(b);
		}
		//if b is a lexeme
		else {
			sym_node *p = NULL;
			if(getSymNode(find_symbol(b)) != NULL){
				p = getSymNode(find_symbol(b));
				valB = p->fval;
			} else {
				printf("error: %s never declared\n", b);
				return NULL;
			}
		}
	}

	switch (op) {
		//SUM
		case '+':
			return ftoa(valA + valB);
			break;
		//SUBTRACTION
		case '-':
			return ftoa(valA + valB);
			break;
		//MULTIPLICATION
		case '*':
			return ftoa(valA * valB);
			break;
		//DIVISION
		case '/':
			return ftoa(valA / valB);
			break;
		default:
			return NULL;
			break;
	}
}

// FIXME: da rimuovere
char* itoa (int i){
	char* buffer = (char*) malloc (30); 
	sprintf (buffer,"%d",i);	
	return buffer;
}


// FIXME: da rimuovere
char* ftoa (float f){
	char* buffer = (char*) malloc (30); 
	sprintf (buffer,"%f",f);
	return buffer;
}


//int main() {
// --- PER SOLO LA GESTIONE DEI LEXEMES ---
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
// --- END ---

// --- PER TESTARE LA SYMBOL TABLE ---
//    int result;
//    printf("------- Sym Table -------\n");
//    print_symbols();
//
//    add_symbol(10, "a", 1);
//    result = find_symbol("a");
//    printf("result: %d\n", result);
//
//    print_symbols();
//    add_symbol(10, "b", 2);
//    result = find_symbol("b");
//    printf("result: %d\n", result);
//
//    add_symbol(10, "c", 2);
//    result = find_symbol("c");
//    printf("result: %d\n", result);
//
//    print_symbols();
// --- END ---
//    return 0;
//}

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

typedef struct sym_node {
    sym_node* next;
    char *token;
    char *lexeme;
    int type;           // 0 == ganz
                        // 1 == genau
                        // 2 == boolean
} sym_node;

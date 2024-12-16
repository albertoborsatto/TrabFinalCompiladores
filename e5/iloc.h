#ifndef _ILOC_H_
#define _ILOC_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum op_type {
    left,
    right,
    cmp,
    cbr,
    jump,
    label
};

typedef struct iloc
{
    char* mnem;
    char* arg1;
    char* arg2;
    char* arg3;
    enum op_type type;
    
} iloc_t;

typedef struct iloc_code 
{
    iloc_t *iloc_instr;
    int num_iloc;
} iloc_code_t;

iloc_code_t gera_codigo(char *mnem, char* arg1, char* arg2, char* arg3, enum op_type type);

iloc_t gera_iloc(char *mnem, char* arg1, char* arg2, char* arg3, enum op_type type);

void inserir_iloc_code(iloc_code_t* code, iloc_t* iloc);

void print_code(iloc_code_t* code);

void free_code(iloc_code_t* code);

void concat_code(iloc_code_t* code1, iloc_code_t* code2);

iloc_code_t gera_aritm(char *mnem, void *tree1, void *tree2, char* local, enum op_type type);

void iloc_op_new(char* mnem, char* arg1, char* arg2, char* arg3, enum op_type type);

#endif //_ILOC_H_
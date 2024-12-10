#ifndef _ILOC_H_
#define _ILOC_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct iloc
{
    char* mnem;
    char* arg1;
    char* arg2;
    char* arg3;
} iloc_t;

typedef struct iloc_code 
{
    iloc_t *iloc_instr;
    int num_iloc;
} iloc_code_t;

iloc_code_t gera_codigo(char *mnem, char* arg1, char* arg2, char* arg3);

iloc_t gera_iloc(char *mnem, char* arg1, char* arg2, char* arg3);

void inserir_iloc_code(iloc_code_t* code, iloc_t* iloc);

void print_code(iloc_code_t* code);

void free_code(iloc_code_t* code);

#endif //_ILOC_H_
#include "iloc.h"
#include "asd.h"
#include "util.h"

iloc_code_t gera_codigo(char *mnem, char* arg1, char* arg2, char* arg3) {
    iloc_code_t code;
    code.num_iloc = 1;
    code.iloc_instr = malloc(sizeof(iloc_t));
    code.iloc_instr[0] = gera_iloc(mnem, arg1, arg2, arg3);
    return code;
}

iloc_t gera_iloc(char *mnem, char* arg1, char* arg2, char* arg3) {
    iloc_t instr;
    instr.mnem = strdup(mnem);
    instr.arg1 = arg1 ? strdup(arg1) : NULL;
    instr.arg2 = arg2 ? strdup(arg2) : NULL;
    instr.arg3 = arg3 ? strdup(arg3) : NULL;
    return instr;
}

void inserir_iloc_code(iloc_code_t* code, iloc_t* iloc) {
    if (code != NULL && iloc != NULL) {
        code->num_iloc++;
        code->iloc_instr = realloc(code->iloc_instr, code->num_iloc * sizeof(iloc_t));
        code->iloc_instr[code->num_iloc-1] = *iloc;
    } else {
        //TODO: mensagem melhor
        printf("Code or Iloc instruction is null");
    }
}

void concat_code(iloc_code_t* code1, iloc_code_t* code2) {
    if (code1!=NULL && code2!=NULL) {
        int old_num_iloc = code1->num_iloc;
        code1->num_iloc += code2->num_iloc;
        iloc_t *temp = realloc(code1->iloc_instr, code1->num_iloc * sizeof(iloc_t));
        if (temp == NULL) {
            printf("Erro ao realocar memória");
            return;
        }
        code1->iloc_instr = temp;
        memcpy(code1->iloc_instr + old_num_iloc, code2->iloc_instr, code2->num_iloc * sizeof(iloc_t));
    } 
    // TODO: tratar caso em que code1 é NULL
}

void print_code(iloc_code_t* code) {
    if (code == NULL || code->iloc_instr == NULL) {
        printf("Code is empty\n");
        return;
    }
    for (int i = 0; i < code->num_iloc; i++) {
        printf("%s %s %s %s\n", 
            code->iloc_instr[i].mnem, 
            code->iloc_instr[i].arg1 ? code->iloc_instr[i].arg1 : "",
            code->iloc_instr[i].arg2 ? code->iloc_instr[i].arg2 : "",
            code->iloc_instr[i].arg3 ? code->iloc_instr[i].arg3 : "");
    }
}

void free_code(iloc_code_t* code) {
    if (code == NULL || code->iloc_instr == NULL) return;
    for (int i = 0; i < code->num_iloc; i++) {
        free(code->iloc_instr[i].mnem);
        free(code->iloc_instr[i].arg1);
        free(code->iloc_instr[i].arg2);
        free(code->iloc_instr[i].arg3);
    }
    free(code->iloc_instr);
}

iloc_code_t gera_aritm(char *mnem, void *tree1, void *tree2, char* local) {
    // cast trees to asd_tree_t
    asd_tree_t *asd1 = (asd_tree_t *) tree1;
    asd_tree_t *asd2 = (asd_tree_t *) tree2;

    iloc_code_t arit_code;
    arit_code.num_iloc = asd1->code.num_iloc + asd2->code.num_iloc;
    concat_code(&asd1->code, &asd2->code);  

    arit_code.iloc_instr = malloc(arit_code.num_iloc * sizeof(iloc_t));

    memcpy(arit_code.iloc_instr, asd1->code.iloc_instr, asd1->code.num_iloc * sizeof(iloc_t));

    iloc_t new_instr = gera_iloc(mnem, asd1->temp, asd2->temp, local);
    inserir_iloc_code(&arit_code, &new_instr);

    return arit_code;
}

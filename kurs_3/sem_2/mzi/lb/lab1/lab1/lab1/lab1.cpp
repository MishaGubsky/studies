#include "stdafx.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <windows.h>

#include "tea.h"


#define GENERETE_KEY_ARGUMENT "generate_key"
#define ENCRYPT_FILE_ARGUMENT "encrypt"
#define DECRYPT_FILE_ARGUMENT "decrypt"


FILE* open_file(int argn, int argc, const char *argv[], const char* mode) {
    FILE* file = fopen(argv[argn], mode);
    if (!file) {
        printf("Error while opening file \"%s\"\n", argv[4]);
        return NULL;
    }
    return file;
}


void generate_key(char* key) {
    srand(time(NULL));
    memset(key, 0, KEY_LENGTH + 1);
    for (int i = 0; i < KEY_LENGTH; ++i) {
        key[i] = rand() % ('z' - 'A') + 'A';
    }
}


int main(int argc, const char *argv[]) {
    if (argc == 2 && !strcmp(argv[1], GENERETE_KEY_ARGUMENT)) {
        char key[KEY_LENGTH + 1];
        generate_key(key);
        printf("%s\n", key);
    }
    else if (argc == 5) {
        int key[4];
        memset(key, 0, KEY_LENGTH);
        memcpy(key, argv[2], min(KEY_LENGTH, strlen(argv[2])));

        FILE *input = open_file(3, argc, argv, "rb");
        FILE *output = open_file(4, argc, argv, "wb+");
        if (!input || !output)
            return 0;

        if (!strcmp(argv[1], ENCRYPT_FILE_ARGUMENT)) {
            encrypt((int*)key, input, output);
        }
        else if (!strcmp(argv[1], DECRYPT_FILE_ARGUMENT)) {
            decrypt((int*)key, input, output);
        }
        else {
            printf("Unknown argument \"%s\"\n", argv[1]);
        }

        fclose(input);
        fclose(output);
    }
    else {
        printf("Arguments:\n");
        printf("\t%s\n", GENERETE_KEY_ARGUMENT);
        printf("\t%s [key] [input_file] [output_file]\n", ENCRYPT_FILE_ARGUMENT);
        printf("\t%s [key] [input_file] [output_file]\n", DECRYPT_FILE_ARGUMENT);
    }
	return 0;
}
#include "stdafx.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "tea.h"


void encrypt_block(int block[2], const int key[4]) {
    for (int i = 0; i < CYCLES_COUNT; i++) {
        int delta = (i + 1) * SCHCEDULE_CONST;
        block[0] += ((block[1] << 4) + key[0]) ^ (block[1] + delta) ^ ((block[1] >> 5) + key[1]);
        block[1] += ((block[0] << 4) + key[2]) ^ (block[0] + delta) ^ ((block[0] >> 5) + key[3]);
    }
}


void decrypt_block(int block[2], const int key[4]) {
    for (int i = 0; i < CYCLES_COUNT; i++) {
        int delta = DELTA_CONST - i * SCHCEDULE_CONST;
        block[1] -= ((block[0] << 4) + key[2]) ^ (block[0] + delta) ^ ((block[0] >> 5) + key[3]);
        block[0] -= ((block[1] << 4) + key[0]) ^ (block[1] + delta) ^ ((block[1] >> 5) + key[1]);
    }
}


void encrypt(const int key[4], FILE* input, FILE* output) {
    char block[BLOCK_LENGTH];
    int readed_length, total_length = 0;
    fwrite(&total_length, sizeof(int), 1, output);
    rewind(input);
    while (readed_length = fread(block, sizeof(char), BLOCK_LENGTH, input)) {
        encrypt_block((int*)block, key);
        fwrite(block, sizeof(char), BLOCK_LENGTH, output);
        memset(block, 0, BLOCK_LENGTH);
        total_length += readed_length;
    }
	printf("%d", total_length);
    rewind(output);
    fwrite(&total_length, sizeof(int), 1, output);
    fseek(output, 0, SEEK_END);
}


void decrypt(const int key[4], FILE* input, FILE* output) {
    int total_length = 0;
    rewind(input);
    fread(&total_length, sizeof(int), 1, input);

    char block[BLOCK_LENGTH];
    for (total_length; total_length > 0; total_length -= BLOCK_LENGTH) {
        fread(block, sizeof(char), BLOCK_LENGTH, input);
        decrypt_block((int*)block, key);
        fwrite(block, sizeof(char), min(total_length, BLOCK_LENGTH), output);
    }
}

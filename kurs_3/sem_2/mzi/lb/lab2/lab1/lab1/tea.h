#ifndef __tea__
#define __tea__

#include <stdio.h>

#define min(a, b)  (a < b) ? a : b
#define BLOCK_LENGTH 8
#define KEY_LENGTH 16
#define CYCLES_COUNT 32
#define SCHCEDULE_CONST 0x9e3779b9
#define DELTA_CONST 0xC6EF3720

void encrypt(const int key[4], FILE* input, FILE* output);
void decrypt(const int key[4], FILE* input, FILE* output);

#endif

#include <math.h>
#include <stdio.h>
#include "maa.h"
#include "stdafx.h"

#define A 0x02040801
#define B 0x00804021
#define C 0xbfef7fdf
#define D 0x7dfefbff


int get_authentication_code(FILE* file, int key[]) {
    int lkey = key[0] ^ key[2];
    int rkey = key[1] ^ key[3];

    int x = 0, y = 0, data = 0;
    rewind(file);
    while (fread(&data, sizeof(int), 1, file)) {
        lkey = (lkey << 1) | (lkey >> (sizeof(int) - 1));
        rkey = lkey ^ rkey;
        x = ((rkey + x) | A & C) * (x ^ data) % 0xfffffffe;
        y = ((rkey + y) | B & C) * (y ^ data) % 0xfffffffe;
    }

    return x ^ y;
}

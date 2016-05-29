#include "stdafx.h"
#include "crypto.h"
#include <stdio.h>


void crypt(char *data, int data_len, char *key) {
    for (int i = 0; i < data_len;) {
        for (int j = 0; key[j] != 0 && i < data_len; i++, j++) {
            data[i] ^= key[j];
        }
    }
}

#include "stdafx.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_TESTS_COUNT 100
#define MAX_TEST_LENGTH 1000 * 1000

#define min(a, b) (a < b) ? a : b

int ma123in(int argc, char const *argv[]) {
    srand(time(NULL));

    if (argc < 3)
        return 0;

    int tests_count;
    sscanf(argv[1], "%d", &tests_count);
    tests_count = min(tests_count, MAX_TESTS_COUNT);

    int test_length;
    sscanf(argv[2], "%d", &test_length);
    test_length = min(test_length, MAX_TEST_LENGTH);

    printf("Creating %d tests with %d max length:\n", tests_count, test_length);
    for (int i = 0; i < tests_count; i++) {
        char file_name[100];
        sprintf(file_name, "tests/%0*d.test", 2, i);
        FILE* file = fopen(file_name, "w+");

        printf("\tcreating %s\n", file_name);
        int length = rand() % test_length;
        for (int j = 0; j < length; j++) {
            char byte = rand() % ('z' - 'A') + 'A';
            fwrite(&byte, sizeof(char), 1, file);
        }

        fclose(file);
    }
    return 0;
}

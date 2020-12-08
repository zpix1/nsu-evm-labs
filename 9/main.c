#include <stdio.h>
#include <stdlib.h>

const int OFFSET = (1 << 24) / sizeof(int);
const int SIZE = 16 * 1024 *  1024 / sizeof(int);
const int K = 5;
const int MAXN = 32;

void generate(int* data, const int n) {
    const int blocksize = SIZE / n;
    for (int i = 0; i < blocksize; i++) {
        for (int j = 0; j < n - 1; j++) {
            data[j * OFFSET + i] = (j+1) * OFFSET + i;
        }
        data[(n - 1) * OFFSET + i] = i + 1;
    }
    data[(n - 1) * OFFSET + blocksize - 1] = 0;
}

int main() {
    int* data = (int*)calloc(OFFSET * MAXN, sizeof(int));
    printf("[\n");
    int t = 0;
    for (int n = 1; n <= MAXN; n++) {
        generate(data, n);
        unsigned long long mn = 100000000000000;
        for (int k = 0; k < 100; k++) {
            unsigned long long start = __builtin_ia32_rdtsc();

            int k;
            int i;
            for (k = 0, i = 0; i < SIZE*K; i++) {
                k = data[k];
            }
            t = k;

            unsigned long long end = __builtin_ia32_rdtsc();

            if ((end - start) / SIZE / K < mn) {
                mn = (end - start) / SIZE / K;
            }
        }
        printf("[%d, %llu],\n", n, mn);
    }
    printf("]\n");
    printf("%d\n", t);
    free(data);
    return 0;
}
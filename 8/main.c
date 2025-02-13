#include <stdio.h>
#include <stdlib.h>
#include <time.h>

const long long Nmin = 1024 / sizeof(int);
const long long Nmax = 32 * 1024 * 1024LL / sizeof(int);
const int K = 10;

void gen_ascending(int* data, const long long N) {
    for (long long i = 0; i < N - 1; i++) {
        data[i] = i + 1;
    }
    data[N] = 0;
}

void gen_descending(int* data, const long long N) {
    data[0] = N - 1;
    for (long long i = 1; i < N; i++) {
        data[i] = i - 1;
    }
}

void gen_random(int* data, const long long N) {
    int* perm = (int*)malloc(N * sizeof(int));
    for(int i = 0; i < N; i++){
        perm[i] = i;
    }
    for (int i = N - 1; i >= 0; i--){
        int j = rand() % (i + 1);
        int temp = perm[i];
        perm[i] = perm[j];
        perm[j] = temp;
    }
    for (int i = 0; i < N; i++) {
        data[perm[i]] = perm[(i + 1) % N];
    }
    free(perm);
}

int test(int* data, const long long N, const int K, void (*gen)(int* data, const long long N)) {
    gen(data, N);

    // warm-up
    int k;
    long long i;

    for (k = 0, i = 0; i < N; i++) {
        k = data[k];
    }
    
    unsigned long long start = __builtin_ia32_rdtsc();

    for (k = 0, i = 0; i < N*K; i++) {
        k = data[k];
    }

    unsigned long long end = __builtin_ia32_rdtsc();
    
    printf("%lld, %d, %llu],\n", N*4, K, (end-start) / N / K);
	return k;
}

int main() {
    int* data = (int*)malloc(Nmax * sizeof(int));
    printf("[\n");
    for (int N = Nmin; N <= Nmax; N *= 2) {
        printf("[\"asc\", ");
        test(data, N, K, gen_ascending);
        printf("[\"dec\", ");
        test(data, N, K, gen_descending);
        printf("[\"ran\", ");
        test(data, N, K, gen_random);
    }
    printf("]\n");

    free(data);
    return 0;
}
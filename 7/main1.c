#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

const int N = 4;
const int M = 10;

void print_matrix(float* m) {
    printf("Matrix:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            printf("%10.5f ", m[i * N + j]);
        }
        printf("\n");
    }
}

// result should be zero
void mul(float* m1, float* m2, float* result) {
    for (int i = 0; i < N; i++) {
        for (int k = 0; k < N; k++) {
            for (int j = 0; j < N; j++) {
                result[i*N + j] += m1[i*N + k] * m2[k*N + j];
            }
        }
    }
}

float* get_matrix() {
    return (float*)calloc(N*N, sizeof(float));
}

void free_matrix(float* m) {
    free(m);
}

void make_id(float* m) {
    for (int i = 0; i < N; i++) {
        m[i*N + i] = 1.0;
    }
}

void inverse(float* A) {
    float* I = get_matrix(); 
    make_id(I);

    float m1 = 0.0;
    for (int i = 0; i < N; i++) {
        float tmp = 0.0;
        for (int j = 0; j < N; j++) {
            tmp += fabs(A[i*N + j]);
        }
        if (tmp > m1) {
            m1 = tmp;
        }
    }

    float minf = 0.0;
    for (int i = 0; i < N; i++) {
        float tmp = 0.0;
        for (int j = 0; j < N; j++) {
            tmp += fabs(A[j*N + i]);
        }
        if (tmp > minf) {
            minf = tmp;
        }
    }

    float* B = get_matrix();
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            B[i*N + j] = A[j*N + i] / minf / m1;
        }
    }

    float* R = get_matrix();
    mul(B, A, R);
    for (int i = 0; i < N*N; i++) {
        R[i] = I[i] - R[i];
    }

    float* temp = get_matrix();
    memcpy(temp, R, sizeof(float)*N*N);
    for (int iter = 0; iter < M; iter++) {
        printf("Iteration %d\n", iter);
        for (int i = 0; i < N*N; i++) {
            I[i] += temp[i];
        }
        memset(A, 0, sizeof(float)*N*N);
        mul(temp, R, A);
        memcpy(temp, A, sizeof(float)*N*N);
    }
    memset(A, 0, sizeof(float)*N*N);
    mul(I, B, A);

    free_matrix(temp);
    free_matrix(I);
    free_matrix(B);
    free_matrix(R);
}

int main() {
    float* A = get_matrix();
    for (int i = 0; i < N*N; i++) {
        A[i] = i + 1;
    }

    float* Aorig = NULL;
    if (N < 10) {
        Aorig = get_matrix();
        for (int i = 0; i < N*N; i++) {
            Aorig[i] = A[i];
        }
    }

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC_RAW, &start);
    inverse(A);
    clock_gettime(CLOCK_MONOTONIC_RAW, &end);
    printf("Time: %lf sec.\n", end.tv_sec-start.tv_sec + 0.000000001*(end.tv_nsec-start.tv_nsec));

    if (N < 10) {
        float* res = get_matrix();
        print_matrix(A);
        print_matrix(Aorig);
        mul(Aorig, A, res);
        print_matrix(res);
        free_matrix(res);
    }

    free_matrix(A);
    free_matrix(Aorig);
}
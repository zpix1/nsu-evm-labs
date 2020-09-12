#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

double get_pi(long long int total) {
    long long matched = 0;
    for (long long i = 0; i < total; i++) {
        double x = rand() * 1.0 / RAND_MAX;
        double y = rand() * 1.0 / RAND_MAX;
        if (x*x + y*y <= 1.0) {
            matched++;
        }
    }
    return matched * 4.0 / total;
}

int main(int argc, char** argv) {
    struct timespec start, end;
    long long n = 90000000;
    if (argc > 1) {
        n = atoll(argv[1]);
    }
    clock_gettime(CLOCK_MONOTONIC_RAW, &start);
    double pi = get_pi(n);
    clock_gettime(CLOCK_MONOTONIC_RAW, &end);

    // printf("PI = %lf\n", pi);
    printf("{ \"time\": %lf, \"pi\": %lf }\n", end.tv_sec-start.tv_sec + 0.000000001*(end.tv_nsec-start.tv_nsec), pi);
    return 0;
}
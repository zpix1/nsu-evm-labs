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

int main() {
    double pi = get_pi(90000000);
    printf("PI = %lf\n", pi);
    return 0;
}
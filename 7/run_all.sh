echo "1: no vec"
gcc -O2 main1.c && ./a.out
echo "2: vec"
gcc -O2 main2.c && ./a.out
echo "1: BLAS"
gcc -O2 main3.c -lblas && ./a.out

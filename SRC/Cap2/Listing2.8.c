#include <stdio.h>

int f(void);   // <-- prototipo declarado aquí

int main() {
    int r = f();
    printf("Resultado de f(): %d\n", r);
    return r;
}


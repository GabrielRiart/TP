#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
    pid_t child_pid;

    /* Creamos el proceso hijo. */
    child_pid = fork();

    if (child_pid > 0) {
        // El padre se duerme por 60 segundos.
        sleep(60);
                /* Este es el proceso padre. */
        printf("Este es el proceso padre con PID %d\n", (int)getpid());
        printf("Mi hijo tiene el PID %d\n", (int)child_pid);
    } else {
        /* Este es el proceso hijo. */
        printf("Este es el proceso hijo con PID %d\n", (int)getpid()); 
        // El hijo termina inmediatamente.
        exit(0);
    }

    return 0;
}

/* readfile_example.c
 *
 * Ejemplo de manejo correcto de recursos cuando puede haber errores.
 *
 * Compilar:
 *   gcc -std=c11 -Wall -Wextra readfile_example.c -o readfile_example
 */

#include <fcntl.h>     // open
#include <stdlib.h>    // malloc, free, exit
#include <unistd.h>    // read, close
#include <sys/types.h> // tipos básicos
#include <sys/stat.h>  // open flags
#include <stdio.h>     // printf, perror
#include <string.h>    // strlen, memcpy

/* Lee hasta LENGTH bytes de FILENAME a un buffer recién reservado.
 * Devuelve un puntero al buffer (el llamador debe liberar con free),
 * o NULL si hubo error. */
char* read_from_file(const char* filename, size_t length)
{
    char* buffer = NULL;
    int fd = -1;
    ssize_t bytes_read;

    /* Paso 1: reservar memoria */
    buffer = (char*) malloc(length);
    if (buffer == NULL) {
        perror("malloc");
        return NULL;
    }

    /* Paso 2: abrir archivo */
    fd = open(filename, O_RDONLY);
    if (fd == -1) {
        perror("open");
        free(buffer);
        return NULL;
    }

    /* Paso 3: leer datos */
    bytes_read = read(fd, buffer, length);
    if (bytes_read == -1) {
        perror("read");
        free(buffer);
        close(fd);
        return NULL;
    }

    /* Paso 4: cerrar archivo */
    if (close(fd) == -1) {
        perror("close");
        free(buffer);
        return NULL;
    }

    /* Paso 5: devolver buffer (el llamador debe free) */
    return buffer;
}

/* MAIN DEMOSTRATIVO */
int main(void)
{
    const char* filename = "demo.txt";
    const char* text = "Este es un archivo de prueba.\n";

    /* Crear un archivo de prueba para leer */
    {
        int fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (fd == -1) {
            perror("open for write");
            return EXIT_FAILURE;
        }
        if (write(fd, text, strlen(text)) == -1) {
            perror("write");
            close(fd);
            return EXIT_FAILURE;
        }
        close(fd);
    }

    /* Leer usando la función segura */
    char* result = read_from_file(filename, strlen(text));
    if (!result) {
        fprintf(stderr, "Error leyendo el archivo con read_from_file\n");
        return EXIT_FAILURE;
    }

    printf("Contenido leído desde '%s': \"%s\"\n", filename, result);

    free(result);
    return EXIT_SUCCESS;
}


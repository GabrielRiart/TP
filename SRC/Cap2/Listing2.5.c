#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>     // mkstemp
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>

/* Tipo para el "handle" del archivo temporal: en esta implementación es un fd */
typedef int temp_file_handle;

/* Escribe LENGTH bytes desde BUFFER en un archivo temporal.
 * El archivo se unlinkea inmediatamente. Devuelve fd (>=0) o -1 en error. */
temp_file_handle write_temp_file(const char* buffer, size_t length)
{
    char temp_filename[] = "/tmp/temp_file.XXXXXX";
    int fd = mkstemp(temp_filename);
    if (fd == -1) {
        perror("mkstemp");
        return -1;
    }

    /* Unlinkear inmediatamente para que el archivo sea anónimo y se elimine
       cuando se cierre el fd. No consideramos esto fatal: si falla, imprimimos
       y seguimos, pero idealmente deberían gestionarse ambos casos. */
    if (unlink(temp_filename) == -1) {
        perror("unlink (warning)");
        /* seguimos: el archivo existe en el filesystem, pero lo seguiremos usando */
    }

    /* Escribir el tamaño primero (para el ejemplo del libro) */
    ssize_t wn = write(fd, &length, sizeof(length));
    if (wn != (ssize_t)sizeof(length)) {
        if (wn == -1) perror("write length");
        else fprintf(stderr, "write length: short write\n");
        close(fd);
        return -1;
    }

    /* Escribir los datos en bucle para manejar escrituras parciales */
    size_t remaining = length;
    const char* p = buffer;
    while (remaining > 0) {
        ssize_t w = write(fd, p, remaining);
        if (w == -1) {
            if (errno == EINTR) continue; /* reintentar si fue interrumpido */
            perror("write data");
            close(fd);
            return -1;
        }
        remaining -= (size_t)w;
        p += w;
    }

    /* Devolver el descriptor (archivo todavía abierto y listo para usarse) */
    return fd;
}

/* Lee el contenido del archivo temporal (creado por write_temp_file).
 * *length será rellenado con el tamaño. Devuelve un buffer alocado con malloc
 * que el llamador debe liberar, o NULL en error. Cierra el fd, lo que eliminará
 * el archivo del sistema de archivos (si fue unlinkeado). */
char* read_temp_file(temp_file_handle temp_file, size_t* length)
{
    if (temp_file < 0) {
        fprintf(stderr, "read_temp_file: invalid handle\n");
        return NULL;
    }

    int fd = temp_file;

    /* Ir al inicio del archivo */
    if (lseek(fd, 0, SEEK_SET) == -1) {
        perror("lseek");
        close(fd);
        return NULL;
    }

    /* Leer el tamaño guardado */
    ssize_t rn = read(fd, length, sizeof(*length));
    if (rn != (ssize_t)sizeof(*length)) {
        if (rn == -1) perror("read length");
        else fprintf(stderr, "read length: short read\n");
        close(fd);
        return NULL;
    }

    /* Reservar buffer (agregamos +1 para poder tratarlo como string si es texto) */
    if (*length == 0) {
        /* caso trivial: longitud cero */
        char* buf = malloc(1);
        if (!buf) { perror("malloc"); close(fd); return NULL; }
        buf[0] = '\0';
        close(fd);
        return buf;
    }

    char* buffer = (char*)malloc(*length + 1);
    if (!buffer) {
        perror("malloc");
        close(fd);
        return NULL;
    }

    /* Leer los datos en bucle */
    size_t remaining = *length;
    char* p = buffer;
    while (remaining > 0) {
        ssize_t r = read(fd, p, remaining);
        if (r == -1) {
            if (errno == EINTR) continue;
            perror("read data");
            free(buffer);
            close(fd);
            return NULL;
        } else if (r == 0) {
            fprintf(stderr, "read data: unexpected EOF\n");
            free(buffer);
            close(fd);
            return NULL;
        }
        remaining -= (size_t)r;
        p += r;
    }

    /* Null-terminate (si es texto, útil para printf) */
    buffer[*length] = '\0';

    /* Cerrar fd -> si previamente unlinkeamos, el archivo se elimina del disco aquí */
    if (close(fd) == -1) {
        perror("close");
        /* Aun así devolvemos buffer; el cierre falló, pero no vamos a recuperar */
    }

    return buffer;
}

/* MAIN demostrativo */
int main(void)
{
    const char* text = "Este es un texto de prueba para el archivo temporal.";
    size_t len = strlen(text);

    printf("Contenido original (%zu bytes): \"%s\"\n", len, text);

    /* Escribir a archivo temporal */
    temp_file_handle h = write_temp_file(text, len);
    if (h == -1) {
        fprintf(stderr, "Error al crear/escribir el archivo temporal\n");
        return EXIT_FAILURE;
    }
    printf("Escrito %zu bytes en archivo temporal (fd=%d). El archivo ya está unlinkeado.\n", len, h);

    /* Leer de vuelta */
    size_t read_len = 0;
    char* read_buf = read_temp_file(h, &read_len);
    if (!read_buf) {
        fprintf(stderr, "Error al leer el archivo temporal\n");
        return EXIT_FAILURE;
    }

    printf("Leído %zu bytes del archivo temporal: \"%s\"\n", read_len, read_buf);

    /* Comprobar contenido */
    if (read_len == len && memcmp(read_buf, text, len) == 0) {
        printf("Verificación OK: contenido idéntico.\n");
    } else {
        printf("Verificación FALLIDA: contenido distinto.\n");
    }

    free(read_buf);
    return EXIT_SUCCESS;
}


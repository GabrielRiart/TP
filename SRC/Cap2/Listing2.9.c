#include <stdio.h>
#include <tiffio.h>

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <archivo.tif>\n", argv[0]);
        return 1;
    }

    printf("[INFO] Intentando abrir: %s\n", argv[1]);
    TIFF* tiff = TIFFOpen(argv[1], "r");

    if (!tiff) {
        fprintf(stderr, "[ERROR] No se pudo abrir el archivo TIFF: %s\n", argv[1]);
        return 2;
    }

    printf("[OK] Archivo abierto correctamente.\n");

    // Podrías leer metadatos, por ahora solo cerramos
    TIFFClose(tiff);
    printf("[INFO] Archivo cerrado.\n");

    return 0;
}


# Compiladores y flags
CC  = gcc
CXX = g++
CFLAGS = -Wall -g
CXXFLAGS = -Wall -g

# Directorios
SRC_DIR_CAP1 = SRC/Cap1
BIN_DIR_CAP1 = bin/Cap1

SRC_DIR_CAP2 = SRC/Cap2
BIN_DIR_CAP2 = bin/Cap2

SRC_DIR_CAP3 = SRC/Cap3
BIN_DIR_CAP3 = bin/Cap3

SRC_DIR_CAP5 = SRC/Cap5
BIN_DIR_CAP5 = bin/Cap5

# ====== CAPÍTULO 1 (ejecutable único) ======
CAP1_SRC_C   = $(SRC_DIR_CAP1)/Listing1.1.c
CAP1_SRC_CPP = $(SRC_DIR_CAP1)/Listing1.2.cpp
CAP1_HDR     = $(SRC_DIR_CAP1)/Listing1.3.hpp

CAP1_OBJ = $(BIN_DIR_CAP1)/Listing1.1.o $(BIN_DIR_CAP1)/Listing1.2.o
CAP1_BIN = $(BIN_DIR_CAP1)/programa_cap1

# ====== CAPÍTULO 2 ======
# Listings simples (2.1 → 2.6)
CAP2_SIMPLE_SRC  = $(SRC_DIR_CAP2)/Listing2.1.c $(SRC_DIR_CAP2)/Listing2.2.c \
                   $(SRC_DIR_CAP2)/Listing2.3.c $(SRC_DIR_CAP2)/Listing2.4.c \
                   $(SRC_DIR_CAP2)/Listing2.5.c $(SRC_DIR_CAP2)/Listing2.6.c
CAP2_SIMPLE_BINS = $(patsubst $(SRC_DIR_CAP2)/%.c,$(BIN_DIR_CAP2)/%,$(CAP2_SIMPLE_SRC))

# Listings especiales (2.7, 2.8, 2.9)
CAP2_LIST27 = $(SRC_DIR_CAP2)/Listing2.7.c
CAP2_LIST28 = $(SRC_DIR_CAP2)/Listing2.8.c
CAP2_LIST29 = $(SRC_DIR_CAP2)/Listing2.9.c

CAP2_LIB      = $(BIN_DIR_CAP2)/libtest.a
CAP2_APP_OBJ  = $(BIN_DIR_CAP2)/Listing2.8.o
CAP2_APP_BIN  = $(BIN_DIR_CAP2)/app
CAP2_TIFF_BIN = $(BIN_DIR_CAP2)/tifftest

# ====== CAPÍTULO 3 ======
CAP3_SRC  = $(wildcard $(SRC_DIR_CAP3)/*.c)
CAP3_BINS = $(patsubst $(SRC_DIR_CAP3)/%.c,$(BIN_DIR_CAP3)/%,$(CAP3_SRC))

# ====== CAPÍTULO 5 (cada listing es ejecutable) ======
CAP5_SRC = $(wildcard $(SRC_DIR_CAP5)/*.c)
CAP5_BINS = $(patsubst $(SRC_DIR_CAP5)/%.c,$(BIN_DIR_CAP5)/%,$(CAP5_SRC))

# ====== OBJETIVO PRINCIPAL ======
all: cap1 cap2 cap3 cap5

# ---------------- CAPÍTULO 1 ----------------
cap1: $(CAP1_BIN)

$(CAP1_BIN): $(CAP1_OBJ)
	@mkdir -p $(BIN_DIR_CAP1)
	$(CXX) -o $@ $(CAP1_OBJ)

$(BIN_DIR_CAP1)/Listing1.1.o: $(CAP1_SRC_C) $(CAP1_HDR)
	@mkdir -p $(BIN_DIR_CAP1)
	$(CC) $(CFLAGS) -c $< -o $@

$(BIN_DIR_CAP1)/Listing1.2.o: $(CAP1_SRC_CPP) $(CAP1_HDR)
	@mkdir -p $(BIN_DIR_CAP1)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# ---------------- CAPÍTULO 2 ----------------
cap2: $(CAP2_SIMPLE_BINS) $(CAP2_APP_BIN) $(CAP2_TIFF_BIN)

# Regla genérica: listings simples (2.1–2.6)
$(BIN_DIR_CAP2)/%: $(SRC_DIR_CAP2)/%.c
	@mkdir -p $(BIN_DIR_CAP2)
	$(CC) $(CFLAGS) $< -o $@

# Librería estática libtest.a con Listing2.7
$(CAP2_LIB): $(CAP2_LIST27)
	@mkdir -p $(BIN_DIR_CAP2)
	$(CC) $(CFLAGS) -c $< -o $(BIN_DIR_CAP2)/Listing2.7.o
	ar cr $@ $(BIN_DIR_CAP2)/Listing2.7.o

# Programa app (Listing2.8 usa libtest.a)
$(CAP2_APP_OBJ): $(CAP2_LIST28)
	@mkdir -p $(BIN_DIR_CAP2)
	$(CC) $(CFLAGS) -c $< -o $@

$(CAP2_APP_BIN): $(CAP2_APP_OBJ) $(CAP2_LIB)
	$(CC) -o $@ $(CAP2_APP_OBJ) -L$(BIN_DIR_CAP2) -ltest

# Programa tifftest (Listing2.9)
$(CAP2_TIFF_BIN): $(CAP2_LIST29)
	@mkdir -p $(BIN_DIR_CAP2)
	$(CC) $(CFLAGS) $< -o $@ -ltiff

# Extra: ejecutar Listing2.9 y abrir imagen
run_tiff: $(CAP2_TIFF_BIN)
	@if [ -f mondongo.tiff ]; then \
		echo "[INFO] Ejecutando tifftest con mondongo.tiff..."; \
		$(CAP2_TIFF_BIN) mondongo.tiff; \
		display mondongo.tiff & \
	else \
		echo "[WARN] No se encontró mondongo.tiff en este directorio."; \
	fi

# ---------------- CAPÍTULO 3 ----------------
cap3: $(CAP3_BINS)

$(BIN_DIR_CAP3)/%: $(SRC_DIR_CAP3)/%.c
	@mkdir -p $(BIN_DIR_CAP3)
	$(CC) $(CFLAGS) $< -o $@

# ---------------- CAPÍTULO 5 ----------------
cap5: $(CAP5_BINS)

# Regla genérica para compilar cada listing de Cap5
$(BIN_DIR_CAP5)/%: $(SRC_DIR_CAP5)/%.c
	@mkdir -p $(BIN_DIR_CAP5)
	$(CC) $(CFLAGS) $< -o $@

# ---------------- LIMPIEZA ----------------
clean:
	rm -rf bin/Cap1 bin/Cap2 bin/Cap3 bin/Cap5


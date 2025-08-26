# Compiladores y flags
CC  = gcc
CXX = g++
CFLAGS = -Wall -g
CXXFLAGS = -Wall -g

# Directorios
SRC_DIR_CAP1 = SRC/Cap1
BIN_DIR_CAP1 = bin/Cap1

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

# ====== CAPÍTULO 3 (cada listing es ejecutable) ======
CAP3_SRC = $(wildcard $(SRC_DIR_CAP3)/*.c)
CAP3_BINS = $(patsubst $(SRC_DIR_CAP3)/%.c,$(BIN_DIR_CAP3)/%,$(CAP3_SRC))

# ====== CAPÍTULO 5 (cada listing es ejecutable) ======
CAP5_SRC = $(wildcard $(SRC_DIR_CAP5)/*.c)
CAP5_BINS = $(patsubst $(SRC_DIR_CAP5)/%.c,$(BIN_DIR_CAP5)/%,$(CAP5_SRC))

# ====== OBJETIVO PRINCIPAL ======
all: cap1 cap3 cap5

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

# ---------------- CAPÍTULO 3 ----------------
cap3: $(CAP3_BINS)

# Regla genérica para compilar cada listing de Cap3
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
	rm -rf bin/Cap1 bin/Cap3 bin/Cap5


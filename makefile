# Compiladores y flags
CC  = gcc
CXX = g++
CFLAGS = -Wall -g
CXXFLAGS = -Wall -g -pthread

# Directorios
SRC_DIR_CAP1 = SRC/Cap1
BIN_DIR_CAP1 = bin/Cap1

SRC_DIR_CAP2 = SRC/Cap2
BIN_DIR_CAP2 = bin/Cap2

SRC_DIR_CAP3 = SRC/Cap3
BIN_DIR_CAP3 = bin/Cap3

SRC_DIR_CAP4 = SRC/Cap4
BIN_DIR_CAP4 = bin/Cap4

# ====== CAPÍTULO 1 ======
CAP1_SRC_C   = $(SRC_DIR_CAP1)/Listing1.1.c
CAP1_SRC_CPP = $(SRC_DIR_CAP1)/Listing1.2.cpp
CAP1_HDR     = $(SRC_DIR_CAP1)/Listing1.3.hpp

CAP1_OBJ = $(BIN_DIR_CAP1)/Listing1.1.o $(BIN_DIR_CAP1)/Listing1.2.o
CAP1_BIN = $(BIN_DIR_CAP1)/programa_cap1

# ====== CAPÍTULO 2 ======
CAP2_SIMPLE_SRC  = $(SRC_DIR_CAP2)/Listing2.1.c $(SRC_DIR_CAP2)/Listing2.2.c \
                   $(SRC_DIR_CAP2)/Listing2.3.c $(SRC_DIR_CAP2)/Listing2.4.c \
                   $(SRC_DIR_CAP2)/Listing2.5.c $(SRC_DIR_CAP2)/Listing2.6.c
CAP2_SIMPLE_BINS = $(patsubst $(SRC_DIR_CAP2)/%.c,$(BIN_DIR_CAP2)/%,$(CAP2_SIMPLE_SRC))

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

# ====== CAPÍTULO 4 ======
CAP4_SRC_C   = $(wildcard $(SRC_DIR_CAP4)/Listing4*.c)
CAP4_SRC_CPP = $(wildcard $(SRC_DIR_CAP4)/Listing4*.cpp)

CAP4_BINS_C   = $(patsubst $(SRC_DIR_CAP4)/%.c,$(BIN_DIR_CAP4)/%,$(CAP4_SRC_C))
CAP4_BINS_CPP = $(patsubst $(SRC_DIR_CAP4)/%.cpp,$(BIN_DIR_CAP4)/%,$(CAP4_SRC_CPP))

CAP4_BINS = $(CAP4_BINS_C) $(CAP4_BINS_CPP)

# ====== OBJETIVO PRINCIPAL ======
all: cap1 cap2 cap3 cap4

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

$(BIN_DIR_CAP2)/%: $(SRC_DIR_CAP2)/%.c
	@mkdir -p $(BIN_DIR_CAP2)
	$(CC) $(CFLAGS) $< -o $@

$(CAP2_LIB): $(CAP2_LIST27)
	@mkdir -p $(BIN_DIR_CAP2)
	$(CC) $(CFLAGS) -c $< -o $(BIN_DIR_CAP2)/Listing2.7.o
	ar cr $@ $(BIN_DIR_CAP2)/Listing2.7.o

$(CAP2_APP_OBJ): $(CAP2_LIST28)
	@mkdir -p $(BIN_DIR_CAP2)
	$(CC) $(CFLAGS) -c $< -o $@

$(CAP2_APP_BIN): $(CAP2_APP_OBJ) $(CAP2_LIB)
	$(CC) -o $@ $(CAP2_APP_OBJ) -L$(BIN_DIR_CAP2) -ltest

$(CAP2_TIFF_BIN): $(CAP2_LIST29)
	@mkdir -p $(BIN_DIR_CAP2)
	$(CC) $(CFLAGS) $< -o $@ -ltiff

# ---------------- CAPÍTULO 3 ----------------
cap3: $(CAP3_BINS)

$(BIN_DIR_CAP3)/%: $(SRC_DIR_CAP3)/%.c
	@mkdir -p $(BIN_DIR_CAP3)
	$(CC) $(CFLAGS) $< -o $@

# ---------------- CAPÍTULO 4 ----------------
cap4: $(CAP4_BINS)

$(BIN_DIR_CAP4)/%: $(SRC_DIR_CAP4)/%.c
	@mkdir -p $(BIN_DIR_CAP4)
	$(CC) $(CFLAGS) $< -o $@

$(BIN_DIR_CAP4)/%: $(SRC_DIR_CAP4)/%.cpp
	@mkdir -p $(BIN_DIR_CAP4)
	$(CXX) $(CXXFLAGS) $< -o $@

# ---------------- LIMPIEZA ----------------
clean:
	rm -rf bin/Cap1 bin/Cap2 bin/Cap3 bin/Cap4


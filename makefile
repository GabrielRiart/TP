# Compiladores y flags
CC  = gcc
CXX = g++
CFLAGS = -Wall -g
CXXFLAGS = -Wall -g

# Directorios
SRC_DIR = SRC/Cap1
BIN_DIR = bin/Cap1

# Archivos fuente
CAP1_SRC_C   = $(SRC_DIR)/Listing1.1.c
CAP1_SRC_CPP = $(SRC_DIR)/Listing1.2.cpp
CAP1_HDR     = $(SRC_DIR)/Listing1.3.hpp

# Objetos en bin/Cap1
CAP1_OBJ = $(BIN_DIR)/Listing1.1.o $(BIN_DIR)/Listing1.2.o
CAP1_BIN = $(BIN_DIR)/programa_cap1

# Regla por defecto
all: cap1

# Ejecutable de Cap1
cap1: $(CAP1_BIN)

$(CAP1_BIN): $(CAP1_OBJ)
	@mkdir -p $(BIN_DIR)
	$(CXX) -o $@ $(CAP1_OBJ)

# Regla: compilar .c a .o
$(BIN_DIR)/Listing1.1.o: $(SRC_DIR)/Listing1.1.c $(CAP1_HDR)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Regla: compilar .cpp a .o
$(BIN_DIR)/Listing1.2.o: $(SRC_DIR)/Listing1.2.cpp $(CAP1_HDR)
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Limpiar
clean:
	rm -rf $(BIN_DIR)


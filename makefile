#compilador y flags

CC = gcc
CFLAGS = -Wall -g

#directorios

SRC_DIR = SRC
BIN_DIR = bin

#capitulos

CAPITULOS = Cap1 Cap2 Cap3 Cap4 Cap5

#archivos fuente y ejecutables por capitulo
#(ejemplo: Cap1/listing1.1.c -> bin/Cap1/listing1.1)
SRC_FILES = $(foreach cap,$(CAPITULOS),$wildcard $(SRC_DIR)/$(cap)/*.c))
BIN_FILES = $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%,$(SRC_FILES))

#objetivo principal: compilar todo
all: $(BIN_FILES)

#regla generica: compilar .c -> ejecutable en bin/
$(BIN_DIR)/%: $(SRC_DIR)/%.C
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ $<

#compilar por capitulo 
$(CAPITULOS):
	$(MAKE) $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%,$(wildcard $(SRC_DIR)/$@/*.c))

#limpiar todo
clean:
	rm -rf $(BIN_DIR)

#limpiar por capitulo
clean_%:
	rm -rf $(BIN_DIR)/$*

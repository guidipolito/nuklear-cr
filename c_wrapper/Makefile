CC ?= gcc

CFLAGS += -std=gnu99 -Wall -Wextra -fPIC
CFLAGS += -O0 -g

TARGET = libnuklear.so

SRC = main.c
OBJ = build/nuklear.o

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) -shared -o $@ $^

build/nuklear.o: $(SRC)
	mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf build $(TARGET)

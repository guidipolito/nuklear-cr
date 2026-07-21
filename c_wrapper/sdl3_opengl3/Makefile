CC ?= gcc

CFLAGS += -std=gnu99 -Wall -Wextra -O0 -g -fPIC

LDFLAGS += -shared
LDLIBS += -lSDL3 -lGL -ldl

TARGET = build/libnuklear.so

SRC = main.c glad.c
OBJ = build/main.o build/glad.o

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

build/main.o: main.c
	mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@

build/glad.o: glad.c
	mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf build $(TARGET)

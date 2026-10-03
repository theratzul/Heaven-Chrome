# Makefile for Heaven Chrome (Linux / Debian / Steam)

CC ?= gcc
CFLAGS ?= -O2 -Wall -Wextra -std=c99
LDFLAGS ?= -lm

# Auto-detect SDL2 or fallback to bundled headers & system shared lib
SDL_CFLAGS := $(shell sdl2-config --cflags 2>/dev/null)
SDL_LIBS := $(shell sdl2-config --libs 2>/dev/null)

ifeq ($(SDL_LIBS),)
    # Fallback to local include and system shared object
    SDL_CFLAGS := -Iinclude -D_REENTRANT
    ifneq ($(wildcard /usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0),)
        SDL_LIBS := /usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0
    else
        SDL_LIBS := -lSDL2
    endif
endif

CFLAGS += $(SDL_CFLAGS)
LDFLAGS += $(SDL_LIBS)

SRC = src/main.c src/game.c src/render.c src/audio.c
OBJ = $(SRC:.c=.o)
BIN_DIR = bin
TARGET = $(BIN_DIR)/heaven-chrome

.PHONY: all clean package install

all: $(TARGET)

$(TARGET): $(OBJ)
	@mkdir -p $(BIN_DIR)
	$(CC) $(OBJ) -o $@ $(LDFLAGS)
	@echo "Build complete: $(TARGET)"

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)
	rm -rf $(BIN_DIR) heaven-chrome-linux.tar.gz

package: all
	@mkdir -p steam_package
	cp $(TARGET) steam_package/
	cp run.sh steam_package/
	cp steam_appid.txt steam_package/
	cp heaven-chrome.desktop steam_package/
	cp heaven-chrome.png steam_package/
	tar -czvf heaven-chrome-linux.tar.gz -C steam_package .
	rm -rf steam_package
	@echo "Created Steam package: heaven-chrome-linux.tar.gz"

install: all
	install -d /usr/local/bin
	install -m 755 $(TARGET) /usr/local/bin/
	install -d /usr/local/share/applications
	install -m 644 heaven-chrome.desktop /usr/local/share/applications/
	install -d /usr/local/share/icons/hicolor/256x256/apps
	install -m 644 heaven-chrome.png /usr/local/share/icons/hicolor/256x256/apps/heaven-chrome.png
	install -d /usr/share/pixmaps
	install -m 644 heaven-chrome.png /usr/share/pixmaps/heaven-chrome.png

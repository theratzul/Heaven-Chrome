# Makefile for Heaven Chrome (Windows 11 / Steam Edition)

# Detect host environment
UNAME_S := $(shell uname -s 2>/dev/null || echo Windows)

ifeq ($(findstring Linux,$(UNAME_S)),Linux)
    CC = x86_64-w64-mingw32-gcc
    WINDRES = x86_64-w64-mingw32-windres
    IS_LINUX = 1
else
    CC ?= gcc
    WINDRES ?= windres
    IS_LINUX = 0
endif

CFLAGS ?= -O2 -Wall -Wextra -std=c99 -Iinclude
LDFLAGS ?= -Llib -lmingw32 -lSDL2main -lSDL2 -mwindows -lm

SRC = src/main.c src/game.c src/render.c src/audio.c
OBJ = $(SRC:.c=.o)
RES = resource.res.o

BIN_DIR = bin
TARGET = $(BIN_DIR)/heaven-chrome.exe

.PHONY: all clean run package

all: $(TARGET) $(BIN_DIR)/SDL2.dll $(BIN_DIR)/steam_appid.txt
	@echo "Build complete: $(TARGET)"

$(TARGET): $(OBJ) $(RES)
	@mkdir -p $(BIN_DIR)
	$(CC) $(OBJ) $(RES) -o $@ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(RES): resource.rc icon.ico
	$(WINDRES) -i resource.rc -o $@

$(BIN_DIR)/SDL2.dll:
	@mkdir -p $(BIN_DIR)
	@if [ -f bin/SDL2.dll ]; then :; elif [ -f lib/SDL2.dll ]; then cp lib/SDL2.dll $(BIN_DIR)/; fi

$(BIN_DIR)/steam_appid.txt:
	@mkdir -p $(BIN_DIR)
	@cp steam_appid.txt $(BIN_DIR)/

run: all
	@echo "=== Launching Heaven Chrome Windows Build ==="
ifeq ($(IS_LINUX),1)
	@echo "Host detected: Linux. Launching with Wine..."
	@wine $(TARGET)
else
	@echo "Host detected: Windows. Launching normally..."
	@./$(TARGET) || $(TARGET)
endif

package: all
	@mkdir -p steam_windows_package
	@cp $(TARGET) steam_windows_package/
	@cp $(BIN_DIR)/SDL2.dll steam_windows_package/
	@cp steam_appid.txt steam_windows_package/
	@cp icon.ico steam_windows_package/
	@cp heaven-chrome.png steam_windows_package/
	@cp setup.bat steam_windows_package/
	@cp run.bat steam_windows_package/
	@cp run.sh steam_windows_package/
	@echo "Heaven Chrome - Windows 11 & Steam Build" > steam_windows_package/README.txt
	@echo "To add to Steam: Games -> Add a Non-Steam Game -> Select heaven-chrome.exe" >> steam_windows_package/README.txt
	@rm -f heaven-chrome-windows.zip
	@cd steam_windows_package && zip -r ../heaven-chrome-windows.zip ./*
	@rm -rf steam_windows_package
	@echo "Created Steam Windows package: windows/heaven-chrome-windows.zip"

clean:
	rm -f $(OBJ) $(RES) $(TARGET)
	rm -rf steam_windows_package heaven-chrome-windows.zip

# Target microcontroller
MCU = atmega328p

# Paths
SRC_DIR = src
BUILD_DIR = build
FLASH_DIR = flash

# Tools
CC = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

# Flags
CFLAGS = -mmcu=$(MCU) -Wall
LDFLAGS = -mmcu=$(MCU) -nostartfiles 

# Port for avrdude (change if needed)
PORT = /dev/ttyACM0
BAUD = 115200

# File names
SRC = $(SRC_DIR)/main.s
OBJ = $(BUILD_DIR)/main.o
ELF = $(BUILD_DIR)/main.elf
HEX = $(FLASH_DIR)/main.hex

# Default target (build everything)
all: $(HEX)

# Assemble .s file into .o
$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Link .o to .elf
$(ELF): $(OBJ)
	$(CC) $(LDFLAGS) $^ -o $@

# Convert .elf to .hex
$(HEX): $(ELF)
	$(OBJCOPY) -O ihex -R .eeprom $< $@

# Flash the .hex to the Arduino
flash: $(HEX)
	$(AVRDUDE) -p $(MCU) -c arduino -P $(PORT) -b $(BAUD) -U flash:w:$(HEX)

# Clean up build files
clean:
	rm -f $(BUILD_DIR)/*.o $(BUILD_DIR)/*.elf $(FLASH_DIR)/*.hex

# Phony targets
.PHONY: all flash clean

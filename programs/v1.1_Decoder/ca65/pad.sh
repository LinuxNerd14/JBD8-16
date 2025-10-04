#!/bin/bash
# Script to pad a 16KB ROM file into a 32KB image

# Check if arguments are provided
if [ $# -ne 2 ]; then
	echo "Usage: $0 <input_rom_file> <output_rom_file>"
	exit 1
fi

INPUT_ROM="$1"
OUTPUT_ROM="$2"

# Check if the input file exists
if [ ! -f "$INPUT_ROM" ]; then
	echo "Error: File '$INPUT_ROM' not found!"
	exit 1
fi

# Create 0x4000 bytes (16 KB) of 0x00 for the lower half
dd if=/dev/zero bs=1 count=16768 2>/dev/null >lower.bin # Old number: 16384

# Concatenate with the input ROM
cat lower.bin "$INPUT_ROM" >tmp.bin

# Show intermediate size
echo "Intermediate file size (should be input size + 16384):"
ls -l tmp.bin

# Pad to exactly 32 KB (32768 bytes)
CURRENT_SIZE=$(stat -c%s "tmp.bin")
PADDING=$((32768 - CURRENT_SIZE))

if [ $PADDING -gt 0 ]; then
	dd if=/dev/zero bs=1 count=$PADDING 2>/dev/null >>tmp.bin
fi

# Rename final file
mv tmp.bin "$OUTPUT_ROM"

# Show final result
ls -l "$OUTPUT_ROM"
echo "✅ Created $OUTPUT_ROM successfully!"

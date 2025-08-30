# Parameters
input_file = "HelloWorld.bin"  # Replace with your binary file
output_file = "HelloWorldButItDoesntSuck.bin"  # Output file name
desired_size = 0x8000  # Target size in bytes (65535)
address_low = 0x7FFC  # Address for the low byte
address_high = 0x7FFD
low_byte = 0x82  # Replace with the desired low byte value (e.g., $C183 -> $83)
high_byte = 0xC1

# Read the input file
with open(input_file, "rb") as infile:
    original_data = infile.read()

# Calculate how many zeros are needed
padding_needed = desired_size - len((b"\x00" * 16770)+original_data)
if padding_needed < 0:
    raise ValueError("File size exceeds the target size of 65535 bytes!")

with open(output_file, "wb") as outfile:
    outfile.write(b"\x00" * 16770)
    outfile.write(original_data)
    outfile.write(b"\x00" * padding_needed)

with open(output_file, "r+b") as f:
    f.seek(address_low)
    f.write(bytes([low_byte]))
    f.seek(address_high)
    f.write(bytes([high_byte]))


print(f"Binified.")

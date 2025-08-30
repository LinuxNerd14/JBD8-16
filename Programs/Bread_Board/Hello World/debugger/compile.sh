ca65 debugger.s -o debugger.o
ld65 -C config.cfg debugger.o -o debugger.bin
python3 padder.py
minipro -p 28C256 -uP -w debuggerButItDoesntSuck.bin
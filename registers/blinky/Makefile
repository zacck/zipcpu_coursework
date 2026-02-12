compile:
	rm -rf _build && mkdir _build
	yosys -p 'synth_ice40 -json _build/blinky.json' blinky.v
	nextpnr-ice40 --up5k --package sg48 --pcf blinky.pcf --json _build/blinky.json --asc _build/blinky.asc
	icepack _build/blinky.asc _build/blinky.bin

flash:
	iceprog _build/blinky.bin


verilate:
	rm -rf obj_dir
	verilator -Wall --trace --cc blinky.v --exe blinky.cpp
	cd obj_dir/ && make -f Vblinky.mk

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

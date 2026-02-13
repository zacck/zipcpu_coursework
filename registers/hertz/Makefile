compile:
	rm -rf _build && mkdir _build
	yosys -p 'synth_ice40 -json _build/hertz.json' hertz.v
	nextpnr-ice40 --up5k --package sg48 --pcf hertz.pcf --json _build/hertz.json --asc _build/hertz.asc
	icepack _build/hertz.asc _build/hertz.bin

flash:
	iceprog _build/hertz.bin

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

compile:
	rm -rf _build && mkdir _build
	yosys -p 'synth_ice40 -json _build/thruwire.json' thruwire.v
	nextpnr-ice40 --up5k --package sg48 --pcf thruwire.pcf --json _build/thruwire.json --asc _build/thruwire.asc
	icepack _build/thruwire.asc _build/thruwire.bin

flash:
	iceprog _build/thruwire.bin

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

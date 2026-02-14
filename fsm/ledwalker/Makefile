compile:
	rm -rf _build && mkdir _build
	yosys -p 'synth_ice40 -json _build/ledwalker.json' ledwalker.v
	nextpnr-ice40 --up5k --package sg48 --pcf ledwalker.pcf --json _build/ledwalker.json --asc _build/ledwalker.asc
	icepack _build/ledwalker.asc _build/ledwalker.bin

flash:
	iceprog _build/ledwalker.bin

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

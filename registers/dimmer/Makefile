compile:
	rm -rf _build && mkdir _build
	yosys -p 'synth_ice40 -json _build/dimmer.json' dimmer.v
	nextpnr-ice40 --up5k --package sg48 --pcf dimmer.pcf --json _build/dimmer.json --asc _build/dimmer.asc
	icepack _build/dimmer.asc _build/dimmer.bin

flash:
	iceprog _build/dimmer.bin

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

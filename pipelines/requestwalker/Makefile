compile:
	rm -rf _build && mkdir _build
	yosys -p 'synth_ice40 -json _build/requestwalker.json' requestwalker.v
	nextpnr-ice40 --up5k --package sg48 --pcf requestwalker.pcf --json _build/requestwalker.json --asc _build/requestwalker.asc
	icepack _build/requestwalker.asc _build/requestwalker.bin

flash:
	iceprog _build/requestwalker.bin

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

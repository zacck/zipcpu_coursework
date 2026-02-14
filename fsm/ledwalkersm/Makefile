compile:
	rm -rf _build && mkdir _build
	yosys -p 'synth_ice40 -json _build/ledwalkersm.json' ledwalkersm.v
	nextpnr-ice40 --up5k --package sg48 --pcf ledwalkersm.pcf --json _build/ledwalkersm.json --asc _build/ledwalkersm.asc
	icepack _build/ledwalkersm.asc _build/ledwalkersm.bin

flash:
	iceprog _build/ledwalkersm.bin

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

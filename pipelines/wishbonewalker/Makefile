compile:
	rm -rf _build && mkdir _build
	yosys -p 'synth_ice40 -json _build/wishbonewalker.json' wishbonewalker.v
	nextpnr-ice40 --up5k --package sg48 --pcf wishbonewalker.pcf --json _build/wishbonewalker.json --asc _build/wishbonewalker.asc
	icepack _build/wishbonewalker.asc _build/wishbonewalker.bin

flash:
	iceprog _build/wishbonewalker.bin

timing:
	icetime -p wishbonewalker.pcf -P sg48 -d up5k -t _build/wishbonewalker.asc -c 12

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

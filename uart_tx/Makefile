compile:
	rm -rf _build && mkdir _build
	yosys  -p 'synth_ice40 -json _build/uarttx.json' hello.v
	nextpnr-ice40 --up5k --package sg48 --pcf uarttx.pcf --json _build/uarttx.json --asc _build/uarttx.asc
	icepack _build/uarttx.asc _build/uarttx.bin

flash:
	iceprog _build/uarttx.bin

timing:
	icetime -p uarttx.pcf -P sg48 -d up5k -t _build/uarttx.asc -c 12

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

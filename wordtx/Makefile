compile:
	rm -rf _build && mkdir _build
	yosys  -p 'synth_ice40 -json _build/topworder.json' top.v
	nextpnr-ice40 --up5k --package sg48 --pcf worder.pcf --json _build/topworder.json --asc _build/topworder.asc
	icepack _build/topworder.asc _build/topworder.bin

flash:
	iceprog _build/topworderbin

timing:
	icetime -p worder.pcf -P sg48 -d up5k -t _build/topworder.asc -c 12

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

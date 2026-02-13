compile:
	rm -rf _build && mkdir _build
	yosys -p 'synth_ice40 -json _build/tfail.json' tfail.v
	nextpnr-ice40 --up5k --package sg48 --pcf tfail.pcf --json _build/tfail.json --asc _build/tfail.asc
	icepack _build/tfail.asc _build/tfail.bin

flash:
	iceprog _build/tfail.bin

sim: 
	rm -rf build && mkdir build
	cd build && cmake .. && cmake --build .

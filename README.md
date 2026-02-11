## Beginners ZIPCPU course work 

- An attempt to do all the exercises and examples esp the formal verification & practical 


## Building Simulations using CMake 
- From the specific part directory e.g `wires` to the following 

``` bash 
rm -rf build && mkdir build && cd build

cmake ..

cmake --build .
```

This should give you a simulation executable as specified in the CMakeLists in that directory
and running that should show the simulation results. 

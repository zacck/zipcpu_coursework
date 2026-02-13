cmake_minimum_required(VERSION 3.20)
cmake_policy(SET CMP0074 NEW)
project(hertzsim)


find_package(verilator HINTS $ENV{VERILATOR_ROOT})

include_directories(obj_dir /usr/local/share/verilator/include)

add_library(Vtest_lib SHARED
	/usr/local/share/verilator/include/verilated.cpp
	/usr/local/share/verilator/include/verilated_vcd_c.cpp
)

verilate(Vtest_lib SOURCES ./hertz.v INCLUDE_DIRS "../" TRACE_VCD  VERILATOR_ARGS "-O3")

add_executable(${CMAKE_PROJECT_NAME}
	hertz.cpp
)

target_link_libraries(${CMAKE_PROJECT_NAME} Vtest_lib)

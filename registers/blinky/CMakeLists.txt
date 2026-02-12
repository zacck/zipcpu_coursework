cmake_minimum_required(VERSION 3.20)
cmake_policy(SET CMP0074 NEW)
project(blinkysim)


find_package(verilator HINTS $ENV{VERILATOR_ROOT})

include_directories(obj_dir /usr/local/share/verilator/include)

add_library(Vtest_lib SHARED
	/usr/local/share/verilator/include/verilated.cpp
)

verilate(Vtest_lib SOURCES ./blinky.v INCLUDE_DIRS "../" TRACE_FST VERILATOR_ARGS "-O3")

add_executable(${CMAKE_PROJECT_NAME}
	blinky.cpp
)

target_link_libraries(${CMAKE_PROJECT_NAME} Vtest_lib)

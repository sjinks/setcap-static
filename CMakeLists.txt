cmake_minimum_required(VERSION 3.0)

set(CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_STATIC_LIBRARY_SUFFIX}")
set(CMAKE_EXE_LINKER_FLAGS "-static")

project(setcap-static VERSION 1.0.0 LANGUAGES C)

find_path(NAMES sys/capability.h REQUIRED)
find_library(LIBCAP_LIBRARY NAMES "${CMAKE_STATIC_LIBRARY_PREFIX}cap${CMAKE_STATIC_LIBRARY_SUFFIX}" cap REQUIRED)
add_library(libcap STATIC IMPORTED)
set_target_properties(libcap PROPERTIES IMPORTED_LOCATION ${LIBCAP_LIBRARY})

add_executable(setcap-static setcap.c)
target_link_libraries(setcap-static libcap)

cmake_minimum_required(VERSION 3.0)

if(POLICY CMP0056)
    cmake_policy(SET CMP0056 NEW)
endif()
if(POLICY CMP0065)
    cmake_policy(SET CMP0065 NEW)
endif()
if(POLICY CMP0066)
    cmake_policy(SET CMP0066 NEW)
endif()

set(CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_STATIC_LIBRARY_SUFFIX}")
set(CMAKE_EXE_LINKER_FLAGS "-static")
set(CMAKE_ENABLE_EXPORTS Off)

include(CheckFunctionExists)

project(setcap-static VERSION 1.0.0 LANGUAGES C)

find_path(NAMES sys/capability.h REQUIRED)
find_library(LIBCAP_LIBRARY NAMES "${CMAKE_STATIC_LIBRARY_PREFIX}cap${CMAKE_STATIC_LIBRARY_SUFFIX}" cap)
if(NOT LIBCAP_LIBRARY)
    message(FATAL_ERROR "Unable to find libcap")
endif()
add_library(libcap STATIC IMPORTED)
set_target_properties(libcap PROPERTIES IMPORTED_LOCATION ${LIBCAP_LIBRARY})

set(CMAKE_REQUIRED_LIBRARIES "${LIBCAP_LIBRARY};${CMAKE_REQUIRED_LIBRARIES}")
check_function_exists(cap_set_nsowner HAVE_CAP_SET_NSOWNER)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h)

add_executable(setcap-static setcap.c)
target_link_libraries(setcap-static libcap)
target_include_directories(setcap-static PUBLIC ${PROJECT_BINARY_DIR})

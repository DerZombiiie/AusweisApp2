cmake_minimum_required(VERSION 3.14)

set(CMAKE_SYSTEM_NAME iOS)

if(NOT CMAKE_OSX_ARCHITECTURES)
	set(CMAKE_OSX_ARCHITECTURES arm64)
endif()

if(INTEGRATED_SDK)
	set(CMAKE_OSX_DEPLOYMENT_TARGET 11.0)
else()
	set(CMAKE_OSX_DEPLOYMENT_TARGET 13.0)
endif()

set(UNIX True)
set(APPLE True)
set(IOS True)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

option(BITCODE "Enable bitcode" ON)
if(BITCODE)
	set(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE "YES")
	set(CMAKE_XCODE_ATTRIBUTE_BITCODE_GENERATION_MODE "bitcode")
	set(CMAKE_XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC "YES")
endif()

set(CMAKE_FIND_ROOT_PATH ${CMAKE_PREFIX_PATH} CACHE STRING "iOS find search path root")
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# work-around: cmake will fail if this is missing!
macro(find_host_package)
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)
  set(IOS FALSE)
  find_package(${ARGN})
  set(IOS TRUE)
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
  set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)
endmacro()


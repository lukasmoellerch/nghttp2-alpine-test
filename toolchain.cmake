set(CMAKE_SYSTEM_NAME "Linux")
set(CMAKE_SYSTEM_PROCESSOR "x86_64")

set(CMAKE_CROSSCOMPILING 1)
set(ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}/")
cmake_path(SET ROOT_DIR NORMALIZE "${ROOT_DIR}")

set(AR x86_64-unknown-linux-musl-ar)
set(CMAKE_AR ${AR})
set(RANLIB x86_64-unknown-linux-musl-ranlib)
set(CMAKE_RANLIB ${RANLIB})

set(DOCKER_IMAGE aws-example-tc)

set(SYSROOT ${ROOT_DIR}sysroot)
set(OSX_SYSROOT ${SYSROOT})
set(CMAKE_SYSROOT ${SYSROOT})

set(CMAKE_CPP_COMPILER_TARGET "x86_64-alpine-linux-musl")

set(COMMON_FLAGS "-funwind-tables --sysroot=${SYSROOT} --prefix=/usr/local/bin/x86_64-unknown-linux-musl- --target=x86_64-alpine-linux-musl")
set(COMPILER_FLAGS "${COMMON_FLAGS}")

set(CMAKE_CXX_FLAGS "${COMPILER_FLAGS} -stdlib=libstdc++")
# Convince libcurl that the target platform has socket and fcntl_o_nonblock
set(CMAKE_C_FLAGS "${COMPILER_FLAGS} -DHAVE_SOCKET -DHAVE_FCNTL_O_NONBLOCK")

set(LINK_FLAGS "${COMMON_FLAGS} -L${ROOT_DIR}/sysroot/lib --gcc-toolchain=${ROOT_DIR}/sysroot/usr")

# these variables tell CMake to avoid using any binary it finds in 
# the sysroot, while picking headers and libraries exclusively from it 
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
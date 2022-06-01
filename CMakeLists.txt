cmake_minimum_required(VERSION 3.14)

project(
    cppless
    VERSION 0.1.0
    DESCRIPTION "Short description"
    HOMEPAGE_URL "https://spcl.inf.ethz.ch"
    LANGUAGES CXX
)

if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
  message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
  file(DOWNLOAD "https://raw.githubusercontent.com/lukasmoellerch/cmake-conan/lukasmoellerch-patch-2/conan.cmake"
                "${CMAKE_BINARY_DIR}/conan.cmake"
                TLS_VERIFY ON)
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)

conan_cmake_configure(REQUIRES libnghttp2/1.47.0
                               openssl/3.0.3
                      GENERATORS cmake_find_package
                      OPTIONS libnghttp2:with_asio=True
                              boost:without_locale=True
                              boost:without_iostreams=True
                              boost:without_log=True
                              boost:without_context=True
                              boost:without_coroutine=True
                              boost:without_fiber=True
                              boost:without_stacktrace=True)


# The find-package conan generator uses the variables which are not necessarily defined
set(_out_libraries "")
set(_out_libraries_target "")
set(0 1)
set(xcode_sysroot_option "")

# Use auto-detection for host settings (will use our custom cpp compiler)
conan_cmake_autodetect(CONAN_SETTINGS)

include(conan-utils.cmake)
# We need some setting for the build system to force cross compilation
conan_utils_host_system_name(CONAN_HOST_OS)

# Construct host compilation environment
set(ENV_HOST "")
if (DEFINED CMAKE_C_COMPILER) 
  list(APPEND ENV_HOST "CC=${CMAKE_C_COMPILER}")
endif()
if (DEFINED CMAKE_CXX_COMPILER) 
  list(APPEND ENV_HOST "CXX=${CMAKE_CXX_COMPILER}")
endif()
if (DEFINED AR) 
  list(APPEND ENV_HOST "AR=${AR}")
endif()
if (DEFINED RANLIB) 
  list(APPEND ENV_HOST "RANLIB=${RANLIB}")
endif()
if (DEFINED CMAKE_C_FLAGS)
  list(APPEND ENV_HOST "CFLAGS=${CMAKE_C_FLAGS}")
endif()
if (DEFINED CMAKE_CXX_FLAGS)
  list(APPEND ENV_HOST "CXXFLAGS=${CMAKE_CXX_FLAGS}")
endif()
if (DEFINED LINK_FLAGS)
  list(APPEND ENV_HOST "LDFLAGS=${LINK_FLAGS}")
endif()

conan_cmake_install(PATH_OR_REFERENCE .
                    BUILD missing
                    BUILD libnghttp2/1.47.0
                    BUILD openssl/3.0.3
                    ENV_HOST "${ENV_HOST}"
                    REMOTE conancenter
                    SETTINGS_BUILD os=${CONAN_HOST_OS}
                    SETTINGS_HOST ${CONAN_SETTINGS})


                    
list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR})

SET(CMAKE_CXX_STANDARD 20)

find_package(libnghttp2 REQUIRED)

add_executable(example main.cpp)
target_link_libraries(example libnghttp2::libnghttp2)
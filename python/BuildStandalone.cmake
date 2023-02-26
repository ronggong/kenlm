cmake_minimum_required(VERSION 3.4)

file(GLOB
  KENLM_PYTHON_STANDALONE_SRCS
  "util/*.cc"
  "lm/*.cc"
  "util/double-conversion/*.cc"
  "python/*.cc"
  )

list(FILTER KENLM_PYTHON_STANDALONE_SRCS EXCLUDE REGEX ".*main.cc")
list(FILTER KENLM_PYTHON_STANDALONE_SRCS EXCLUDE REGEX ".*test.cc")

add_library(
  kenlm_lib
  SHARED
  ${KENLM_PYTHON_STANDALONE_SRCS}
  )

target_include_directories(kenlm_lib PRIVATE ${PROJECT_SOURCE_DIR})
target_compile_definitions(kenlm_lib PRIVATE KENLM_MAX_ORDER=${KENLM_MAX_ORDER})

find_package(ZLIB)
find_package(BZip2)
find_package(LibLZMA)

if (ZLIB_FOUND)
  target_link_libraries(kenlm_lib PRIVATE ${ZLIB_LIBRARIES})
  target_include_directories(kenlm_lib PRIVATE ${ZLIB_INCLUDE_DIRS})
  target_compile_definitions(kenlm_lib PRIVATE HAVE_ZLIB)
endif()
if(BZIP2_FOUND)
  target_link_libraries(kenlm_lib PRIVATE ${BZIP2_LIBRARIES})
  target_include_directories(kenlm_lib PRIVATE ${BZIP2_INCLUDE_DIR})
  target_compile_definitions(kenlm_lib PRIVATE HAVE_BZLIB)
endif()
if(LIBLZMA_FOUND)
  target_link_libraries(kenlm_lib PRIVATE ${LIBLZMA_LIBRARIES})
  target_include_directories(kenlm_lib PRIVATE ${LIBLZMA_INCLUDE_DIRS})
  target_compile_definitions(kenlm_lib PRIVATE HAVE_LZMA)
endif()

# set output name of the kenlm --> kenlm
set_target_properties(
  kenlm_lib
  PROPERTIES
  OUTPUT_NAME "kenlm"
)

# find_package(PythonExtensions REQUIRED)
# find_package(Cython REQUIRED)

# provided by scikit-build
# add_cython_target(${PROJECT_SOURCE_DIR}/python/kenlm CXX)
# add_library(kenlm MODULE ${kenlm})
# python_extension_module(kenlm)

# Build the Python library
add_library(kenlm MODULE ${PROJECT_SOURCE_DIR}/python/kenlm.cpp)

# set output name of the kenlm --> kenlm
set_target_properties(
  kenlm
  PROPERTIES
  OUTPUT_NAME ""
)


target_link_libraries(kenlm kenlm_lib)
target_include_directories(kenlm PRIVATE ${PROJECT_SOURCE_DIR})
target_compile_definitions(kenlm PRIVATE KENLM_MAX_ORDER=${KENLM_MAX_ORDER})

find_package(PythonExtensions REQUIRED)
python_extension_module(kenlm)
# find_package(Cython REQUIRED)
# add_cython_target(${PROJECT_SOURCE_DIR}/python/kenlm.pyx)

install(TARGETS kenlm_lib kenlm DESTINATION ${PYTHON_RELATIVE_SITE_PACKAGES_DIR})
# install(FILES ${PROJECT_SOURCE_DIR}/python/__init__.py DESTINATION ${PYTHON_RELATIVE_SITE_PACKAGES_DIR}/kenlm)

# rpath setting to make sure the python binding library finds
# the primary lib
if(APPLE)
  # macOS
  set(CMAKE_MACOSX_RPATH ON)
  set(_portable_rpath_origin "@loader_path")
else()
  # Linux
  set(CMAKE_BUILD_RPATH_USE_ORIGIN ON)
  set(_portable_rpath_origin $ORIGIN)
endif(APPLE)

set_target_properties(kenlm PROPERTIES
  BUILD_RPATH ${_portable_rpath_origin}
  INSTALL_RPATH ${_portable_rpath_origin}
  INSTALL_RPATH_USE_LINK_PATH TRUE
  )

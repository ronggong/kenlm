cmake_minimum_required(VERSION 3.1)

  # TODO: glob in an identical way to setup.py, add library kenlm, and just spit it out
  # add the compression libs if found

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
  kenlm
  SHARED
  ${KENLM_PYTHON_STANDALONE_SRCS}
  )

find_package(ZLIB)
find_package(BZip2)
find_package(LibLZMA)

target_link_libraries(
  kenlm
  PRIVATE
  $<$<BOOL:ZLIB_FOUND>:ZLIB::ZLIB>
  $<$<BOOL:BZLIB_FOUND>:${BZIP2_LIBRARIES}>
  $<$<BOOL:LIBLZMA_FOUND>:${LIBLZMA_LIBRARIES}>
  )

target_include_directories(
  kenlm
  PRIVATE
  $<$<BOOL:BZLIB_FOUND>:${BZIP2_INCLUDE_DIR}>
  $<$<BOOL:LIBLZMA_FOUND>:${LIBLZMA_INCLUDE_DIRS}>
  ${PROJECT_SOURCE_DIR}
  )

target_compile_definitions(
  kenlm
  PRIVATE
  $<$<BOOL:ZLIB_FOUND>:HAVE_ZLIB>
  $<$<BOOL:BZLIB_FOUND>:HAVE_BZLIB>
  $<$<BOOL:LIBLZMA_FOUND>:HAVE_LZMA>
  KENLM_MAX_ORDER=${KENLM_MAX_ORDER}
  )

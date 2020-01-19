
cmake_minimum_required(VERSION 2.6.4)

PROJECT(ALI_PERF_TESTS)

# Get Trilinos as one entity
IF (DEFINED TRILINOS_DIR)
  SET(CMAKE_PREFIX_PATH ${TRILINOS_DIR} ${CMAKE_PREFIX_PATH})
ENDIF()
FIND_PACKAGE(Trilinos REQUIRED)

MESSAGE("\nFound Trilinos!  Here are the details: ")
MESSAGE("   Trilinos_DIR = ${Trilinos_DIR}")
MESSAGE("   Trilinos_VERSION = ${Trilinos_VERSION}")
MESSAGE("   Trilinos_BIN_DIRS = ${Trilinos_BIN_DIRS}")
MESSAGE("   Trilinos_TPL_LIST = ${Trilinos_TPL_LIST}")
MESSAGE("   Trilinos_TPL_LIBRARY_DIRS = ${Trilinos_TPL_LIBRARY_DIRS}")
MESSAGE("   Trilinos_BUILD_SHARED_LIBS = ${Trilinos_BUILD_SHARED_LIBS}")
MESSAGE("   Trilinos_CXX_COMPILER_FLAGS = ${Trilinos_CXX_COMPILER_FLAGS}")
MESSAGE("End of Trilinos details\n")

LIST(FIND Trilinos_PACKAGE_LIST Piro Piro_List_ID)
IF (Piro_List_ID GREATER -1)
  MESSAGE("-- Looking for Piro (required) in Trilinos ...                Found!")
ELSE()
  MESSAGE("-- Looking for Piro (required) in Trilinos ...                NOT Found!")
  MESSAGE(FATAL_ERROR "ALI performance tests REQUIRE Piro. Please, configure Trilinos with guidance from trilinos-cmake script in doc directory.")
ENDIF()

IF(EXISTS "${Trilinos_INCLUDE_DIRS}/KokkosCore_config.h")
  FILE(READ "${Trilinos_INCLUDE_DIRS}/KokkosCore_config.h" KOKKOS_CORE_CONFIG_FILE)
  STRING(REGEX MATCH "KOKKOS_ENABLE_OPENMP" ALBANY_ENABLE_OPENMP ${KOKKOS_CORE_CONFIG_FILE})
  IF(ALBANY_ENABLE_OPENMP)
    MESSAGE("-- Kokkos is configured to use OpenMP, Albany will also.")
  ENDIF()
  STRING(REGEX MATCH "KOKKOS_ENABLE_CUDA" ALBANY_ENABLE_CUDA ${KOKKOS_CORE_CONFIG_FILE})
  IF(ALBANY_ENABLE_CUDA)
    MESSAGE("-- Kokkos is configured to use CUDA, Albany will also.")
    STRING(REGEX MATCH "KOKKOS_COMPILER_CUDA_VERSION ([0-9]*)" _ ${KOKKOS_CORE_CONFIG_FILE})
    SET(ALBANY_CUDA_COMPILER_VERSION "${CMAKE_MATCH_1}")
    MESSAGE("-- ALBANY_CUDA_COMPILER_VERSION = ${ALBANY_CUDA_COMPILER_VERSION}")
  ENDIF()
ELSE()
  MESSAGE(FATAL_ERROR "\nError: ${Trilinos_INCLUDE_DIRS}/KokkosCore_config.h not found!")
ENDIF()

#FIXME: throw error if Albany doesn't have ALI enabled? 

IF (DEFINED TESTING_EXE_DIR)
  SET(CMAKE_PREFIX_PATH ${TESTING_EXE_DIR} ${CMAKE_PREFIX_PATH})
  MESSAGE("\n-- TESTING_EXE_DIR set: ${TESTING_EXE_DIR}.")
ELSE()
  MESSAGE(FATAL_ERROR "TESTING_EXE_DIR not set!")
ENDIF()

IF (DEFINED MESH_FILE_DIR)
  SET(CMAKE_PREFIX_PATH ${MESH_FILE_DIR} ${CMAKE_PREFIX_PATH})
  MESSAGE("\n-- MESH_FILE_DIR set: ${MESH_FILE_DIR}.")
ELSE()
  MESSAGE(FATAL_ERROR "MESH_FILE_DIR not set!")
ENDIF()

SET(ExePath ${TESTING_EXE_DIR}/src/Albany) 
IF(ALBANY_ENABLE_CUDA)
  SET(ALBANY_EXE ${Trilinos_MPI_EXEC} "--map-by" "ppr:2:socket" ${Trilinos_MPI_EXEC_NUMPROCS_FLAG} 8 ${ExePath})
  SET(ALBANY_EXTRA_ARGS "--kokkos-ndevices=4")
ELSE()
  SET(ALBANY_EXE ${Trilinos_MPI_EXEC} "--bind-to" "core" "--npernode" 48 ${Trilinos_MPI_EXEC_NUMPROCS_FLAG} 384 ${ExePath})
ENDIF()

enable_testing()

add_subdirectory(perf_tests)


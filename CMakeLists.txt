
cmake_minimum_required(VERSION 3.17.0)

PROJECT(ALI_PERF_TESTS CXX C)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)
MESSAGE(" +----------------------------------+")
MESSAGE(" |       Installation details       |")
MESSAGE(" +----------------------------------+")
MESSAGE(" | - Prefix: ${CMAKE_INSTALL_PREFIX}")
MESSAGE(" | - Binaries dir: ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}")
MESSAGE(" | - Headers dir: ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_INCLUDEDIR}")
MESSAGE(" | - Libraries dir: ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")
MESSAGE(" +----------------------------------+")

# Kokkos recommends to set CMAKE_CXX_EXTENSIONS to OFF
set(CMAKE_CXX_EXTENSIONS OFF)

# Get Trilinos as one entity
set (TRILINOS_DIR "" CACHE STRING "Location of the Trilinos installation folder")
if (TRILINOS_DIR)
  list(PREPEND CMAKE_PREFIX_PATH ${TRILINOS_DIR})
endif()
message ("-- Looking for trilinos installation ...")
message ("     TRILINOS_DIR: ${TRILINOS_DIR}") 
find_package(Trilinos 16.1 REQUIRED)
message("-- Looking for trilinos installation ... Found.\n")

# Trilinos_BIN_DIRS probably should be defined in the Trilinos config. Until it is, set it here.
# This is needed to find SEACAS tools used during testing (epu, etc).
SET(Trilinos_BIN_DIR "${Trilinos_INSTALL_DIR}/bin")

message("+-----------------------------------------")
message("|     Trilinos installation details")
message("+-----------------------------------------")
message("|  Trilinos_DIR: ${Trilinos_DIR}")
message("|  Trilinos_CMAKE_BUILD_TYPE: ${Trilinos_CMAKE_BUILD_TYPE}")
message("|  Trilinos_VERSION: ${Trilinos_VERSION}")
message("|  Trilinos_GIT_COMMIT_ID: ${Trilinos_GIT_COMMIT_ID}")
message("|  Trilinos_BIN_DIR: ${Trilinos_BIN_DIR}")
message("|  Trilinos_BUILD_SHARED_LIBS: ${Trilinos_BUILD_SHARED_LIBS}")
message("|  Kokkos executions spaces:")
message("|    Kokkos_ENABLE_SERIAL: ${Kokkos_ENABLE_SERIAL}")
message("|    Kokkos_ENABLE_OpenMP: ${Kokkos_ENABLE_OPENMP}")
message("|    Kokkos_ENABLE_CUDA: ${Kokkos_ENABLE_CUDA}")
message("|    Kokkos_ENABLE_HIP: ${Kokkos_ENABLE_HIP}")
MESSAGE("|  Trilinos_PACKAGE_LIST = ${Trilinos_PACKAGE_LIST}")
MESSAGE("|  Trilinos_BUILD_SHARED_LIBS = ${Trilinos_BUILD_SHARED_LIBS}")
MESSAGE("|  Trilinos_CXX_COMPILER_FLAGS = ${Trilinos_CXX_COMPILER_FLAGS}")
message("+-----------------------------------------\n")

OPTION (ALBANY_SUPPRESS_TRILINOS_WARNINGS "Whether or not Trilinos headers should be treated as 'system' headers (hence, without issuing warnings)" ON)


# Ensure SEACASIoss, Iopx are available
LIST(FIND Trilinos_PACKAGE_LIST SEACASIoss SEACASIoss_List_ID)
IF (SEACASIoss_List_ID GREATER -1)
  MESSAGE("-- Looking for SEACASIoss (required) in Trilinos ...        Found!")
ELSE()
  MESSAGE("-- Looking for SEACASIoss (required) in Trilinos ...    NOT Found")
  MESSAGE(FATAL_ERROR "ALI performance tests REQUIRE SEACASIoss. Please, configure Trilinos with guidance from trilinos-cmake script in doc directory.")
ENDIF()

# Find SEACAS decomp
find_program(
  ALBANY_SEACAS_DECOMP
  NAMES decomp
  PATHS ${Trilinos_BIN_DIRS} ENV PATH
)
MESSAGE("-- ALBANY_SEACAS_DECOMP  = ${ALBANY_SEACAS_DECOMP}")

# Define Albany executables, procs and args
SET(ALBANY_BASH "bash" "-lc") # Used for piping commands
IF(ALIPT_BUILD_BLAKE)
  # TempFix: Multiple nodes causes issues when there are multiple failing tests which don't fail in a clean way and not enough ports are open.
  # A delay between tests is needed to allow all ranks to unbind but this takes too long. Reverting to one node for now.
  #SET(ALBANY_NUM_PROCS 384)
  #SET(ALBANY_NUM_PROCS 192)
  SET(ALBANY_NUM_PROCS 96)
  SET(ALBANY_MPI_CONFIG "mpirun -n ${ALBANY_NUM_PROCS} --map-by core")
ELSEIF(ALIPT_BUILD_WEAVER)
  #SET(ALBANY_NUM_PROCS 8) # TempFix: cannot launch multiple nodes on weaver
  SET(ALBANY_NUM_PROCS 4)
  SET(ALBANY_MPI_CONFIG "mpirun -n ${ALBANY_NUM_PROCS} --map-by ppr:2:socket")
  SET(ALBANY_EXTRA_ARGS "--kokkos-map-device-id-by=mpi_rank")
ELSEIF(ALIPT_BUILD_ICME_CPU)
  SET(ALBANY_NUM_PROCS 48)
  SET(ALBANY_MPI_CONFIG "srun --ntasks=${ALBANY_NUM_PROCS} --ntasks-per-node=12 --ntasks-per-socket=6 --cpu-bind=cores --hint=nomultithread")
ELSE()
  MESSAGE(FATAL_ERROR "ALIPT_BUILD_X not set!")
ENDIF()

# Define Albany executable paths
#FIXME: throw error if Albany doesn't have ALI enabled? 
IF (DEFINED SFAD6_EXE_DIR)
  MESSAGE("-- SFAD6_EXE_DIR set: ${SFAD6_EXE_DIR}.")
  SET(ALBANY_SFAD6_EXE "${ALBANY_MPI_CONFIG} ${SFAD6_EXE_DIR}/src/Albany")
  SET(ALBANY_ANALYSIS_SFAD6_EXE "${ALBANY_MPI_CONFIG} ${SFAD6_EXE_DIR}/src/AlbanyAnalysis")
ELSE()
  MESSAGE(FATAL_ERROR "SFAD6_EXE_DIR not set!")
ENDIF()
IF (DEFINED SFAD12_EXE_DIR)
  MESSAGE("-- SFAD12_EXE_DIR set: ${SFAD12_EXE_DIR}.")
  SET(ALBANY_SFAD12_EXE "${ALBANY_MPI_CONFIG} ${SFAD12_EXE_DIR}/src/Albany")
  SET(ALBANY_ANALYSIS_SFAD12_EXE "${ALBANY_MPI_CONFIG} ${SFAD12_EXE_DIR}/src/AlbanyAnalysis")
ELSE()
  MESSAGE(FATAL_ERROR "SFAD12_EXE_DIR not set!")
ENDIF()
IF (DEFINED SFAD16_EXE_DIR)
  MESSAGE("-- SFAD16_EXE_DIR set: ${SFAD16_EXE_DIR}.")
  SET(ALBANY_SFAD16_EXE "${ALBANY_MPI_CONFIG} ${SFAD16_EXE_DIR}/src/Albany")
  SET(ALBANY_ANALYSIS_SFAD16_EXE "${ALBANY_MPI_CONFIG} ${SFAD16_EXE_DIR}/src/AlbanyAnalysis")
ENDIF()
IF (DEFINED SFAD24_EXE_DIR)
  MESSAGE("-- SFAD24_EXE_DIR set: ${SFAD24_EXE_DIR}.")
  SET(ALBANY_SFAD24_EXE "${ALBANY_MPI_CONFIG} ${SFAD24_EXE_DIR}/src/Albany")
  SET(ALBANY_ANALYSIS_SFAD24_EXE "${ALBANY_MPI_CONFIG} ${SFAD24_EXE_DIR}/src/AlbanyAnalysis")
ELSE()
  MESSAGE(FATAL_ERROR "SFAD24_EXE_DIR not set!")
ENDIF()
IF (DEFINED MALI_EXE_DIR)
  MESSAGE("-- MALI_EXE_DIR set: ${MALI_EXE_DIR}.")
  SET(MALI_EXE "${ALBANY_MPI_CONFIG} ${MALI_EXE_DIR}/landice_model")
ELSE()
  MESSAGE(FATAL_ERROR "MALI_EXE_DIR not set!")
ENDIF()
IF (DEFINED MESH_FILE_DIR)
  MESSAGE("-- MESH_FILE_DIR set: ${MESH_FILE_DIR}.\n")
ELSE()
  MESSAGE(FATAL_ERROR "MESH_FILE_DIR not set!")
ENDIF()

enable_testing()

add_subdirectory(perf_tests)


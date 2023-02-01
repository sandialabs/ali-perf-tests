
#cmake_minimum_required (VERSION 2.8)
set (CTEST_DO_SUBMIT ON)
set (CTEST_TEST_TYPE Nightly)

# What to build and test
set (CLEAN_BUILD TRUE)
set (DOWNLOAD_ALI_PERF_TESTS TRUE)
set (BUILD_ALI_PERF_TESTS TRUE)
set (RUN_ALI_PERF_TESTS TRUE)


# Begin User inputs:
set (CTEST_SITE "weaver.sandia.gov" ) # generally the output of hostname
set (CTEST_DASHBOARD_ROOT "$ENV{TEST_DIRECTORY}" ) # writable path
set (CTEST_SCRIPT_DIRECTORY "$ENV{SCRIPT_DIRECTORY}" ) # where the scripts live
set (CTEST_CMAKE_GENERATOR "Unix Makefiles" ) # What is your compilation apps ?
set (CTEST_CONFIGURATION  Release) # What type of build do you want ?

set (INITIAL_LD_LIBRARY_PATH $ENV{LD_LIBRARY_PATH})

set (CTEST_PROJECT_NAME "Albany" )
set (CTEST_SOURCE_NAME repos)
#set (CTEST_NAME "weaver-CUDA-Albany-Perf-Tests")
set (CTEST_BINARY_NAME build)
#set (CTEST_BUILD_NAME "weaver-CUDA-Albany-Perf-Tests")


set (CTEST_SOURCE_DIRECTORY "${CTEST_DASHBOARD_ROOT}/${CTEST_SOURCE_NAME}")
set (CTEST_BINARY_DIRECTORY "${CTEST_DASHBOARD_ROOT}/${CTEST_BINARY_NAME}")

if (NOT EXISTS "${CTEST_SOURCE_DIRECTORY}")
  file (MAKE_DIRECTORY "${CTEST_SOURCE_DIRECTORY}")
endif ()
if (NOT EXISTS "${CTEST_BINARY_DIRECTORY}")
  file (MAKE_DIRECTORY "${CTEST_BINARY_DIRECTORY}")
endif ()

configure_file (${CTEST_SCRIPT_DIRECTORY}/CTestConfig.cmake
  ${CTEST_SOURCE_DIRECTORY}/CTestConfig.cmake COPYONLY)

set (CTEST_NIGHTLY_START_TIME "01:00:00 UTC")
set (CTEST_CMAKE_COMMAND "cmake")
set (CTEST_COMMAND "ctest -D ${CTEST_TEST_TYPE}")
set (CTEST_BUILD_FLAGS "-j40")

set (CTEST_DROP_METHOD "https")

execute_process(COMMAND bash delete_txt_files.sh 
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
set (TRILINSTALLDIR "/home/projects/albany/nightlyCDashWeaver/build/TrilinosInstall") 
execute_process(COMMAND grep "Trilinos_C_COMPILER " ${TRILINSTALLDIR}/lib/cmake/Trilinos/TrilinosConfig.cmake
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE MPICC_RESULT
		OUTPUT_FILE "mpicc.txt")
execute_process(COMMAND bash get_mpicc.sh 
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE GET_MPICC_RESULT)
execute_process(COMMAND cat mpicc.txt 
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE GET_MPICC_RESULT
		OUTPUT_VARIABLE MPICC
		OUTPUT_STRIP_TRAILING_WHITESPACE)
#message("IKT mpicc = " ${MPICC}) 
execute_process(COMMAND ${MPICC} -dumpversion 
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE COMPILER_VERSION_RESULT
		OUTPUT_VARIABLE COMPILER_VERSION
		OUTPUT_STRIP_TRAILING_WHITESPACE)
#message("IKT compiler version = " ${COMPILER_VERSION})
execute_process(COMMAND ${MPICC} --version 
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE COMPILER_RESULT
		OUTPUT_FILE "compiler.txt")
execute_process(COMMAND bash process_compiler.sh 
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE CHANGE_COMPILER_RESULT
		OUTPUT_VARIABLE COMPILER
		OUTPUT_STRIP_TRAILING_WHITESPACE)
#message("IKT compiler = " ${COMPILER})
execute_process(COMMAND grep "Trilinos_CXX_COMPILER " ${TRILINSTALLDIR}/lib/cmake/Trilinos/TrilinosConfig.cmake
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE MPICXX_RESULT
		OUTPUT_FILE "mpicxx.txt")
execute_process(COMMAND bash get_mpicxx.sh 
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE GET_MPICXX_RESULT)
execute_process(COMMAND cat mpicxx.txt 
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE GET_MPICXX_RESULT
		OUTPUT_VARIABLE NVCC
		OUTPUT_STRIP_TRAILING_WHITESPACE)
#message("IKT nvcc = " ${NVCC}) 
execute_process(COMMAND ${NVCC} --version 
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE NVCC_RESULT
		OUTPUT_FILE "cuda.txt")
execute_process(COMMAND bash get_cuda_version.sh 
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		RESULT_VARIABLE CUDA_VERSION_RESULT
		OUTPUT_VARIABLE CUDA_VERSION
		OUTPUT_STRIP_TRAILING_WHITESPACE)
#message("IKT cuda version = " ${CUDA_VERSION})

find_program(UNAME NAMES uname)
macro(getuname name flag)
  exec_program("${UNAME}" ARGS "${flag}" OUTPUT_VARIABLE "${name}")
endmacro(getuname)

getuname(osname -s)
getuname(osrel  -r)
getuname(cpu    -m)

#message("IKT osname = " ${osname}) 
#message("IKT osrel = " ${osrel}) 
#message("IKT cpu = " ${cpu}) 

set (CTEST_BUILD_NAME "AlbanyPerfTests-${osname}-${osrel}-${COMPILER}-${COMPILER_VERSION}-${CTEST_CONFIGURATION}-${CUDA_VERSION}-sfad")
set (CTEST_NAME "AlbanyPerfTests-${osname}-${osrel}-${COMPILER}-${COMPILER_VERSION}-${CTEST_CONFIGURATION}-${CUDA_VERSION}-sfad")


if (CTEST_DROP_METHOD STREQUAL "https")
  set (CTEST_DROP_SITE "sems-cdash-son.sandia.gov")
  set (CTEST_PROJECT_NAME "Albany")
  set (CTEST_DROP_LOCATION "/cdash/submit.php?project=Albany")
  set (CTEST_TRIGGER_SITE "")
  set (CTEST_DROP_SITE_CDASH TRUE)
endif()

find_program (CTEST_GIT_COMMAND NAMES git)

set (ALIPerfTests_REPOSITORY_LOCATION git@github.com:sandialabs/ali-perf-tests.git)
set (GithubIO_REPOSITORY_LOCATION git@github.com:sandialabs/ali-perf-data.git)
set (MPI_PATH $ENV{MPI_ROOT})  
set (MKL_PATH $ENV{MKL_ROOT})  
set (BOOST_PATH $ENV{BOOST_ROOT}) 
set (NETCDF_PATH $ENV{NETCDF_ROOT}) 
set (PNETCDF_PATH $ENV{PNETCDF_ROOT}) 
set (HDF5_PATH $ENV{HDF5_ROOT})
set (ZLIB_PATH $ENV{ZLIB_ROOT})  

if (CLEAN_BUILD)
  # Initial cache info
  set (CACHE_CONTENTS "
  SITE:STRING=${CTEST_SITE}
  CMAKE_TYPE:STRING=Release
  CMAKE_GENERATOR:INTERNAL=${CTEST_CMAKE_GENERATOR}
  TESTING:BOOL=OFF
  PRODUCT_REPO:STRING=${ALIPerfTests_REPOSITORY_LOCATION}
  " )

  ctest_empty_binary_directory( "${CTEST_BINARY_DIRECTORY}" )
  file(WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "${CACHE_CONTENTS}")
endif ()


if (DOWNLOAD_ALI_PERF_TESTS)

  set (CTEST_CHECKOUT_COMMAND)
  set (CTEST_UPDATE_COMMAND "${CTEST_GIT_COMMAND}")
  
  #
  # Get ali-perf-tests
  #

  if (NOT EXISTS "${CTEST_SOURCE_DIRECTORY}/ali-perf-tests")
    execute_process (COMMAND "${CTEST_GIT_COMMAND}" 
      clone ${ALIPerfTests_REPOSITORY_LOCATION} -b master ${CTEST_SOURCE_DIRECTORY}/ali-perf-tests
      OUTPUT_VARIABLE _out
      ERROR_VARIABLE _err
      RESULT_VARIABLE HAD_ERROR)
    
    message(STATUS "out: ${_out}")
    message(STATUS "err: ${_err}")
    message(STATUS "res: ${HAD_ERROR}")
    if (HAD_ERROR)
      message(FATAL_ERROR "Cannot clone ali-perf-tests repository!")
    endif ()
  endif ()

  set (CTEST_UPDATE_COMMAND "${CTEST_GIT_COMMAND}")
  
  # Pull the repo
  execute_process (COMMAND "${CTEST_GIT_COMMAND}" pull
      WORKING_DIRECTORY ${CTEST_SOURCE_DIRECTORY}/ali-perf-tests
      OUTPUT_VARIABLE _out
      ERROR_VARIABLE _err
      RESULT_VARIABLE HAD_ERROR)
  message(STATUS "Output of ali-perf-tests pull: ${_out}")
  message(STATUS "Text sent to standard error stream: ${_err}")
  message(STATUS "command result status: ${HAD_ERROR}")
  if (HAD_ERROR)
    message(FATAL_ERROR "Cannot pull ali-perf-tests!")
  endif ()
  #
  # Get ali-perf-data repo
  #

  if (NOT EXISTS "${CTEST_SOURCE_DIRECTORY}/ali-perf-data")
    execute_process (COMMAND "${CTEST_GIT_COMMAND}"
      clone ${GithubIO_REPOSITORY_LOCATION} -b master ${CTEST_SOURCE_DIRECTORY}/ali-perf-data
      OUTPUT_VARIABLE _out
      ERROR_VARIABLE _err
      RESULT_VARIABLE HAD_ERROR)

    message(STATUS "out: ${_out}")
    message(STATUS "err: ${_err}")
    message(STATUS "res: ${HAD_ERROR}")
    if (HAD_ERROR)
      message(FATAL_ERROR "Cannot clone ali-perf-data repository!")
    endif ()
  endif ()

  set (CTEST_UPDATE_COMMAND "${CTEST_GIT_COMMAND}")

  # Pull the ali-perf-data repo

  execute_process (COMMAND "${CTEST_GIT_COMMAND}" pull
      WORKING_DIRECTORY ${CTEST_SOURCE_DIRECTORY}/ali-perf-data
      OUTPUT_VARIABLE _out
      ERROR_VARIABLE _err
      RESULT_VARIABLE HAD_ERROR)
  message(STATUS "Output of ali-perf-data pull: ${_out}")
  message(STATUS "Text sent to standard error stream: ${_err}")
  message(STATUS "command result status: ${HAD_ERROR}")
  if (HAD_ERROR)
    message(FATAL_ERROR "Cannot pull ali-perf-data!")
  endif ()


endif ()


ctest_start(${CTEST_TEST_TYPE})


if (BUILD_ALI_PERF_TESTS) 
  message ("ctest state: BUILD_ALI_PERF_TESTS")
  #
  # Configure the ali-perf-tests build
  #

  set (CONFIGURE_OPTIONS
    "-Wno-dev"
    "-DALIPT_BUILD_WEAVER:BOOL=ON"
    "-DTRILINOS_DIR:FILEPATH=${TRILINSTALLDIR}"
    "-DSFAD6_EXE_DIR:FILEPATH=/home/projects/albany/nightlyCDashWeaver/build/AlbBuildSFad6"
    "-DSFAD12_EXE_DIR:FILEPATH=/home/projects/albany/nightlyCDashWeaver/build/AlbBuildSFad12"
    "-DSFAD24_EXE_DIR:FILEPATH=/home/projects/albany/nightlyCDashWeaver/build/AlbBuildSFad24"
    "-DMESH_FILE_DIR:FILEPATH=/home/projects/albany/ali-perf-tests-meshes"
    "-DCMAKE_BUILD_TYPE:STRING=RELEASE"
    "-DBUILD_SHARED_LIBS:BOOL=ON"
    "-DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF"
  )

  if (NOT EXISTS "${CTEST_BINARY_DIRECTORY}/ALIPerfTestsBuild")
    file (MAKE_DIRECTORY ${CTEST_BINARY_DIRECTORY}/ALIPerfTestsBuild)
  endif ()

  CTEST_CONFIGURE(
    BUILD "${CTEST_BINARY_DIRECTORY}/ALIPerfTestsBuild"
    SOURCE "${CTEST_SOURCE_DIRECTORY}/ali-perf-tests"
    OPTIONS "${CONFIGURE_OPTIONS}"
    RETURN_VALUE HAD_ERROR
    )

  if (CTEST_DO_SUBMIT)
    ctest_submit (PARTS Configure
      RETURN_VALUE  S_HAD_ERROR
      )

    if (S_HAD_ERROR)
      message ("Cannot submit ALI-Perf-Tests configure results!")
    endif ()
  endif ()

  if (HAD_ERROR)
    message ("Cannot configure ALI-Perf-Tests build!")
  endif ()

  #
  # Build the rest of Trilinos and install everything
  #

  #set (CTEST_BUILD_TARGET all)
  #set (CTEST_BUILD_TARGET install)

  MESSAGE("\nBuilding target: '${CTEST_BUILD_TARGET}' ...\n")

  CTEST_BUILD(
    BUILD "${CTEST_BINARY_DIRECTORY}/ALIPerfTestsBuild"
    RETURN_VALUE  HAD_ERROR
    NUMBER_ERRORS  BUILD_LIBS_NUM_ERRORS
    APPEND
    )

  if (CTEST_DO_SUBMIT)
    ctest_submit (PARTS Build
      RETURN_VALUE  S_HAD_ERROR
      )

    if (S_HAD_ERROR)
      message ("Cannot submit ALI-Perf-Tests build results!")
    endif ()

  endif ()

  if (HAD_ERROR)
    message ("Cannot build ALI-Perf-Tests!")
  endif ()

  if (BUILD_LIBS_NUM_ERRORS GREATER 0)
    message ("Encountered build errors in ALI-Perf-Tests build. Exiting!")
  endif ()

endif()

if (RUN_ALI_PERF_TESTS) 
  #
  # Run tests  
  #
  set (CTEST_TEST_TIMEOUT 1200)

  CTEST_TEST(
    BUILD "${CTEST_BINARY_DIRECTORY}/ALIPerfTestsBuild"
    RETURN_VALUE  HAD_ERROR
    )

  if (CTEST_DO_SUBMIT)
    ctest_submit (PARTS Test
      RETURN_VALUE  S_HAD_ERROR
      )

    if (S_HAD_ERROR)
      message(FATAL_ERROR "Cannot submit ALI-Perf-Tests results!")
    endif ()
  endif ()

endif()


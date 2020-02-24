
# Begin User inputs:
set (CTEST_SITE "waterman.sandia.gov" ) # generally the output of hostname
set (CTEST_DASHBOARD_ROOT "$ENV{TEST_DIRECTORY}" ) # writable path
set (CTEST_SCRIPT_DIRECTORY "$ENV{SCRIPT_DIRECTORY}" ) # where the scripts live
set (CTEST_CMAKE_GENERATOR "Unix Makefiles" ) # What is your compilation apps ?
set (CTEST_CONFIGURATION  Release) # What type of build do you want ?

set (INITIAL_LD_LIBRARY_PATH $ENV{LD_LIBRARY_PATH})

set (CTEST_PROJECT_NAME "Albany" )
set (CTEST_SOURCE_NAME repos)
set (CTEST_NAME "linux-gcc-${CTEST_BUILD_CONFIGURATION}")
set (CTEST_BINARY_NAME build)
set (CTEST_BUILD_NAME "waterman.sandia.gov")


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

set (CTEST_NIGHTLY_START_TIME "00:00:00 UTC")
set (CTEST_CMAKE_COMMAND "cmake")
set (CTEST_COMMAND "ctest -D ${CTEST_TEST_TYPE}")
set (CTEST_FLAGS "-j8")
SET (CTEST_BUILD_FLAGS "-j8")

if (CTEST_DROP_METHOD STREQUAL "http")
  set (CTEST_DROP_SITE "cdash.sandia.gov")
  set (CTEST_PROJECT_NAME "Albany")
  set (CTEST_DROP_LOCATION "/CDash-2-3-0/submit.php?project=Albany")
  set (CTEST_TRIGGER_SITE "")
  set (CTEST_DROP_SITE_CDASH TRUE)
endif ()


find_program (CTEST_GIT_COMMAND NAMES git)

set (ALIPerfTests_REPOSITORY_LOCATION git@github.com:ikalash/ali-perf-tests.git)
set (GithubIO_REPOSITORY_LOCATION git@github.com:ikalash/ikalash.github.io.git)
set (MPI_PATH $ENV{MPI_ROOT})  
set (MKL_PATH $ENV{MKL_ROOT})  
set (BOOST_PATH $ENV{BOOST_ROOT}) 
set (NETCDF_PATH $ENV{NETCDF_ROOT}) 
set (PNETCDF_PATH $ENV{PNETCDF_ROOT}) 
set (HDF5_PATH $ENV{HDF5_ROOT})
set (ZLIB_PATH $ENV{ZLIB_ROOT})  
set (YAMLCPP_PATH $ENV{YAMLCPP_ROOT})

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
  # Get ikalash.github.io repo
  #

  if (NOT EXISTS "${CTEST_SOURCE_DIRECTORY}/ikalash.github.io")
    execute_process (COMMAND "${CTEST_GIT_COMMAND}"
      clone ${GithubIO_REPOSITORY_LOCATION} -b master ${CTEST_SOURCE_DIRECTORY}/ikalash.github.io
      OUTPUT_VARIABLE _out
      ERROR_VARIABLE _err
      RESULT_VARIABLE HAD_ERROR)

    message(STATUS "out: ${_out}")
    message(STATUS "err: ${_err}")
    message(STATUS "res: ${HAD_ERROR}")
    if (HAD_ERROR)
      message(FATAL_ERROR "Cannot clone ikalash.github.io repository!")
    endif ()
  endif ()

  set (CTEST_UPDATE_COMMAND "${CTEST_GIT_COMMAND}")

  # Pull the ikalash.github.io repo

  execute_process (COMMAND "${CTEST_GIT_COMMAND}" pull
      WORKING_DIRECTORY ${CTEST_SOURCE_DIRECTORY}/ikalash.github.io
      OUTPUT_VARIABLE _out
      ERROR_VARIABLE _err
      RESULT_VARIABLE HAD_ERROR)
  message(STATUS "Output of ikalash.github.io pull: ${_out}")
  message(STATUS "Text sent to standard error stream: ${_err}")
  message(STATUS "command result status: ${HAD_ERROR}")
  if (HAD_ERROR)
    message(FATAL_ERROR "Cannot pull ikalash.github.io!")
  endif ()


endif ()


ctest_start(${CTEST_TEST_TYPE})


if (BUILD_ALI_PERF_TESTS) 
  message ("ctest state: BUILD_ALI_PERF_TESTS")
  #
  # Configure the ali-perf-tests build
  #
  set_property (GLOBAL PROPERTY SubProject IKTWatermanALIPerformTests)
  set_property (GLOBAL PROPERTY Label IKTWatermanALIPerformTests)

  set (CONFIGURE_OPTIONS
    "-Wno-dev"
    "-DTRILINOS_DIR:FILEPATH=/home/projects/albany/waterman/build/TrilinosInstall"
    "-DTESTING_EXE_DIR:FILEPATH=/home/projects/albany/waterman/build/AlbBuildSFad/"
    "-DMESH_FILE_DIR:FILEPATH=/home/projects/albany/waterman/ali-perf-tests-meshes"
    "-DCMAKE_CXX_FLAGS:STRING='-std=gnu++11'"
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

  set_property (GLOBAL PROPERTY SubProject IKTWatermanALIPerformTests)
  set_property (GLOBAL PROPERTY Label IKTWatermanALIPerformTests)
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
  set (CTEST_TEST_TIMEOUT 700)

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


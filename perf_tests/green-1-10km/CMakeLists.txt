# Copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_PopulateMesh.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_PopulateMesh.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_MueLuKokkos.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_MueLuKokkos.yaml COPYONLY)

IF (NOT ALBANY_ENABLE_CUDA)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_MueLuKokkos.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_MueLuKokkos.yaml COPYONLY)

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_MueLu.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_MueLu.yaml COPYONLY)

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_MueLu.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_MueLu.yaml COPYONLY)

  IF(ALIPT_TUNE)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_MueLu_Tune.yaml
                   ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_MueLu_Tune.yaml COPYONLY)
    configure_file(${CMAKE_SOURCE_DIR}/ext/Autotuning/autotune.py
                   ${CMAKE_CURRENT_BINARY_DIR}/autotune.py COPYONLY)
    configure_file(${CMAKE_SOURCE_DIR}/jupyter_nb/scripts/ctest2json.py
                   ${CMAKE_CURRENT_BINARY_DIR}/ctest2json.py COPYONLY)
  ENDIF()
ENDIF()

# Create symlink for mesh directory
SET(MESH_PATH "${MESH_FILE_DIR}/green-1-10km")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${MESH_PATH} ${CMAKE_CURRENT_BINARY_DIR}/mesh)

# Decompose the mesh
execute_process(COMMAND ${ALBANY_SEACAS_DECOMP} --processors ${ALBANY_NUM_PROCS} --root ${CMAKE_CURRENT_BINARY_DIR}/ --subdir mesh-decomp
                ${MESH_PATH}/gis_2d.exo)

# Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Add tests to populate mesh with ascii inputs
add_test(${testName}_pop_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_albany_PopulateMesh.yaml ${ALBANY_EXTRA_ARGS}")

# Add tests for performance
add_test(${testName}_ent_muk_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD6_EXE} input_albany_Enthalpy_MueLuKokkos.yaml ${ALBANY_EXTRA_ARGS}")

IF (NOT ALBANY_ENABLE_CUDA)
  add_test(${testName}_vel_muk_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_albany_Velocity_MueLuKokkos.yaml ${ALBANY_EXTRA_ARGS}")
  add_test(${testName}_vel_mu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_albany_Velocity_MueLu.yaml ${ALBANY_EXTRA_ARGS}")

  add_test(${testName}_ent_mu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD6_EXE} input_albany_Enthalpy_MueLu.yaml ${ALBANY_EXTRA_ARGS}")

  IF(ALIPT_TUNE)
    add_test(${testName}_vel_mu_tune_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_albany_Velocity_MueLu_Tune.yaml ${ALBANY_EXTRA_ARGS}")
  ENDIF()
ENDIF()

# Add dependencies
set_tests_properties(${testName}_pop_np${ALBANY_NUM_PROCS}
                     PROPERTIES
                     FIXTURES_SETUP ${testName}_pop
                     LABELS "pop")
set_tests_properties(${testName}_ent_muk_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_pop)
IF (NOT ALBANY_ENABLE_CUDA)
  set_tests_properties(${testName}_vel_mu_np${ALBANY_NUM_PROCS}
                       ${testName}_vel_muk_np${ALBANY_NUM_PROCS}
                       ${testName}_ent_mu_np${ALBANY_NUM_PROCS}
                       PROPERTIES FIXTURES_REQUIRED ${testName}_pop)

  IF(ALIPT_TUNE)
    set_tests_properties(${testName}_vel_mu_tune_np${ALBANY_NUM_PROCS}
                         PROPERTIES
                         LABELS "tune")
  ENDIF()
ENDIF()


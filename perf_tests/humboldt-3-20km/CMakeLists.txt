# Copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_PopulateMesh_Wedge.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_PopulateMesh_Wedge.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_MueLuKokkos_Wedge.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_MueLuKokkos_Wedge.yaml COPYONLY)
IF(NOT ALBANY_ENABLE_CUDA)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_MueLu_Wedge.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_MueLu_Wedge.yaml COPYONLY)
  IF(ALIPT_TUNE)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_MueLu_Wedge_Tune.yaml
                   ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_MueLu_Wedge_Tune.yaml COPYONLY)
    configure_file(${CMAKE_SOURCE_DIR}/jupyter_nb/scripts/autotune.py
                   ${CMAKE_CURRENT_BINARY_DIR}/autotune.py COPYONLY)
    configure_file(${CMAKE_SOURCE_DIR}/jupyter_nb/scripts/ctest2json.py
                   ${CMAKE_CURRENT_BINARY_DIR}/ctest2json.py COPYONLY)
  ENDIF()
ENDIF()

# Create symlink for mesh directory
SET(MESH_PATH "${MESH_FILE_DIR}/humboldt-3-20km")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${MESH_PATH} ${CMAKE_CURRENT_BINARY_DIR}/mesh)

# Decompose the mesh
execute_process(COMMAND ${ALBANY_SEACAS_DECOMP} --processors ${ALBANY_NUM_PROCS} --root ${CMAKE_CURRENT_BINARY_DIR}/ --subdir mesh-decomp
                ${MESH_PATH}/humboldt_2d.exo)

# Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Add test to populate mesh with ascii inputs
add_test(${testName}_pop_wdg_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_PopulateMesh_Wedge.yaml ${ALBANY_EXTRA_ARGS})

# Add tests for performance
add_test(${testName}_vel_muk_wdg_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_Velocity_MueLuKokkos_Wedge.yaml ${ALBANY_EXTRA_ARGS})
IF(NOT ALBANY_ENABLE_CUDA)
  add_test(${testName}_vel_mu_wdg_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_Velocity_MueLu_Wedge.yaml ${ALBANY_EXTRA_ARGS})
  IF(ALIPT_TUNE)
    add_test(${testName}_vel_mu_wdg_tune_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_Velocity_MueLu_Wedge_Tune.yaml ${ALBANY_EXTRA_ARGS})
  ENDIF()
ENDIF()

# Add dependencies
set_tests_properties(${testName}_pop_wdg_np${ALBANY_NUM_PROCS}
                     PROPERTIES
                     FIXTURES_SETUP ${testName}_pop_wdg
                     LABELS "pop")
set_tests_properties(${testName}_vel_muk_wdg_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_pop_wdg)
IF(NOT ALBANY_ENABLE_CUDA)
  set_tests_properties(${testName}_vel_mu_wdg_np${ALBANY_NUM_PROCS}
                       PROPERTIES FIXTURES_REQUIRED ${testName}_pop_wdg)
  IF(ALIPT_TUNE)
    set_tests_properties(${testName}_vel_mu_wdg_tune_np${ALBANY_NUM_PROCS}
                         PROPERTIES
                         LABELS "tune")
  ENDIF()
ENDIF()


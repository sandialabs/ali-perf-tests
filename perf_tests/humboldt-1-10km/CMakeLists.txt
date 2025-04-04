# Copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_pop.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_pop.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_vel_fea.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_vel_fea.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_vel_gpu.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_vel_gpu.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_cop_fea.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_cop_fea.yaml COPYONLY)

IF (ALBANY_SFAD6_EXE)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_ent_fea.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_ent_fea.yaml COPYONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_ent_gpu.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_ent_gpu.yaml COPYONLY)
ENDIF()

IF (NOT ALIPT_ENABLE_GPU)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_vel_cpu.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_vel_cpu.yaml COPYONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_cop_if2_slu.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_cop_if2_slu.yaml COPYONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_cop_fro_slu.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_cop_fro_slu.yaml COPYONLY)

  IF (ALBANY_SFAD6_EXE)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_ent_cpu.yaml
                   ${CMAKE_CURRENT_BINARY_DIR}/input_ent_cpu.yaml COPYONLY)
  ENDIF()

ELSE()
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_cop_if2_tch.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_cop_if2_tch.yaml COPYONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_cop_fro_tch.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_cop_fro_tch.yaml COPYONLY)
ENDIF()

# Create symlink for mesh directory
SET(MESH_PATH "${MESH_FILE_DIR}/humboldt-1-10km")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${MESH_PATH} ${CMAKE_CURRENT_BINARY_DIR}/mesh)

# Decompose the mesh
execute_process(COMMAND ${ALBANY_SEACAS_DECOMP} --processors ${ALBANY_NUM_PROCS} --root ${CMAKE_CURRENT_BINARY_DIR}/ --subdir mesh-decomp
                ${MESH_PATH}/humboldt_2d.exo)

# Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Add test to populate mesh with ascii inputs
add_test(${testName}_pop_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD24_EXE} input_pop.yaml ${ALBANY_EXTRA_ARGS}")

# Add tests for performance
add_test(${testName}_vel_fea_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_vel_fea.yaml ${ALBANY_EXTRA_ARGS}")
add_test(${testName}_vel_gpu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_vel_gpu.yaml ${ALBANY_EXTRA_ARGS}")
add_test(${testName}_cop_fea_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD24_EXE} input_cop_fea.yaml ${ALBANY_EXTRA_ARGS}")
IF (ALBANY_SFAD6_EXE)
  add_test(${testName}_ent_fea_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD6_EXE} input_ent_fea.yaml ${ALBANY_EXTRA_ARGS}")
  add_test(${testName}_ent_gpu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD6_EXE} input_ent_gpu.yaml ${ALBANY_EXTRA_ARGS}")
ENDIF()
IF (NOT ALIPT_ENABLE_GPU)
  add_test(${testName}_vel_cpu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_vel_cpu.yaml ${ALBANY_EXTRA_ARGS}")
  add_test(${testName}_cop_if2_slu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD24_EXE} input_cop_if2_slu.yaml ${ALBANY_EXTRA_ARGS}")
  add_test(${testName}_cop_fro_slu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD24_EXE} input_cop_fro_slu.yaml ${ALBANY_EXTRA_ARGS}")
  IF (ALBANY_SFAD6_EXE)
    add_test(${testName}_ent_cpu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD6_EXE} input_ent_cpu.yaml ${ALBANY_EXTRA_ARGS}")
  ENDIF()
ELSE()
  add_test(${testName}_cop_if2_tch_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD24_EXE} input_cop_if2_tch.yaml ${ALBANY_EXTRA_ARGS}")
  add_test(${testName}_cop_fro_tch_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD24_EXE} input_cop_fro_tch.yaml ${ALBANY_EXTRA_ARGS}")
ENDIF()

# Add dependencies
set_tests_properties(${testName}_pop_np${ALBANY_NUM_PROCS}
                     PROPERTIES
                     FIXTURES_SETUP ${testName}_pop
                     LABELS "pop")
set_tests_properties(${testName}_vel_fea_np${ALBANY_NUM_PROCS}
                     ${testName}_vel_gpu_np${ALBANY_NUM_PROCS}
                     ${testName}_cop_fea_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_pop)
IF (ALBANY_SFAD6_EXE)
  set_tests_properties(${testName}_ent_fea_np${ALBANY_NUM_PROCS}
                       ${testName}_ent_gpu_np${ALBANY_NUM_PROCS}
                       PROPERTIES FIXTURES_REQUIRED ${testName}_pop)
ENDIF()
IF (NOT ALIPT_ENABLE_GPU)
  set_tests_properties(${testName}_vel_cpu_np${ALBANY_NUM_PROCS}
                       ${testName}_cop_if2_slu_np${ALBANY_NUM_PROCS}
                       ${testName}_cop_fro_slu_np${ALBANY_NUM_PROCS}
                       PROPERTIES FIXTURES_REQUIRED ${testName}_pop)
  IF (ALBANY_SFAD6_EXE)
    set_tests_properties(${testName}_ent_cpu_np${ALBANY_NUM_PROCS}
                         PROPERTIES FIXTURES_REQUIRED ${testName}_pop)
  ENDIF()
ELSE()
  set_tests_properties(${testName}_cop_if2_tch_np${ALBANY_NUM_PROCS}
                       ${testName}_cop_fro_tch_np${ALBANY_NUM_PROCS}
                       PROPERTIES FIXTURES_REQUIRED ${testName}_pop)
ENDIF()


#copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_FiniteElementAssembly_SingleWorkset_Tetrahedron.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_FiniteElementAssembly_SingleWorkset_Tetrahedron.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_FiniteElementAssembly_Memoization_Tetrahedron.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_FiniteElementAssembly_Memoization_Tetrahedron.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_FiniteElementAssembly_SingleWorkset_Wedge.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_FiniteElementAssembly_SingleWorkset_Wedge.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_FiniteElementAssembly_Memoization_Wedge.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_FiniteElementAssembly_Memoization_Wedge.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_MueLu_Wedge.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_MueLu_Wedge.yaml COPYONLY)
#configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_MueLuKokkos_Wedge.yaml
#               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_MueLuKokkos_Wedge.yaml COPYONLY)

#Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
  ${MESH_FILE_DIR}/green-1-10km-pop/enthalpy-tet ${CMAKE_CURRENT_BINARY_DIR}/mesh-ent-tet)
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
  ${MESH_FILE_DIR}/green-1-10km-pop/enthalpy-wedge ${CMAKE_CURRENT_BINARY_DIR}/mesh-ent-wdg)

#create test
add_test(${testName}_ent_fea_mem_tet_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD4_EXE} input_albany_Enthalpy_FiniteElementAssembly_Memoization_Tetrahedron.yaml ${ALBANY_EXTRA_ARGS})
#add_test(${testName}_ent_muk_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD6_EXE} input_albany_Enthalpy_MueLuKokkos_Wedge.yaml ${ALBANY_EXTRA_ARGS})
IF (NOT ALBANY_ENABLE_CUDA)  
  add_test(${testName}_ent_fea_1ws_tet_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD4_EXE} input_albany_Enthalpy_FiniteElementAssembly_SingleWorkset_Tetrahedron.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_ent_fea_1ws_wdg_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD6_EXE} input_albany_Enthalpy_FiniteElementAssembly_SingleWorkset_Wedge.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_ent_fea_mem_wdg_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD6_EXE} input_albany_Enthalpy_FiniteElementAssembly_Memoization_Wedge.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_ent_mu_wdg_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD6_EXE} input_albany_Enthalpy_MueLu_Wedge.yaml ${ALBANY_EXTRA_ARGS})
ENDIF()

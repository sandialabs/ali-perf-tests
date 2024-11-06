IF (ALIPT_BUILD_BLAKE)
  add_subdirectory(ant-16km)
  #add_subdirectory(ant-8km) # Too much memory (1 node)
  #add_subdirectory(ant-4km) # Too much memory (2 nodes)
ENDIF()


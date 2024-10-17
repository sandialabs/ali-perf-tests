IF (ALIPT_BUILD_BLAKE)
  add_subdirectory(ant-16km)
  add_subdirectory(ant-8km)
  add_subdirectory(ant-4km)
ELSEIF (ALIPT_BUILD_WEAVER)
  add_subdirectory(ant-16km)
  add_subdirectory(ant-8km)
ENDIF()


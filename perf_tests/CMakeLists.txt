IF (NOT ALBANY_ENABLE_CUDA)
  add_subdirectory(ant-2-20km)
ENDIF()
add_subdirectory(green-1-10km)
add_subdirectory(green-1-7km)
add_subdirectory(green-3-20km)


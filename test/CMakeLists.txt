cmake_minimum_required(VERSION 3.21)

project(
  lib_test_app
  VERSION 1.0.0
  LANGUAGES CXX
)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

################################################################################
# build
################################################################################
find_package(vdp-utils REQUIRED)

add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE vdp-utils::vdp-utils)

################################################################################
# install
################################################################################
include(GNUInstallDirs)

install(
  TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

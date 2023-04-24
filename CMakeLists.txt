cmake_minimum_required(VERSION 3.14)
include(FetchContent)
include(CMakePrintHelpers)

set(APP DOOM)
set(EXE doom)

project (${APP} VERSION 0.1)

list(APPEND SOURCE_DIRS  ${PROJECT_SOURCE_DIR}/linuxdoom-1.10)
list(APPEND INCLUDE_DIRS ${PROJECT_SOURCE_DIR}/linuxdoom-1.10/include)
file(GLOB source_files "${SOURCE_DIRS}/*.cpp")

add_executable(${EXE} ${source_files})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror -DNORMALUNIX -DLINUX -Wno-unused-function -Wno-unused-variable -Wno-write-strings -Wno-narrowing -Wno-literal-suffix -fsanitize=address -fpermissive")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -DNORMALUNIX -DLINUX -Wno-unused-function -Wno-unused-variable -Wno-write-strings -Wno-narrowing -Wno-literal-suffix -fpermissive -Wno-int-to-pointer-cast")

# Custom boost dir
# set(BOOST_ROOT "${PROJECT_SOURCE_DIR}/libs/boost")
# set(Boost_NO_SYSTEM_PATHS on CACHE BOOL "Do not search system for Boost" )

# set(Boost_NO_BOOST_CMAKE         ON)
# set(Boost_USE_STATIC_LIBS        ON)  # only find static libs
# set(Boost_USE_DEBUG_LIBS        OFF)  # ignore debug libs and
# set(Boost_USE_RELEASE_LIBS       ON)  # only find release libs
# set(Boost_USE_MULTITHREADED      ON)
# set(Boost_USE_STATIC_RUNTIME    OFF)
# find_package(Boost 1.75.0 REQUIRED COMPONENTS date_time regex system thread)
# list(APPEND INCLUDE_DIRS ${Boost_INCLUDE_DIRS})

# FetchContent_Declare(fmt
#   GIT_REPOSITORY https://github.com/fmtlib/fmt.git
#   GIT_TAG master
# )
# FetchContent_MakeAvailable(fmt)

find_package(SDL2 REQUIRED)
list(APPEND EXTRA_LIBS SDL2::SDL2)

target_include_directories(${EXE} PRIVATE
    ${INCLUDE_DIRS}
)
target_link_libraries(${EXE}
  PRIVATE
  ${EXTRA_LIBS}
  -lnsl
  -lm
)

option(${APP}_TEST "Set whether to run TESTS or not" OFF)
if (${APP}_TEST)
    set(test_dir  ${CMAKE_CURRENT_SOURCE_DIR}/tests)
    file(GLOB test_files "${test_dir}/*.cpp")

    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.13.0
    )

    # For Windows: Prevent overriding the parent project's compiler/linker settings
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)

    enable_testing()
    add_executable(
        ${EXE}_test
        ${test_files}
    )

    # Needed if main project is a library
    # target_link_libraries(${EXE}_test PRIVATE
    #     ${EXE}
    #     GTest::gtest_main
    # )

    include(GoogleTest)
    gtest_discover_tests(${EXE}_test)
endif()

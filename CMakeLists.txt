cmake_minimum_required(VERSION 3.14)
include(FetchContent)
include(CMakePrintHelpers)

set(APP DOOM)
set(EXE doom)

project (${APP} VERSION 0.1)

list(APPEND SOURCE_DIRS  ${PROJECT_SOURCE_DIR}/src)
list(APPEND INCLUDE_DIRS ${PROJECT_SOURCE_DIR}/include)
file(GLOB source_files "${SOURCE_DIRS}/*.c")

add_executable(${EXE} ${source_files})

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED True)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-int-to-pointer-cast -Wno-write-strings -Wno-narrowing -Wno-unused-function -Wno-unused-variable -Wno-literal-suffix -fpermissive -ggdb -O0 -DNORMALUNIX -DLINUX")
# set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -Wall -Werror -DNORMALUNIX -DLINUX -Wno-unused-function -Wno-unused-variable -Wno-write-strings -Wno-narrowing -Wno-literal-suffix -fsanitize=address -fpermissive")


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

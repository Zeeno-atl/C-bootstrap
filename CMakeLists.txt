cmake_minimum_required(VERSION 3.26)
set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${CMAKE_CURRENT_LIST_DIR}/build/${CMAKE_BUILD_TYPE})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR}/build/${CMAKE_BUILD_TYPE})

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/out)

project(hello-world LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API 2182bf5c-ef0d-489a-91da-49dbc3090d2a)
set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_options(-Wall -Wextra -pedantic)
    
    set(CMAKE_LINK_WHAT_YOU_USE ON)
endif()


set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)


file(GLOB_RECURSE sources "${CMAKE_SOURCE_DIR}/src/*.cpp" "${CMAKE_SOURCE_DIR}/modules/*.cpp") 
file(GLOB_RECURSE modules "${CMAKE_SOURCE_DIR}/modules/*.cppm") 

add_executable(${PROJECT_NAME})
target_include_directories(${PROJECT_NAME} PRIVATE "include")
target_sources(${PROJECT_NAME}
    PRIVATE ${sources}
)
target_sources(${PROJECT_NAME}
    PUBLIC FILE_SET all_my_modules TYPE CXX_MODULES FILES
    ${modules}
)

# enable modules on GCC only
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(${PROJECT_NAME} PRIVATE -fmodules-ts)
    target_link_options(${PROJECT_NAME} PRIVATE -fmodules-ts)
endif()

# static link for the release build
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    target_link_options(${PROJECT_NAME} PRIVATE --static)
else()
    target_compile_options(${PROJECT_NAME} PRIVATE
        -fsanitize=address,undefined,leak
        -fstack-protector-all
        -fstack-clash-protection
    )
    target_link_options(${PROJECT_NAME} PRIVATE
        -fsanitize=address,undefined,leak
        -fstack-protector-all
        -fstack-clash-protection
    )
endif()


# Find clang-tidy
function(find_clang_tidy out_var)
    foreach(version RANGE 30 10 -1)
        find_program(CLANG_TIDY_EXECUTABLE clang-tidy-${version})
        if(CLANG_TIDY_EXECUTABLE)
            message(STATUS "Found clang-tidy-${version}: ${CLANG_TIDY_EXECUTABLE}")
            set(${out_var} ${CLANG_TIDY_EXECUTABLE} PARENT_SCOPE)
            return()
        endif()
    endforeach()

    find_program(CLANG_TIDY_EXECUTABLE clang-tidy)
    if(CLANG_TIDY_EXECUTABLE)
        message(STATUS "Found clang-tidy: ${CLANG_TIDY_EXECUTABLE}")
        set(${out_var} ${CLANG_TIDY_EXECUTABLE} PARENT_SCOPE)
    else()
        message(WARNING "clang-tidy not found, static analysis will not be enabled.")
    endif()
endfunction()

# Call the function to find clang-tidy
find_clang_tidy(CLANG_TIDY)

# Enable clang-tidy if found
if(CLANG_TIDY)
    message(STATUS "Enabling clang-tidy integration")

    # Add clang-tidy as a target to run on all source files
    set_target_properties(${PROJECT_NAME} PROPERTIES
        CXX_CLANG_TIDY "${CLANG_TIDY}"
    )
else()
    message(WARNING "clang-tidy not found, static analysis will not be enabled.")
endif()


find_package(magic_enum CONFIG REQUIRED)

target_link_libraries(${PROJECT_NAME}
PRIVATE
    magic_enum::magic_enum
)

# Add cppcheck
find_program(CPPCHECK_EXECUTABLE cppcheck)
if(CPPCHECK_EXECUTABLE)
    message(STATUS "Found cppcheck: ${CPPCHECK_EXECUTABLE}")
    # Specify the cppcheck arguments here
    set(CPPCHECK_ARGUMENTS "--enable=all" "--inconclusive" "--force" "--suppress=missingIncludeSystem")

    foreach(dir ${CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES})
        list(APPEND CPPCHECK_ARGUMENTS "-isystem${dir}")
        message(STATUS "Adding include directory to cppcheck: ${dir}")
    endforeach()

    set_target_properties(${PROJECT_NAME} PROPERTIES
        CXX_CPPCHECK "${CPPCHECK_EXECUTABLE};${CPPCHECK_ARGUMENTS}"
    )
else()
    message(WARNING "cppcheck not found, static analysis will not be enabled.")
endif()

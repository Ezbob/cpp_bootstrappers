CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

# Name and description are injected from makefile
PROJECT(${PROJECT_NAME}
    VERSION 0.1
    DESCRIPTION "${PROJECT_DESCRIPTION}"
    LANGUAGES CXX
)

# CMAKE module path adding "cmake" directory to the path
SET(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")

# SOURCES_PREFIX refers to the source folder and is useful when stating
# the source files depedencies of a target
SET(SOURCES_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/src")

# Compilation flags that depends on build type
# A symbol _DEBUG is exposed to enable conditional compilation through preprocessor directives
SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -std=c++11 -D_DEBUG -g")
SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -std=c++11 -O3")

# Linker flags. This just makes the c and c++ stdlibs statically linked for higher portability
SET(CMAKE_EXE_LINKER_FLAGS " -Wall -Wextra -static-libgcc -static-libstdc++")

SET(EXEC_NAME "${PROJECT_NAME}")

# Next steps:
SET(SOURCES
    "${SOURCES_PREFIX}/main.cpp"
)

# Adds an executable
ADD_EXECUTABLE(${EXEC_NAME} "")

# Target_Sources works best when sources has been set to "" in lib/exe (this then becomes a legacy parameter)
# Target_Sources helps with transitive scoping (i.e. PRIVATE, PUBLIC or INTERFACE)
# all TARGET_* needs to defined after the target (since it has to be there first)

TARGET_SOURCES(${EXEC_NAME} PRIVATE ${SOURCES})

# # Adds a (STATIC) library
# # STATIC adds archive files ".a" that can included in a compile process
# # SHARED adds .dll, .so or .dynlib
# ADD_LIBRARY(${PROJECT_NAME} STATIC "")

# TARGET_INCLUDE_DIRECTORIES(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")

# TARGET_LINK_LIBRARIES(${PROJECT_NAME} PRIVATE somecoollib)

# # There are also non-"Target_" version of most of the above these does not "bind" to
# # a specific target (not the best of idea for encapsulation)

# # Adds and merges some subdir's CMakeLists.txt. This makes the Commands available in that
# # subdirectory's CMakeLists.txt available to this. This can cause some command name-clashes so beware
# ADD_SUBDIRECTORY(another_dir)

# # Custom targets. Here is a post build that strips a binary when in release
# if(${CMAKE_BUILD_TYPE}, Release)
# add_custom_command(TARGET ${PROJECT_NAME}
#     POST_BUILD
#     COMMAND strip ${PROJECT_NAME}
# )
# endif()

# Do something depending on windows is the platform
# if(${WIN32})
#
# else()
#
# endif()

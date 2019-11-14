# More rescent CMake include the CMAKE_CXX_STANDARD
# but this file is just for backward compatibility with the 3.0.2 cmake
# implementation

function(USE_CXX11_STANDARD)
    # Do we support c++11 ?
    INCLUDE(CheckCXXCompilerFlag)

    CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
    CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
        #c++0x is the code for when the c++11 standard was new

    IF(COMPILER_SUPPORTS_CXX11)
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    ELSEIF(COMPILER_SUPPORTS_CXX0X)
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
    ELSE()
        MESSAGE(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support")
    ENDIF()
endfunction(USE_CXX11_STANDARD)

function(USE_CXX14_STANDARD)
    # Do we support c++14 ?
    INCLUDE(CheckCXXCompilerFlag)

    CHECK_CXX_COMPILER_FLAG("-std=c++14" COMPILER_SUPPORTS_CXX14)

    IF(COMPILER_SUPPORTS_CXX14)
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
    ELSE()
        MESSAGE(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++14 support")
    ENDIF()
endfunction(USE_CXX14_STANDARD)

function(USE_CXX17_STANDARD)
    # Do we support c++17 ?
    INCLUDE(CheckCXXCompilerFlag)

    CHECK_CXX_COMPILER_FLAG("-std=c++17" COMPILER_SUPPORTS_CXX17)

    IF(COMPILER_SUPPORTS_CXX17)
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
    ELSE()
        MESSAGE(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++17 support")
    ENDIF()
endfunction(USE_CXX17_STANDARD)

# SPDX-FileCopyrightText: Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FIND_PACKAGE(Threads)

option(RX_USE_EXCEPTIONS "Use C++ exceptions" ON)
option(RXCPP_USE_FIBERS "Make the default scheduler fiber aware" OFF)
option(RX_BUILD_TESTING "Whether or not to build tests" ON)
option(RX_BUILD_EXAMPLES "Whether or not to build examples" ON)

# define some compiler settings

MESSAGE( STATUS "CMAKE_CXX_COMPILER_ID: " ${CMAKE_CXX_COMPILER_ID} )

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    MESSAGE( STATUS "clang compiler version: " ${CMAKE_CXX_COMPILER_VERSION} )
    MESSAGE( STATUS "using clang settings" )
    set(RX_COMPILE_OPTIONS
        -Wall -Wextra -Werror -Wunused
        -stdlib=libc++
        -Wno-error=unused-command-line-argument
        -ftemplate-depth=1024
        )
    if (NOT RX_USE_EXCEPTIONS)
        MESSAGE( STATUS "no exceptions" )
        list(APPEND RX_COMPILE_OPTIONS -fno-exceptions)
    endif()
elseif (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    MESSAGE( STATUS "gnu compiler version: " ${CMAKE_CXX_COMPILER_VERSION} )
    MESSAGE( STATUS "using gnu settings" )
    set(RX_COMPILE_OPTIONS
        -Wall -Wextra -Werror -Wunused
        )
    if (NOT RX_USE_EXCEPTIONS)
        MESSAGE( STATUS "no exceptions" )
        list(APPEND RX_COMPILE_OPTIONS -fno-exceptions)
    endif()
  elseif (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    MESSAGE( STATUS "msvc compiler version: " ${CMAKE_CXX_COMPILER_VERSION} )
    MESSAGE( STATUS "using msvc settings" )
    set(RX_COMPILE_OPTIONS
        /W4 /WX
        /wd4503 # truncated symbol
        /wd4702 # unreachable code
        /bigobj
        /DUNICODE /D_UNICODE # it is a new millenium
        )
    if (NOT RX_USE_EXCEPTIONS)
        MESSAGE( STATUS "no exceptions" )
        list(APPEND RX_COMPILE_OPTIONS /EHs-c-)
    endif()
    if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "19.0.23506.0")
        MESSAGE( STATUS "with coroutines" )
        list(APPEND RX_COMPILE_OPTIONS
            /await # enable coroutines
            )
    endif()
endif()

set(RX_COMPILE_FEATURES cxx_std_14)

set(IX_SRC_DIR ${RXCPP_DIR}/Ix/CPP/src)
set(RX_SRC_DIR ${RXCPP_DIR}/Rx/v2/src)
set(RX_CATCH_DIR ${RXCPP_DIR}/ext/catch/single_include/catch2)

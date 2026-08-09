option(ENABLE_CPPCHECK "Enable static analysis with cppcheck" OFF)
option(ENABLE_CLANG_TIDY "Enable static analysis with clang-tidy" OFF)
option(ENABLE_INCLUDE_WHAT_YOU_USE "Enable static analysis with include-what-you-use" OFF)
set(ENABLE_QT_DEPRECATION_CHECK "" CACHE STRING "Define hex value (e.g. 0x060b00 for Qt 6.11) for testing for deprecations. Empty = OFF")
set(ENABLE_QT_STRICT_MODE "" CACHE STRING "Define hex value (e.g. 0x060b00 for Qt 6.11) enabling Qt strict mode up to the specified version. Empty = OFF")

if(ENABLE_CPPCHECK)
  find_program(CPPCHECK cppcheck)
  if(CPPCHECK)
    message(STATUS "CPPCHECK is enabled!")
    set(CMAKE_CXX_CPPCHECK
        ${CPPCHECK}
        --library=qt
        --suppress=missingInclude
        --enable=all
        --inline-suppr
        --inconclusive)
  else()
    message(SEND_ERROR "cppcheck requested but executable not found")
  endif()
endif()

if(ENABLE_CLANG_TIDY)
  find_program(CLANGTIDY clang-tidy)
  if(CLANGTIDY)
    message(STATUS "CLANGTIDY is enabled!")
    set(CMAKE_CXX_CLANG_TIDY ${CLANGTIDY} -extra-arg=-Wno-unknown-warning-option)
  else()
    message(SEND_ERROR "clang-tidy requested but executable not found")
  endif()
endif()

if(ENABLE_INCLUDE_WHAT_YOU_USE)
  find_program(INCLUDE_WHAT_YOU_USE include-what-you-use)
  if(INCLUDE_WHAT_YOU_USE)
    message(STATUS "INCLUDE_WHAT_YOU_USE is enabled!")
    set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE ${INCLUDE_WHAT_YOU_USE})
  else()
    message(SEND_ERROR "include-what-you-use requested but executable not found")
  endif()
endif()

if(NOT "${ENABLE_QT_DEPRECATION_CHECK}" STREQUAL "")
    message(STATUS "Qt deprecations warnings enabled for: ${ENABLE_QT_DEPRECATION_CHECK}")
    find_package(Qt6 REQUIRED COMPONENTS Core)
    if(${Qt6Core_VERSION} VERSION_GREATER_EQUAL "6.5.0")
        add_compile_definitions(QT_DISABLE_DEPRECATED_UP_TO=${ENABLE_QT_DEPRECATION_CHECK})
    else() # Macro deprecated with Qt 6.5
        add_compile_definitions(QT_DISABLE_DEPRECATED_BEFORE=${ENABLE_QT_DEPRECATION_CHECK})
    endif()
endif()

if(NOT "${ENABLE_QT_STRICT_MODE}" STREQUAL "")
    find_package(Qt6 REQUIRED COMPONENTS Core)
    if(${Qt6Core_VERSION} VERSION_GREATER_EQUAL "6.8.0")
        message(STATUS "Qt strict mode enabled up to: ${ENABLE_QT_STRICT_MODE}")
        add_compile_definitions(QT_ENABLE_STRICT_MODE_UP_TO=${ENABLE_QT_STRICT_MODE})
    endif()
endif()

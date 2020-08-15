cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(biiiserial_library VERSION 1.0.0 LANGUAGES C)
add_library(biiiserial_library SHARED biiiserial.c biiiserial.def)
add_executable(biiiserial_test biiiserial.c)

set_target_properties(biiiserial_library PROPERTIES
    PUBLIC_HEADER biiiserial.h
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    OUTPUT_NAME "biiiserial"
    # XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Hex_Identity_ID_Goes_Here"
)

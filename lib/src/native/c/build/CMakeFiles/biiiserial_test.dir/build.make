# CMAKE generated file: DO NOT EDIT!
# Generated by "MinGW Makefiles" Generator, CMake Version 3.17

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = "C:\Program Files\CMake\bin\cmake.exe"

# The command to remove a file.
RM = "C:\Program Files\CMake\bin\cmake.exe" -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c\build

# Include any dependencies generated for this target.
include CMakeFiles/biiiserial_test.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/biiiserial_test.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/biiiserial_test.dir/flags.make

CMakeFiles/biiiserial_test.dir/biiiserial.c.obj: CMakeFiles/biiiserial_test.dir/flags.make
CMakeFiles/biiiserial_test.dir/biiiserial.c.obj: ../biiiserial.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/biiiserial_test.dir/biiiserial.c.obj"
	C:\PROGRA~2\MICROS~2\2019\COMMUN~1\VC\Tools\MSVC\1425~1.286\bin\Hostx64\x64\cl.exe  /nologo $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) /FoCMakeFiles\biiiserial_test.dir\biiiserial.c.obj /FdCMakeFiles\biiiserial_test.dir/ /FS -c E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c\biiiserial.c

CMakeFiles/biiiserial_test.dir/biiiserial.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/biiiserial_test.dir/biiiserial.c.i"
	C:\PROGRA~2\MICROS~2\2019\COMMUN~1\VC\Tools\MSVC\1425~1.286\bin\Hostx64\x64\cl.exe > CMakeFiles\biiiserial_test.dir\biiiserial.c.i  /nologo $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c\biiiserial.c

CMakeFiles/biiiserial_test.dir/biiiserial.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/biiiserial_test.dir/biiiserial.c.s"
	C:\PROGRA~2\MICROS~2\2019\COMMUN~1\VC\Tools\MSVC\1425~1.286\bin\Hostx64\x64\cl.exe  /nologo $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) /FoNUL /FAs /FaCMakeFiles\biiiserial_test.dir\biiiserial.c.s /c E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c\biiiserial.c

# Object files for target biiiserial_test
biiiserial_test_OBJECTS = \
"CMakeFiles/biiiserial_test.dir/biiiserial.c.obj"

# External object files for target biiiserial_test
biiiserial_test_EXTERNAL_OBJECTS =

biiiserial_test.exe: CMakeFiles/biiiserial_test.dir/biiiserial.c.obj
biiiserial_test.exe: CMakeFiles/biiiserial_test.dir/build.make
biiiserial_test.exe: CMakeFiles/biiiserial_test.dir/objects1.rsp
biiiserial_test.exe: CMakeFiles/biiiserial_test.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable biiiserial_test.exe"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles\biiiserial_test.dir\link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/biiiserial_test.dir/build: biiiserial_test.exe

.PHONY : CMakeFiles/biiiserial_test.dir/build

CMakeFiles/biiiserial_test.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles\biiiserial_test.dir\cmake_clean.cmake
.PHONY : CMakeFiles/biiiserial_test.dir/clean

CMakeFiles/biiiserial_test.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c\build E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c\build E:\tools\vscodium-portable\data\appdata\BiFu\BiiiSerial\lib\src\native\c\build\CMakeFiles\biiiserial_test.dir\DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/biiiserial_test.dir/depend


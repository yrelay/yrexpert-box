# Every CTest script has to contain the source and binary directory:

SET (CTEST_SOURCE_DIRECTORY "$ENV{HOME}/Dashboards/My Testing/Insight")
SET (CTEST_BINARY_DIRECTORY "$ENV{HOME}/Dashboards/My Testing/Insight-bin")

# The "$ENV{HOME}" gets replaced by the environment variable "HOME", which on most systems points to user's home directory.

# Second thing we need is the command that perform initial configuration of the project. For example, if the project uses CMake, then the command would be something like:

SET (CTEST_CMAKE_COMMAND "/usr/local/bin/cmake")


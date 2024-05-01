#!/bin/bash

declare -a CMAKE_PLATFORM_FLAGS
if [[ ${HOST} =~ .*darwin.* ]]; then
  CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
else
  CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
fi

# As per https://conda-forge.org/docs/maintainer/knowledge_base/#cross-compilation-examples
if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" && "${mpi}" == "openmpi" ]]; then
  export OPAL_PREFIX="$PREFIX"
  #export OMPI_FCFLAGS=${FFLAGS}
  export CC=mpicc
  export CXX=mpic++
  export FC=mpifort
fi

source "$SRC_DIR/install" -DPython3_EXECUTABLE="$PYTHON" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$PREFIX" -DFABM_EXTRA_INSTITUTES=ogs -DFABM_OGS_BASE="$SRC_DIR/extern/ogs" ${CMAKE_PLATFORM_FLAGS[@]}

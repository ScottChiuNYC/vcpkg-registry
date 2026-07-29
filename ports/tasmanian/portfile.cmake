vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ORNL/TASMANIAN
    REF v8.2
    SHA512 3ed296ea17d5f9be130c346da57217a4873f538115fc3191b0ca213480ac69697156525fc77bdf5e51bf3b6ac5b66258e5fe6e2337399135c1b0851f35da276e
    HEAD_REF master
)

vcpkg_replace_string(
    "${SOURCE_PATH}/Config/TasmanianConfig.in.cmake"
    "include(\"@Tasmanian_final_install_path@/lib/@CMAKE_PROJECT_NAME@/@CMAKE_PROJECT_NAME@.cmake\")"
    "include(\"\${CMAKE_CURRENT_LIST_DIR}/Tasmanian.cmake\")"
)
vcpkg_replace_string(
    "${SOURCE_PATH}/Config/TasmanianConfig.in.cmake"
    "set_property(TARGET Tasmanian::tasgrid PROPERTY IMPORTED_LOCATION \"@Tasmanian_final_install_path@/bin/tasgrid\${CMAKE_EXECUTABLE_SUFFIX_CXX}\")"
    "set_property(TARGET Tasmanian::tasgrid PROPERTY IMPORTED_LOCATION \"\${PACKAGE_PREFIX_DIR}/tools/tasmanian/tasgrid\${CMAKE_EXECUTABLE_SUFFIX}\")"
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(TASMANIAN_BUILD_SHARED_LIBS ON)
else()
    set(TASMANIAN_BUILD_SHARED_LIBS OFF)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_SHARED_LIBS=${TASMANIAN_BUILD_SHARED_LIBS}
        -DTasmanian_ENABLE_RECOMMENDED=OFF
        -DTasmanian_ENABLE_OPENMP=OFF
        -DTasmanian_ENABLE_BLAS=OFF
        -DTasmanian_ENABLE_PYTHON=OFF
        -DTasmanian_ENABLE_CUDA=OFF
        -DTasmanian_ENABLE_HIP=OFF
        -DTasmanian_ENABLE_DPCPP=OFF
        -DTasmanian_ENABLE_MAGMA=OFF
        -DTasmanian_ENABLE_FORTRAN=OFF
        -DTasmanian_ENABLE_MPI=OFF
        -DTasmanian_ENABLE_SWIG=OFF
        -DTasmanian_ENABLE_DOXYGEN=OFF
        -DTasmanian_MATLAB_WORK_FOLDER=
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME Tasmanian CONFIG_PATH lib/Tasmanian)
vcpkg_copy_tools(TOOL_NAMES tasgrid AUTO_CLEAN)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)
file(REMOVE
    "${CURRENT_PACKAGES_DIR}/include/tasgridLogs.hpp"
    "${CURRENT_PACKAGES_DIR}/share/Tasmanian/TasmanianENVsetup.sh"
)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

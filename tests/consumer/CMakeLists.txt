cmake_minimum_required(VERSION 3.23)
project(custom_registry_consumer LANGUAGES CXX)

include(CTest)

find_package(GTest CONFIG REQUIRED)
find_package(Tasmanian CONFIG REQUIRED)

add_executable(tasmanian_smoke main.cpp)
target_link_libraries(tasmanian_smoke PRIVATE Tasmanian::Tasmanian)
target_compile_features(tasmanian_smoke PRIVATE cxx_std_17)
add_test(NAME tasmanian_smoke COMMAND tasmanian_smoke)

add_executable(gtest_smoke gtest_smoke.cpp)
target_link_libraries(gtest_smoke PRIVATE GTest::gtest_main)
target_compile_features(gtest_smoke PRIVATE cxx_std_17)
include(GoogleTest)
gtest_discover_tests(gtest_smoke)

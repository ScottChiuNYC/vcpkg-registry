cmake_minimum_required(VERSION 3.23)
project(tasmanian_registry_consumer LANGUAGES CXX)

include(CTest)

find_package(Tasmanian CONFIG REQUIRED)

add_executable(tasmanian_smoke main.cpp)
target_link_libraries(tasmanian_smoke PRIVATE Tasmanian::Tasmanian)
target_compile_features(tasmanian_smoke PRIVATE cxx_std_17)

add_test(NAME tasmanian_smoke COMMAND tasmanian_smoke)

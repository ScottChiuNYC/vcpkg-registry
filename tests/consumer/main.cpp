#include <Tasmanian.hpp>

#include <iostream>
#include <string>

int main() {
    const std::string version = TasGrid::TasmanianSparseGrid::getVersion();
    std::cout << "Tasmanian sparse-grid version: " << version << '\n';
    return version == "8.2" || version == "8.2.0" ? 0 : 1;
}

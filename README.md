# ScottChiuNYC vcpkg Registry

Private-curated public vcpkg Git registry for C++ dependencies that are not available in the Microsoft curated registry.

## Ports

- `tasmanian`: ORNL Toolkit for Adaptive Stochastic Modeling and Non-Intrusive ApproximatioN.

## Consumer configuration

Projects keep the Microsoft registry as their `default-registry` and add this repository under `registries` for explicitly listed packages such as `tasmanian`.

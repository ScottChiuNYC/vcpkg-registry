# ScottChiuNYC vcpkg Registry

A public, curated vcpkg Git registry for C++ dependencies that need packaging behavior different from the Microsoft curated registry.

## Ports

### `gtest`

Google Testing and Mocking Framework.

- packaged version: `1.17.0#3`, based on Microsoft vcpkg's `gtest@1.17.0#2` port;
- license: BSD-3-Clause;
- CMake package: `GTest`;
- primary targets: `GTest::gtest`, `GTest::gtest_main`, `GTest::gmock`, and `GTest::gmock_main`;
- preserves the official source SHA512, patches, install layout, generated pkg-config files, and CMake package configuration;
- uses `vcpkg_fixup_pkgconfig(SKIP_CHECK)` so the `.pc` files are normalized without acquiring or executing `pkgconf`.

### `tasmanian`

ORNL Toolkit for Adaptive Stochastic Modeling and Non-Intrusive ApproximatioN.

- packaged version: `8.2.0` from upstream tag `v8.2`;
- license: BSD-3-Clause;
- CMake package: `Tasmanian`;
- primary target: `Tasmanian::Tasmanian`;
- initial port scope: C++ libraries and the `tasgrid` tool;
- disabled initially: recommended dependencies, OpenMP, BLAS, Python, CUDA, HIP, DPC++, MAGMA, Fortran, MPI, SWIG, Doxygen, and MATLAB.

## Use this registry with the Microsoft registry

A project can use both registries. Keep Microsoft vcpkg as the `default-registry`, then route `gtest` and `tasmanian` to this registry:

```json
{
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/microsoft/vcpkg",
    "baseline": "00807e89724847a866033a2f042c38fafae3c534"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/ScottChiuNYC/vcpkg-registry",
      "baseline": "<published-registry-commit-sha>",
      "packages": [
        "gtest",
        "tasmanian"
      ]
    }
  ]
}
```

Then add the dependencies to the consuming project's `vcpkg.json`:

```json
{
  "dependencies": [
    "gtest",
    "tasmanian"
  ]
}
```

Consume the installed packages in CMake:

```cmake
find_package(GTest CONFIG REQUIRED)
find_package(Tasmanian CONFIG REQUIRED)

target_link_libraries(your_tests PRIVATE GTest::gtest_main)
target_link_libraries(your_target PRIVATE Tasmanian::Tasmanian)
```

The custom registry is consulted only for package names listed in its `packages` array. All other ports continue to resolve from the Microsoft default registry.

## Registry validation

`.github/workflows/test-ports.yml` validates the complete Git-registry path on Windows and Linux:

1. verify that each current port tree matches its file under `versions/`;
2. create a consumer configuration with Microsoft as the default registry and this repository as an additional registry;
3. install `gtest` and `tasmanian` through the Git registry;
4. assert that the manifest installation database contains no `pkgconf` package;
5. compile consumers linked to `GTest::gtest_main` and `Tasmanian::Tasmanian`;
6. run both consumers through CTest.

Pull requests use vcpkg's `reference` field to test the unpublished topic branch. Published consumers should normally omit `reference` and pin `baseline` to a commit on `main`.

## Publishing a port update

When a port changes, update its manifest and source hash if applicable, then regenerate the versions database with vcpkg's `x-add-version` command. Do not rewrite an already-published version's `git-tree`; use a new upstream version or increment `port-version` for packaging-only changes.

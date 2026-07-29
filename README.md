# ScottChiuNYC vcpkg Registry

A public, curated vcpkg Git registry for C++ dependencies that are not available in the Microsoft curated registry.

## Ports

### `tasmanian`

ORNL Toolkit for Adaptive Stochastic Modeling and Non-Intrusive ApproximatioN.

- packaged version: `8.2.0` from upstream tag `v8.2`;
- license: BSD-3-Clause;
- CMake package: `Tasmanian`;
- primary target: `Tasmanian::Tasmanian`;
- initial port scope: C++ libraries and the `tasgrid` tool;
- disabled initially: recommended dependencies, OpenMP, BLAS, Python, CUDA, HIP, DPC++, MAGMA, Fortran, MPI, SWIG, Doxygen, and MATLAB.

## Use this registry with the Microsoft registry

A project can use both registries. Keep Microsoft vcpkg as the `default-registry`, then route only `tasmanian` to this registry:

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
        "tasmanian"
      ]
    }
  ]
}
```

Then add the dependency to the consuming project's `vcpkg.json`:

```json
{
  "dependencies": [
    "tasmanian"
  ]
}
```

Consume the installed package in CMake:

```cmake
find_package(Tasmanian CONFIG REQUIRED)
target_link_libraries(your_target PRIVATE Tasmanian::Tasmanian)
```

The custom registry is consulted only for package names listed in its `packages` array. All other ports continue to resolve from the Microsoft default registry.

## Registry validation

`.github/workflows/test-ports.yml` validates the complete Git-registry path on Windows and Linux:

1. verify that the current port tree matches `versions/t-/tasmanian.json`;
2. create a consumer configuration with Microsoft as the default registry and this repository as an additional registry;
3. install `tasmanian` through the Git registry;
4. compile a consumer linked to `Tasmanian::Tasmanian`;
5. run the consumer through CTest.

Pull requests use vcpkg's `reference` field to test the unpublished topic branch. Published consumers should normally omit `reference` and pin `baseline` to a commit on `main`.

## Publishing a port update

When the upstream Tasmanian version changes, update the port manifest and source hash, then regenerate the versions database with vcpkg's `x-add-version` command. Do not rewrite an already-published version's `git-tree`; use a new upstream version or increment `port-version` for packaging-only changes.

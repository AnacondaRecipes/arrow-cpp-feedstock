# arrow-cpp-feedstock

## Build Notes

- **Tightly coupled with pyarrow-feedstock** — same source tarball, same version, same SHA256. Must be bumped together.
- Arrow's CUDA support (`ARROW_CUDA=ON`) does NOT compile any `.cu` files. It only uses the CUDA driver API (`cuda.h`, `libcuda.so`). No `nvcc` invocation.
  - Consequence: No GCC downgrade needed for CUDA builds (unlike catboost, llama.cpp which compile `.cu` files)
  - Consequence: One CUDA build is technically sufficient for all CUDA versions (forward compatible via driver API)
  - We still build per CUDA version (12.8, 13.0, 13.1) for ecosystem consistency
- `libcuda.so` comes from the NVIDIA driver, not any conda package — whitelisted in `missing_dso_whitelist`
- Arrow produces `libarrow_cuda${SHLIB_EXT}` when built with `ARROW_CUDA=ON`
- `run_exports` uses `max_pin="x.x.x"` (version only, no build string). Variant matching must be handled by consumers (e.g., pyarrow explicitly requesting `arrow-cpp ... cuda*`)

## CUDA Variant Design (PKG-13005)

- CUDA gated by `ANACONDA_ROCKET_ENABLE_CUDA` — CPU-only by default in CI
- Two CUDA versions: 12.8, 13.1 (one per CUDA generation; 13.0 dropped — identical binary, minimal user benefit)
- Build number: +100 for CUDA variants
- Build string: `cuda{ver}_h{hash}_{buildnum}` / `cpu_h{hash}_{buildnum}`
- Platforms: linux-64 only (Windows CUDA can be added later)

## Update History

- 23.0.1: Added CUDA variant support (PKG-13005/PKG-8494)
- 23.0.1: Initial version (CPU only, PKG-12059)

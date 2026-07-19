# xash3d-api

`xash3d-api` provides common FFI definitions necessary to interoperate with
[Xash3D engine](https://github.com/FWGS/xash3d-fwgs).

# Usage

Add the following to your `Cargo.toml`:

```toml
[dependencies]
xash3d-api = "0.2"
```

# Feature flags

* `std` - links to the standard library.
* `libm` - add additional methods to vectors in no-std environments.
* `glam` - use vector types from this crate.

# Minimum Supported Rust Version (MSRV)

This version of crate requires Rust `1.68` or later.

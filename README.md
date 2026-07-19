# Raw FFI bindings to Xash3D FWGS engine

All of the definitions necessary to interoperate with
[Xash3D engine](https://github.com/FWGS/xash3d-fwgs). Bindings are generated
statically to minimize build dependencies.

# Generate bindings

[bindgen-cli](https://github.com/rust-lang/rust-bindgen) is **required**.

To manually generate bindings run `generate.sh [target]`. The default target is
`i686-unknown-linux-gnu`.

```ignore
cd xash3d-api
./generate.sh
```

# odin-waylib

A raylib-shaped API for Odin plugins compiled to WebAssembly. Plugin code imports only this package and writes raylib code; the host engine implements the significant procedures as wasm imports under the module `host`.

Three kinds of things are in the package:

- **Host procedures**, the foreign block in `waylib.odin`. Anything that does real work goes through the engine this way. So far: `TraceLog(level, message: string)` and `DrawRectangleV(position, size, color)`.
- **Every raylib type** and the named colours, re-exported in `raylib_types.odin` through `vendor:raylib`, so `Vector2`, `Color`, `Rectangle`, `KeyboardKey` and the rest are the same types the engine uses.
- **raylib's pure helpers**, raymath and the easings, re-exported in `raymath.odin` and `easings.odin`. They are implemented in Odin and compile into the plugin, nothing crosses the boundary.

The re-export files are generated. After an Odin update run:

```sh
./generate.py "$(odin root)/vendor/raylib"
```

## Plugin side

Check out this repository as `module/waylib`, for example as a git submodule, and pass `module` as a collection:

```sh
odin build plugin -target:freestanding_wasm32 -no-entry-point -collection:module=module
```

```odin
import wl "module:waylib"

position := wl.Vector2Rotate({100, 0}, angle)
wl.DrawRectangleV(position, {16, 16}, wl.YELLOW)
wl.TraceLog(.INFO, "hello from the plugin")
```

Do not import `vendor:raylib` in a plugin. Its types and helpers are all available here, and calling one of its real procedures pulls raylib's browser build into the module, which the host cannot instantiate. The package refuses to compile for non-wasm targets.

## Host side

Every declaration in the foreign block must be provided by the host under the module `host` with the wasm signature Odin's wasm32 ABI produces: scalars and enums as themselves, structs and strings by pointer, that is an `i32` offset into the plugin's memory that the host reads and bounds-checks. `TraceLog` is `(i32, i32)` and `DrawRectangleV` is `(i32, i32, i32)`. A struct return arrives as an out-pointer first argument. The reference implementation is `plugin_host.odin` in odin-game; the two must change together.

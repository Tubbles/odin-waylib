# odin-waylib

A raylib-shaped API for Odin plugins compiled to WebAssembly. Plugin code imports it and writes raylib calls; the host engine implements them as wasm imports under the module `host`. Types are raylib's own through `vendor:raylib` (`Color`, `Vector2`, `Rectangle`, `TraceLogLevel`, plus the named colours), so raylib knowledge carries over.

Procedures so far: `TraceLog(level, message: string)` and `DrawRectangleV(position, size, color)`.

## Plugin side

Check out this repository as `module/waylib`, for example as a git submodule, and pass `module` as a collection:

```sh
odin build plugin -target:freestanding_wasm32 -no-entry-point -collection:module=module
```

```odin
import wl "module:waylib"

wl.DrawRectangleV({10, 10}, {16, 16}, wl.YELLOW)
wl.TraceLog(.INFO, "hello from the plugin")
```

Plugins may use `vendor:raylib` for anything that is not a procedure call, such as raymath. Calling a `vendor:raylib` procedure pulls raylib's browser build into the module, and the host cannot instantiate that. The package refuses to compile for non-wasm targets.

## Host side

Every declaration in the foreign block must be provided by the host under the module `host` with the wasm signature Odin's wasm32 ABI produces: scalars and enums as themselves, structs and strings by pointer, that is an `i32` offset into the plugin's memory that the host reads and bounds-checks. `TraceLog` is `(i32, i32)` and `DrawRectangleV` is `(i32, i32, i32)`. A struct return arrives as an out-pointer first argument. The reference implementation is `plugin_host.odin` in odin-game; the two must change together.

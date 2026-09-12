// The API a plugin gets from the engine, shaped like raylib so raylib knowledge carries
// over: same procedure names, same argument types, and the types are raylib's own.
//
// Owned by the engine that implements it. The foreign block below is one half of the
// plugin ABI; the other half is the engine's table of host functions under the "host"
// module (in odin-game: game_host_functions in plugin_host.odin), where every declaration
// here has an entry with the matching wasm signature. Change both together.
//
// On the wire, wasm passes structs and strings by pointer, so each such argument is an
// i32 offset into the plugin's memory that the engine reads and bounds-checks. Scalars
// and enums cross as themselves.
//
// Plugins may use vendor:raylib for anything that is not a procedure call, such as its
// colour constants or raymath. Calling a vendor:raylib procedure would pull raylib's
// browser build into the module, and the engine cannot instantiate that.
package waylib

import rl "vendor:raylib"

when ODIN_ARCH != .wasm32 && ODIN_ARCH != .wasm64p32 {
	#panic("shared:waylib is for plugins built to wasm; the engine uses vendor:raylib directly")
}

foreign import host "host"

@(default_calling_convention = "c")
foreign host {
	// Logs through the engine's logger, prefixed as a plugin message.
	TraceLog :: proc(level: TraceLogLevel, message: string) ---
	DrawRectangleV :: proc(position: Vector2, size: Vector2, color: Color) ---
}

Color         :: rl.Color
Vector2       :: rl.Vector2
Rectangle     :: rl.Rectangle
TraceLogLevel :: rl.TraceLogLevel

// raylib's named colours, so a plugin needs only this import for the common cases.
LIGHTGRAY  :: rl.LIGHTGRAY
GRAY       :: rl.GRAY
DARKGRAY   :: rl.DARKGRAY
YELLOW     :: rl.YELLOW
GOLD       :: rl.GOLD
ORANGE     :: rl.ORANGE
PINK       :: rl.PINK
RED        :: rl.RED
MAROON     :: rl.MAROON
GREEN      :: rl.GREEN
LIME       :: rl.LIME
DARKGREEN  :: rl.DARKGREEN
SKYBLUE    :: rl.SKYBLUE
BLUE       :: rl.BLUE
DARKBLUE   :: rl.DARKBLUE
PURPLE     :: rl.PURPLE
VIOLET     :: rl.VIOLET
DARKPURPLE :: rl.DARKPURPLE
BEIGE      :: rl.BEIGE
BROWN      :: rl.BROWN
DARKBROWN  :: rl.DARKBROWN
WHITE      :: rl.WHITE
BLACK      :: rl.BLACK
BLANK      :: rl.BLANK
MAGENTA    :: rl.MAGENTA
RAYWHITE   :: rl.RAYWHITE

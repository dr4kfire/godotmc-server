@icon("uid://0pm7q27lqf60") # icon.svg (godot logo)
class_name DotServer
extends Dot

const SERVER_NAME: String = "Dot"
const SERVER_VERSION: String = "1.21.10-b0.0.1"
const BUILD_NUMBER: String = "2026-APR-18+1" ## yyyy-MMM-dd+n

#@export var offline_mode: bool = false
@export var cross_platform_mode: bool = false
@export var backwards_compatible: bool = false
@export_enum("1.21.10") var compatibility_version: String = "1.21.10"

@export_group("Performance")
@export var maxRenderDistance: int = 10
@export var sendOnlyNecessaryChunks: bool = true
@export var dontSaveUnmodifiedChunks: bool = true

class_name TextComponent
extends MinecraftResource
## Minecraft's implementation of rich text
##
## For more info check out [url=https://minecraft.wiki/w/Text_component_format]this minecraft.wiki
## article[/url]


enum ContentType {
	TEXT,
	TRANSLATE,
	SCORE,
	SELECTOR,
	KEYBIND
	}

enum ColorOptions {
	BLACK,
	DARK_BLUE,
	DARK_GREEN,
	DARK_AQUA,
	DARK_RED,
	DARK_PURPLE,
	GOLD,
	GRAY,
	DARK_GRAY,
	BLUE,
	GREEN,
	AQUA,
	RED,
	LIGH_PURPLE,
	YELLOW,
	WHITE = 0xffffff,
	CUSTOM
	}


@export var type: ContentType 
@export var extra: TextComponent

@export_group("Formatting")
@export var color: ColorOptions = ColorOptions.WHITE
@export var custom_color: Color = Color.WHITE
#@export var font: Font #Temporarily unused
@export var bold: bool = false 
@export var italic: bool = false
@export var underlined: bool = false
@export var strikethrough: bool = false
@export var obfuscated: bool = false
@export var shadow_color: Color = Color.TRANSPARENT

@export_category("Content Options")
@export_group("Text")
@export_multiline() var text: String = ""
@export_group("Translated Text")
@export var translate: String = ""
@export var fallback: String = ""
@export var with: Array[TextComponent]
@export_group("Scoreboard Value")
@export var score_name: String = "*"
@export var score_objective: StringName
@export_group("Entity Names")
@export_group("Keybind")

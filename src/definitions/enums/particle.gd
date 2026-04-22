#TODO: Implement this fully
class_name Particle
extends Object


class DustOptions:
	var __post_init: bool = false
	var color: Color:
		set(value):
			if __post_init: return
			color = value
		get():
			return color
	var size: float:
		set(value):
			if __post_init: return
			size = value
		get():
			return size
	
	func _init(new_color: Color, new_size: float) -> void:
		color = new_color
		size = new_size
		__post_init = true
class DustTransition extends DustOptions:
	var from_color: Color:
		set(value):
			if __post_init: return
			color = value
		get():
			return color
	var to_color: Color:
		set(value):
			if __post_init: return
			to_color = value
		get():
			return to_color
	
	func _init(new_from_color: Color, new_to_color: Color, new_size: float) -> void:
		color = new_from_color
		to_color = new_to_color
		size = new_size
		__post_init = true

class Spell:
	var __post_init: bool = false
	var color: Color:
		set(value):
			if __post_init: return
			color = value
		get():
			return color
	var power: float:
		set(value):
			if __post_init: return
			power = value
		get():
			return power
	
	func _init(new_color: Color, new_power: float) -> void:
		color = new_color
		power = new_power
		__post_init = true
#TODO: Implement Location in order for this to work!
class Trail:
	var __post_init: bool = false
	var target: Vector3:
		set(value):
			if __post_init: return
			target = value
		get():
			return target
	var color: Color:
		set(value):
			if __post_init: return
			color = value
		get():
			return color
	var duration: int:
		set(value):
			if __post_init: return
			duration = value
		get():
			return duration
	
	func _init(new_target: Vector3, new_color: Color, new_duration: int) -> void:
		color = new_color
		duration = new_duration
		target = new_target
		__post_init = true


enum {
	AMBIENT_ENTITY_EFFECT,
	ANGRY_VILLAGER,
	BARRIER,
	BLOCK,
	BLOCK_DUST,
	BLOCK_MARKER,
	BUBBLE,
	BUBBLE_COLUMN_UP,
	BUBBLE_POP,
	CAMPFIRE_COSY_SMOKE,
	CAMPFIRE_SIGNAL_SMOKE,
	CHERRY_LEAVES,
	CLOUD,
	COMPOSTER,
	CRIMSON_SPORE,
	CRIT,
	CRIT_MAGIC,
	CURRENT_DOWN,
	DAMAGE_INDICATOR,
	DRAGON_BREATH,
	DRIPPING_HONEY,
	DRIPPING_LAVA,
	DRIPPING_OBSIDIAN_TEAR,
	DRIPPING_WATER,
	DUST,
	DUST_COLOR_TRANSITION,
	DUST_PILLAR,
	ELECTRIC_SPARK,
	ENCHANT,
	ENCHANTED_HIT,
	END_ROD,
	ENTITY_EFFECT,
	EXPLOSION,
	EXPLOSION_EMITTER,
	EXPLOSION_LARGE,
	FALLING_DUST,
	FALLING_HONEY,
	FALLING_LAVA,
	FALLING_NECTAR,
	FALLING_OBSIDIAN_TEAR,
	FALLING_SPORE_BLOSSOM,
	FALLING_WATER,
	FIREWORK,
	FISHING,
	FLAME,
	FLASH,
	FLUID_FALLING,
	FLUID_PICKUP,
	FOOTSTEP,
	GLOW,
	GLOW_SQUID_INK,
	HAPPY_VILLAGER,
	HEART,
	HEART_EMITTER,
	INSTANT_EFFECT,
	ITEM,
	ITEM_COBWEB,
	ITEM_SNOWBALL,
	LANDING_HONEY,
	LANDING_LAVA,
	LANDING_OBSIDIAN_TEAR,
	LAVA,
	MYCELIUM,
	NAUTILUS,
	NOTE,
	OPEN_SIGN_ENTITY,
	POOF,
	PORTAL,
	REDSTONE,
	REVERSE_PORTAL,
	SCRAPE,
	SCREAM,
	SMOKE,
	SMOKE_LARGE,
	SNOWFLAKE,
	SONIC_BOOM,
	SPORE_BLOSSOM_AIR,
	SQUID_INK,
	STORM,
	SUGAR,
	SWEEP_ATTACK,
	TAIL_UPDATE,
	TOTEM,
	TOTEM_OF_UNDYING,
	TRAIL,
	TRANSLUCENT,
	UNDERWATER,
	VIBRATION,
	WARPED_SPORE,
	WAX_OFF,
	WAX_ON,
	WATER_BUBBLE,
	WATER_DROP,
	WATER_SPLASH,
	WAXING,
	WAXING_OFF,
	WEB,
	WITCH,
}


#TODO: Implement ParticleBuilder in order for this to work
static func builder() -> Object:
	return

static func getDataType(_particle: int) -> Variant:
	return

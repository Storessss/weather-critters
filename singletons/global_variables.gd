extends Node

var critters: Array[PackedScene] = [
	preload("res://scenes/critters/slime.tscn"),
	preload("res://scenes/critters/spitter.tscn"),
	preload("res://scenes/critters/crusher.tscn"),
	preload("res://scenes/critters/triple_shooter.tscn"),
	preload("res://scenes/critters/little_devil.tscn"),
	preload("res://scenes/critters/spingus.tscn"),
	preload("res://scenes/critters/dungeon_flower.tscn")
]

enum TimeOfDay {
	MORNING,
	AFTERNOON,
	EVENING,
	NIGHT
}

enum Season {
	SPRING,
	SUMMER,
	FALL,
	WINTER
}

enum Weather {
	CLOUDY,
	SUNNY,
	LIGHT_RAIN,
	RAIN,
	STORM,
	SNOW,
	HAIL
}

enum MoonPhase {
	NEW_MOON,
	WAXING_CRESCENT,
	FIRST_QUARTER,
	WAXING_GIBBOUS,
	FULL_MOON,
	WANING_GIBBOUS,
	LAST_QUARTER,
	WANING_CRESCENT
}

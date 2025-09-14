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

var catched_critter_data: Dictionary
var save_path: String = "user://save1.save"

func save_data() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(catched_critter_data)
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		catched_critter_data = file.get_var()
		file.close()

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

func _physics_process(_delta: float) -> void:
	print(catched_critter_data)
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/main/bestiary.tscn")

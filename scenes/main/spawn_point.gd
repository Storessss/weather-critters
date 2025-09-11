extends Node2D

var critters: Array[PackedScene] = [
	preload("res://scenes/critters/slime.tscn"),
	preload("res://scenes/critters/spitter.tscn"),
	preload("res://scenes/critters/crusher.tscn"),
	preload("res://scenes/critters/triple_shooter.tscn"),
	preload("res://scenes/critters/little_devil.tscn"),
	preload("res://scenes/critters/spingus.tscn"),
	preload("res://scenes/critters/dungeon_flower.tscn")
]
var critter: Critter

func _ready() -> void:
	$SpawnTimer.start(randf_range(5.0, 55.0))
	#$SpawnTimer.start(5.0)

func _process(delta: float) -> void:
	if $SpawnTimer.is_stopped():
		$SpawnTimer.start(randf_range(5.0, 55.0))
		#$SpawnTimer.start(5.0)
		if critter:
			critter.queue_free()
		else:
			var can_spawn: bool
			while not can_spawn:
				critter = critters.pick_random().instantiate()
				critter.global_position = global_position
				get_tree().current_scene.add_child(critter)
				var checks_ok: bool = critter.check()
				if checks_ok:
					can_spawn = true
				else:
					critter.queue_free()

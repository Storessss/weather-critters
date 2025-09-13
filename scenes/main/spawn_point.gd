extends Node2D

var critter: Critter

var leaf_particles_scene: PackedScene = preload("res://scenes/particles/leaf_particles.tscn")

func _ready() -> void:
	$SpawnTimer.start(randf_range(5.0, 55.0))

func _process(delta: float) -> void:
	if $SpawnTimer.is_stopped():
		$SpawnTimer.start(randf_range(5.0, 55.0))
		if critter:
			critter.queue_free()
		else:
			var can_spawn: bool
			while not can_spawn:
				critter = GlobalVariables.critters.pick_random().instantiate()
				critter.global_position = global_position
				get_tree().current_scene.add_child(critter)
				var checks_ok: bool = critter.check()
				if checks_ok:
					can_spawn = true
				else:
					critter.queue_free()
		play_leaves()

func play_leaves():
	var leaf_particles: GPUParticles2D = leaf_particles_scene.instantiate()
	leaf_particles.global_position = global_position
	get_tree().current_scene.add_child(leaf_particles)
	var leaf_sounds: Array[AudioStream] = [
		preload("res://sounds/leaves1.wav"),
		preload("res://sounds/leaves2.wav"),
		preload("res://sounds/leaves3.wav"),
		preload("res://sounds/leaves4.wav"),
		preload("res://sounds/leaves5.wav"),
		preload("res://sounds/leaves6.wav"),
	]
	$LeavesSound.stream = leaf_sounds.pick_random()
	$LeavesSound.play()

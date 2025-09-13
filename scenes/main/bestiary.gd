extends Control

var index: int
var critter: Critter

func _process(delta: float) -> void:
	show_critter_info()
	if Input.is_action_just_pressed("next_critter"):
		index = (index + 1 + GlobalVariables.critters.size()) % GlobalVariables.critters.size()
		show_critter_info()
	elif Input.is_action_just_pressed("previous_critter"):
		index = (index - 1 + GlobalVariables.critters.size()) % GlobalVariables.critters.size()
		show_critter_info()

func show_critter_info() -> void:
	if critter:
		critter.queue_free()
	critter = GlobalVariables.critters[index].instantiate()
	$TextureRect.texture = critter.texture
	if critter.found:
		$NameLabel.text = critter.name
		$TextureRect.modulate = Color.WHITE
	else:
		$NameLabel.text = "???"
		$TextureRect.modulate = Color.BLACK
	$TipLabel.text = critter.tip

extends CanvasModulate

@export var gradient: GradientTexture1D
@onready var p: Node2D = get_parent()

func _process(delta: float) -> void:
	var minutes_of_day: int = p.hour * 60 + p.minute
	var value: float = float(minutes_of_day) / 1440.0
	color = gradient.gradient.sample(value)

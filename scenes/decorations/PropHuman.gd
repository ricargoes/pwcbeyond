extends TextureRect

func _ready():
	var possible_props = [
		preload("res://resources/sprites/props/musket.png"),
		preload("res://resources/sprites/props/compass.png")
	]
	var prop = possible_props[randi() % possible_props.size()]
	texture = prop

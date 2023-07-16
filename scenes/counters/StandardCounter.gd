extends HBoxContainer

@export var level = 0
@export var initial_level = 0

func _ready():
	refresh()

func refresh():
	var circles = get_children()
	for circle in circles:
		if int(str(circle.name)) <= initial_level:
			circle.permanent()
		elif int(str(circle.name)) <= level:
			circle.fill()
		else:
			circle.is_empty()


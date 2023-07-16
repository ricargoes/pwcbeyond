extends ScrollContainer

func _ready():
	set_process(true)

func _process(_delta):
	size.y = 0
	custom_minimum_size.y = get_viewport_rect().size.y

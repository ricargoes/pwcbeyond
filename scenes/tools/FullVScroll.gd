extends ScrollContainer

func _ready():
	set_process(true)

func _process(_delta):
	rect_size.y = 0
	rect_min_size.y = get_viewport_rect().size.y

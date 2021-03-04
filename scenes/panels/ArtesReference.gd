extends Popup

var _ars_group = ""
var _max_level = 0
onready var list = find_node("ArtesList")

func launch(who, show_all=false):
	_ars_group = who.get_name()
	_max_level = who.get_level()
	find_node("ShowAll").pressed = show_all
	rect_size.x = get_parent().rect_size.x
	paint(show_all)
	popup_centered()

func paint(paint_all = false):
	for node in list.get_children():
		node.queue_free()
	var paint_level = 5 if paint_all else _max_level
	for level in range(1, paint_level+1):
		var ars = ResourceManager.ars_card_class.instance()
		var ars_data = ArtesGetter.get_ars(_ars_group, level)
		ars.paint(ars_data)
		list.add_child(ars)

func _on_CheckButton_pressed():
	paint(find_node("ShowAll").pressed)

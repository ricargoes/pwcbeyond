extends VBoxContainer

@export var editable = false
@export var ability_name = "ABILITY"

signal leveled_up
signal leveled_down
signal clicked(node)


func _ready():
	refresh()


func refresh():
	$StandardCounter.refresh()
	$Label/Label.text = ability_name
	if editable:
		$Label/Plus.show()
		$Label/Minus.show()
		$Label/Label.custom_minimum_size = Vector2(110, 0)
	else:
		$Label/Plus.hide()
		$Label/Minus.hide()
		$Label/Label.custom_minimum_size = Vector2(160, 0)


func set_level(level, min_level = 1):
	$StandardCounter.initial_level = min_level
	$StandardCounter.level = max(level, min_level)
	$StandardCounter.refresh()


func get_level():
	return $StandardCounter.level


func level_up():
	if $StandardCounter.level >= 5:
		return
	
	$StandardCounter.level += 1
	leveled_up.emit(self)
	refresh()


func level_down():
	if $StandardCounter.level <= $StandardCounter.initial_level:
		return
	
	$StandardCounter.level -= 1
	leveled_down.emit(self)
	refresh()


func set_editable(is_editable):
	editable = is_editable
	refresh()


func _on_ability_click(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit(self)


func set_indicator_name(new_name):
	ability_name = new_name


func get_indicator_name():
	return ability_name


func set_name_editable(is_editable):
	$Label/Label.editable = is_editable




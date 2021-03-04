extends Control

export var editable = false
export var status_name = "Status"
export var perm_level = 0

var temp_level = 0
var are_efforts_locked = false

signal clicked(node)
signal effort

func _ready():
	temp_level = perm_level
	refresh()

func refresh():
	$Label/Label.text = status_name
	if editable:
		$Label/Plus.show()
		$Label/Minus.show()
		find_node("Effort").show()
	else:
		$Label/Plus.hide()
		$Label/Minus.hide()
		find_node("Effort").hide()
	
	for i in range(1, 6):
		if i <= perm_level:
			$CenterContainer/Markers.get_node("p" + str(i)).fill()
		else:
			$CenterContainer/Markers.get_node("p" + str(i)).empty()
	
	for i in range(-3, 6):
		if temp_level < 0 and i < 0 and i >= temp_level:
			$CenterContainer/Markers.get_node("t" + str(i)).mark()
		elif temp_level > 0 and i > 0 and i <= temp_level:
			$CenterContainer/Markers.get_node("t" + str(i)).mark()
		elif i != 0:
			$CenterContainer/Markers.get_node("t" + str(i)).empty()


func set_editable(is_editable):
	editable = is_editable
	refresh()


func set_level(level, temp = null):
	perm_level = level
	if temp:
		temp_level = temp
	else:
		temp_level = perm_level
	refresh()


func get_level():
	return temp_level


func rest():
	if temp_level < 0:
		$SFXErase.play()
	elif temp_level < perm_level:
		$SFXDraw.play()
	temp_level = min(temp_level+1, perm_level)
	refresh()


func get_tired():
	var getting_tired = temp_level > -3
	if temp_level > 0:
		$SFXErase.play()
	elif temp_level > -3:
		$SFXDraw.play()
	temp_level = max(temp_level-1, -3)
	refresh()
	return getting_tired


func make_effort():
	if are_efforts_locked:
		return
	
	var getting_tired = get_tired()
	if getting_tired:
		emit_signal("effort")
		lock_efforts()


func lock_efforts():
	are_efforts_locked = true
	find_node("Effort").disabled = true


func unlock_efforts(_type):
	are_efforts_locked = false
	find_node("Effort").disabled = false


func get_name():
	return status_name


func get_penalty():
	var penalty
	if temp_level > -3:
		penalty = min(temp_level, 0)
	else:
		penalty = -100
	
	return penalty


func _on_tireness_click(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked", self)

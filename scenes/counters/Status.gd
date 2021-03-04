extends Control

export var editable = true
export var type = "Salud"
export var icon_colection = "health"

var damage_light = 0
var damage_heavy = 0
var max_damage = 0
var states = {}

func _ready():
	states = GameInfo.states[type]
	load_icons()
	generate_status()
	refresh()


func load_icons():
	$Label/Minus.texture_normal = load("res://resources/sprites/buttons/" + icon_colection + ".png")
	$Label/Minus.texture_pressed = load("res://resources/sprites/buttons/pressed_" + icon_colection + ".png")
	$Label/Plus.texture_normal = load("res://resources/sprites/buttons/" + icon_colection + "1.png")
	$Label/Plus.texture_pressed = load("res://resources/sprites/buttons/pressed_" + icon_colection + "1.png")
	$Label/PlusHeavy.texture_normal = load("res://resources/sprites/buttons/" + icon_colection + "2.png")
	$Label/PlusHeavy.texture_pressed = load("res://resources/sprites/buttons/pressed_" + icon_colection + "2.png")


func generate_status():
	$Label/Label.text = type
	var rombus_class = preload("res://scenes/counters/RombusPoint.tscn")
	var degrees_counter = 0
	for state in states:
		var state_name = Label.new()
		state_name.text = state["label"]
		$CenterContainer/States.add_child(state_name)
		var state_penalty = Label.new()
		state_penalty.text = state["penalty"]
		state_penalty.align = Label.ALIGN_RIGHT
		$CenterContainer/States.add_child(state_penalty)
		var degrees_container = HBoxContainer.new()
		degrees_container.name = "MarkersContainer"
		$CenterContainer/States.add_child(degrees_container)
		for _i in range(0, state["degrees"]):
			degrees_counter += 1
			var damage_marker = rombus_class.instance()
			damage_marker.name = "d"+str(degrees_counter)
			degrees_container.add_child(damage_marker)
	max_damage = degrees_counter


func refresh():
	if editable:
		$Label/Minus.show()
		$Label/Plus.show()
		$Label/PlusHeavy.show()
	else:
		$Label/Minus.hide()
		$Label/Plus.hide()
		$Label/PlusHeavy.hide()
	
	for i in range(1, max_damage + 1):
		var marker = $CenterContainer/States.find_node("*d"+str(i), true, false)
		if i <= damage_heavy:
			marker.cross()
		elif i <= damage_heavy + damage_light:
			marker.mark()
		else:
			marker.empty()


func set_editable(is_editable):
	editable = is_editable
	refresh()


func set_damage(new_damage_light, new_damage_heavy):
	damage_light = new_damage_light
	damage_heavy = new_damage_heavy
	refresh()

func hurt(heavy = true):
	if heavy or damage_heavy + damage_light + 1 > max_damage:
		damage_heavy = min(damage_heavy + 1, max_damage)
		$SFXHeavy.play()
		if damage_heavy + damage_light > max_damage:
			damage_light -= 1
	else:
		$SFXLight.play()
		damage_light = min(damage_light + 1, max_damage)
	refresh()

func heal():
	$SFXHeal.play()
	if damage_light > 0:
		damage_light -= 1
	else:
		damage_heavy = max(damage_heavy - 1, 0)
	refresh()


func get_penalty():
	var damage = damage_light + damage_heavy
	var penalty
	var degrees_count = 0
	for state in states:
		degrees_count += state["degrees"]
		if damage <= degrees_count:
			if state["penalty"] == "x":
				penalty = -100
			else:
				penalty = int(state["penalty"])
				break
	
	return penalty

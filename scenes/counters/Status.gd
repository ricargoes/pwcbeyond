extends Control

@export var editable = true
@export var type = "Salud"
@export var icon_colection = "health"

var states_damage = {}
var states = {}

func _ready():
	states = GameInfo.states[type]
	generate_status()
	refresh()

func generate_status():
	%Label.text = type
	var rombus_class = preload("res://scenes/counters/RombusPoint.tscn")
	for idx in range(states.size()):
		var state = states[idx]
		var plus_icon_level = "1" if idx == 0 else "2"
		var state_name = state["label"]
		var state_label = Label.new()
		state_label.text = state_name
		%States.add_child(state_label)
		var minus = TextureButton.new()
		minus.texture_normal = load("res://resources/sprites/buttons/" + icon_colection + ".png")
		minus.texture_pressed = load("res://resources/sprites/buttons/pressed_" + icon_colection + ".png")
		var plus = TextureButton.new()
		plus.texture_normal = load("res://resources/sprites/buttons/" + icon_colection + plus_icon_level + ".png")
		plus.texture_pressed = load("res://resources/sprites/buttons/pressed_" + icon_colection + plus_icon_level + ".png")
		plus.pressed.connect(hurt.bind(state_name))
		minus.pressed.connect(heal.bind(state_name))
		var state_controls = HBoxContainer.new()
		minus.add_to_group("status_damage")
		plus.add_to_group("status_damage")
		state_controls.add_child(minus)
		state_controls.add_child(plus)
		%States.add_child(state_controls)
		var degrees_container = GridContainer.new()
		degrees_container.columns = 5
		degrees_container.name =  state_name + "Markers"
		%States.add_child(degrees_container)
		for n_counter in range(0, state["degrees"]):
			var damage_marker = rombus_class.instantiate()
			damage_marker.name = "d"+str(n_counter + 1)
			degrees_container.add_child(damage_marker)


func refresh():
	if editable:
		get_tree().call_group("status_damage", "show")
	else:
		get_tree().call_group("status_damage", "hide")
	
	for state in states:
		var state_name = state["label"]
		var markers_cont = %States.get_node(state_name + "Markers")
		for i in range(1, state["degrees"] + 1):
			var marker = markers_cont.get_node("d"+str(i))
			if i <= states_damage.get(state_name, 0):
				marker.cross()
			else:
				marker.is_empty()


func set_editable(is_editable):
	editable = is_editable
	refresh()


func set_damage(new_states_damage):
	states_damage = new_states_damage
	refresh()


func hurt(state_name):
	var relevant_state = {}
	for state in states:
		if state["label"] == state_name:
			relevant_state = state
			break
	var max_damage = relevant_state["degrees"]
	states_damage[state_name] = min(states_damage.get(state_name, 0) + 1, max_damage)
	$SFXHeavy.play()
	refresh()


func heal(state_name):
	$SFXHeal.play()
	states_damage[state_name] = max(states_damage[state_name] - 1, 0)
	refresh()


func get_penalty():
	return 0

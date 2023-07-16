extends Control


var skill_points = 30
var access_points = 4
var max_access_points = 4
var max_artes_points = 4

var _count_access_points = 0
var _count_artes_points = 0

var _char_type = ""

func _ready():
	%Version.select(1)
	paint_atributes()
	paint_skills()
	paint_plane_manipulation()


func paint_atributes():
	var feature_type = "atributes"
	var item_levels = GameInfo.version_skill_template[get_sheet_version()][feature_type]
	Helper.build_ability_tree(feature_type, %Atributes, item_levels)
	get_tree().call_group(feature_type, "connect", "leveled_up", update_atribute_points)
	get_tree().call_group(feature_type, "connect", "leveled_down", update_atribute_points)


func paint_skills():
	var feature_type = "skills"
	var item_levels = GameInfo.version_skill_template[get_sheet_version()][feature_type]
	Helper.build_ability_tree(feature_type, find_child("Skills"), item_levels)
	
	for group_containers in find_child("Skills").get_children():
		var group = group_containers.name
		var node = ResourceManager.ability_counter_class.instantiate()
		node.ability_name = ""
		node.editable = true
		node.set_level(0, 0)
		node.set_name_editable(true)
		node.add_to_group(group.to_lower())
		node.add_to_group(feature_type)
		group_containers.add_child(node)
	
	skill_points = 30
	get_tree().call_group(feature_type, "connect", "leveled_up", update_skill_points.bind(true))
	get_tree().call_group(feature_type, "connect", "leveled_down", update_skill_points.bind(false))


func paint_plane_manipulation():
	for access in ["Ego", "Quod", "Scientia", "Opus"]:
		var access_node = find_child(access)
		access_node.connect("leveled_up", update_access_points.bind(true))
		access_node.connect("leveled_down", update_access_points.bind(false))


func rollback_ability(ability, is_atribute = false):
	ability.set_level(ability.get_level() - 1, 1 if is_atribute else 0)


func update_atribute_points(last_updates_atribute):
	
	var levels_by_group = {}
	var atribute_groups = find_child("Atributes").get_children()
	for atribute_group in atribute_groups:
		levels_by_group[atribute_group.name] = 0
		for atribute in atribute_group.get_children():
			if atribute.has_method("get_level"):
				levels_by_group[atribute_group.name] += atribute.get_level()
	
	var atributes_sorted = []
	for _i in range(0, atribute_groups.size()):
		var max_value = 0
		var atribute_winning
		for atribute_group in atribute_groups:
			if levels_by_group[atribute_group.name] >= max_value:
				atribute_winning = atribute_group
				max_value = levels_by_group[atribute_group.name]
		atributes_sorted.append(atribute_winning.name)
		atribute_groups.erase(atribute_winning)
	
	
	var extra_point_available = true
	var primary_atribute = atributes_sorted.pop_front()
	if levels_by_group[primary_atribute] > 10:
		$Warning.send_warning("Los atributos primarios no pueden tener más de 6 puntos repartidos, 7 con el extra")
		rollback_ability(last_updates_atribute, true)
		return
	elif levels_by_group[primary_atribute] == 10:
		extra_point_available = false
	
	var secondary_atribute = atributes_sorted.pop_front()
	if levels_by_group[secondary_atribute] > 8:
		$Warning.send_warning("Los atributos secundarios no pueden tener más de 4 puntos repartidos, 5 con el extra")
		rollback_ability(last_updates_atribute, true)
		return
	elif levels_by_group[secondary_atribute] == 8:
		if extra_point_available:
			extra_point_available = false
		else:
			$Warning.send_warning("Los atributos secundarios no pueden tener más de 4 puntos repartidos, y el punto extra ya está repartido en los atributos primarios")
			rollback_ability(last_updates_atribute, true)
			return
	
	for _i in range(0, atributes_sorted.size()):
		var other_atributes = atributes_sorted.pop_front()
		if levels_by_group[other_atributes] > 6:
			$Warning.send_warning("Los atributos terciarios no pueden tener más de 2 puntos repartidos, 3 con el extra")
			rollback_ability(last_updates_atribute, true)
			return
		elif levels_by_group[other_atributes] == 6:
			if extra_point_available:
				extra_point_available = false
			else:
				$Warning.send_warning("Los atributos terciarios no pueden tener más de 2 puntos repartidos, y el punto extra ya está repartido en los atributos primarios o secundarios")
				rollback_ability(last_updates_atribute, true)
				return


func update_skill_points(last_updated_ability, going_up):
	var new_ability_level = last_updated_ability.get_level()
	var points_spent = new_ability_level
	if going_up:
		if points_spent > skill_points:
			rollback_ability(last_updated_ability)
			$Warning.send_warning("No te quedan suficientes puntos para este nivel")
		else:
			skill_points -= points_spent
	else:
		skill_points += points_spent + 1
	
	find_child("PointsLeft").text = "Quedan " + str(skill_points) + "puntos"


func _hide_everything():
	find_child("SheetInfo").hide()
	find_child("SheetDescription").hide()
	find_child("SheetAtributes").hide()
	find_child("SheetSkills").hide()
	find_child("SheetPlaneManipulation").hide()


func info_form_ok():
	if %Chronicle.text == "":
		$Warning.send_warning("El campo Crónica no debe estar vacío")
	elif %Player.text == "":
		$Warning.send_warning("El campo Jugador no debe estar vacío")
	elif %Name.text == "":
		$Warning.send_warning("El campo Nombre no debe estar vacío")
	else:
		return true
	
	return false

func get_sheet_version():
	return %Version.get_item_text(%Version.get_selected_items()[0])


func _on_Version_item_selected(_index):
	paint_atributes()
	paint_skills()


func _on_Human_pressed():
	if info_form_ok():
		_char_type = "human"
		description_phase()


func _on_Planewalker_pressed():
	if info_form_ok():
		_char_type = "planewalker"
		description_phase()

func info_phase():
	_hide_everything()
	find_child("SheetInfo").show()
	%Version.mouse_filter = Control.MOUSE_FILTER_STOP

func description_phase():
	_hide_everything()
	find_child("SheetDescription").show()
	%Version.mouse_filter = Control.MOUSE_FILTER_IGNORE

func atributes_phase():
	_hide_everything()
	find_child("SheetAtributes").show()

func skills_phase():
	_hide_everything()
	find_child("SheetSkills").show()
	if _char_type != "planewalker":
		find_child("SheetSkills").find_child("Next").text = "Fin"
	else:
		find_child("SheetSkills").find_child("Next").text = "Siguiente"

func plane_manipulation_phase():
	if _char_type == "planewalker":
		var vias_options = find_child("Via")
		if vias_options.get_item_count() == 0:
			$GET.connect("request_completed", Callable(self, "_on_get_vias_request_completed"))
			$GET.request(GameInfo.vias_table_url,
				PackedStringArray(["accept: application/json", "Range-Unit: items"]),
				HTTPClient.METHOD_GET
				)
			find_child("InstructionsAccessL").text = "Quedan " + str(max_access_points-_count_access_points) + " puntos por repartir"
		
		_hide_everything()
		find_child("SheetPlaneManipulation").show()
	else:
		finish()


func _on_get_vias_request_completed(_result, _response_code, _headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var vias = test_json_conv.get_data()
	var vias_options = find_child("Via")
	vias_options.clear()
	for via in vias:
		vias_options.add_item(via["name"])
	
	$GET.disconnect("request_completed", Callable(self, "_on_get_vias_request_completed"))


func _on_Via_item_selected(id):
	var vias_options = find_child("Via")
	var via_name = vias_options.get_item_text(id)
	$GET.connect("request_completed", Callable(self, "_on_get_artes_request_completed"))
	$GET.request(GameInfo.vias_to_artes_table_url + "?via_name=eq." + via_name,
		PackedStringArray(["accept: application/json", "Range-Unit: items"]),
		HTTPClient.METHOD_GET
		)


func _on_get_artes_request_completed(_result, _response_code, _headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var vias_artes = test_json_conv.get_data()
	var artes_node = find_child("Artes")
	Helper.remove_children(find_child("Artes"))
	for via_arte in vias_artes:
		var ars_name = via_arte["ars_group_name"]
		var ars = ResourceManager.ability_counter_class.instantiate()
		ars.name = ars_name
		ars.ability_name = ars_name
		ars.editable = true
		ars.set_level(0, 0)
		ars.connect("leveled_up", update_artes_points.bind(true))
		ars.connect("leveled_down", update_artes_points.bind(false))
		ars.connect("clicked", Callable($ArtesReference, "launch").bind(true))
		artes_node.add_child(ars)
	_count_artes_points = 0
	find_child("InstructionsAccessL").text = "Quedan " + str(max_artes_points-_count_artes_points) + " puntos por repartir"
	
	$GET.disconnect("request_completed", Callable(self, "_on_get_artes_request_completed"))


func update_artes_points(last_updated_ability, going_up):
	if going_up:
		if _count_artes_points < max_artes_points:
			_count_artes_points += 1
		else:
			rollback_ability(last_updated_ability)
	else:
		_count_artes_points -= 1
	
	find_child("InstructionsArtesL").text = "Quedan " + str(max_artes_points-_count_artes_points) + " puntos por repartir"


func update_access_points(last_updated_ability, going_up):
	if going_up:
		if _count_access_points < max_access_points:
			_count_access_points += 1
		else:
			rollback_ability(last_updated_ability)
	else:
		_count_access_points -= 1
	
	find_child("InstructionsAccessL").text = "Quedan " + str(max_access_points-_count_access_points) + " puntos por repartir"


func finish():
	var character = load("res://scenes/classes/Character.tscn").instantiate()
	character.set_id(self)
	character.save_human_side(self)
	character.save_planewalker_side(self)
	character.initialize_status()
	CharactersGetter.insert_character(character)
	get_tree().change_scene_to_file("res://scenes/screens/MainMenu.tscn")


func _on_Exit_pressed():
	get_tree().change_scene_to_file("res://scenes/screens/MainMenu.tscn")



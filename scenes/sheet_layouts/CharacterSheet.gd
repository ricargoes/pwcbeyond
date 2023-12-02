extends Control

var sheet_layouts = {
	'desktop': [
		"WebSheetLayout",
		"DashboardLayout"
	],
	'mobile': [
		"WebSheetLayout"
	]
}

var character = null

var vigor
var concentracion
var coherencia
var salud
var cordura

func _ready():
	if not character:
		character = GameInfo.load_character()
	salud = find_child("Salud")
	cordura = find_child("Cordura")
	vigor = find_child("Vigor")
	concentracion = find_child("Concentracion")
	coherencia = find_child("Coherencia")
	vigor.effort.connect(character.effort.bind("físicos"))
	concentracion.effort.connect(character.effort.bind("mentales"))
	coherencia.effort.connect(character.effort.bind("plane_manipulation"))
	character.effort_spended.connect(vigor.unlock_efforts)
	character.effort_spended.connect(concentracion.unlock_efforts)
	character.effort_spended.connect(coherencia.unlock_efforts)
	%RollTool.set_roller(character)
	%RollTool.set_health(salud)
	%RollTool.set_tireness("físicos", vigor)
	%RollTool.set_tireness("mentales", concentracion)
	%RollTool.set_tireness("plane_manipulation", coherencia)
	build_sheet()

func build_sheet():
	clean()
	randomize()
	choose_logo()
	paint_info()
	paint_atributes()
	paint_skills()
	paint_plane_manipulation()
	paint_status()


func clean():
	Helper.remove_children(%Atributes)
	Helper.remove_children(%Skills)
	Helper.remove_children(%Artes)


func autosave():
	if %AutosaveCheck.button_pressed:
		save_changes()
		commit_changes()
		%AutosaveCheck.get_node("CPUParticles2D").emitting = true


func save_changes():
	character.save_human_side(self)
	character.save_status(self)
	character.save_planewalker_side(self)

func commit_changes():
	var post_data = { "character_stats": character.get_data_dict() }
	CharactersGetter.update_character(character.chronicle, character.player_name, character.char_name, post_data)


func choose_logo():
	var possible_logos = [
		preload("res://resources/logos/PWC-logo-fighting_man.png"),
		preload("res://resources/logos/PWC-logo-running_man.png"),
		preload("res://resources/logos/PWC-logo-tentacles.png"),
		preload("res://resources/logos/PWC-logo-ESA_tentacle.png"),
		preload("res://resources/logos/PWC-logo-ESA.png"),
		preload("res://resources/logos/PWC-logo-scroll.png"),
		preload("res://resources/logos/PWC-logo-liberty.png"),
		preload("res://resources/logos/PWC-logo-top-spaceships.png"),
		preload("res://resources/logos/PWC-logo-top-dragons.png"),
		preload("res://resources/logos/PWC-logo-top-mountain.png"),
		preload("res://resources/logos/PWC-logo-top-tentacles.png")
	]
	var logo = possible_logos[randi() % possible_logos.size()]
	%Logo.texture = logo

func paint_info():
	%Player.text = character.player_name
	%Chronicle.text = character.chronicle
	%Name.text = character.char_name
	
	%Job.text = character.bio["job"]
	%Species.text = character.bio["species"]
	%Age.text = character.bio["age"]
	
	%XP.text = character.status["xp"]
	%EP.text = character.status["ep"]

	%Looks.text = character.bio["looks"]
	%Personality.text = character.bio["personality"]
	%Past.text = character.bio["past"]
	%Motivation.text = character.bio["motivation"]


func paint_atributes():
	var feature_type = "atributes"
	Helper.build_ability_tree(%Atributes, feature_type, character.version, 1, false, character.atributes)
	get_tree().call_group(feature_type, "connect", "clicked", %RollTool.select_atribute)


func paint_skills():
	var feature_type = "skills"
	Helper.build_ability_tree(%Skills, feature_type, character.version, 0, false, character.skills)
	get_tree().call_group(feature_type, "connect", "clicked", %RollTool.select_skill)


func paint_plane_manipulation():
	var char_pm = character.plane_manipulation
	
	var modus = %PlaneManipulation.find_child("Modus")
	var via = %PlaneManipulation.find_child("Via")
	modus.text = char_pm["modus"]
	via.text = char_pm["via"]
	
	var aspects = char_pm["aspects"]
	for i in range(0, min(aspects.size(), 2)):
		var aspect = %PlaneManipulation.find_child("Aspect"+str(i+1))
		aspect.text = aspects[i]
	
	var iter = %PlaneManipulation.find_child("Journey")
	iter.set_level(char_pm["journey"], 0)
	
	var access = char_pm["access"]
	for access_name in ["Ego", "Quod", "Scientia", "Opus"]:
		var node = %PlaneManipulation.find_child(access_name)
		node.set_level(access[access_name.to_lower()], 0)
		node.add_to_group("plane_manipulation")
	
	var artes = char_pm["artes"]
	if artes.keys().size() > 4:
		%Artes.columns = 3
		%Artes.set("theme_override_constants/h_separation", -15)
	for ars_name in artes.keys():
		var ars = ResourceManager.ability_counter_class.instantiate()
		ars.name = ars_name
		ars.ability_name = ars_name
		ars.set_level(artes[ars_name], 0)
		%Artes.add_child(ars)
		ars.connect("clicked", Callable(find_child("ArtesReference"), "launch"))

func paint_status():
	var sheet_status = character.status
	vigor.set_level(sheet_status["Vigor"]["perm"], sheet_status["Vigor"]["temp"])
	concentracion.set_level(sheet_status["Concentración"]["perm"], sheet_status["Concentración"]["temp"])
	
	salud.set_damage(sheet_status["Salud"])
	cordura.set_damage(sheet_status["Cordura"])
	
	if not character.plane_manipulation.is_empty():
		coherencia.set_level(sheet_status["Coherencia"]["perm"], sheet_status["Coherencia"]["temp"])


func _on_EditarCheck_pressed():
	var make_editable = %EditCheck.button_pressed
	get_tree().call_group("features", "set_editable", make_editable)
	get_tree().call_group("editable_lineedits", "set_editable", make_editable)
	get_tree().call_group("editable_textedits", "set_readonly", not make_editable)
	var new_focus_mode = Control.FOCUS_ALL if make_editable else Control.FOCUS_NONE
	get_tree().call_group("editable_lineedits", "set_focus_mode", new_focus_mode)
	get_tree().call_group("editable_textedits", "set_focus_mode", new_focus_mode)


func _on_Delete_pressed():
	find_child("ConfirmationPopup").popup_centered()


func _on_Confirmation_pressed():
	$Autosave.stop()
	CharactersGetter.delete_character(character.chronicle, character.player_name, character.char_name)
	exit()


func _on_Exit_pressed():
	exit()


func exit():
	get_tree().change_scene_to_file("res://scenes/screens/MainMenu.tscn")


func change_layout():
	var platform = 'mobile' if OS.get_name() in ["Android", "iOS"] else 'desktop'
	var layouts = sheet_layouts[platform]
	var new_layout = layouts[(layouts.find(name) + 1) % layouts.size()]
	GameInfo.next_character = character
	get_tree().change_scene_to_file("res://scenes/sheet_layouts/"+new_layout+".tscn")


func _on_Logo_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		choose_logo()


func _on_InventoryButton_pressed():
	%Inventory.initialize(character)
	%Inventory.popup_centered()

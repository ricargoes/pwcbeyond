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
onready var roll_tool = find_node("RollTool")
onready var inventory = find_node("Inventory")

onready var atributes_panel = find_node("Atributes")
onready var skills_panel = find_node("Skills")
onready var plane_manipulation_panel = find_node("PlaneManipulation")
onready var artes_node = find_node("Artes")

var vigor
var voluntad
var coherencia
var salud
var cordura

onready var player_tb = find_node("Player")
onready var chronicle_tb = find_node("Chronicle")
onready var name_tb = find_node("Name")
onready var job_tb = find_node("Job")
onready var species_tb = find_node("Species")
onready var age_tb = find_node("Age")
onready var xp_tb = find_node("XP")
onready var ep_tb = find_node("EP")
onready var looks_tb = find_node("Looks")
onready var personality_tb = find_node("Personality")
onready var past_tb = find_node("Past")
onready var motivation_tb = find_node("Motivation")


func _ready():
	if not character:
		character = GameInfo.load_character()
	salud = find_node("Salud")
	cordura = find_node("Cordura")
	vigor = find_node("Vigor")
	voluntad = find_node("Voluntad")
	coherencia = find_node("Coherencia")
	vigor.connect("effort", character, "effort", ["físicos"])
	voluntad.connect("effort", character, "effort", ["mentales"])
	coherencia.connect("effort", character, "effort", ["plane_manipulation"])
	character.connect("effort_spended", vigor, "unlock_efforts")
	character.connect("effort_spended", voluntad, "unlock_efforts")
	character.connect("effort_spended", coherencia, "unlock_efforts")
	roll_tool.set_roller(character)
	roll_tool.set_health(salud)
	roll_tool.set_tireness("físicos", vigor)
	roll_tool.set_tireness("mentales", voluntad)
	roll_tool.set_tireness("plane_manipulation", coherencia)
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
	Helper.remove_children(atributes_panel)
	Helper.remove_children(skills_panel)
	Helper.remove_children(artes_node)


func autosave():
	var autosave_check = find_node("AutosaveCheck")
	if autosave_check.pressed:
		save_changes()
		commit_changes()
		autosave_check.get_node("CPUParticles2D").emitting = true


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
	find_node("Logo").texture = logo

func paint_info():
	player_tb.text = character.player_name
	chronicle_tb.text = character.chronicle
	name_tb.text = character.char_name
	
	job_tb.text = character.bio["job"]
	species_tb.text = character.bio["species"]
	age_tb.text = character.bio["age"]
	
	xp_tb.text = character.status["xp"]
	ep_tb.text = character.status["ep"]

	looks_tb.text = character.bio["looks"]
	personality_tb.text = character.bio["personality"]
	past_tb.text = character.bio["past"]
	motivation_tb.text = character.bio["motivation"]


func paint_atributes():
	var feature_type = "atributes"
	Helper.build_ability_tree(feature_type, atributes_panel, character.atributes, false)
	get_tree().call_group(feature_type, "connect", "clicked", roll_tool, "select_atribute")


func paint_skills():
	var feature_type = "skills"
	Helper.build_ability_tree(feature_type, skills_panel, character.skills, false)
	get_tree().call_group(feature_type, "connect", "clicked", roll_tool, "select_skill")


func paint_plane_manipulation():
	var char_pm = character.plane_manipulation
	
	var modus = plane_manipulation_panel.find_node("Modus")
	var via = plane_manipulation_panel.find_node("Via")
	modus.text = char_pm["modus"]
	via.text = char_pm["via"]
	
	var aspects = char_pm["aspects"]
	for i in range(0, min(aspects.size(), 2)):
		var aspect = plane_manipulation_panel.find_node("Aspect"+str(i+1))
		aspect.text = aspects[i]
	
	var iter = plane_manipulation_panel.find_node("Journey")
	iter.set_level(char_pm["journey"], 0)
	
	var access = char_pm["access"]
	for access_name in ["Ego", "Quod", "Scientia", "Opus"]:
		var node = plane_manipulation_panel.find_node(access_name)
		node.set_level(access[access_name.to_lower()], 0)
		node.add_to_group("plane_manipulation")
	
	var artes = char_pm["artes"]
	if artes.keys().size() > 4:
		artes_node.columns = 3
		artes_node.set("custom_constants/hseparation", -15)
	for ars_name in artes.keys():
		var ars = ResourceManager.ability_counter_class.instance()
		ars.name = ars_name
		ars.ability_name = ars_name
		ars.set_level(artes[ars_name], 0)
		artes_node.add_child(ars)
		ars.connect("clicked", find_node("ArtesReference"), "launch")

func paint_status():
	var sheet_status = character.status
	vigor.set_level(sheet_status["Vigor"]["perm"], sheet_status["Vigor"]["temp"])
	voluntad.set_level(sheet_status["Voluntad"]["perm"], sheet_status["Voluntad"]["temp"])
	
	salud.set_damage(sheet_status["Salud"]["light"],sheet_status["Salud"]["heavy"])
	cordura.set_damage(sheet_status["Cordura"]["light"],sheet_status["Cordura"]["heavy"])
	
	if not character.plane_manipulation.empty():
		coherencia.set_level(sheet_status["Coherencia"]["perm"], sheet_status["Coherencia"]["temp"])


func _on_EditarCheck_pressed():
	var edit_check = find_node("EditCheck")
	get_tree().call_group("features", "set_editable", edit_check.pressed)
	get_tree().call_group("editable_lineedits", "set_editable", edit_check.pressed)
	get_tree().call_group("editable_textedits", "set_readonly", not edit_check.pressed)
	var new_focus_mode = Control.FOCUS_ALL if edit_check.pressed else Control.FOCUS_NONE
	get_tree().call_group("editable_lineedits", "set_focus_mode", new_focus_mode)
	get_tree().call_group("editable_textedits", "set_focus_mode", new_focus_mode)


func _on_Delete_pressed():
	find_node("ConfirmationPopup").popup_centered()


func _on_Confirmation_pressed():
	$Autosave.stop()
	CharactersGetter.delete_character(character.chronicle, character.player_name, character.char_name)
	exit()


func _on_Exit_pressed():
	exit()


func exit():
	get_tree().change_scene("res://scenes/screens/MainMenu.tscn")


func change_layout():
	var platform = 'mobile' if OS.get_name() in ["Android", "iOS"] else 'desktop'
	var layouts = sheet_layouts[platform]
	var new_layout = layouts[(layouts.find(name) + 1) % layouts.size()]
	GameInfo.next_character = character
	get_tree().change_scene("res://scenes/sheet_layouts/"+new_layout+".tscn")


func _on_Logo_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		choose_logo()


func _on_InventoryButton_pressed():
	inventory.initialize(character)
	inventory.popup_centered()

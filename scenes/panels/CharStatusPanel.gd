extends Control


var character = null

@onready var salud_node = find_child("Salud")
@onready var cordura_node = find_child("Cordura")
@onready var vigor_node = find_child("Vigor")
@onready var voluntad_node = find_child("Voluntad")
@onready var coherencia_node = find_child("Coherencia")

func _ready():
	CharactersGetter.connect("cache_refreshed", Callable(self, "refresh_ui"))


func set_character(new_character):
	character = new_character
	make_ui_editable(false)
	refresh_char()


func clear_character():
	set_character(null)


func refresh_char():
	if character:
		CharactersGetter.request_character(character.chronicle, character.player_name, character.char_name)


func refresh_ui(_characters_refreshed):
	if not character:
		find_child("Name").text = "Sin personaje"
		find_child("DataBox").hide()
		return
	else:
		find_child("DataBox").show()
		character = CharactersGetter.get_character(character.chronicle, character.player_name, character.char_name)
		find_child("Name").text = character.char_name + " [" + character.player_name + "]"
		var char_status = character.status
		vigor_node.set_level(char_status["Vigor"]["perm"], char_status["Vigor"]["temp"])
		voluntad_node.set_level(char_status["Voluntad"]["perm"], char_status["Voluntad"]["temp"])
		if char_status.has("Coherencia"):
			coherencia_node.set_level(char_status["Coherencia"]["perm"], char_status["Coherencia"]["temp"])
			coherencia_node.show()
		else:
			coherencia_node.hide()
		
		salud_node.set_damage(char_status["Salud"]["light"],char_status["Salud"]["heavy"])
		cordura_node.set_damage(char_status["Cordura"]["light"],char_status["Cordura"]["heavy"])


func make_ui_editable(do_it):
	salud_node.set_editable(do_it)
	cordura_node.set_editable(do_it)
	vigor_node.set_editable(do_it)
	voluntad_node.set_editable(do_it)
	coherencia_node.set_editable(do_it)


func _on_Name_clicked(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if character:
			var full_character_sheet = load("res://scenes/sheet_layouts/WebSheetLayout.tscn").instantiate()
			full_character_sheet.character = character
			var exit_button = full_character_sheet.find_child("Exit")
			exit_button.disconnect("pressed", Callable(full_character_sheet, "_on_Exit_pressed"))
			exit_button.connect("pressed", Callable(self, "_on_CharSheetExit_pressed"))
			full_character_sheet.find_child("AutosaveCheck").button_pressed = false
			full_character_sheet.find_child("Delete").queue_free()
			full_character_sheet.find_child("EditL").queue_free()
			full_character_sheet.find_child("EditCheck").queue_free()
			$CharSheet.add_child(full_character_sheet)
			$CharSheet.popup_centered()


func _on_CharSheetExit_pressed():
	$CharSheet.hide()
	Helper.remove_children($CharSheet)


func _on_EditBut_pressed():
	if find_child("EditBut").button_pressed:
		$RefreshInterval.stop()
		make_ui_editable(true)
	else:
		$RefreshInterval.start()
		make_ui_editable(false)

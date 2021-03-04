extends Control

onready var character_finder = $CharacterFinder
onready var master_screen = find_node("MasterScreen")

onready var char_sheet_cards = [
	master_screen.find_node("Char1"),
	master_screen.find_node("Char2"),
	master_screen.find_node("Char3"),
	master_screen.find_node("Char4"),
	master_screen.find_node("Char5"),
	master_screen.find_node("Char6")
]

func character_finder_view():
	character_finder.show()
	master_screen.hide()


func master_screen_view():
	character_finder.hide()
	master_screen.show()


func clear_character_selection():
	for char_sheet_card in char_sheet_cards:
		char_sheet_card.clear_character()


func _on_CharacterFinder_ok(selected_chars):
	if selected_chars.size() == 0:
		$Warning.send_warning("Encuentra y selecciona varios personajes primero.")
		return
	else:
		clear_character_selection()
		for i in range(0, min(selected_chars.size(), char_sheet_cards.size())):
			var character = selected_chars[i]
			char_sheet_cards[i].set_character(character)
		master_screen_view()


func _on_CharacterFinder_back():
	get_tree().change_scene("res://scenes/screens/MainMenu.tscn")


func _on_Exit_pressed():
	character_finder_view()

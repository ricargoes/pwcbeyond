extends Control


func _on_CharacterFinder_ok(selected_chars):
	if selected_chars.size() == 0:
		$Warning.send_warning("Encuentra y selecciona un personaje primero.")
		return
	else:
		GameInfo.next_character = selected_chars.front()
		get_tree().change_scene("res://scenes/sheet_layouts/WebSheetLayout.tscn")


func _on_CharacterFinder_back():
	get_tree().change_scene("res://scenes/screens/MainMenu.tscn")

extends Control

func _on_CreateChar_pressed():
	get_tree().change_scene("res://scenes/screens/CharacterCreation.tscn")


func _on_GetCharSheet_pressed():
	get_tree().change_scene("res://scenes/screens/CharacterSelection.tscn")


func _on_MasterMode_pressed():
	get_tree().change_scene("res://scenes/screens/MasterMode.tscn")


func _on_Quit_pressed():
	get_tree().quit()


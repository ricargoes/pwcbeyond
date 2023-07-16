extends CenterContainer

@onready var char_list = $VBoxContainer/PosibleChars

@export var multiple_selection = false

signal ok(selected_characters)
signal back()

func _ready():
	char_list.clear()
	$VBoxContainer/PosibleChars.select_mode = ItemList.SELECT_MULTI if multiple_selection else ItemList.SELECT_SINGLE


func _on_SearchButton_pressed():
	var search_text = $VBoxContainer/SearchCont/SearchLine.text
	char_list.clear()
	CharactersGetter.search(search_text)
	CharactersGetter.connect("cache_refreshed", Callable(self, "populate_list"))


func populate_list(characters):
	for character in characters:
		char_list.add_item(character.chronicle + " --- " + character.player_name + " --- " + character.char_name)


func _on_Ok_pressed():
	var selected_chars = char_list.get_selected_items()
	var chars_info = []
	for selected_char in selected_chars:
		var char_info = char_list.get_item_text(selected_char).split(" --- ")
		chars_info.append(CharactersGetter.get_character(char_info[0], char_info[1], char_info[2]))
	emit_signal("ok", chars_info)


func _on_Back_pressed():
	emit_signal("back")

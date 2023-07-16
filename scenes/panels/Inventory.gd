extends Popup

@onready var item_inventory = find_child("Items")
@onready var weapon_inventory = find_child("Weapons")

@onready var weapon_choice = find_child("AddWeaponChoice")

@onready var item_card = find_child("ItemCard")
@onready var weapon_card = find_child("WeaponCard")

var owned_items = {}
var owned_weapons = {}

var inventory_owner = null


func initialize(character):
	inventory_owner = character
	
	item_inventory.clear()
	weapon_inventory.clear()
	
	owned_items = inventory_owner.get_equipment()["items"]
	owned_weapons = inventory_owner.get_equipment()["weapons"]
	
	var weapons = WeaponsGetter.get_all()
	var weapon_classes = weapons.keys()
	weapon_classes.sort()
	for weapon_class in weapon_classes:
		var weapon_list = weapons[weapon_class].keys()
		weapon_list.sort()
		for weapon_name in weapon_list:
			var weapon_reference = make_weapon_string(weapon_class, weapon_name)
			weapon_choice.add_item(weapon_reference)
	
	var owned_item_list = owned_items.keys()
	owned_item_list.sort()
	item_inventory.clear()
	for reference in owned_item_list:
		item_inventory.add_item(reference)
	
	weapon_inventory.clear()
	var owned_weapons_class_list = owned_weapons.keys()
	owned_weapons_class_list.sort()
	for weapon_class in owned_weapons_class_list:
		var weapon_list = owned_weapons[weapon_class]
		weapon_list.sort()
		for weapon_name in weapon_list:
			weapon_inventory.add_item(make_weapon_string(weapon_class, weapon_name))


func make_weapon_string(weapon_class, weapon_name):
	return weapon_class + " - " + weapon_name


func paint_item_card(item_name, item_description):
	item_card.find_child("ItemName").text = item_name
	item_card.find_child("ItemDescription").text = item_description


func _on_AddItemButton_pressed():
	var item_line_edit = find_child("AddItemEdit")
	var item_description_edit = find_child("AddItemDescription")
	item_inventory.add_item(item_line_edit.text)
	owned_items[item_line_edit.text] = item_description_edit.text
	item_line_edit.text = ""
	item_description_edit.text = ""


func _on_AddWeaponButton_pressed():
	var weapon_string = weapon_choice.get_item_text(weapon_choice.get_selected())
	weapon_inventory.add_item(weapon_string)
	var weapon_descriptor = weapon_string.split(" - ")
	if not owned_weapons.has(weapon_descriptor[0]):
		owned_weapons[weapon_descriptor[0]] = []
	owned_weapons[weapon_descriptor[0]].append(weapon_descriptor[1])


func _on_RemoveWeapon_pressed():
	var selected = weapon_inventory.get_selected_items()
	if selected.size() > 0:
		var weapon_descriptor = weapon_inventory.get_item_text(selected[0]).split(" - ")
		owned_weapons[weapon_descriptor[0]].erase(weapon_descriptor[1])
		weapon_inventory.remove_item(selected[0])


func _on_RemoveItem_pressed():
	var selected = item_inventory.get_selected_items()
	if selected.size() > 0:
		var removed_item = item_inventory.get_item_text(selected[0])
		owned_items.erase(removed_item)
		item_inventory.remove_item(selected[0])


func _on_Items_item_selected(index):
	weapon_card.get_parent().hide()
	var item_name = item_inventory.get_item_text(index)
	paint_item_card(item_name, owned_items[item_name])
	item_card.get_parent().show()


func _on_Weapons_item_selected(index):
	item_card.get_parent().hide()
	weapon_inventory.get_item_text(index)
	var weapon_string = weapon_inventory.get_item_text(index)
	var weapon_descriptor = weapon_string.split(" - ")
	weapon_card.paint(WeaponsGetter.get_weapon(weapon_descriptor[0], weapon_descriptor[1]))
	weapon_card.get_parent().show()


func commit_equipment():
	var inventory_data = { "items": owned_items, "weapons": owned_weapons }
	var post_data = {
		"character_inventory": inventory_data
		}
	CharactersGetter.update_character(inventory_owner.chronicle, inventory_owner.player_name, inventory_owner.char_name, post_data)

extends NinePatchRect

func paint(weapon_data):
	find_node("Name").text = weapon_data["name"]
	find_node("WeaponClass").text = weapon_data["weapon_class_name"]
	find_node("Proficiency").initial_level = weapon_data["proficiency"]
	find_node("Proficiency").refresh()
	find_node("DamageType").text = "Letal" if weapon_data["is_lethal_damage"] else "Contundente"
	find_node("IsRanged").text = "A distancia" if weapon_data["is_ranged"] else "Melee"
	find_node("Range").text = weapon_data["weapon_range"]
	find_node("BaseDamage").text = str(weapon_data["base_damage"])
	find_node("IncrementDamage").text = str(weapon_data["increment_damage"])
	find_node("Description").text = weapon_data["description"]
	if weapon_data["ammo"] == 0:
		find_node("AmmoContainer").hide()
	else:
		find_node("Ammo").text = str(weapon_data["ammo"])
		find_node("AmmoContainer").show()

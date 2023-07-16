extends NinePatchRect

func paint(weapon_data):
	find_child("Name").text = weapon_data["name"]
	find_child("WeaponClass").text = weapon_data["weapon_class_name"]
	find_child("Proficiency").initial_level = weapon_data["proficiency"]
	find_child("Proficiency").refresh()
	find_child("DamageType").text = "Letal" if weapon_data["is_lethal_damage"] else "Contundente"
	find_child("IsRanged").text = "A distancia" if weapon_data["is_ranged"] else "Melee"
	find_child("Range").text = weapon_data["weapon_range"]
	find_child("BaseDamage").text = str(weapon_data["base_damage"])
	find_child("IncrementDamage").text = str(weapon_data["increment_damage"])
	find_child("Description").text = weapon_data["description"]
	if weapon_data["ammo"] == 0:
		find_child("AmmoContainer").hide()
	else:
		find_child("Ammo").text = str(weapon_data["ammo"])
		find_child("AmmoContainer").show()

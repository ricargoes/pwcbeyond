extends NinePatchRect

func paint(weapon_data):
	%Name.text = weapon_data["name"]
	%WeaponClass.text = weapon_data["weapon_class_name"]
	%Proficiency.initial_level = weapon_data["proficiency"]
	%Proficiency.refresh()
	%IsRanged.text = "A distancia" if weapon_data["is_ranged"] else "Melee"
	%Range.text = weapon_data["weapon_range"]
	
	Helper.remove_children(%Damage)
	for damage in weapon_data["damage"]:
		var cost = Label.new()
		cost.size_flags_horizontal = Label.SIZE_EXPAND
		var plural = "" if damage["cost"] == 1 else "s"
		cost.text = str(damage["cost"]) + " éxito" + plural + ": "
		%Damage.add_child(cost)
		var value = Label.new()
		value.size_flags_horizontal = Label.SIZE_EXPAND 
		if damage.has("stun"):
			value.text = str(damage["stun"]) + "A"
		if damage.has("lethal"):
			value.text = str(damage["lethal"]) + "L"
		if damage.has("critical"):
			value.text = str(damage["critical"]) + "X"
		%Damage.add_child(value)		
	
	%Description.text = weapon_data["description"]
	if weapon_data["ammo"] == 0:
		%AmmoContainer.hide()
	else:
		%Ammo.text = str(weapon_data["ammo"])
		%AmmoContainer.show()

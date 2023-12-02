extends Node


func build_ability_tree(parent_node, type, version, perm_level=0, editable = true, char_levels=null):
	var abilities_schema = GameInfo.abilities_schema[version][type]
	remove_children(parent_node)
	for group in abilities_schema:
		var container = VBoxContainer.new()
		var group_name = group["name"]
		container.name = group_name
		container.add_theme_constant_override("separation", 5)
		parent_node.add_child(container)
		
		var label = Label.new()
		label.text = "-" + group_name + "-"
		label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", ResourceManager.h2_font_size)
		container.add_child(label)
		
		for item in group["abilities"]:
			if item == "":
				continue
			var node = ResourceManager.ability_counter_class.instantiate()
			node.ability_name = item
			node.editable = editable
			var current_level = char_levels[group_name][item] if char_levels else 0
			node.set_level(current_level, perm_level)
			node.add_to_group(group_name.to_lower())
			node.add_to_group(type)
			container.add_child(node)


func remove_children(parent):
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()


func sort_ascending(a, b):
	if a[0] < b[0]:
		return true
	else:
		return false

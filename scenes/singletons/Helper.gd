extends Node


func build_ability_tree(type, parent_node, item_levels, editable = true):
	remove_children(parent_node)
	for group in item_levels.keys():
		var container = VBoxContainer.new()
		container.name = group
		container.add_constant_override("separation", 10)
		parent_node.add_child(container)
		
		var label = Label.new()
		label.text = "-" + group + "-"
		label.align = Label.ALIGN_CENTER
		label.add_font_override("font", ResourceManager.h2_font)
		container.add_child(label)
		
		for item in item_levels[group].keys():
			if item == "":
				continue
			var node = ResourceManager.ability_counter_class.instance()
			node.ability_name = item
			node.editable = editable
			var perm_level = 0
			var current_level = 0
			if type == "atributes":
				perm_level = 1 
			current_level = item_levels[group][item]
			node.set_level(current_level, perm_level)
			node.add_to_group(group.to_lower())
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

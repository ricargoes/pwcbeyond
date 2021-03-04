extends NinePatchRect

func paint(ars_data):
	find_node("ArsName").text = ars_data["name"]
	find_node("ArsGroupName").text = ars_data["ars_group_name"]
	find_node("Level").initial_level = ars_data["level"]
	find_node("Level").refresh()
	find_node("Challenge").text = ars_data["challenge"]
	find_node("Target").text = ars_data["target"]
	find_node("Range").text = ars_data["ars_range"]
	find_node("CastTime").text = ars_data["casting_time"]
	find_node("Cost").text = ars_data["cost"]
	find_node("Duration").text = ars_data["duration"]
	find_node("Maint").text = ars_data["maintenance"]
	find_node("Description").text = ars_data["description"]

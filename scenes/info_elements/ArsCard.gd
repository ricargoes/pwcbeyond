extends NinePatchRect

func paint(ars_data):
	find_child("ArsName").text = ars_data["name"]
	find_child("ArsGroupName").text = ars_data["ars_group_name"]
	find_child("Level").initial_level = ars_data["level"]
	find_child("Level").refresh()
	find_child("Challenge").text = ars_data["challenge"]
	find_child("Target").text = ars_data["target"]
	find_child("Range").text = ars_data["ars_range"]
	find_child("CastTime").text = ars_data["casting_time"]
	find_child("Cost").text = ars_data["cost"]
	find_child("Duration").text = ars_data["duration"]
	find_child("Maint").text = ars_data["maintenance"]
	find_child("Description").text = ars_data["description"]

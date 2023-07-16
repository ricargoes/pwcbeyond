extends Node


var char_name = ""
var player_name = ""
var chronicle = ""

var atributes = {}
var skills = {}
var plane_manipulation = {}

var bio = {}

var equipment = {}
var background = {}

var status = {}

var boosts = []

signal effort_spended(type)

func set_id(character_sheet):
	chronicle = character_sheet.find_child("Chronicle").text
	player_name = character_sheet.find_child("Player").text
	char_name = character_sheet.find_child("Name").text

func save_human_side(character_sheet):
	
	bio = {}
	bio["job"] = character_sheet.find_child("Job").text
	bio["species"] = character_sheet.find_child("Species").text
	bio["age"] = character_sheet.find_child("Age").text
	bio["looks"] = character_sheet.find_child("Looks").text
	bio["personality"] = character_sheet.find_child("Personality").text
	bio["past"] = character_sheet.find_child("Past").text
	bio["motivation"] = character_sheet.find_child("Motivation").text

	atributes = {}
	for atribute_group in character_sheet.find_child("Atributes").get_children():
		atributes[atribute_group.name] = {}
		for sheet_atribute in atribute_group.get_children():
			if sheet_atribute.has_method("get_level"):
				atributes[atribute_group.name][sheet_atribute.get_indicator_name()] = sheet_atribute.get_level()
	
	skills = {}
	for skill_group in character_sheet.find_child("Skills").get_children():
		skills[skill_group.name] = {}
		for sheet_skill in skill_group.get_children():
			if sheet_skill.has_method("get_level"):
				skills[skill_group.name][sheet_skill.get_indicator_name()] = sheet_skill.get_level()
	
func save_planewalker_side(character_sheet):
	plane_manipulation = {}
	plane_manipulation["modus"] = character_sheet.find_child("Modus").text
	plane_manipulation["via"] = character_sheet.find_child("Via").text
	
	plane_manipulation["aspects"] = [character_sheet.find_child("Aspect1").text, character_sheet.find_child("Aspect2").text]
	plane_manipulation["journey"] = character_sheet.find_child("Journey").get_level()
	plane_manipulation["access"] = {}
	
	plane_manipulation["access"]["ego"] = character_sheet.find_child("Ego").get_level()
	plane_manipulation["access"]["quod"] = character_sheet.find_child("Quod").get_level()
	plane_manipulation["access"]["scientia"] = character_sheet.find_child("Scientia").get_level()
	plane_manipulation["access"]["opus"] = character_sheet.find_child("Opus").get_level()
	
	plane_manipulation["artes"] = {}
	for ars in character_sheet.find_child("Artes").get_children():
		plane_manipulation["artes"][ars.get_indicator_name()] = ars.get_level()

func initialize_status():
	status["Vigor"] = { "perm": atributes["Físicos"]["Resistencia"], "temp": atributes["Físicos"]["Resistencia"] }
	status["Voluntad"] = { "perm": atributes["Mentales"]["Astucia"], "temp": atributes["Mentales"]["Astucia"] }
	status["Coherencia"] = { "perm": plane_manipulation["access"]["ego"], "temp": plane_manipulation["access"]["ego"] }
	for type in ["Salud", "Cordura"]:
		status[type] = { "light": 0, "heavy": 0 }
	
	for type in ["xp", "ep"]:
		status[type] = ""

func save_status(character_sheet):
	status = {}
	status["Vigor"] = { "perm": atributes["Físicos"]["Resistencia"], "temp": character_sheet.find_child("Vigor").temp_level}
	status["Voluntad"] = { "perm": atributes["Mentales"]["Astucia"], "temp": character_sheet.find_child("Voluntad").temp_level}
	status["Coherencia"] = { "perm": plane_manipulation["access"]["ego"], "temp": character_sheet.find_child("Coherencia").temp_level}
	
	status["Salud"] = { "light": character_sheet.find_child("Salud").damage_light, "heavy": character_sheet.find_child("Salud").damage_heavy }
	status["Cordura"] = { "light": character_sheet.find_child("Cordura").damage_light, "heavy": character_sheet.find_child("Cordura").damage_heavy }
	
	status["ep"] = character_sheet.find_child("EP").text
	status["xp"] = character_sheet.find_child("XP").text

func get_data_dict():
	return {
		"bio": bio,
		"atributes": atributes,
		"skills": skills,
		"plane_manipulation": plane_manipulation,
		"status": status
	}

func from_data_dict(char_dict):
	chronicle = char_dict["chronicle"]
	player_name = char_dict["player"]
	char_name = char_dict["character_name"]
	bio = char_dict["character_stats"]["bio"]
	atributes = char_dict["character_stats"]["atributes"]
	skills = char_dict["character_stats"]["skills"]
	plane_manipulation = char_dict["character_stats"]["plane_manipulation"]
	status = char_dict["character_stats"]["status"]
	
	equipment = char_dict["character_inventory"]


func get_equipment():
	if equipment.is_empty():
		return GameInfo.empty_character_equipment
	else:
		return equipment


func effort(type):
	boosts.append(type)

func spend_effort(type):
	if boosts.has(type):
		for _i in range(boosts.count(type)):
			boosts.erase(type)
		emit_signal("effort_spended", type)

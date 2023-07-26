extends Control

var character = null

var selected_atribute = null
var selected_skill = null
var type_of_attempt = ""

var health = null
var tireness = { }


func _ready():
	randomize()
	refresh()


func set_roller(new_character):
	character = new_character


func select_atribute(new_selected_atribute):
	selected_atribute = new_selected_atribute
	refresh()


func select_skill(new_selected_skill):
	selected_skill = new_selected_skill
	refresh()


func set_health(node):
	health = node


func set_tireness(related_atribute, node):
	tireness[related_atribute] = node


func refresh():
	%AtributeL.text = "Atributo"
	if selected_atribute:
		if selected_atribute.is_in_group("físicos"):
			type_of_attempt = "físicos"
		if selected_atribute.is_in_group("mentales"):
			type_of_attempt = "mentales"
		if selected_atribute.is_in_group("plane_manipulation"):
			type_of_attempt = "plane_manipulation"
		
		%AtributeL.text = selected_atribute.get_indicator_name()
	
	%AbilityL.text = "Habilidad"
	if selected_skill:
		%AbilityL.text = selected_skill.get_indicator_name()
	
	%Atribute.text = str(calculate_atribute_level())
	%Ability.text = str(calculate_skill_level())
	%Mod.text = str(calculate_mod())


func calculate_atribute_level():
	var atribute_level = 0
	if selected_atribute:
		atribute_level = selected_atribute.get_level()
	
	return atribute_level


func calculate_skill_level():
	var skill_level = 0
	if selected_skill:
		skill_level = selected_skill.get_level()
	
	return skill_level


func calculate_mod():
	var mod = 0
	if character and character.boosts.has(type_of_attempt):
		var n_ocurrences = character.boosts.count(type_of_attempt)
		mod += n_ocurrences
	else:
		if health:
			mod += health.get_penalty()
		
		if tireness.has(type_of_attempt):
			mod += tireness[type_of_attempt].get_penalty()
		
	return mod


func spend_boosts():
	if character:
		character.spend_effort(type_of_attempt)


func _on_Roll_pressed():
	
	var atribute_level = calculate_atribute_level()
	var skill_level = calculate_skill_level()
	var mod = calculate_mod()
	
	var luck = 0
	var roll_throw = PackedStringArray()
	for _i in range(4):
		var die = roll_fudge_die()
		luck += die
		if die == -1:
			roll_throw.append("-")
		elif die == 0:
			roll_throw.append("0")
		elif die == 1:
			roll_throw.append("+")
			
	var result = atribute_level + skill_level + mod + luck
	
	$SFXRoll.play()
	%Result.text = str(result) + " = " + str(atribute_level + skill_level + mod) + " + [" +  " ".join(roll_throw) + "]"
	if %Public.button_pressed:
		send_to_discord_web_hook(result, roll_throw)
	
	spend_boosts()


func send_to_discord_web_hook(result, roll_throw):
	var atribute_text = selected_atribute.get_indicator_name() if selected_atribute else "No atributo"
	var skill_text = selected_skill.get_indicator_name() if selected_skill else "No habilidad"
	var atribute_level = calculate_atribute_level()
	var skill_level = calculate_skill_level()
	var mod = calculate_mod()
	var username = "Anon"
	if character:
		username = character.char_name + " (" + character.player_name + ")"
	
	var payload = {
		"username": "PWC Beyond",
		"embeds": [
			{
				"author": { "name": username },
				"title": str(result) + "    [" + atribute_text + " + " + skill_text + "]",
				"description": "Resultado: " + str(result) + " = " + str(atribute_level + skill_level + mod) + " + [" +  " ".join(roll_throw) + "]",
				"color": 4325120,
				"fields": [
					{
						"name": "Competencia",
						"value": str(atribute_level + skill_level) + " = " + str(atribute_level) + " + " + str(skill_level),
						"inline": true
					}, {
						"name": "Penalizador",
						"value": str(mod),
						"inline": true
					}, {
						"name": "Suerte",
						"value": str(result - (atribute_level + skill_level + mod)) + " = [" +  " ".join(roll_throw) + "]",
						"inline": true
					},
				]
			}
		]
	}
	$Webhook.request(
		GameInfo.discord_webhook_url,
		PackedStringArray(["Content-Type: application/json"]),
		HTTPClient.METHOD_POST,
		JSON.stringify(payload))


func roll_fudge_die():
	return (randi() % 3) -1

extends HTTPRequest

var new_format = []

func _ready():
	search()


func search():
	var query_order = "order=chronicle,player,character_name"
	
	request(
		GameInfo.character_sheets_table_url + "?" + query_order,
		PoolStringArray(["accept: application/json", "Range-Unit: items"]),
		true,
		HTTPClient.METHOD_GET
		)


func _on_Node_request_completed(result, response_code, headers, body):
	var chars = JSON.parse(body.get_string_from_utf8()).result
	for char2 in chars:
		var chronicle = char2["chronicle"]
		var player = char2["player"]
		var char_name = char2["character_name"]
		var data = char2["character_stats"]
		var n_data = {
			"bio": data["description"].duplicate(true),
			"status": data["status"].duplicate(true),
			"atributes": data["atributes"].duplicate(true),
			"skills": data["abilities"].duplicate(true),
			"plane_manipulation": data["plane_manipulation"].duplicate(true)
		}
		n_data["bio"]["age"] = data["data"]["age"]
		n_data["bio"]["job"] = data["data"]["job"]
		n_data["bio"]["species"] = data["data"]["species"]
		if not data["plane_manipulation"].empty():
			n_data["plane_manipulation"].erase("iter")
			n_data["plane_manipulation"]["journey"] = data["plane_manipulation"]["iter"]
			n_data["plane_manipulation"].erase("aspecti")
			n_data["plane_manipulation"]["aspects"] = data["plane_manipulation"]["aspecti"]
			var vacants = 2 - n_data["plane_manipulation"]["aspects"].size()
			for i in range(vacants):
				n_data["plane_manipulation"]["aspects"].append("")
		
		
		var post_data = { "character_stats": n_data }
		CharactersGetter.update_character(chronicle, player, char_name, post_data)
		yield(get_tree().create_timer(0.5), "timeout")
		new_format.append(n_data)
	
	print(new_format.size())
	get_tree().quit()


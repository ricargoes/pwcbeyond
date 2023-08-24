extends HTTPRequest


var _chars_cache = {}

var request_queue = []

signal cache_refreshed(loaded_characters)


func _ready():
	set_process(true)


func _process(_delta):
	try_request()


func _on_get_request_completed(_result, _response_code, _headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var chars = test_json_conv.get_data()
	var chars_recovered = []
	for character_dict in chars:
		var chronicle = character_dict["chronicle"]
		var player = character_dict["player"]
		var char_name = character_dict["character_name"]
		if not _chars_cache.has(chronicle):
			_chars_cache[chronicle] = {}
		if not _chars_cache[chronicle].has(player):
			_chars_cache[chronicle][player] = {}
		
		var character = ResourceManager.character_class.instantiate()
		character.from_data_dict(character_dict)
		_chars_cache[chronicle][player][char_name] = character
		chars_recovered.append(character)
	emit_signal("cache_refreshed", chars_recovered)


func get_character(chronicle, player, char_name):
	if _chars_cache.has(chronicle) and _chars_cache[chronicle].has(player) and _chars_cache[chronicle][player].has(char_name):
		return _chars_cache[chronicle][player][char_name]
	else:
		request_character(chronicle, player, char_name)
		return null


func character_filter(chronicle=null, player=null, char_name=null):
	var html_space = "%20"
	var adapted_chronicle = chronicle.replace(" ", html_space)
	var adapted_player = player.replace(" ", html_space)
	var adapted_char_name = char_name.replace(" ", html_space)
	var query_filter = "?chronicle=eq."+adapted_chronicle+"&player=eq."+adapted_player+"&character_name=eq."+adapted_char_name
	return query_filter


func try_request():
	if get_http_client_status() == HTTPClient.STATUS_DISCONNECTED and not request_queue.is_empty():
		var url = request_queue.pop_front()
		request(
			url,
			PackedStringArray(["accept: application/json", "Range-Unit: items"]),
			HTTPClient.METHOD_GET
			)


func request_character(chronicle, player, char_name):
	request_queue.append(GameInfo.character_sheets_table_url + character_filter(chronicle, player, char_name))


func search(search_text):
	var query_filter = ""
	if search_text != "":
		query_filter = "or=(chronicle.ilike.*"+search_text+"*,player.ilike.*"+search_text+"*,character_name.ilike.*"+search_text+"*)"
	var query_order = "order=chronicle,player,character_name"
	
	request_queue.append(GameInfo.character_sheets_table_url + "?" + query_filter + query_order)


func insert_character(character):
	var post_data = JSON.stringify({
		"chronicle": character.chronicle, 
		"player": character.player_name, 
		"character_name": character.char_name, 
		"character_stats": character.get_data_dict()
		})
	$CharactersInserter.request(
		GameInfo.character_sheets_table_url,
		PackedStringArray(["Content-Type: application/json"]),
		HTTPClient.METHOD_POST,
		post_data
		)


func delete_character(chronicle, player, char_name):
	$CharactersDeleter.request(
		GameInfo.character_sheets_table_url + character_filter(chronicle, player, char_name),
		PackedStringArray(["Content-Type: application/json"]),
		HTTPClient.METHOD_DELETE
		)


func update_character(chronicle, player, char_name, payload):
	$CharactersUpdater.request(
		GameInfo.character_sheets_table_url + character_filter(chronicle, player, char_name),
		PackedStringArray(["Content-Type: application/json"]),
		HTTPClient.METHOD_PATCH,
		JSON.stringify(payload)
		)


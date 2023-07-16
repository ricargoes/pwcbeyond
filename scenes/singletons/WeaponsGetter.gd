extends HTTPRequest


var _cache = {}


func _ready():
	self.request(GameInfo.weapons_table_url)


func _on_get_request_completed(_result, _response_code, _headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var weapons = test_json_conv.get_data()
	for weapon in weapons:
		if not _cache.has(weapon["weapon_class_name"]):
			_cache[weapon["weapon_class_name"]] = {}
		_cache[weapon["weapon_class_name"]][weapon["name"]] = weapon


func get_all():
	return _cache


func get_weapon(weapon_class, weapon_name):
	return _cache[weapon_class][weapon_name]

extends HTTPRequest


var _artes_cache = {}


func _ready():
	self.request(GameInfo.artes_table_url)


func _on_get_request_completed(_result, _response_code, _headers, body):
	var artes = JSON.parse(body.get_string_from_utf8()).result
	for ars in artes:
		if not _artes_cache.has(ars["ars_group_name"]):
			_artes_cache[ars["ars_group_name"]] = {}
		_artes_cache[ars["ars_group_name"]][int(ars["level"])] = ars


func get_ars(ars, level):
	return _artes_cache[ars][level]

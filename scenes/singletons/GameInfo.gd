extends Node

const empty_character_equipment = {"items": {}, "weapons": {}}

var abilities_schema = {}

const states = {
	"Salud": [
		{
			"label": "Aturdido",
			"penalty": "",
			"degrees": 10
		},{
			"label": "Herido",
			"penalty": "",
			"degrees": 5
		},{
			"label": "Crítico",
			"penalty": "",
			"degrees": 2
		}
	],
	"Cordura": [
		{
			"label": "Trauma",
			"penalty": "",
			"degrees": 5
		},{
			"label": "Trastorno",
			"penalty": "",
			"degrees": 3
		},{
			"label": "Locura",
			"penalty": "",
			"degrees": 2
		}
	]
}

const discord_webhook_url = "youwebhook"
#const host = "http://pwc.fluffyclouds.duckdns.org:3000"
const host = "http://localhost:3000"

const character_sheets_table_url = host + "/character_sheets"
const schemas_table_url = host + "/json_schemas"
const artes_table_url = host + "/artes"
const vias_table_url = host + "/vias"
const vias_to_artes_table_url = host + "/vias_to_artes_association"
const weapons_table_url = host + "/weapon_spec"

var next_character = null


func load_character():
	var character = next_character
	next_character = null
	return character

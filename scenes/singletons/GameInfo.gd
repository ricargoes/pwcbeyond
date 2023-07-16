extends Node

const empty_character_equipment = {"items": {}, "weapons": {}}

const version_skill_template = {
	"v1": {
		"atributes": {
			"Físicos": {"Fuerza": 1, "Destreza": 1, "Resistencia": 1},
			"Sociales": {"Carisma": 1, "Manipulación": 1, "Apariencia": 1},
			"Mentales": {"Percepción": 1, "Inteligencia": 1, "Astucia": 1}
		},
		"skills": {
			"Talentos": {"Alerta": 0, "Atletismo": 0, "Creatividad": 0, "Diplomacia": 0, "Empatía": 0, "Intimidación": 0, "Liderazgo": 0, "Pelea": 0, "Subterfugio": 0, "Tratar animales": 0 },
			"Tecnicas": {"Actuación artística": 0, "Armas a distancia": 0, "Armas de melee": 0, "Busq. información": 0, "Conducción": 0, "Curación": 0, "Pericias": 0, "Rastreo": 0, "Sigilo": 0, "Supervivencia": 0},
			"Conocimientos": {"Arte": 0, "Biología": 0, "Física/Química": 0, "Informática": 0, "Lingüística": 0, "Mat./Economía": 0, "Medicina": 0, "Psicología": 0, "Sociopolítica": 0, "Tecnología": 0}
		},
	},
	"v2": {
		"atributes": {
			"Físicos": {"Fuerza": 1, "Destreza": 1, "Resistencia": 1},
			"Sociales": {"Carisma": 1, "Manipulación": 1, "Apariencia": 1},
			"Mentales": {"Percepción": 1, "Inteligencia": 1, "Astucia": 1}
		},
		"skills": {
			"Talentos": {"Atletismo": 0, "Creatividad": 0, "Empatía": 0, "Intimidación": 0, "Mentir": 0, "Observación": 0, "Pelea": 0, "Persuasión": 0, "Resiliencia": 0, "Tratar animales": 0 },
			"Tecnicas": {"Armas a distancia": 0, "Armas de melee": 0, "Conducción": 0, "Curación": 0, "Juego de manos": 0, "Interpretación": 0, "Investigación": 0, "Pericias": 0, "Sigilo": 0, "Supervivencia": 0},
			"Conocimientos": {"Arte": 0, "Biología": 0, "Física/Química": 0, "Lingüística": 0, "Mat./Economía": 0, "Medicina": 0, "Psicología": 0, "Seguridad": 0, "Sociopolítica": 0, "Tecnología": 0}
		}
	}
}

const states = {
	"Salud": [
		{
			"label": "Magullado",
			"penalty": "",
			"degrees": 3
		},{
			"label": "Herido",
			"penalty": "-1",
			"degrees": 3
		},{
			"label": "Malherido",
			"penalty": "-2",
			"degrees": 2
		},{
			"label": "Incapacitado",
			"penalty": "x",
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
const host = "http://pwc.fluffyclouds.duckdns.org:3000"

const character_sheets_table_url = host + "/character_sheets"
const artes_table_url = host + "/artes"
const vias_table_url = host + "/vias"
const vias_to_artes_table_url = host + "/vias_to_artes_association"
const weapons_table_url = host + "/weapon_spec"

var next_character = null


func load_character():
	var character = next_character
	next_character = null
	return character

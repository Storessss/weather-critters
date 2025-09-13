extends Node

class_name Critter

@export var critter_name: String
@export var texture: Texture2D
@export_multiline var tip: String
var found: bool

@export var time_of_day: Array[GlobalVariables.TimeOfDay]
@export var day: Array[int]
@export var weekday: Array[int]
@export var month: Array[int]
@export var season: Array[GlobalVariables.Season]
@export var weather: Array[GlobalVariables.Weather]
@export var moon_phase: Array[GlobalVariables.MoonPhase]

@onready var p: Node2D = get_parent()

func check() -> bool:
	if p.time_of_day in time_of_day or time_of_day.is_empty():
		if p.day in day or day.is_empty():
			if p.weekday in weekday or weekday.is_empty():
				if p.month in month or month.is_empty():
					if p.season in season or season.is_empty():
						if p.weather in weather or weather.is_empty():
							if p.moon_phase in moon_phase or moon_phase.is_empty():
								return true
	return false

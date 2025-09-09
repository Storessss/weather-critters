extends Node2D

var now: Dictionary
var year: int
var month: int
var day: int
var weekday: int
var hour: int
var minute: int
var second: int

var time: int
@onready var time_label: RichTextLabel = $VBoxContainer/TimeLabel

var season: int
@onready var season_label: RichTextLabel = $VBoxContainer/SeasonLabel

var moon_phase: int
@onready var moon_phase_label: RichTextLabel = $VBoxContainer/MoonPhaseLabel

func _process(delta: float) -> void:
	now = Time.get_datetime_dict_from_system()
	year = now.year
	month = now.month
	day = now.day
	weekday = now.weekday
	hour = now.hour
	minute = now.minute
	second = now.second
	get_time()
	get_season()
	get_moon_phase()
	
func get_time() -> void:
	if hour >= 6 and hour < 12:
		time = 1
		time_label.text = "Morning"
	elif hour >= 12 and hour < 17:
		time = 2
		time_label.text = "Afternoon"
	elif hour >= 17 and hour < 22:
		time = 3
		time_label.text = "Evening"
	elif hour >= 22 and hour < 6:
		time = 4
		time_label.text = "Night"

func get_season() -> void:
	if (month == 3 and day >= 20) or (month in [4, 5]) or (month == 6 and day <= 20):
		season = 2
		season_label.text = "Spring"
	elif (month == 6 and day >= 21) or (month in [7, 8]) or (month == 9 and day <= 21):
		season = 3
		season_label.text = "Summer"
	elif (month == 9 and day >= 22) or (month in [10, 11]) or (month == 12 and day <= 20):
		season = 4
		season_label.text = "Fall"
	else:
		season = 1
		season_label.text = "Winter"

func get_moon_phase() -> void:
	var ref_year: int = 2000
	var ref_month: int = 1
	var ref_day: int = 6

	var jd_now: float = _julian_day(year, month, day)
	var jd_ref: float = _julian_day(ref_year, ref_month, ref_day)

	var days_since_new: float = jd_now - jd_ref

	var lunar_age: float = fmod(days_since_new, 29.530588853)

	var phase_name: String = ""
	if lunar_age < 1:
		moon_phase = 1
		moon_phase_label.text = "New Moon"
	elif lunar_age < 6.38265:
		moon_phase = 2
		moon_phase_label.text = "Waxing Crescent"
	elif lunar_age < 8.38265:
		moon_phase = 3
		moon_phase_label.text = "First Quarter"
	elif lunar_age < 14.7653:
		moon_phase = 4
		moon_phase_label.text = "Waxing Gibbous"
	elif lunar_age < 15.7653:
		moon_phase = 5
		moon_phase_label.text = "Full Moon"
	elif lunar_age < 22.14795:
		moon_phase = 6
		moon_phase_label.text = "Waning Gibbous"
	elif lunar_age < 24.14795:
		moon_phase = 7
		moon_phase_label.text = "Last Quarter"
	else:
		moon_phase = 8
		moon_phase_label.text = "Waning Crescent"

func _julian_day(year: int, month: int, day: int) -> float:
	if month <= 2:
		year -= 1
		month += 12
	var A: int = int(year / 100)
	var B: int = 2 - A + int(A / 4)
	var jd: float = int(365.25 * (year + 4716)) + int(30.6001 * (month + 1)) + day + B - 1524.5
	return jd

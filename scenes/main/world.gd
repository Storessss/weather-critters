extends Node2D

var now: Dictionary
var year: int
var month: int
var day: int
var weekday: int
var hour: int
var minute: int
var second: int

var time_of_day: int
@onready var time_label: RichTextLabel = $Hud/VBoxContainer/TimeOfDayLabel

var season: int
@onready var season_label: RichTextLabel = $Hud/VBoxContainer/SeasonLabel

var weather: int
var weather_chances: Dictionary
@onready var weather_label: RichTextLabel = $Hud/VBoxContainer/WeatherLabel

var moon_phase: int
@onready var moon_phase_label: RichTextLabel = $Hud/VBoxContainer/MoonPhaseLabel

var days_of_week: Array[String] = [
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	"Sunday"
]

var months: Array[String] = [
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December"
]

func _process(delta: float) -> void:
	now = Time.get_datetime_dict_from_system()
	year = now.year
	month = now.month
	day = now.day
	weekday = now.weekday
	hour = now.hour
	minute = now.minute
	second = now.second
	$Hud/VBoxContainer/DayLabel.text = days_of_week[weekday - 1] + " " + str(day) + " " + months[month - 1] \
	+ " " + str(year) + " " + str(hour).pad_zeros(2) + ":" + str(minute).pad_zeros(2) + ":" + str(second).pad_zeros(2)
	get_time()
	get_season()
	if $WeatherTimer.is_stopped():
		$WeatherTimer.start(randf_range(10.0, 200.0))
		get_weather()
	if weather == GlobalVariables.Weather.STORM and $LightningTimer.is_stopped():
		$LightningTimer.start(randf_range(7.0, 25.0))
		storm_flash()
	get_moon_phase()
	
func get_time() -> void:
	if hour >= 6 and hour < 12:
		time_of_day = GlobalVariables.TimeOfDay.MORNING
		time_label.text = "Morning"
	elif hour >= 12 and hour < 17:
		time_of_day = GlobalVariables.TimeOfDay.AFTERNOON
		time_label.text = "Afternoon"
	elif hour >= 17 and hour < 22:
		time_of_day = GlobalVariables.TimeOfDay.EVENING
		time_label.text = "Evening"
	elif hour >= 22 or hour < 6:
		time_of_day = GlobalVariables.TimeOfDay.NIGHT
		time_label.text = "Night"

func get_season() -> void:
	if (month == 3 and day >= 20) or (month in [4, 5]) or (month == 6 and day <= 20):
		season = GlobalVariables.Season.SPRING
		season_label.text = "Spring"
	elif (month == 6 and day >= 21) or (month in [7, 8]) or (month == 9 and day <= 21):
		season = GlobalVariables.Season.SUMMER
		season_label.text = "Summer"
	elif (month == 9 and day >= 22) or (month in [10, 11]) or (month == 12 and day <= 20):
		season = GlobalVariables.Season.FALL
		season_label.text = "Fall"
	else:
		season = GlobalVariables.Season.WINTER
		season_label.text = "Winter"
		
func get_weather() -> void:
	if season == GlobalVariables.Season.SPRING:
		weather_chances = {
			GlobalVariables.Weather.CLOUDY: 20,
			GlobalVariables.Weather.SUNNY: 15,
			GlobalVariables.Weather.LIGHT_RAIN: 20,
			GlobalVariables.Weather.RAIN: 15,
			GlobalVariables.Weather.STORM: 15,
			GlobalVariables.Weather.SNOW: 0,
			GlobalVariables.Weather.HAIL: 15,
		}
	elif season == GlobalVariables.Season.SUMMER:
		weather_chances = {
			GlobalVariables.Weather.CLOUDY: 25,
			GlobalVariables.Weather.SUNNY: 50,
			GlobalVariables.Weather.LIGHT_RAIN: 5,
			GlobalVariables.Weather.RAIN: 5,
			GlobalVariables.Weather.STORM: 0,
			GlobalVariables.Weather.SNOW: 0,
			GlobalVariables.Weather.HAIL: 15,
		}
	elif season == GlobalVariables.Season.FALL:
		weather_chances = {
			GlobalVariables.Weather.CLOUDY: 40,
			GlobalVariables.Weather.SUNNY: 20,
			GlobalVariables.Weather.LIGHT_RAIN: 15,
			GlobalVariables.Weather.RAIN: 10,
			GlobalVariables.Weather.STORM: 10,
			GlobalVariables.Weather.SNOW: 5,
			GlobalVariables.Weather.HAIL: 0,
		}
	elif season == GlobalVariables.Season.WINTER:
		weather_chances = {
			GlobalVariables.Weather.CLOUDY: 25,
			GlobalVariables.Weather.SUNNY: 5,
			GlobalVariables.Weather.LIGHT_RAIN: 20,
			GlobalVariables.Weather.RAIN: 15,
			GlobalVariables.Weather.STORM: 15,
			GlobalVariables.Weather.SNOW: 20,
			GlobalVariables.Weather.HAIL: 0,
		}
	#weather_chances = {
			#GlobalVariables.Weather.CLOUDY: 0,
			#GlobalVariables.Weather.SUNNY: 0,
			#GlobalVariables.Weather.LIGHT_RAIN: 0,
			#GlobalVariables.Weather.RAIN: 0,
			#GlobalVariables.Weather.STORM: 100,
			#GlobalVariables.Weather.SNOW: 0,
			#GlobalVariables.Weather.HAIL: 0,
		#}
	for effect in $WeatherEffects.get_children():
		if effect is GPUParticles2D:
			effect.emitting = false
	$WeatherEffects/LightningFlash.visible = false
	$SunRays.visible = false
	var key: int
	weather = -1
	while weather != key:
		key = weather_chances.keys().pick_random()
		if randi_range(1, 100) <= weather_chances[key]:
			weather = key
	if weather == GlobalVariables.Weather.CLOUDY:
		$WeatherSound.stream = preload("res://sounds/cloudy.mp3")
		weather_label.text = "Cloudy"
	elif weather == GlobalVariables.Weather.SUNNY:
		$SunRays.visible = true
		$WeatherSound.stream = preload("res://sounds/sunny.mp3")
		weather_label.text = "Sunny"
	elif weather == GlobalVariables.Weather.LIGHT_RAIN:
		$WeatherEffects/LightRainParticles.emitting = true
		$WeatherSound.stream = preload("res://sounds/light_rain.mp3")
		weather_label.text = "Light Rain"
	elif weather == GlobalVariables.Weather.RAIN:
		$WeatherEffects/RainParticles.emitting = true
		$WeatherSound.stream = preload("res://sounds/rain.mp3")
		weather_label.text = "Rain"
	elif weather == GlobalVariables.Weather.STORM:
		$WeatherEffects/RainParticles.emitting = true
		$WeatherSound.stream = preload("res://sounds/rain.mp3")
		weather_label.text = "Storm"
	elif weather == GlobalVariables.Weather.SNOW:
		$WeatherEffects/SnowParticles.emitting = true
		$WeatherSound.stream = preload("res://sounds/snow.mp3")
		weather_label.text = "Snow"
	elif weather == GlobalVariables.Weather.HAIL:
		$WeatherEffects/HailParticles.emitting = true
		$WeatherSound.stream = preload("res://sounds/hail.mp3")
		weather_label.text = "Hail"
	$WeatherSound.play()
		
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
		moon_phase = GlobalVariables.MoonPhase.NEW_MOON
		moon_phase_label.text = "New Moon"
	elif lunar_age < 6.38265:
		moon_phase = GlobalVariables.MoonPhase.WAXING_CRESCENT
		moon_phase_label.text = "Waxing Crescent"
	elif lunar_age < 8.38265:
		moon_phase = GlobalVariables.MoonPhase.FIRST_QUARTER
		moon_phase_label.text = "First Quarter"
	elif lunar_age < 14.7653:
		moon_phase = GlobalVariables.MoonPhase.WAXING_GIBBOUS
		moon_phase_label.text = "Waxing Gibbous"
	elif lunar_age < 15.7653:
		moon_phase = GlobalVariables.MoonPhase.FULL_MOON
		moon_phase_label.text = "Full Moon"
	elif lunar_age < 22.14795:
		moon_phase = GlobalVariables.MoonPhase.WANING_GIBBOUS
		moon_phase_label.text = "Waning Gibbous"
	elif lunar_age < 24.14795:
		moon_phase = GlobalVariables.MoonPhase.LAST_QUARTER
		moon_phase_label.text = "Last Quarter"
	else:
		moon_phase = GlobalVariables.MoonPhase.WANING_CRESCENT
		moon_phase_label.text = "Waning Crescent"

func _julian_day(year: int, month: int, day: int) -> float:
	if month <= 2:
		year -= 1
		month += 12
	var A: int = int(year / 100)
	var B: int = 2 - A + int(A / 4)
	var jd: float = int(365.25 * (year + 4716)) + int(30.6001 * (month + 1)) + day + B - 1524.5
	return jd

func play_lightning_flash():
	var flash: ColorRect = $WeatherEffects/LightningFlash
	flash.visible = true
	flash.modulate.a = 0.8
	
	var tween := create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_callback(Callable(flash, "hide"))
	
func storm_flash():
	play_lightning_flash()
	if randf() < 0.5:
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout
		play_lightning_flash()
	await get_tree().create_timer(randf_range(0.4, 2.2)).timeout
	play_thunder_sound()
	
func play_thunder_sound():
	var thunder_sounds: Array[AudioStream] = [
		preload("res://sounds/thunder1.wav"),
		preload("res://sounds/thunder2.wav"),
		preload("res://sounds/thunder3.wav"),
		preload("res://sounds/thunder4.wav"),
		preload("res://sounds/thunder5.wav"),
		preload("res://sounds/thunder6.wav"),
		preload("res://sounds/thunder7.wav"),
	]
	$ThunderSound.stream = thunder_sounds.pick_random()
	$ThunderSound.play()

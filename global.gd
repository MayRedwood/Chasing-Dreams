extends Node


const DARK_PURPLE := Color("4C3F91")
const LIGHT_PURPLE := Color("9145B6")
const DESATURATED_ROSE := Color("B958A5")
const VIBRANT_ROSE := Color("FF5677")

var background_color := DARK_PURPLE
var enemy_color := LIGHT_PURPLE
var bullet_color := DESATURATED_ROSE
var player_color := VIBRANT_ROSE

var save_path := "user://save.save"
var save_0_path := "res://save0.res"
var loaded := false

var tutorial_done := false

var deaths := -1

var counter := 0.0

var doremy_counter := 1

var score := 0
var high_score := 0

var one := false
var two := false
var three := false
var four := false
var five := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func choose_dialogs() -> String:
	if high_score > 4000 and four and (not five) and doremy_counter > 1:
		five = true
		return "Five"
	elif high_score > 2500 and three and not four:
		four = true
		return "Four"
	elif (deaths > 30 or high_score > 2500) and two and not three:
		three = true
		return "Three"
	elif (deaths > 20 or high_score > 1500) and one and not two:
		two = true
		return "Two"
	elif (deaths > 10 or high_score > 750) and not one:
		one = true
		return "One"
	elif deaths < 4 and not one:
		return "Intro"
	return ""


func save_files():
	if not loaded:
		load_files()
	else:
		var file = File.new()
		file.open(save_path, File.WRITE)
		var save_dict = {
			"deaths": deaths,
			"doremy_counter": doremy_counter,
			"high_score": high_score,
			"one": one,
			"two": two,
			"three": three,
			"four": four,
			"five": five
		}
		file.store_line(to_json(save_dict))
		file.close()


func load_files():
	loaded = true
	var file = File.new()
	if file.file_exists(save_path):
		file.open(save_path, File.READ)
		var saved_data: Dictionary = parse_json(file.get_line())
		deaths = saved_data.deaths
		doremy_counter = saved_data.doremy_counter
		high_score = saved_data.high_score
		one = saved_data.one
		two = saved_data.two
		three = saved_data.three
		four = saved_data.four
		five = saved_data.five
		file.close()
	else:
		file.open(save_path, File.WRITE)
		var save_dict = {
			"deaths": deaths,
			"doremy_counter": doremy_counter,
			"high_score": high_score,
			"one": one,
			"two": two,
			"three": three,
			"four": four,
			"five": five
		}
		file.store_line(to_json(save_dict))
		file.close()

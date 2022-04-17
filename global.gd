extends Node


const DARK_PURPLE := Color("4C3F91")
const LIGHT_PURPLE := Color("9145B6")
const DESATURATED_ROSE := Color("B958A5")
const VIBRANT_ROSE := Color("FF5677")

var background_color := DARK_PURPLE
var enemy_color := LIGHT_PURPLE
var bullet_color := DESATURATED_ROSE
var player_color := VIBRANT_ROSE

var deaths_file := "user://deaths.save"
var doremy_counter_file := "user://doremy.save"
var high_score_file := "user://score.save"
var story_file := "user://story.save"
var loaded := false

var deaths := -1

var counter := 0.0

var doremy_counter := 1

var score: int
var high_score: int

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
		var file := File.new()
		# warning-ignore: return_value_discarded
		file.open(deaths_file, File.WRITE)
		file.store_var(deaths)
		file.close()
		# warning-ignore: return_value_discarded
		file.open(doremy_counter_file, File.WRITE)
		file.store_var(doremy_counter)
		file.close()
		# warning-ignore: return_value_discarded
		file.open(high_score_file, File.WRITE)
		file.store_var(high_score)
		file.close()
		# warning-ignore: return_value_discarded
		file.open(story_file, File.WRITE)
		if five:
			file.store_var(5)
		elif four:
			file.store_var(4)
		elif three:
			file.store_var(3)
		elif two:
			file.store_var(2)
		elif one:
			file.store_var(1)
		file.close()


func load_files():
	var file := File.new()
	if file.file_exists(deaths_file):
		# warning-ignore: return_value_discarded
		file.open(deaths_file, File.READ)
		deaths = file.get_var()
	else:
		# warning-ignore: return_value_discarded
		file.open(deaths_file, File.WRITE)
		file.store_var(deaths)
	file.close()
	if file.file_exists(doremy_counter_file):
		# warning-ignore: return_value_discarded
		file.open(doremy_counter_file, File.READ)
		doremy_counter = file.get_var()
	else:
		# warning-ignore: return_value_discarded
		file.open(doremy_counter_file, File.WRITE)
		file.store_var(doremy_counter)
	file.close()
	if file.file_exists(high_score_file):
		# warning-ignore: return_value_discarded
		file.open(high_score_file, File.READ)
		high_score = file.get_var()
	else:
		# warning-ignore: return_value_discarded
		file.open(high_score_file, File.WRITE)
		file.store_var(high_score)
	file.close()
	if file.file_exists(story_file):
		# warning-ignore: return_value_discarded
		file.open(story_file, File.READ)
		var s = file.get_var()
		if s >= 5:
			five = true
		if s >= 4:
			four = true
		if s >= 3:
			three = true
		if s >= 2:
			two = true
		if s >= 1:
			one = true
	else:
		# warning-ignore: return_value_discarded
		file.open(story_file, File.WRITE)
		if five:
			file.store_var(5)
		elif four:
			file.store_var(4)
		elif three:
			file.store_var(3)
		elif two:
			file.store_var(2)
		elif one:
			file.store_var(1)
		else:
			file.store_var(-1)
	file.close()
	loaded = true

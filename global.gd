extends Node


const DARK_PURPLE := Color("4C3F91")
const LIGHT_PURPLE := Color("9145B6")
const DESATURATED_ROSE := Color("B958A5")
const VIBRANT_ROSE := Color("FF5677")

var background_color := DARK_PURPLE
var enemy_color := LIGHT_PURPLE
var bullet_color := DESATURATED_ROSE
var player_color := VIBRANT_ROSE

var save_path := "user://save.res"
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
		var save_data = ResourceLoader.load(save_0_path).duplicate()
		save_data.deaths = deaths
		save_data.doremy_counter = doremy_counter
		save_data.high_score = high_score
		save_data.one = one
		save_data.two = two
		save_data.three = three
		save_data.four = four
		save_data.five = five
		var e = ResourceSaver.save(save_path, save_data)
		print(e)
		if e != 0:
			if e > null:
				pass



func load_files():
	loaded = true
	var save_data: Resource
	var file := File.new()
	if file.file_exists(save_path):
		save_data = ResourceLoader.load(save_path)
		deaths = save_data.deaths
		doremy_counter = save_data.doremy_counter
		high_score = save_data.high_score
		one = save_data.one
		two = save_data.two
		three = save_data.three
		four = save_data.four
		five = save_data.five
	else:
		save_data = ResourceLoader.load(save_0_path).duplicate()
		var e = ResourceSaver.save(save_path, save_data)
		if e != 0:
			if e > null:
				pass

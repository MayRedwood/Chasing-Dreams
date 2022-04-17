extends Node


const DARK_PURPLE := Color("4C3F91")
const LIGHT_PURPLE := Color("9145B6")
const DESATURATED_ROSE := Color("B958A5")
const VIBRANT_ROSE := Color("FF5677")

var background_color := DARK_PURPLE
var enemy_color := LIGHT_PURPLE
var bullet_color := DESATURATED_ROSE
var player_color := VIBRANT_ROSE

var deaths := -1

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
	if high_score > 4000 and four and not five:
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

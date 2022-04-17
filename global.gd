extends Node


const DARK_PURPLE := Color("4C3F91")
const LIGHT_PURPLE := Color("9145B6")
const DESATURATED_ROSE := Color("B958A5")
const VIBRANT_ROSE := Color("FF5677")

var background_color := DARK_PURPLE
var enemy_color := LIGHT_PURPLE
var bullet_color := DESATURATED_ROSE
var player_color := VIBRANT_ROSE


var score: int
var high_score: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

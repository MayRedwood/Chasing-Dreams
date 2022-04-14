extends Node2D


const SPEED := 300
const ACCEL := 0.8
var speed: float = SPEED

const MAX_TIMER := 25 * 60
var timer := MAX_TIMER

var grasping := false

var velocity := Vector2.ZERO
onready var tween := $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		tween.interpolate_property(self, "speed", speed, SPEED/2.0, 0.2, 2)
		tween.interpolate_property(self, "modulate:a", modulate.a, 0.5, 0.2, 2)
		tween.start()
		grasping = true
		timer -= 25
	elif event.is_action_released("ui_accept"):
		tween.interpolate_property(self, "speed", speed, SPEED, 0.2, 2)
		tween.interpolate_property(self, "modulate:a", modulate.a, 1.0, 0.2, 2)
		tween.start()
		grasping = false


func _physics_process(delta):
	velocity = velocity.move_toward(
			get_player_input().normalized() * speed * delta, 
			ACCEL
		)
	
	if grasping:
		timer -= 4
	elif timer < MAX_TIMER:
		timer += 1
	if timer <= 1:
		# warning-ignore: return_value_discarded
		get_tree().reload_current_scene()
	
	position += velocity
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)


func get_player_input() -> Vector2:
	return Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)
extends Node2D


const SPEED := 300
const ACCEL := 0.8
var speed: float = SPEED

const MAX_TIMER := 120
var timer := MAX_TIMER ## The timer on invincibility

var grasping := false

var velocity := Vector2.ZERO
onready var tween := $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore: return_value_discarded
	$Area2D.connect("area_shape_entered", self, "_on_area_shape_entered")


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and timer >= 0.8 * MAX_TIMER:
		__grasp()
	elif event.is_action_pressed("ui_select"):
		tween.interpolate_property(self, "speed", speed, SPEED/2.0, 0.2, 1)
		tween.start()
	elif event.is_action_released("ui_select"):
		tween.interpolate_property(self, "speed", speed, SPEED, 0.2, 1)
		tween.start()
	elif event.is_action_pressed("ui_home"):
		Global.score = 4000


func _physics_process(delta):
	velocity = velocity.move_toward(
			get_player_input().normalized() * speed * delta, 
			ACCEL
		)
	
	if timer < MAX_TIMER:
		timer += 1
	
	position += velocity
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)


func get_player_input() -> Vector2:
	return Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)


func _on_area_shape_entered(area_id, area, area_shape, _local_shape):
	if not Bullets.is_bullet_existing(area_id, area_shape):
		if area.get_parent() is Enemy:
			area.get_parent().die()
		return

	# Get a BulletID from the area_shape passed in by the engine.
	# warning-ignore: unused_variable
	var bullet_id = Bullets.get_bullet_from_shape(area_id, area_shape)

	#Bullets.call_deferred("release_bullet", bullet_id)
	if not grasping:
		grasping = true ## Don't die if we're alredy dead!
		reload_scene()


func reload_scene():
	#var file := File.new()
	if Global.score > Global.high_score:
		Global.high_score = Global.score
	get_tree().call_deferred("reload_current_scene")


func __grasp():
	timer -= 120
	tween.interpolate_property(self, "modulate:a", modulate.a, 0.2, 0.25, 1)
	tween.start()
	grasping = true
	yield(get_tree().create_timer(0.25), "timeout")
	tween.interpolate_property(self, "modulate:a", modulate.a, 1.0, 0.25, 1)
	tween.start()
	yield(get_tree().create_timer(0.25), "timeout")
	grasping = false

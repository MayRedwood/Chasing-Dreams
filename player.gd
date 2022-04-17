extends Node2D


const SPEED := 300
const ACCEL := 0.8
var speed: float = SPEED

const MAX_TIMER := 120
var timer := MAX_TIMER

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
			get_parent().counter -= 1
			Global.score += 10
		return

	# Get a BulletID from the area_shape passed in by the engine.
	# warning-ignore: unused_variable
	var bullet_id = Bullets.get_bullet_from_shape(area_id, area_shape)

	#Bullets.call_deferred("release_bullet", bullet_id)
	if not grasping:
		grasping = true
		reload_scene()


func reload_scene():
	#var file := File.new()
	get_tree().call_deferred("reload_current_scene")


func __grasp():
	timer -= 120
	tween.interpolate_property(self, "modulate:a", modulate.a, 0.5, 0.25, 1)
	tween.start()
	grasping = true
	yield(tween, "tween_all_completed")
	tween.interpolate_property(self, "modulate:a", modulate.a, 1.0, 0.25, 1)
	tween.start()
	yield(tween, "tween_all_completed")
	grasping = false

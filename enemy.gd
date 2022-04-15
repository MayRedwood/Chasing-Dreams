extends Node2D
class_name Enemy


var player: Node2D
export(Resource) var bullet_kit


# Called when the node enters the scene tree for the first time.
func _ready():
	__shoot()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_rotation_degrees += 1


func __shoot():
	while true:
		yield(get_tree().create_timer(0.5), "timeout")
		shoot_circle()


func shoot_at_player():
	var bullet_velocity = (player.global_position - global_position).normalized()
	var properties := {
		"transform": Transform2D(bullet_velocity.angle(), global_position),
		"velocity": bullet_velocity * 150
	}
	Bullets.spawn_bullet(bullet_kit, properties)


func shoot_circle():
	for i in range(10):
		var bullet_velocity = (player.global_position - global_position).normalized()
		bullet_velocity = bullet_velocity.rotated(i * deg2rad(360/10))
		var properties := {
			"transform": Transform2D(bullet_velocity.angle(), global_position),
			"velocity": bullet_velocity * 150
		}
		Bullets.spawn_bullet(bullet_kit, properties)
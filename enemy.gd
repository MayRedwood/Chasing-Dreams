extends Node2D


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
		yield(get_tree().create_timer(0.3), "timeout")
		shoot_at_player()


func shoot_at_player():
	var bullet_velocity = (player.global_position - global_position).normalized()
	var properties := {
		"transform": Transform2D(bullet_velocity.angle(), global_position),
		"velocity": bullet_velocity * 150
	}
	Bullets.spawn_bullet(bullet_kit, properties)

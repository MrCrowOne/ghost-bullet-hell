extends Node2D

const BULLET: PackedScene = preload("res://scenes/player/bullet.tscn")
const AUDIO_TEMPLATE: PackedScene = preload("res://scenes/player/effects/audio_template.tscn")

@onready var gun: Sprite2D = get_node("Gun")
#@onready var animation: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var timer: Timer = $TimerShoot
#caso for ter animação da arma
#var is_attacking: bool = false

var is_attacking = true

func _physics_process(delta: float) -> void:
	#caso for ter animação da arma
	#if Input.is_action_just_pressed("ui_accept") and not is_attacking:
		#animation.play("attack")
		#is_attacking = true
		#a partir do minuto 17:00
	if Input.is_action_just_pressed("shoot"):
		spawn_bullet()

func spawn_bullet() -> void:
	var bullet = BULLET.instantiate()
	get_tree().root.call_deferred("add_child", bullet)
	bullet.global_position = global_position + Vector2(0, 0.5)
	is_attacking = false
	var som = "res://fonts/laser-gun.wav"
	spawn_sfx(som)
func animate(attack_direction: Vector2, direction: Vector2) -> void:
	if attack_direction.x > 0:
		gun.flip_v = false
	if attack_direction.x < 0:
		gun.flip_v = true
	
	look_at(direction)

func spawn_sfx(sfx_path: String) -> void:
	var sfx = AUDIO_TEMPLATE.instantiate()
	sfx.sfx_to_play = sfx_path
	add_child(sfx)


func _on_timer_shoot_timeout() -> void:
	pass # Replace with function body.

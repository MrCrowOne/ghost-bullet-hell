extends Node2D

const BULLET: PackedScene = preload("res://scenes/player/bullet.tscn")
const AUDIO_TEMPLATE: PackedScene = preload("res://scenes/player/effects/audio_template.tscn")

@onready var player = get_parent()
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

	if player.using_controller:
		var aim_input = Vector2(
			Input.get_action_strength("weapon_aim_right") - Input.get_action_strength("weapon_aim_left"),
			Input.get_action_strength("weapon_aim_down") - Input.get_action_strength("weapon_aim_up")
		)
		
		if aim_input.length() > 0:
			bullet.global_position = global_position + aim_input.normalized() * 30  # Ajuste a posição do tiro
			bullet.look_at(global_position + aim_input)
	else:
		var mouse_position = get_global_mouse_position()
		bullet.global_position = global_position
		bullet.look_at(mouse_position)
	
	is_attacking = false
	var som = "res://fonts/laser-gun.wav"
	spawn_sfx(som)


func spawn_sfx(sfx_path: String) -> void:
	var sfx = AUDIO_TEMPLATE.instantiate()
	sfx.sfx_to_play = sfx_path
	add_child(sfx)


func _on_timer_shoot_timeout() -> void:
	pass # Replace with function body.

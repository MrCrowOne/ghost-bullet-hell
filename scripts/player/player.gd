extends CharacterBody2D

@export var movement_speed: float = 500.0
@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.3
@export var dash_cooldown: float = 1.0

@onready var collision: CollisionShape2D = $Collision
@onready var dust: GPUParticles2D = $Dust
@onready var sprite = $Texture
@onready var hand: Node2D = get_node("Hand")

var using_controller = false
var previous_mouse_position = Vector2.ZERO

var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector2.ZERO
var original_collision_mask

const GROUP_BULLET_BOSS = 2  # Supondo que "bulletBoss" esteja no grupo 2

func _ready() -> void:
	original_collision_mask = collision_layer  # Armazena a máscara original

func _physics_process(delta: float) -> void:
	handle_dash(delta)
	walk(delta)
	animate()
	handle_aiming_method()

func handle_dash(delta: float):
	if is_dashing:
		# Continua o dash enquanto o tempo de dash não acabar
		dash_timer -= delta
		if dash_timer > 0:
			velocity = dash_direction * dash_speed
		else:
			is_dashing = false
			dash_cooldown_timer = dash_cooldown  # Inicia o cooldown
			collision_layer = original_collision_mask  # Restaura a máscara original
	else:
		# Se o cooldown do dash acabou e a tecla de dash foi pressionada
		if dash_cooldown_timer > 0:
			dash_cooldown_timer -= delta
		elif Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
			is_dashing = true
			dash_timer = dash_duration
			dash_direction = velocity.normalized()  # O dash segue a direção atual do movimento
			sprite.play("dash")  # Inicia a animação de dash
			collision_layer &= ~GROUP_BULLET_BOSS  # Remove o grupo "bulletBoss" da colisão

func walk(delta: float):
	if not is_dashing:
		var direction: Vector2 = Vector2(
			Input.get_axis("left", "right"),
			Input.get_axis("up", "down")
		).normalized()

		var directionXbox: Vector2 = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()

		velocity = direction * movement_speed
		velocity = directionXbox * movement_speed

	move_and_slide()

func animate() -> void:
	if not is_dashing:
		if velocity.x > 0:
			sprite.flip_h = true
			hand.position.x = 15

		if velocity.x < 0:
			sprite.flip_h = false
			hand.position.x = -15

		if velocity != Vector2.ZERO:
			dust.emitting = true
			sprite.play("run")
			return

		sprite.play("idle")
		dust.emitting = false

func handle_aiming_method():
	var current_mouse_position = get_global_mouse_position()

	if previous_mouse_position != current_mouse_position:
		using_controller = false
	previous_mouse_position = current_mouse_position

	if Input.get_axis("right_stick_left", "right_stick_right") != 0 or Input.get_axis("right_stick_up", "right_stick_down") != 0:
		using_controller = true

	if using_controller:
		hand_follow_xbox()
	else:
		hand_follow_mouse()

func hand_follow_mouse() -> void:
	var mouse_position = get_global_mouse_position()
	var direction = global_position.direction_to(mouse_position)

	hand.position = direction.normalized() * 30
	hand.look_at(mouse_position)

func hand_follow_xbox():
	var right_stick_input = Vector2(
		Input.get_axis("right_stick_left", "right_stick_right"),
		Input.get_axis("right_stick_up", "right_stick_down")
	)

	if right_stick_input.length() > 0:
		hand.position = right_stick_input.normalized() * 30
		hand.look_at(global_position + right_stick_input)

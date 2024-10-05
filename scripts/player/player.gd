extends CharacterBody2D

@export var movement_speed: float = 500.0
@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.3
@export var dash_cooldown: float = 1.0

@onready var collision: CollisionShape2D = $Collision
@onready var dust: GPUParticles2D = $Dust
@onready var sprite = $Texture
@onready var hand: Node2D = get_node("Hand")

var using_controller = false  # Variável para rastrear o método de mira atual
var previous_mouse_position = Vector2.ZERO  # Armazena a posição anterior do mouse

var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	handle_dash(delta)
	walk(delta)
	animate()
	hand_follow_mouse()
	hand_follow_xbox()

func handle_dash(delta: float):
	# Se o jogador pode fazer dash
	if is_dashing:
		collision.disabled = true
		# Continua o dash enquanto o tempo de dash não acabar
		dash_timer -= delta
		if dash_timer > 0:
			velocity = dash_direction * dash_speed
		else:
			is_dashing = false
			dash_cooldown_timer = dash_cooldown  # Inicia o cooldown
	else:
		collision.disabled = false
		# Reseta o cooldown para permitir outro dash
		if dash_cooldown_timer > 0:
			dash_cooldown_timer -= delta
		# Inicia o dash ao pressionar a tecla "dash" (pode ser "Shift")
		elif Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
			is_dashing = true
			dash_timer = dash_duration
			dash_direction = velocity.normalized()  # O dash segue a direção atual do movimento
			sprite.play("dash")  # Inicia a animação de dash

func walk(delta: float):
	# Se não estiver no modo de dash, continua a movimentação normal
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
	# Animações normais quando não está no modo de dash
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
	# Verifica se o jogador está usando o mouse ou o controle
	var current_mouse_position = get_global_mouse_position()

	# Se o mouse se moveu, desativamos o controle e usamos o mouse
	if previous_mouse_position != current_mouse_position:
		using_controller = false
	previous_mouse_position = current_mouse_position

	# Se o jogador mexeu o analógico direito do controle, usamos o controle
	if Input.get_axis("right_stick_left", "right_stick_right") != 0 or Input.get_axis("right_stick_up", "right_stick_down") != 0:
		using_controller = true

	# Chama a função de mira correta
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

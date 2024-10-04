extends CharacterBody2D

@export var movement_speed: float = 500.0

@onready var sprite = $Texture
@onready var hand: Node2D = get_node("Hand")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	walk()
	animate()
	hand_follow_mouse()

func walk():
	var direction: Vector2 = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	velocity = direction * movement_speed
	move_and_slide()
	

func animate() -> void:
	#flip
	if velocity.x > 0:
		sprite.play("run")
		sprite.flip_h = true
		hand.position.x = 15
	elif velocity.x < 0:
		sprite.play("run")
		sprite.flip_h = false
		hand.position.x = -15
	else:
		sprite.play("idle")

func hand_follow_mouse() -> void:
	# Faz a mão/arma seguir o mouse, sem interferir na animação
	var mouse_position = get_global_mouse_position()
	var direction = global_position.direction_to(mouse_position)
	
	# Defina uma posição fixa da mão em relação ao jogador, ajustável
	hand.position = direction.normalized() * 15
	hand.look_at(mouse_position)  # Faz a mão/arma olhar para o mouse

func get_mouse_position() -> Vector2:
	return get_global_mouse_position()

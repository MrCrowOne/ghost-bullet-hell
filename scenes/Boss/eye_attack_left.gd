extends Node2D

@onready var animated: AnimatedSprite2D = $"../AnimatedSprite2D"

# Velocidade do projétil
var projectile_speed = 400
var speed = 400 
# Tempo entre ataques
var attack_interval = 5.0
# Referência ao jogador
var player
var direction = Vector2()

var projectile_positions = [ # Posição do primeiro projétil (à esquerda)
	Vector2(0, 0),    # Posição do segundo projétil (no centro)  # Posição do terceiro projétil (à direita)
]

var attack_in_progress = false  # Flag para evitar múltiplos ataques durante a animação

# Quando a mão estiver pronta
func _ready():
	# Referência ao jogador (assumindo que o player está na root da cena)
	player = get_tree().get_nodes_in_group("Player")
	if player.size() > 0:
		player = player[0]  # Assume que há apenas um jogador
	else:
		print("Nenhum jogador encontrado no grupo 'Player'")
		return

	# Timer para controlar os ataques
	var attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = attack_interval
	attack_timer.autostart = true
	attack_timer.connect("timeout", Callable(self, "_on_attack"))

# Função para tocar a animação antes de disparar o projétil
func _on_attack():
	if not attack_in_progress:  # Evita disparar múltiplos ataques
		attack_in_progress = true
		if animated.has_animation("attack2"):
			animated.play("attack2")
		else:
			print("Animação 'attack2' não encontrada")

# Verifica se a animação terminou no último frame
func _process(delta):
	if animated.animation == "attack2":
		var current_frame = animated.frame
		var total_frames = animated.sprite_frames.get_frame_count("attack2")
		
		# Se a animação chegou ao último frame, dispara o projétil
		if current_frame == total_frames - 1:
			_on_timer_eye_left_timeout()
			attack_in_progress = false  # Libera para o próximo ataque

# Função para disparar o projétil
func _on_timer_eye_left_timeout():
	var fire_point = get_node("PointEyeAttack")
	for position in projectile_positions:
		# Cria o projétil
		var projectile_scene = preload("res://scenes/Boss/attack_special.tscn")
		var projectile = projectile_scene.instantiate()

		# Adiciona o projétil à cena principal
		get_tree().current_scene.add_child(projectile)
		# Posiciona o projétil na posição do FirePoint + posição específica
		projectile.position = fire_point.global_position + position

		# Direção para onde o projétil vai (para o jogador)
		var direction = (player.global_position - (fire_point.global_position + position)).normalized()

		# Define a direção do projétil
		projectile.set_direction(direction)

func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()  # Normaliza a direção

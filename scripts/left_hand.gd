extends Node2D

# Velocidade do projétil
var projectile_speed = 400
var speed = 400 
# Tempo entre ataques
var attack_interval = 5.5
# Referência ao jogador
var player
var direction = Vector2()

var projectile_positions = [
	Vector2(-90, -90),  # Posição do primeiro projétil (à esquerda)
	Vector2(0, 0),    # Posição do segundo projétil (no centro)
	Vector2(90, 90)    # Posição do terceiro projétil (à direita)
]
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
	add_child(attack_timer)  # Adiciona o timer à cena
	attack_timer.wait_time = attack_interval
	attack_timer.autostart = true
	attack_timer.connect("timeout", Callable(self, "_on_attack_timeout"))  # Conecta o timeout após adicionar o timer


# Função para disparar o projétil
func _on_attack_timeout():
	var fire_point = get_node("FirePoint")

	for position in projectile_positions:
		# Cria o projétil
		var projectile_scene = preload("res://scenes/Boss/bullet_boss.tscn")
		var projectile = projectile_scene.instantiate()

		# Adiciona o projétil à cena principal
		get_tree().current_scene.add_child(projectile)

		# Posiciona o projétil na posição do FirePoint + posição específica
		projectile.position = fire_point.global_position + position
		
		# Direção para onde o projétil vai (para o jogador)
		var direction = (player.global_position - (fire_point.global_position + position)).normalized()

		# Define a direção do projétil
		projectile.set_direction(direction)
		var sprite = projectile.get_node("AnimatedBullet")
		if direction.x < 0:
			sprite.flip_h = false  # Flip horizontal para a esquerda
		else:
			sprite.flip_h = true  # Não flipar para a direita
func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()  # Normaliza a direção

func _process(delta):
	position += direction * speed * delta  # Move o projétil na direção definida

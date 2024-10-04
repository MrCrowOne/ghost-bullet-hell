extends Node2D

# Velocidade do projétil
var projectile_speed = 400
var speed = 400 
# Tempo entre ataques
var attack_interval = 1.5
# Referência ao jogador
var player
var direction = Vector2()

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
	attack_timer.connect("timeout", Callable(self, "_on_attack_timeout"))

# Função para disparar o projétil
func _on_attack_timeout():
	print("Atacando")  # Verifique se a função está sendo chamada

	# Cria o projétil
	var projectile_scene = preload("res://scenes/Boss/bullet_boss.tscn")  # Certifique-se de que o caminho está correto
	var projectile = projectile_scene.instantiate()

	# Adiciona o projétil à cena principal
	get_tree().current_scene.add_child(projectile)
	# Posiciona o projétil na posição da mão
	projectile.position = global_position

	# Direção para onde o projétil vai (para o jogador)
	var direction = (player.global_position - global_position).normalized()
	 # Define a direção do projétil
	projectile.set_direction(direction)  # Chama o método para definir a direção
	# Definir a velocidade do projétil (assumindo que a bala tenha uma variável de velocidade)
	if projectile.has_method("set_velocity"):
		projectile.set_velocity(direction * projectile_speed)
	else:
		print("O projétil não tem o método set_velocity")

func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()  # Normaliza a direção

func _process(delta):
	position += direction * speed * delta  # Move o projétil na direção definida
